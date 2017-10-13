package com.sinosoft.midplat.cmb.bat;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.FileUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.XmlConf;
import com.sinosoft.midplat.cmb.CmbConf;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.service.Service;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;
/**
 * ����Ӱ����
 * @author AB044104
 *
 */
public class CmbImageTrans extends ABBalance {

	private  XmlConf cThisConf;
	private  int cFuncFlag; // ���״���
//	private String ttLocalDir;
	private String ttLocalDirPlyFile;	//�б�Ӱ��Ŀ¼
	private String ttLocalDirEdrCTFile;//�˱�Ӱ��Ŀ¼
	public CmbImageTrans() {
		super(CmbConf.newInstance(), "1015");
//		
		cThisConf = CmbConf.newInstance();
		cFuncFlag = 1015;
	}
	
//	protected Element getHead() {
//		Element mHead = super.getHead();
//
//		Element mBankCode = new Element("BankCode");
//		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
//		mHead.addContent(mBankCode);
//
//		return mHead;
//	}
	
	@Override
	protected String getFileName() {
		// TODO Auto-generated method stub
		return cThisBusiConf.getChildTextTrim("localIP");
	}
	/**
	 * ������Ҫ�����ļ�����Ҫ��д�������
	 * 
	 */
	public void run() {
		Thread.currentThread().setName(
				String.valueOf(NoFactory.nextTranLogNo()));
		cLogger.info("Into CmbImageTrans.run()...");
		
		//�����һ�ν����Ϣ
		cResultMsg = null;
		
		try {
			
			if (null == cTranDate) {
				cTranDate = new Date();
			}
			
			//modify PBKINSR-1399 ����Ӱ����ʱ���� begin
			Calendar mCalendar = Calendar.getInstance();
			mCalendar.setTime(cTranDate);
	        mCalendar.add(Calendar.DATE,-1);
	        cTranDate = DateUtil.parseDate( DateUtil.getDateStr(mCalendar.getTime(), "yyyy-MM-dd"),"yyyy-MM-dd");
			//modify PBKINSR-1399 ����Ӱ����ʱ���� end
			
			cMidplatRoot = MidplatConf.newInstance().getConf().getRootElement();
			cThisConfRoot = cThisConf.getConf().getRootElement();
			cThisBusiConf = (Element) XPath.selectSingleNode(
					cThisConfRoot, "business[funcFlag='"+cFuncFlag+"']");
			Element tTranData = new Element(TranData);
			Document tInStdXml = new Document(tTranData);
			
			Element tHeadEle = getHead();
			tTranData.addContent(tHeadEle);
			
			try {
				
//				ttLocalDir = cThisBusiConf.getChildTextTrim(localDir);
				ttLocalDirPlyFile = cThisBusiConf.getChildTextTrim("LocalDirPlyFile");
				ttLocalDirEdrCTFile = cThisBusiConf.getChildTextTrim("LocalDirEdrCTFile");
//				File localFile = new File(ttLocalDir);
//				cLogger.info("LocalDir = "+ttLocalDir);
				File localPlyFile = new File(ttLocalDirPlyFile);
				cLogger.info("�б�Ӱ��Ŀ¼ = "+ttLocalDirPlyFile);
				File localEdrCTFile = new File(ttLocalDirEdrCTFile);
				cLogger.info("�˱�Ӱ��Ŀ¼ = "+ttLocalDirEdrCTFile);
				//�������ڱ�������ȷ���ļ���-----�б��ļ�
				FileUtil fileUtil = new FileUtil();
				File[] filePlyList = fileUtil.searchFile(localPlyFile,DateUtil.get8Date(cTranDate) + "_");
				//�����ļ�������Ŀ¼��
				if(filePlyList != null && filePlyList.length > 0){
					filePlyList = fileUtil.backupFiles(filePlyList, ttLocalDirPlyFile, DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
				}
				else {
					//������������ļ�Ϊ�գ�˵�������ѱ��ݹ����ɴӱ���Ŀ¼�г��ļ�
					cLogger.info("�б�Ӱ����������ļ�Ϊ��");
					File bfFile = new File(localPlyFile,DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
					if(bfFile.exists()){
						cLogger.info("�ļ������������ļ�Ϊ�գ��ӱ���Ŀ¼�л�ȡ�ļ�������Ŀ¼Ϊ�� " 
								+ttLocalDirPlyFile + File.separator + DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
						filePlyList = bfFile.listFiles();
					}
					
				}
				//�������ڱ�������ȷ���ļ���-----�˱��ļ�
				File[] fileEdrCTList = fileUtil.searchFile(localEdrCTFile,DateUtil.get8Date(cTranDate) + "_");
				//�����ļ�������Ŀ¼��
				if(fileEdrCTList != null && fileEdrCTList.length > 0){
					fileEdrCTList = fileUtil.backupFiles(fileEdrCTList, ttLocalDirEdrCTFile, DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
				}
				else {
					//������������ļ�Ϊ�գ�˵�������ѱ��ݹ����ɴӱ���Ŀ¼�г��ļ�
					cLogger.info("�˱�Ӱ����������ļ�Ϊ��");
					File bfFile = new File(localEdrCTFile,DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
					if(bfFile.exists()){
						cLogger.info("�ļ������������ļ�Ϊ�գ��ӱ���Ŀ¼�л�ȡ�ļ�������Ŀ¼Ϊ�� " 
								+ttLocalDirEdrCTFile + File.separator + DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
						fileEdrCTList = bfFile.listFiles();
					}
					
				}
				//��ȡ��׼���˱���
				Element ttBodyEle = parse(filePlyList,fileEdrCTList);
				
				tTranData.addContent(ttBodyEle);
			} catch (Exception ex) {
				cLogger.error("���ɱ�׼���˱��ĳ���", ex);
				
				//��ȡ��׼���˱���
				Element ttError = new Element(Error);
				String ttErrorStr = ex.getMessage();
				if ("".equals(ttErrorStr)) {
					ttErrorStr = ex.toString();
				}
				ttError.setText(ttErrorStr);
				tTranData.addContent(ttError);
			}
			
			//����ҵ������ȡ��׼���ر���
			String tServiceClassName = "com.sinosoft.midplat.service.ServiceImpl";
			//��midplat.xml���зǿ�Ĭ�����ã����ø�����
			String tServiceValue = cMidplatRoot.getChildText(service);
			if (null!=tServiceValue && !"".equals(tServiceValue)) {
				tServiceClassName = tServiceValue;
			}
			//����ϵͳ�ĸ��Ի������ļ����зǿ�Ĭ�����ã����ø�����
			tServiceValue = cThisConfRoot.getChildText(service);
			if (null!=tServiceValue && !"".equals(tServiceValue)) {
				tServiceClassName = tServiceValue;
			}
			tServiceValue = cThisBusiConf.getChildText(service);
			if (null!=tServiceValue && !"".equals(tServiceValue)) {
				tServiceClassName = tServiceValue;
			}
			cLogger.info("ҵ����ģ�飺" + tServiceClassName);
			Constructor<Service> tServiceConstructor = (Constructor<Service>) Class.forName(
					tServiceClassName).getConstructor(new Class[]{Element.class});
			Service tService = tServiceConstructor.newInstance(new Object[]{cThisBusiConf});
			Document tOutStdXml = tService.service(tInStdXml);
			
			cResultMsg = tOutStdXml.getRootElement().getChild(
					Head).getChildText(Desc);
			
			
			//ÿ��1�ձ������µĶ����ļ�
//			if ("01".equals(DateUtil.getDateStr(cTranDate, "dd"))) {
//				bakFiles(cThisBusiConf.getChildTextTrim(localDir));
//			}
		} catch (Throwable ex) {
			cLogger.error("���׳���", ex);
			cResultMsg = ex.toString();
		}
		
		cTranDate = null;	//ÿ�����꣬�������
		
		cLogger.info("Out CmbImageTrans.run()!");
	}
	
	protected Element parse(File[] plyFileList, File[] edrCTFileList) throws Exception {
		
		cLogger.info("Into CmbImageTrans.parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		
		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		Element mDetails = new Element("Details");
		mBodyEle.addContent(mCountEle);
		mBodyEle.addContent(mDetails);
		
//		long mSumPrem = 0;
		int mCount = 0;
		//�б�Ӱ�����
		if(plyFileList != null && plyFileList.length > 0){
			for (int i = 0 ; i < plyFileList.length ; i ++ ){
				
				System.out.println(plyFileList[i]);
				//������ȡ�ļ���������ֵ
//				String strFileList = fileList[i].toString().replaceAll("\\\\","/");;
//				String[] tSubMsgs = strFileList.toString().split("\\/",-1);
				//�ļ���
				String fileName = plyFileList[i].getName();
				
				Element mDetail = new Element("Detail");
				//��������
				Element tTranDate = new Element("TranDate");
				tTranDate.setText(DateUtil.get8Date(cTranDate) + "");
				mDetail.addContent(tTranDate);
								
				//�����ţ��Ǳ�����
				Element tContNo = new Element("ContNo");//������
				tContNo.setText(fileName.split("\\_", -1)[1]);
				mDetail.addContent(tContNo);
				
				
//				//1013--�����շ�ǩ����1020--�����˱�ȷ��
//				StringBuffer mSqlStr = new StringBuffer();
//				mSqlStr.append("select Funcflag from TranLog ");
//				mSqlStr.append(" where Rcode = '0' and Funcflag in ('1013','1020')");
//				mSqlStr.append("   and ContNo = '"+tContNo.getText()+"'");
//				mSqlStr.append("   and TranDate ="+ tTranDate.getText());
//				mSqlStr.append(" order by Maketime desc");
//				
//				SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
//				if (mSSRS.MaxRow < 1) {
//					//��û�鵽���ݣ�����Ϊ��Ӱ��Ϊ�������ݣ���������
//					continue;
//				}
//				String funcflag = mSSRS.GetText(1, 1);
//				String BusinessType = "";
//				if("1013".equals(funcflag)) {
//					//�б�Ӱ��
//					BusinessType = "NB";
//				}else if("1020".equals(funcflag)){
//					//�˱�Ӱ��
//					BusinessType = "CT";
//				}
				//�б�Ӱ��
				String BusinessType = "NB";
				//BusinessTypeҵ������: BusinessTypeҵ������: NB =Ͷ����CT =�˱�
				Element tBusinessType = new Element("BusinessType");
				tBusinessType.setText(BusinessType);
				mDetail.addContent(tBusinessType);
				
				//Ͷ�����ţ��Ǳ�����
				Element tProposalPrtNo = new Element("ProposalPrtNo");//������
				tProposalPrtNo.setText("");
				mDetail.addContent(tProposalPrtNo);
				
				//��֤�ţ��Ǳ�����
				Element tContPrtNo = new Element("ContPrtNo");//������
				tContPrtNo.setText("");
				mDetail.addContent(tContPrtNo);
				
				//���·���ǻ�����ʩ�ṩ�Ļ���·��������xml�ļ���
				Element tFilePath = new Element("FilePath");

				String virtualDir = cThisBusiConf.getChildTextTrim("VirtualDir");
				String filePath = plyFileList[i].getPath().replace(fileName, "");
				
				//   \\10.4.16.78\cmbbatch\
				filePath = File.separator + File.separator + getFileName() + File.separator 
							+ filePath.substring(filePath.lastIndexOf(virtualDir));
				filePath = filePath.replaceAll("/","\\\\");
//				filePath = "\\\\10.4.16.84\\share\\lis\\";
				System.out.println("filePath==" + filePath);
				tFilePath.setText(filePath);
				mDetail.addContent(tFilePath);
				
				//�ļ���
				Element tFileName = new Element("FileName");
				tFileName.setText(fileName);
				mDetail.addContent(tFileName);
			
				mDetails.addContent(mDetail);
				mCount++;
			}
		}
		//�˱�Ӱ�����
		if(edrCTFileList != null && edrCTFileList.length > 0){
			for (int i = 0 ; i < edrCTFileList.length ; i ++ ){
				
				System.out.println(edrCTFileList[i]);
				//������ȡ�ļ���������ֵ
//				String strFileList = fileList[i].toString().replaceAll("\\\\","/");;
//				String[] tSubMsgs = strFileList.toString().split("\\/",-1);
				//�ļ���
				String fileName = edrCTFileList[i].getName();
				
				Element mDetail = new Element("Detail");
				//��������
				Element tTranDate = new Element("TranDate");
				tTranDate.setText(DateUtil.get8Date(cTranDate) + "");
				mDetail.addContent(tTranDate);
								
				//�����ţ��Ǳ�����
				Element tContNo = new Element("ContNo");//������
				tContNo.setText(fileName.split("\\_", -1)[1]);
				mDetail.addContent(tContNo);
				
				
//				//1013--�����շ�ǩ����1020--�����˱�ȷ��
//				StringBuffer mSqlStr = new StringBuffer();
//				mSqlStr.append("select Funcflag from TranLog ");
//				mSqlStr.append(" where Rcode = '0' and Funcflag in ('1013','1020')");
//				mSqlStr.append("   and ContNo = '"+tContNo.getText()+"'");
//				mSqlStr.append("   and TranDate ="+ tTranDate.getText());
//				mSqlStr.append(" order by Maketime desc");
//				
//				SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
//				if (mSSRS.MaxRow < 1) {
//					//��û�鵽���ݣ�����Ϊ��Ӱ��Ϊ�������ݣ���������
//					continue;
//				}
//				String funcflag = mSSRS.GetText(1, 1);
//				String BusinessType = "";
//				if("1013".equals(funcflag)) {
//					//�б�Ӱ��
//					BusinessType = "NB";
//				}else if("1020".equals(funcflag)){
//					//�˱�Ӱ��
//					BusinessType = "CT";
//				}
				//�˱�Ӱ��
				String BusinessType = "CT";
				//BusinessTypeҵ������: BusinessTypeҵ������: NB =Ͷ����CT =�˱�
				Element tBusinessType = new Element("BusinessType");
				tBusinessType.setText(BusinessType);
				mDetail.addContent(tBusinessType);
				
				//Ͷ�����ţ��Ǳ�����
				Element tProposalPrtNo = new Element("ProposalPrtNo");//������
				tProposalPrtNo.setText("");
				mDetail.addContent(tProposalPrtNo);
				
				//��֤�ţ��Ǳ�����
				Element tContPrtNo = new Element("ContPrtNo");//������
				tContPrtNo.setText("");
				mDetail.addContent(tContPrtNo);
				
				//���·���ǻ�����ʩ�ṩ�Ļ���·��������xml�ļ���
				Element tFilePath = new Element("FilePath");

				String virtualDir = cThisBusiConf.getChildTextTrim("VirtualDir");
				String filePath = edrCTFileList[i].getPath().replace(fileName, "");
				
				//   \\10.4.16.78\cmbbatch\
				filePath = File.separator + File.separator + getFileName() + File.separator 
							+ filePath.substring(filePath.lastIndexOf(virtualDir));
				filePath = filePath.replaceAll("/","\\\\");
//				filePath = "\\\\10.4.16.84\\share\\lis\\";
				System.out.println("filePath==" + filePath);
				tFilePath.setText(filePath);
				mDetail.addContent(tFilePath);
				
				//�ļ���
				Element tFileName = new Element("FileName");
				tFileName.setText(fileName);
				mDetail.addContent(tFileName);
			
				mDetails.addContent(mDetail);
				mCount++;
			}
		}
		
		
		mCountEle.setText(String.valueOf(mCount));
		
		
		cLogger.info("Out CmbImageTrans.parse()!");
		return mBodyEle;
	}
	
	/**������ڷ���
	 * @param args
	 */
	public static void main(String[] args) 
	{
		CmbImageTrans tNjcbBusiBlc = new CmbImageTrans();
//		tNjcbBusiBlc.setDate("20150522");
		try
		{
			tNjcbBusiBlc.run();
		} catch (Exception e) 
		{
			e.printStackTrace();
		}
	}



}

