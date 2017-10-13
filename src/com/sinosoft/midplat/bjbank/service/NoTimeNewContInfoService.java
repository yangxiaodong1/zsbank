package com.sinosoft.midplat.bjbank.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
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

public class NoTimeNewContInfoService extends ServiceImpl{

	public NoTimeNewContInfoService(Element thisBusiConf) {
		super(thisBusiConf);
	}

	protected String outFileName = "";
	protected String outLocalDir = "";
	protected String allNumText = "0";
	protected String allMoneyText = "0";
	protected int surrCount = 0;
	protected String tranDate = "";

	@Override
	public Document service(Document inXmlDoc) throws Exception {
		cLogger.info("Into NoTimeNewContInfoService.service()...");

		long mStartMillis = System.currentTimeMillis();
		// ��ȡ�ļ���
		tranDate = inXmlDoc.getRootElement().getChild("Head").getChildText("TranDate");
		
		this.outFileName = getOutFileName();
		this.outLocalDir = getOutLocalDir();

		try {
			// ����ˮ
			cTranLogDB = insertTranLog(inXmlDoc);
			Format format = getFormat(inXmlDoc);
			// 1.ת��Ϊ��׼����,���÷���
			cInXmlDoc = format.noStd2Std(inXmlDoc);
			// 2.���ú��ķ���
			Document outStdXmlDoc = sendRequest();
			// 3. ת��Ϊ�����ʽ()���б��ĸ�ʽ
			Document outNoStdXml = format.std2NoStd(outStdXmlDoc);
//			JdomUtil.print(outNoStdXml);
			// 4. ����ļ�, �����ж��£���������ÿ�β�ѯ�ڵ����������ļ����������һ��
			List<Element> appEntityEleList = setAppEntityList(outNoStdXml);
			// ֱ�����
			Document content = setCommInfo(appEntityEleList.get(0));
			JdomUtil.print(outNoStdXml);
			saveFile(JdomUtil.toBytes(content), outFileName);	
			//�ϴ�����FTP
			ftpFile();
			// ������׼�������
//			List surrDetailList = (List)XPath.selectSingleNode(outNoStdXml.getRootElement(), "//TranDatas/TranData");
//			System.out.println("surrDetailList.size()========"+surrDetailList.size());
//			if(surrDetailList != null && surrDetailList.size()>0){
//				surrCount = surrDetailList.size();				
//			}
			allNumText = outNoStdXml.getRootElement().getChildText("AllNum");
			allMoneyText = outNoStdXml.getRootElement().getChildText("AllMoney");
			if(allNumText != null && !"".equals(allNumText.trim())){
				
			}else{
				allNumText = "0";
				allMoneyText = "0.00";
			}
			
			outStdXmlDoc = adjustOutStdXml(outStdXmlDoc);
			cOutXmlDoc = outStdXmlDoc;

		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"����ʧ�ܣ�", ex);
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
		}

