package com.sinosoft.midplat.bjbank.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.trans.FileTransportor;
import com.sinosoft.midplat.bat.trans.FtpUploadTransportor;
import com.sinosoft.midplat.common.AblifeCodeDef;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.Format;
import com.sinosoft.midplat.net.CallWebsvcAtomSvc;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;

public class PolicyAssetChangeSyncSv extends ServiceImpl{

	public PolicyAssetChangeSyncSv(Element thisBusiConf) {
		super(thisBusiConf);
	}

	protected String outFileName = "";
	protected String outLocalDir = "";
	protected int surrCount = 0;

	@Override
	public Document service(Document inXmlDoc) throws Exception {
		cLogger.info("Into PolicyAssetChangeSyncSv.service()...");

		long mStartMillis = System.currentTimeMillis();
		// 获取文件名
		this.outFileName = getOutFileName();
		this.outLocalDir = getOutLocalDir();

		try {
			// 存流水
			cTranLogDB = insertTranLog(inXmlDoc);
			Format format = getFormat(inXmlDoc);
			// 1.转换为标准报文,调用服务
			cInXmlDoc = format.noStd2Std(inXmlDoc);
			// 2.调用核心服务
			Document outStdXmlDoc = sendRequest();
			// 3. 转换为输出格式()银行报文格式		
			Document outNoStdXml = format.std2NoStd(outStdXmlDoc);
//			JdomUtil.print(outNoStdXml);
//			List surrDetailList = (List)XPath.selectSingleNode(outNoStdXml.getRootElement(), "//TranData/SurrDetails");
			Element element = (Element)XPath.selectSingleNode(outNoStdXml.getRootElement(), "//TranData/SurrDetails");
			List surrDetailList = element.getChildren("SurrDetail");
//			JdomUtil.print(element);
			if(surrDetailList != null && surrDetailList.size()>0){
				surrCount = surrDetailList.size();
			}
			// 4. 输出文件, 这里判断下，若配置了每次查询节点则输出多个文件，否则输出一个
			List<Element> appEntityEleList = setAppEntityList(outNoStdXml);
			// 直接输出
			Document content = setCommInfo(appEntityEleList.get(0));
//			JdomUtil.print(content);
			saveFile(JdomUtil.toBytes(content), outFileName);	
			//上传银行FTP
			ftpFile();
			// 调整标准输出报文
			outStdXmlDoc = adjustOutStdXml(outStdXmlDoc);
			cOutXmlDoc = outStdXmlDoc;

		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"交易失败！", ex);
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
		}

