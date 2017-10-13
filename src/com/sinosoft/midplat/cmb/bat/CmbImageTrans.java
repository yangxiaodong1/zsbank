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
 * 招行影像传输
 * @author AB044104
 *
 */
public class CmbImageTrans extends ABBalance {

	private  XmlConf cThisConf;
	private  int cFuncFlag; // 交易代码
//	private String ttLocalDir;
	private String ttLocalDirPlyFile;	//承保影像目录
	private String ttLocalDirEdrCTFile;//退保影像目录
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
	 * 由于需要遍历文件，需要重写任务入口
	 * 
	 */
	public void run() {
		Thread.currentThread().setName(
				String.valueOf(NoFactory.nextTranLogNo()));
		cLogger.info("Into CmbImageTrans.run()...");
		
		//清空上一次结果信息
		cResultMsg = null;
		
		try {
			
			if (null == cTranDate) {
				cTranDate = new Date();
			}
			
			//modify PBKINSR-1399 招行影像传输时间变更 begin
			Calendar mCalendar = Calendar.getInstance();
			mCalendar.setTime(cTranDate);
	        mCalendar.add(Calendar.DATE,-1);
	        cTranDate = DateUtil.parseDate( DateUtil.getDateStr(mCalendar.getTime(), "yyyy-MM-dd"),"yyyy-MM-dd");
			//modify PBKINSR-1399 招行影像传输时间变更 end
			
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
				cLogger.info("承保影像目录 = "+ttLocalDirPlyFile);
				File localEdrCTFile = new File(ttLocalDirEdrCTFile);
				cLogger.info("退保影像目录 = "+ttLocalDirEdrCTFile);
				//根据日期遍历出正确的文件名-----承保文件
				FileUtil fileUtil = new FileUtil();
				File[] filePlyList = fileUtil.searchFile(localPlyFile,DateUtil.get8Date(cTranDate) + "_");
				//备份文件到日期目录下
				if(filePlyList != null && filePlyList.length > 0){
					filePlyList = fileUtil.backupFiles(filePlyList, ttLocalDirPlyFile, DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
				}
				else {
					//如果遍历出的文件为空，说明可能已备份过，可从备份目录中出文件
					cLogger.info("承保影像遍历检索文件为空");
					File bfFile = new File(localPlyFile,DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
					if(bfFile.exists()){
						cLogger.info("文件遍历并检索文件为空，从备份目录中获取文件，备份目录为： " 
								+ttLocalDirPlyFile + File.separator + DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
						filePlyList = bfFile.listFiles();
					}
					
				}
				//根据日期遍历出正确的文件名-----退保文件
				File[] fileEdrCTList = fileUtil.searchFile(localEdrCTFile,DateUtil.get8Date(cTranDate) + "_");
				//备份文件到日期目录下
				if(fileEdrCTList != null && fileEdrCTList.length > 0){
					fileEdrCTList = fileUtil.backupFiles(fileEdrCTList, ttLocalDirEdrCTFile, DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
				}
				else {
					//如果遍历出的文件为空，说明可能已备份过，可从备份目录中出文件
					cLogger.info("退保影像遍历检索文件为空");
					File bfFile = new File(localEdrCTFile,DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
					if(bfFile.exists()){
						cLogger.info("文件遍历并检索文件为空，从备份目录中获取文件，备份目录为： " 
								+ttLocalDirEdrCTFile + File.separator + DateUtil.getDateStr(cTranDate,"yyyy/yyyyMM/yyyyMMdd"));
						fileEdrCTList = bfFile.listFiles();
					}
					
				}
				//获取标准对账报文
				Element ttBodyEle = parse(filePlyList,fileEdrCTList);
				
				tTranData.addContent(ttBodyEle);
			} catch (Exception ex) {
				cLogger.error("生成标准对账报文出错！", ex);
				
				//获取标准对账报文
				Element ttError = new Element(Error);
				String ttErrorStr = ex.getMessage();
				if ("".equals(ttErrorStr)) {
					ttErrorStr = ex.toString();
				}
				ttError.setText(ttErrorStr);
				tTranData.addContent(ttError);
			}
			
			//调用业务处理，获取标准返回报文
			String tServiceClassName = "com.sinosoft.midplat.service.ServiceImpl";
			//若midplat.xml中有非空默认配置，采用该配置
			String tServiceValue = cMidplatRoot.getChildText(service);
			if (null!=tServiceValue && !"".equals(tServiceValue)) {
				tServiceClassName = tServiceValue;
			}
			//若子系统的个性化配置文件中有非空默认配置，采用该配置
			tServiceValue = cThisConfRoot.getChildText(service);
			if (null!=tServiceValue && !"".equals(tServiceValue)) {
				tServiceClassName = tServiceValue;
			}
			tServiceValue = cThisBusiConf.getChildText(service);
			if (null!=tServiceValue && !"".equals(tServiceValue)) {
				tServiceClassName = tServiceValue;
			}
			cLogger.info("业务处理模块：" + tServiceClassName);
			Constructor<Service> tServiceConstructor = (Constructor<Service>) Class.forName(
					tServiceClassName).getConstructor(new Class[]{Element.class});
			Service tService = tServiceConstructor.newInstance(new Object[]{cThisBusiConf});
			Document tOutStdXml = tService.service(tInStdXml);
			
			cResultMsg = tOutStdXml.getRootElement().getChild(
					Head).getChildText(Desc);
			
			
			//每月1日备份上月的对账文件
//			if ("01".equals(DateUtil.getDateStr(cTranDate, "dd"))) {
//				bakFiles(cThisBusiConf.getChildTextTrim(localDir));
//			}
		} catch (Throwable ex) {
			cLogger.error("交易出错！", ex);
			cResultMsg = ex.toString();
		}
		
		cTranDate = null;	//每次跑完，清空日期
		
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
		//承保影像遍历
		if(plyFileList != null && plyFileList.length > 0){
			for (int i = 0 ; i < plyFileList.length ; i ++ ){
				
				System.out.println(plyFileList[i]);
				//解析截取文件名串并赋值
//				String strFileList = fileList[i].toString().replaceAll("\\\\","/");;
//				String[] tSubMsgs = strFileList.toString().split("\\/",-1);
				//文件名
				String fileName = plyFileList[i].getName();
				
				Element mDetail = new Element("Detail");
				//交易日期
				Element tTranDate = new Element("TranDate");
				tTranDate.setText(DateUtil.get8Date(cTranDate) + "");
				mDetail.addContent(tTranDate);
								
				//保单号，非必输项
				Element tContNo = new Element("ContNo");//地区号
				tContNo.setText(fileName.split("\\_", -1)[1]);
				mDetail.addContent(tContNo);
				
				
//				//1013--网银收费签单、1020--网银退保确认
//				StringBuffer mSqlStr = new StringBuffer();
//				mSqlStr.append("select Funcflag from TranLog ");
//				mSqlStr.append(" where Rcode = '0' and Funcflag in ('1013','1020')");
//				mSqlStr.append("   and ContNo = '"+tContNo.getText()+"'");
//				mSqlStr.append("   and TranDate ="+ tTranDate.getText());
//				mSqlStr.append(" order by Maketime desc");
//				
//				SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
//				if (mSSRS.MaxRow < 1) {
//					//若没查到数据，则认为该影像为冗余数据，不传核心
//					continue;
//				}
//				String funcflag = mSSRS.GetText(1, 1);
//				String BusinessType = "";
//				if("1013".equals(funcflag)) {
//					//承保影像
//					BusinessType = "NB";
//				}else if("1020".equals(funcflag)){
//					//退保影像
//					BusinessType = "CT";
//				}
				//承保影像
				String BusinessType = "NB";
				//BusinessType业务类型: BusinessType业务类型: NB =投保，CT =退保
				Element tBusinessType = new Element("BusinessType");
				tBusinessType.setText(BusinessType);
				mDetail.addContent(tBusinessType);
				
				//投保单号，非必输项
				Element tProposalPrtNo = new Element("ProposalPrtNo");//地区号
				tProposalPrtNo.setText("");
				mDetail.addContent(tProposalPrtNo);
				
				//单证号，非必输项
				Element tContPrtNo = new Element("ContPrtNo");//地区号
				tContPrtNo.setText("");
				mDetail.addContent(tContPrtNo);
				
				//这个路径是基础设施提供的基础路径配置在xml文件中
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
				
				//文件名
				Element tFileName = new Element("FileName");
				tFileName.setText(fileName);
				mDetail.addContent(tFileName);
			
				mDetails.addContent(mDetail);
				mCount++;
			}
		}
		//退保影像遍历
		if(edrCTFileList != null && edrCTFileList.length > 0){
			for (int i = 0 ; i < edrCTFileList.length ; i ++ ){
				
				System.out.println(edrCTFileList[i]);
				//解析截取文件名串并赋值
//				String strFileList = fileList[i].toString().replaceAll("\\\\","/");;
//				String[] tSubMsgs = strFileList.toString().split("\\/",-1);
				//文件名
				String fileName = edrCTFileList[i].getName();
				
				Element mDetail = new Element("Detail");
				//交易日期
				Element tTranDate = new Element("TranDate");
				tTranDate.setText(DateUtil.get8Date(cTranDate) + "");
				mDetail.addContent(tTranDate);
								
				//保单号，非必输项
				Element tContNo = new Element("ContNo");//地区号
				tContNo.setText(fileName.split("\\_", -1)[1]);
				mDetail.addContent(tContNo);
				
				
//				//1013--网银收费签单、1020--网银退保确认
//				StringBuffer mSqlStr = new StringBuffer();
//				mSqlStr.append("select Funcflag from TranLog ");
//				mSqlStr.append(" where Rcode = '0' and Funcflag in ('1013','1020')");
//				mSqlStr.append("   and ContNo = '"+tContNo.getText()+"'");
//				mSqlStr.append("   and TranDate ="+ tTranDate.getText());
//				mSqlStr.append(" order by Maketime desc");
//				
//				SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
//				if (mSSRS.MaxRow < 1) {
//					//若没查到数据，则认为该影像为冗余数据，不传核心
//					continue;
//				}
//				String funcflag = mSSRS.GetText(1, 1);
//				String BusinessType = "";
//				if("1013".equals(funcflag)) {
//					//承保影像
//					BusinessType = "NB";
//				}else if("1020".equals(funcflag)){
//					//退保影像
//					BusinessType = "CT";
//				}
				//退保影像
				String BusinessType = "CT";
				//BusinessType业务类型: BusinessType业务类型: NB =投保，CT =退保
				Element tBusinessType = new Element("BusinessType");
				tBusinessType.setText(BusinessType);
				mDetail.addContent(tBusinessType);
				
				//投保单号，非必输项
				Element tProposalPrtNo = new Element("ProposalPrtNo");//地区号
				tProposalPrtNo.setText("");
				mDetail.addContent(tProposalPrtNo);
				
				//单证号，非必输项
				Element tContPrtNo = new Element("ContPrtNo");//地区号
				tContPrtNo.setText("");
				mDetail.addContent(tContPrtNo);
				
				//这个路径是基础设施提供的基础路径配置在xml文件中
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
				
				//文件名
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
	
	/**测试入口方法
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

