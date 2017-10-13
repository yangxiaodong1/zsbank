package com.sinosoft.midplat.cgb.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.cgb.CgbConf;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.Format;
import com.sinosoft.midplat.service.Service;
import com.sinosoft.midplat.service.ServiceImpl;

public class CgbNewBusiBlc extends ServiceImpl {

	private Element thisRootConf;
	
	private final static String FUNCFLAG_BLC_NEWCONT = "2210";	// 新单日终对账

	
	public CgbNewBusiBlc(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document inXmlDoc) throws Exception {
		
		long tStartMillis = System.currentTimeMillis();
		cLogger.info("Into CgbNewBusiBlc.service()...");
		cInXmlDoc = inXmlDoc;
		JdomUtil.print(inXmlDoc);
		this.thisRootConf = CgbConf.newInstance().getConf().getRootElement();

		String localFilePath = getOutLocalDir();
		InputStream is = null;
		BufferedReader mBufReader = null;
		// 存流水
		try {
//			cTranLogDB = insertTranLog(inXmlDoc);
			Document inNoStdDoc = null;
			// 汇总后再调用相应的对账接口
			Element reqBodyEle = new Element("Body");
    		int reqCountInt = 0;
    		long reqPremLong = 0;
			// 1.读取本地某行日终对账文件（包含两个文件：柜面日终对账文件和网银日终对账文件）
			Element mBankEle = thisRootConf.getChild("bank");
			Element mTranDataEle = inXmlDoc.getRootElement();
			Element mHeadEle = mTranDataEle.getChild("Head");
			//柜面日终对账文件
			String guimianNameTxt = mBankEle.getAttributeValue("insu") + mBankEle.getAttributeValue(id)+ mHeadEle.getChildText("TranDate") +"01.txt";			
			//柜面专属日终对账文件名
			String netBankNameXml = "D018001"+ mHeadEle.getChildText("TranDate") + "01.xml";
			String netBankNameXml02 = "D018001"+ mHeadEle.getChildText("TranDate") + "02.xml";
			//柜面日终新单对账文件
			File guimianFile = new File(localFilePath+guimianNameTxt);			
			//柜面专属日终对账文件
			File guimianZSFile = new File(localFilePath+netBankNameXml);
			if(!guimianZSFile.exists()){
				guimianZSFile = new File(localFilePath+netBankNameXml02);
			}
			// 1. 处理柜面常规对账文件
            if(guimianFile.exists()){//文件存在
            	is = new FileInputStream(guimianFile);
            	mBufReader = new BufferedReader(new InputStreamReader(is));
            	Element mBodyEle = new Element(Body);
//            	Element mDetailList = new Element("Detail_List");
        		Element mCountEle = new Element(Count);
        		Element mPremEle = new Element(Prem);
//        		mBodyEle.setContent(mDetailList);
        		
        		for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
        			cLogger.info(tLineMsg);
        			// 空行，直接跳过
        			tLineMsg = tLineMsg.trim();
        			if ("".equals(tLineMsg)) {
        				cLogger.warn("空行，直接跳过，继续下一条！");
        				continue;
        			}
        			String[] tSubMsgs = tLineMsg.split("\\|", -1);
        			//柜面此时只有承保保单
        			if (!"1013".equals(tSubMsgs[4])) {
        				cLogger.warn("直接跳过，继续下一条！");
        				continue;
        			}
                    //交易日期
        			Element tTranDateEle = new Element(TranDate);
        			tTranDateEle.setText(tSubMsgs[1]);
                    //交易流水号
        			Element tTranNoEle = new Element(TranNo);
        			tTranNoEle.setText(tSubMsgs[5]);
                    //网点代码
        			Element tNodeNoEle = new Element(NodeNo);
        			tNodeNoEle.setText(tSubMsgs[2]+tSubMsgs[3]);
                    //保单号码
        			Element tContNoEle = new Element(ContNo);
        			tContNoEle.setText(tSubMsgs[6]);
                    //保费金额
        			Element tPremEle = new Element(Prem);
        			long tPremFen = NumberUtil.yuanToFen(tSubMsgs[7]);
        			tPremEle.setText(String.valueOf(tPremFen));  			
        			reqCountInt++;
        			reqPremLong = reqPremLong + tPremFen;

        			Element tDetailEle = new Element(Detail);
        			tDetailEle.addContent(tTranDateEle);
        			tDetailEle.addContent(tNodeNoEle);
        			tDetailEle.addContent(tTranNoEle);
        			tDetailEle.addContent(tContNoEle);
        			tDetailEle.addContent(tPremEle);

        			mBodyEle.addContent(tDetailEle);
        		}
        		mCountEle.setText(reqCountInt+"");
        		mPremEle.setText(reqPremLong+"");
        		mBodyEle.addContent(mCountEle);
        		mBodyEle.addContent(mPremEle);
//        		mBufReader.close(); // 关闭流
        		inNoStdDoc = new Document(mBodyEle);
        		System.out.println("===========柜面出单文件转换报文输出开始===============");
        		JdomUtil.print(inNoStdDoc);
        		System.out.println("===========柜面出单文件转换报文输出结束===============");
                List<Element> detailEleList = XPath.selectNodes(inNoStdDoc.getRootElement(),"//Detail");	
//              System.out.println("detailEleList.size=========================="+detailEleList.size());
				for (Element detailEle : detailEleList) {
					reqBodyEle.addContent(detailEle.detach());
				}
            }
            // 2、 处理柜面专属对账文件
            if(guimianZSFile.exists()){//文件存在
            	is = new FileInputStream(guimianZSFile);
            	mBufReader = new BufferedReader(new InputStreamReader(is));
            	StringBuffer sb = new StringBuffer();
        		for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {       			
        			sb.append(tLineMsg.trim());
        		}
        		String mCharset = cThisBusiConf.getChildText(charset);
        		if (null==mCharset || "".equals(mCharset)) {
        			mCharset = "GBK";
        		}
        		Document pNoStdXml = JdomUtil.build(sb.toString());
        		JdomUtil.print(pNoStdXml);
        		
        		//日志前缀
        		Element thisBusiConf = (Element) XPath.selectSingleNode(thisRootConf, "business[funcFlag='2211']");
        		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
        				.getName()).append('_').append(NoFactory.nextAppNo()).append(
        				'_').append(thisBusiConf.getChildText(funcFlag)).append(
        				"_in.xml");              
        		SaveMessage.save(pNoStdXml, thisBusiConf.getChildText(TranCom), mSaveName.toString());
        		cLogger.info("保存非标准请求报文完毕！");
        		String tFormatClassName = thisBusiConf.getChildText(format);
        		//报文转换模块
        		cLogger.info((new StringBuilder("报文转换模块：")).append(tFormatClassName).toString()); 
        		Constructor tFormatConstructor =  Class.forName(tFormatClassName).getConstructor(new Class[] { Element.class });
        		Format tFormat = (Format) tFormatConstructor.newInstance(new Object[] { thisBusiConf });
        		//将xml转换成标准报文
        		cLogger.info("convert nonstandard xml to standard xml...");
        		Document pStdXml = tFormat.noStd2Std(pNoStdXml);
//        		mBufReader.close(); // 关闭流
        		System.out.println("===========柜面出单XML转换报文输出开始===============");
        		JdomUtil.print(pStdXml);

        		System.out.println("===========柜面出单XML转换报文输出结束===============");
        		reqCountInt = reqCountInt + Integer.parseInt(pStdXml.getRootElement().getChild("Body").getChild("Count").getText());
        		long tPremFen = Long.parseLong((pStdXml.getRootElement().getChild("Body").getChild("Prem").getText()));
        		reqPremLong = reqPremLong + tPremFen;
                List<Element> detailEleList = XPath.selectNodes(pStdXml.getRootElement(),"//Detail");	
//              System.out.println("detailEleList.size=========================="+detailEleList.size());
				for (Element detailEle : detailEleList) {
					reqBodyEle.addContent(detailEle.detach());
				}
            }
            //只有当所有对账文件才能开始与核心进行对账处理
          if(guimianFile.exists() && guimianZSFile.exists()){
            	// 组织报文，供后续日终对账交易转换使用
    			Document totalDetail = new Document(new Element(TranData));
    			
    			Element reqCountEle = new Element(Count);
    			reqCountEle.setText(reqCountInt+"");   			
        		Element reqPremEle = new Element(Prem);
        		reqPremEle.setText(reqPremLong+"");
        		reqBodyEle.addContent(reqCountEle);
        		reqBodyEle.addContent(reqPremEle);
    			totalDetail.getRootElement().addContent(reqBodyEle);	
    			Element cHeadEle = (Element)inXmlDoc.getRootElement().getChild(Head).clone();
//    			cHeadEle.getChild(TranDate).setText(DateUtil.getDateStr(new Date(), "yyyyMMdd"));
    			cHeadEle.getChild(TranDate).setText(mHeadEle.getChildText("TranDate"));
    			totalDetail.getRootElement().addContent(cHeadEle);
//    			System.out.println("===========对账前报文格式输出开始===============");
//        		JdomUtil.print(totalDetail);
//        		System.out.println("===========对账前报文格式输出结束===============");
    				
    			//广发新单对账交易
				NewCgbBusiBlcTread blcThread = new NewCgbBusiBlcTread(FUNCFLAG_BLC_NEWCONT, totalDetail);
				blcThread.start();
    			
            }else{     	
            	cLogger.error("对账文件不存在，文件名为："+guimianFile+";"+guimianZSFile);
            	throw new MidplatException("对账文件不存在，文件名为："+guimianFile+";"+guimianZSFile);
            }
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "交易成功");	
			
		} catch (Exception e) {
			cLogger.error(cThisBusiConf.getChildText(name) + "交易失败！", e);

			if (null != cTranLogDB) { // 插入日志失败时cTranLogDB=null
				cTranLogDB.setRCode(CodeDef.RCode_ERROR); // -1-未返回；0-交易成功，返回；1-交易失败，返回
				cTranLogDB.setRText(NumberUtil.cutStrByByte(e.getMessage(), 150, MidplatConf.newInstance().getDBCharset()));
			}
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, e.getMessage());
		}finally{//关闭流
			if(mBufReader != null){
				mBufReader.close();
			}
			if(is != null){
				is.close();
			}
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
		cLogger.info("Out CgbNewBusiBlc.service()!");
		return cOutXmlDoc;
	}
	
	/**
	 * @Description: 日终财务类对账（新单）
	 * Copyright: Copyright (c) 2014
	 * Company:安邦保险IT部
	 * 
	 * @date Dec 31, 2014 11:30:24 AM
	 * @version 
	 *
	 */
	private class NewCgbBusiBlcTread extends Thread {
		private final Document cInXmlDoc;
		private final String cfuncFlag;

		private NewCgbBusiBlcTread(String funcFlag,Document noStdXmlDoc) {
			cInXmlDoc = (Document)noStdXmlDoc.clone();// 此处需要克隆一份新的，避免日终对账，保全对账操作同一个对象，导致funflag的值不一致。
			cfuncFlag = funcFlag;
		}

		public void run() {
			cLogger.info("Into NewCgbBusiBlcTread.run()...");

			this.setName(String.valueOf(NoFactory.nextTranLogNo()));
			try {
				Element thisBusiConf = (Element) XPath.selectSingleNode(thisRootConf, "business[funcFlag='" + cfuncFlag + "']");
				// 需要设置一下交易码
//				Element funcFlagEle = (Element) XPath.selectSingleNode(cInXmlDoc.getRootElement(), "//Head/FuncFlag");
//				funcFlagEle.setText(cfuncFlag);

//				System.out.println("-------NewCcbBusiBlcTread---------");
//				JdomUtil.print(cInXmlDoc);
				// 1. 转换标准报文
//				Document inStdDoc = nostd2std(cInXmlDoc, thisBusiConf);
				// 保存非标准报文
				StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
						.getName()).append('_').append(NoFactory.nextAppNo()).append(
						'_').append(cfuncFlag).append("_in.xml");
				SaveMessage.save(cInXmlDoc,((Element) thisRootConf.getChild(TranCom).clone()).getText(), mSaveName.toString());
				JdomUtil.print(cInXmlDoc);
				// 2. 调用日终对账服务
				sendRequest(cInXmlDoc, thisBusiConf);
			} catch (Exception e) {
				cLogger.error("日终交易失败，交易码[" + cfuncFlag + "]", e);
			}

			cLogger.info("Out NewCgbBusiBlcTread.run()!");
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
	 * @param tInStd	标准报文
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
	
	public static void main(String[] args) {
		try {
			Element tCcbConfEle = CgbConf.newInstance().getConf().getRootElement();
			Element tBusiConf = (Element) XPath.selectSingleNode(tCcbConfEle, "business[funcFlag='321']");
			CgbNewBusiBlc tCcbFinanceBlc = new CgbNewBusiBlc(tBusiConf);
			
			Document inNoStdDoc = JdomUtil.build(IOTrans.toString(new FileReader(new File("D:/CCBfile/put/653598_23_321_in.xml"))));
			tCcbFinanceBlc.service(inNoStdDoc);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}

