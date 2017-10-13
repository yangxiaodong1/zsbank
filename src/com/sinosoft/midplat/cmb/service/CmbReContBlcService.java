package com.sinosoft.midplat.cmb.service;

import java.io.File;
import java.io.FileReader;
import java.io.FilenameFilter;
import java.lang.reflect.Constructor;

import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.cmb.CmbConf;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.Format;
import com.sinosoft.midplat.service.Service;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class CmbReContBlcService extends ServiceImpl {

	private Element thisRootConf;
	private final static String FUNCFLAG_BLC_NEWCONT = "1006";
    private String logNo = "";
	
	public CmbReContBlcService(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document inXmlDoc) throws Exception {
		
		long tStartMillis = System.currentTimeMillis();
		cLogger.info("Into CmbReContBlcService.service()...");
		cInXmlDoc = inXmlDoc;
		this.thisRootConf = CmbConf.newInstance().getConf().getRootElement();
		Element rootEle = inXmlDoc.getRootElement();

		// 存流水
		try {
			cTranLogDB = insertTranLog(inXmlDoc);
			Element mHeadEle = rootEle.getChild("Head");
			String tranDate = mHeadEle.getChildText("TranDate");
			
			StringBuffer mSqlStr = new StringBuffer();
	        mSqlStr.append("select logno from TranLog ");
	        mSqlStr.append(" where trancom = 10 and Funcflag = 1006 and RCode=1 ");
	        mSqlStr.append(" and trandate =" + tranDate);
	        mSqlStr.append(" order by Makedate,Maketime desc ");
	        SSRS ssrs = new SSRS();
	        ssrs = new ExeSQL().execSQL(mSqlStr.toString());
	        if (ssrs.MaxRow > 0) {
	        	logNo = ssrs.GetText(1,1);
	        	Document inNoStdDoc = null;
				//根据流水号到对应的日志目录路径下面找对应的日志文件	    
//	        	String filedir = tranDate.substring(0,4)+"/"+tranDate.substring(0,6)+"/"+tranDate;
//	        	StringBuilder mFilePath = new StringBuilder(getOutLocalDir()).append("10").append('/').append(filedir);
	        	File[] fileArray = getBatchFiles(tranDate);
	        	if(fileArray.length>0){
//	        		File blcFile = new File(mFilePath+"/"+fileArray[0]);
					//读取文件信息
					inNoStdDoc = JdomUtil.build(IOTrans.toString(new FileReader(fileArray[0])));					
					NewCmbBusiBlcTread tNewCcbBusiBlcTread = new NewCmbBusiBlcTread(FUNCFLAG_BLC_NEWCONT, inNoStdDoc);
					tNewCcbBusiBlcTread.start();
	        	}else{
	        		throw new MidplatException("未找到日志路径下有效日志文件，无法操作！");
	        	}	
	        }else{
	        	throw new MidplatException("未找到数据库中有效日志记录，无法操作！");
	        }	
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "交易成功");	
			
		} catch (Exception e) {
			cLogger.error(cThisBusiConf.getChildText(name) + "交易失败！", e);

			if (null != cTranLogDB) { // 插入日志失败时cTranLogDB=null
				cTranLogDB.setRCode(CodeDef.RCode_ERROR); // -1-未返回；0-交易成功，返回；1-交易失败，返回
				cTranLogDB.setRText(NumberUtil.cutStrByByte(e.getMessage(), 150, MidplatConf.newInstance().getDBCharset()));
			}
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, e.getMessage());
		}
		
		if (null != cTranLogDB) {	//插入日志失败时cTranLogDB=null
			
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));	//-1-未返回；0-交易成功，返回；1-交易失败，返回
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-tStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("更新日志信息失败！" + cTranLogDB.mErrors.getFirstError());
			}
		}
		cLogger.info("Out CcbFinanceBlc.service()!");
		return cOutXmlDoc;
	}
	
	/**
	 * @Description:
	 * Copyright: Copyright (c) 2016
	 * Company:安邦保险IT部
	 * @version 
	 *
	 */
	private class NewCmbBusiBlcTread extends Thread {
		private final Document cInXmlDoc;
		private final String cfuncFlag;

		private NewCmbBusiBlcTread(String funcFlag,Document noStdXmlDoc) {
			cInXmlDoc = (Document)noStdXmlDoc.clone();// 此处需要克隆一份新的，避免日终对账，保全对账操作同一个对象，导致funflag的值不一致。
			cfuncFlag = funcFlag;
		}

		public void run() {
			cLogger.info("Into NewCmbBusiBlcTread.run()...");

			this.setName(String.valueOf(NoFactory.nextTranLogNo()));
			try {
				Element thisBusiConf = (Element) XPath.selectSingleNode(thisRootConf, "business[funcFlag='" + cfuncFlag + "']");
				JdomUtil.print(cInXmlDoc);
				// 需要设置一下交易码
//				Element newContBlcEle = (Element) XPath.selectSingleNode(cInXmlDoc.getRootElement(), "//Head");
				Element tHead = new Element("Head");
				//增加交易码节点并赋值
				Element funcFlagEle = new Element("FuncFlag");
				funcFlagEle.setText("1006");
				//增加银行代码节点并赋值
				Element tranComEle = new Element("TranCom");
				tranComEle.setText(thisRootConf.getChild("TranCom").getValue());
				tranComEle.setAttribute("outcode",thisRootConf.getChild("TranCom").getAttributeValue("outcode"));

				tHead.addContent(funcFlagEle);
				tHead.addContent(tranComEle);
				cInXmlDoc.getRootElement().addContent(tHead);
				// 1. 转换标准报文
				Document inStdDoc = nostd2std(cInXmlDoc, thisBusiConf);
				JdomUtil.print(inStdDoc);
				
				// 2. 调用日终对账服务
				sendRequest(inStdDoc, thisBusiConf);
			} catch (Exception e) {
				cLogger.error("日终交易失败，交易码[" + cfuncFlag + "]", e);
			}
			cLogger.info("Out NewCmbBusiBlcTread.run()!");
		}
	}
	
	/**
	 * 报文转换，将非标准报文转换为核心的标准报文。
	 * 
	 * @param pNoStdXml
	 * @param thisBusiConf
	 * @return
	 * @throws Exception
	 */
	private Document nostd2std(Document pNoStdXml, Element thisBusiConf) throws Exception {
		String tFormatClassName = thisBusiConf.getChildText(format);
		// 报文转换模块
		cLogger.info((new StringBuilder("报文转换模块：")).append(tFormatClassName).toString());
		Constructor tFormatConstructor = Class.forName(tFormatClassName).getConstructor(new Class[] { org.jdom.Element.class });
		Format tFormat = (Format) tFormatConstructor.newInstance(new Object[] { thisBusiConf });
		return tFormat.noStd2Std(pNoStdXml);
	}
	
	/**
	 * 发送交易请求
	 * 
	 * @param tInStd 标准报文
	 * @param thisBusiConf
	 * @return
	 * @throws Exception
	 */
	protected Document sendRequest(Document tInStd, Element thisBusiConf) throws Exception {

		// 业务处理
		String tServiceClassName = thisBusiConf.getChildText(service);
		cLogger.debug((new StringBuilder("业务处理模块：")).append(tServiceClassName).toString());
		Constructor tServiceConstructor = Class.forName(tServiceClassName).getConstructor(new Class[] { org.jdom.Element.class });
		Service tService = (Service) tServiceConstructor.newInstance(new Object[] { thisBusiConf });
		Document tOutStdXml = tService.service(tInStd);

		// 校验核心是否正常返回		
		Element tOutHeadEle = tOutStdXml.getRootElement().getChild(Head);
		if (CodeDef.RCode_ERROR == Integer.parseInt(tOutHeadEle.getChildText(Flag))) {	//交易失败
			throw new MidplatException(tOutHeadEle.getChildText(Desc));
		}
		return tOutStdXml;

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

	
	File[] getBatchFiles(String tranDate) throws MidplatException {
        if (null == getOutLocalDir() || "".equals(getOutLocalDir())) {
            throw new MidplatException("没有配置批量交易[1025]的localDir");
        }
        String filedir = tranDate.substring(0,4)+"/"+tranDate.substring(0,6)+"/"+tranDate;
    	StringBuilder mFilePath = new StringBuilder(getOutLocalDir()).append("10").append('/').append(filedir);
        // 初始化批量文件目录
        File mDirFile = new File(mFilePath.toString());
        if (!mDirFile.exists()) {
            cLogger.debug("本地文件目录[" + mFilePath.toString() + "]不存在，初始化目录");
        }

        // 获取本次上传文件的名称
        return mDirFile.listFiles(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                // TODO Auto-generated method stub
                return (name.startsWith(logNo)&&name.endsWith("1006_in.xml"));
            }

        });
    }
}