		if (null != cTranLogDB) {	// 插入日志失败时tranLogDB=null
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));			
			if (!cTranLogDB.update()) {
				cLogger.error("更新日志信息失败！" + cTranLogDB.mErrors.getFirstError());
			}
		}

		cLogger.info("Out PolicyAssetChangeSyncSv.service()!");
		return cOutXmlDoc;
	}

	/**
	 * 
	 * @param noStdXml
	 * @return
	 * @throws JDOMException 
	 */
	private Document setCommInfo(Element noStdXml){
		
		Element outRootXml = new Element("TranData");
//		Element txHeadEle = new Element("Head");	
//		Element tDetail_ListEle = noStdXml.getChild("Detail_List");
//		outRootXml.addContent(tDetail_ListEle.detach());
//		System.out.println("==========="+noStdXml.getChild("SurrDetails"));
//		if(noStdXml.getChild("SurrDetails") != null){
//			outRootXml.addContent(noStdXml.getChild("SurrDetails").detach());
//		}else{
//			Element surrDetails = new Element("SurrDetails");
			outRootXml.addContent(noStdXml);
//		}
//		// 添加公共头部分
//		outRootXml.addContent(0, outRootXml);
		return new Document(outRootXml);
	}

	private void saveFile(byte[] fileContent, String fileName) throws Exception {
		BufferedOutputStream out = null;
		BufferedInputStream in = null;
		try {
			// 读取文件
			in = new BufferedInputStream(new ByteArrayInputStream(fileContent));
			String tFilePath = "";
			if(outLocalDir.endsWith("/")){
				tFilePath = outLocalDir + fileName;
			}else{
				tFilePath = outLocalDir + "/" + fileName;
			}
			out = new BufferedOutputStream(new FileOutputStream(tFilePath));
			// 拷贝文件
			int len = -1;
			byte[] buffer = new byte[5 * 1024];
			while ((len = in.read(buffer)) != -1) {
				out.write(buffer, 0, len);
			}
			out.flush();
		}catch(Exception exp){
			cLogger.error(cThisBusiConf.getChildText(name)+"交易失败！", exp);
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, "生成银行批量文件失败...");
			
		}finally {
			// 关闭文件
			if (in != null) {
				in.close();
			}
			if (out != null) {
				out.close();
			}
		}
	}

	/**
	 * 获取报文转换类
	 * 
	 * @param pNoStdXml
	 * @param thisBusiConf
	 * @return
	 * @throws Exception
	 */
	private Format getFormat(Document pNoStdXml) throws Exception {
		String tFormatClassName = cThisBusiConf.getChildText("formatIns");
		// 报文转换模块
		cLogger.info((new StringBuilder("报文转换模块：")).append(tFormatClassName).toString());
		Constructor tFormatConstructor = Class.forName(tFormatClassName).getConstructor(new Class[] { org.jdom.Element.class });
		Format tFormat = (Format) tFormatConstructor.newInstance(new Object[] { cThisBusiConf });
		return tFormat;
	}

	/**
	 * 发送交易请求,由子类复写该方法，调用webService服务。
	 * 
	 * @param tInStd
	 * @param thisBusiConf
	 * @return
	 * @throws Exception
	 */
	protected Document sendRequest() throws Exception {

		Document tOutXmlDoc = null;
		String tSqlStr = new StringBuilder(
				"select 1 from TranLog where RCode=").append(
				CodeDef.RCode_OK).append(" and TranDate=").append(
				cTranLogDB.getTranDate()).append(" and FuncFlag=").append(
				cTranLogDB.getFuncFlag()).append(" and TranCom=").append(
				cTranLogDB.getTranCom()).append(" and NodeNo='").append(
				cTranLogDB.getNodeNo()).append('\'').toString();
		ExeSQL tExeSQL = new ExeSQL();
		if ("1".equals(tExeSQL.getOneValue(tSqlStr))) {
           // throw new MidplatException("已成功做过保单状态回传查询，不能重复操作！");
		} else if (tExeSQL.mErrors.needDealError()) {
			throw new MidplatException("保单状态回传日志异常！");
		}
     
		tOutXmlDoc = new CallWebsvcAtomSvc(AblifeCodeDef.SID_Bank_PolicyStatus_Query).call(cInXmlDoc);
		Element tOutRootEle = tOutXmlDoc.getRootElement();
		Element tOutHeadEle = tOutRootEle.getChild(Head);
		if (CodeDef.RCode_ERROR == Integer.parseInt(tOutHeadEle.getChildText(Flag))) {	// 交易失败
			throw new MidplatException(tOutHeadEle.getChildText(Desc));
		}
		
		return tOutXmlDoc;
	}

	/**
	 * 需要文件分片，则在子类中复写该方法，进行数据分片处理
	 * @param outNoStdXml
	 * @return
	 * @throws Exception
	 */
	protected List<Element> setAppEntityList(Document outNoStdXml) throws Exception {
		Element appEntityEle = (Element) XPath.selectSingleNode(outNoStdXml.getRootElement(), "//TranData/SurrDetails");
		List<Element> list = new ArrayList<Element>();
		list.add((Element) appEntityEle.detach());
		return list;
	}

	/**
	 * 犹豫期退保数据回传文件命名：保险公司代码（2位）+银行代码（2位）+交易代码（2位）+日期（8位）.xml
	 * @param inXmlDoc
	 * @return
	 * @throws Exception
	 */
	protected String getOutFileName() throws Exception {
		StringBuffer strBuff = new StringBuffer();
		//保险公司代码（2位）+银行代码（2位）+交易代码（2位）+日期（8位）.xml
		strBuff.append("100109").append(DateUtil.getCur8Date()).append(".xml");
		return strBuff.toString();
	}

	/**
	 * 调整标准输出报文
	 * @param outStdXmlDoc
	 * @return
	 */
	protected Document adjustOutStdXml(Document outStdXmlDoc) throws Exception {
		JdomUtil.print(outStdXmlDoc);
		Element BodyEle = (Element) XPath.selectSingleNode(outStdXmlDoc.getRootElement(), "//TranData");
		//文件名
		Element fileName = new Element("FileName");
		fileName.setText(outFileName);
		//明细条数
		Element surrCount = new Element("PolCount");
		surrCount.setText(this.surrCount+"");

		BodyEle.addContent(fileName);
		BodyEle.addContent(surrCount);

		return outStdXmlDoc;
	}
	
	/**
	 * 获取文件存放路径
	 * @return
	 */
	public String getOutLocalDir() {
		
		String filePath = cThisBusiConf.getChildText(localDir);
		if(filePath.endsWith("/")){
			// do nothing...
		}else{
			filePath = filePath + "/";
		}
		return filePath;
	}
	
	/**
     * 后置处理方法，该方法在生成本地方法后调用。
     * 一般如果生成文件后需要加入个性化处理，则可以实现该方法。
     * @return
     * @throws Exception
     */
    protected void ftpFile()throws Exception{
        //常用ftp上传文件
        Element ftpElement = cThisBusiConf.getChild("ftp");
        if(ftpElement==null){
            cLogger.debug("未配置ftp信息...");
        }else{
            //配置了ftp上传
            FileTransportor t = new FtpUploadTransportor(cThisBusiConf);
            t.transport(getFtpName());
        }
        
        return;
    }

    /**
     * ftp文件名
     * 
     * @return 文件名
     * @throws Exception 
     */
    protected String getFtpName() throws Exception{
        return getOutFileName();
    }
}