		if (null != cTranLogDB) {	// ������־ʧ��ʱtranLogDB=null
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));			
			if (!cTranLogDB.update()) {
				cLogger.error("������־��Ϣʧ�ܣ�" + cTranLogDB.mErrors.getFirstError());
			}
		}

		cLogger.info("Out NoTimeNewContInfoService.service()!");
		return cOutXmlDoc;
	}

	/**
	 * 
	 * @param noStdXml
	 * @return
	 * @throws JDOMException 
	 */
	private Document setCommInfo(Element noStdXml){
		
//		Element outRootXml = new Element("Root");
//		Element txHeadEle = new Element("Head");
//		
//		Element tDetail_ListEle = noStdXml.getChild("Detail_List");
//		outRootXml.addContent(tDetail_ListEle.detach());
//		txHeadEle.addContent(noStdXml.getChild("NRlTmInsPlyDtlTot_Num").detach());
//
//		// ��ӹ���ͷ����
//		outRootXml.addContent(0, txHeadEle);
		return new Document(noStdXml);
	}

	private void saveFile(byte[] fileContent, String fileName) throws Exception {
		BufferedOutputStream out = null;
		BufferedInputStream in = null;
		try {
			// ��ȡ�ļ�
			in = new BufferedInputStream(new ByteArrayInputStream(fileContent));
			String tFilePath = "";
			if(outLocalDir.endsWith("/")){
				tFilePath = outLocalDir + fileName;
			}else{
				tFilePath = outLocalDir + "/" + fileName;
			}
			out = new BufferedOutputStream(new FileOutputStream(tFilePath));
			// �����ļ�
			int len = -1;
			byte[] buffer = new byte[5 * 1024];
			while ((len = in.read(buffer)) != -1) {
				out.write(buffer, 0, len);
			}
			out.flush();
		}catch(Exception exp){
			cLogger.error(cThisBusiConf.getChildText(name)+"����ʧ�ܣ�", exp);
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, "�������������ļ�ʧ��...");
			
		}finally {
			// �ر��ļ�
			if (in != null) {
				in.close();
			}
			if (out != null) {
				out.close();
			}
		}
	}

	/**
	 * ��ȡ����ת����
	 * 
	 * @param pNoStdXml
	 * @param thisBusiConf
	 * @return
	 * @throws Exception
	 */
	private Format getFormat(Document pNoStdXml) throws Exception {
		String tFormatClassName = cThisBusiConf.getChildText("formatIns");
		// ����ת��ģ��
		cLogger.info((new StringBuilder("����ת��ģ�飺")).append(tFormatClassName).toString());
		Constructor tFormatConstructor = Class.forName(tFormatClassName).getConstructor(new Class[] { org.jdom.Element.class });
		Format tFormat = (Format) tFormatConstructor.newInstance(new Object[] { cThisBusiConf });
		return tFormat;
	}

	/**
	 * ���ͽ�������,�����ิд�÷���������webService����
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
           // throw new MidplatException("�ѳɹ���������״̬�ش���ѯ�������ظ�������");
		} else if (tExeSQL.mErrors.needDealError()) {
			throw new MidplatException("����״̬�ش���־�쳣��");
		}
     
		tOutXmlDoc = new CallWebsvcAtomSvc(AblifeCodeDef.NoRealTimeContInfo_SERVICE).call(cInXmlDoc);
		Element tOutRootEle = tOutXmlDoc.getRootElement();
		Element tOutHeadEle = tOutRootEle.getChild(Head);
		if (CodeDef.RCode_ERROR == Integer.parseInt(tOutHeadEle.getChildText(Flag))) {	// ����ʧ��
			throw new MidplatException(tOutHeadEle.getChildText(Desc));
		}
		
		return tOutXmlDoc;
	}

	/**
	 * ��Ҫ�ļ���Ƭ�����������и�д�÷������������ݷ�Ƭ����
	 * @param outNoStdXml
	 * @return
	 * @throws Exception
	 */
	protected List<Element> setAppEntityList(Document outNoStdXml) throws Exception {
		Element appEntityEle = (Element) XPath.selectSingleNode(outNoStdXml.getRootElement(), "//TranData/TranDatas");
		List<Element> list = new ArrayList<Element>();
		list.add((Element) appEntityEle.detach());
		return list;
	}

	/**
	 * ��ʵʱ�˱�ͬ���ļ����������չ�˾���루2λ��+���д��루2λ��+���״��루2λ��+���ڣ�8λ��.xml
	 * @param inXmlDoc
	 * @return
	 * @throws Exception
	 */
	protected String getOutFileName() throws Exception {
		StringBuffer strBuff = new StringBuffer();
		//���չ�˾���루2λ��+���д��루2λ��+���״��루2λ��+���ڣ�8λ��.xml
//		strBuff.append("100114").append(DateUtil.getCur8Date()).append(".xml");
		strBuff.append("100114").append(tranDate).append(".xml");
		return strBuff.toString();
	}

	/**
	 * ������׼�������
	 * @param outStdXmlDoc
	 * @return
	 */
	protected Document adjustOutStdXml(Document outStdXmlDoc) throws Exception {
		JdomUtil.print(outStdXmlDoc);
		Element BodyEle = (Element) XPath.selectSingleNode(outStdXmlDoc.getRootElement(), "//TranData");
		//�ļ���
		Element fileName = new Element("FileName");
		fileName.setText(outFileName);
		//��ϸ����
		Element surrCount = new Element("PolCount");
		surrCount.setText(this.allNumText+"");
		
		Element allNum = new Element("AllNum");
		allNum.setText(this.allNumText+"");
		
		Element allMoney = new Element("AllMoney");
		allMoney.setText(this.allMoneyText+"");

		BodyEle.addContent(allNum);
		BodyEle.addContent(allMoney);
		BodyEle.addContent(fileName);
		BodyEle.addContent(surrCount);

		return outStdXmlDoc;
	}
	
	/**
	 * ��ȡ�ļ����·��
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
     * ���ô��������÷��������ɱ��ط�������á�
     * һ����������ļ�����Ҫ������Ի����������ʵ�ָ÷�����
     * @return
     * @throws Exception
     */
    protected void ftpFile()throws Exception{
        //����ftp�ϴ��ļ�
        Element ftpElement = cThisBusiConf.getChild("ftp");
        if(ftpElement==null){
            cLogger.debug("δ����ftp��Ϣ...");
        }else{
            //������ftp�ϴ�
            FileTransportor t = new FtpUploadTransportor(cThisBusiConf);
            t.transport(getFtpName());
        }
        
        return;
    }

    /**
     * ftp�ļ���
     * 
     * @return �ļ���
     * @throws Exception 
     */
    protected String getFtpName() throws Exception{
        return getOutFileName();
    }
}

