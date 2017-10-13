package com.sinosoft.midplat.icbc.service;

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
import com.sinosoft.midplat.icbc.IcbcConf;
import com.sinosoft.midplat.service.Service;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class IcbcAllEdrBlcService extends ServiceImpl {

	private Element thisRootConf;
	
	private final static String FUNCFLAG_BLC_EDR = "128";	// 保全对账（犹退）
	private boolean hasBL = false ;
	private boolean hasBD = false ;
	
	public IcbcAllEdrBlcService(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document inXmlDoc) throws Exception {
		
		long tStartMillis = System.currentTimeMillis();
		cLogger.info("Into IcbcAllEdrBlcService.service()...");
		cInXmlDoc = inXmlDoc;
		this.thisRootConf = IcbcConf.newInstance().getConf().getRootElement();

		String localFilePath = getOutLocalDir();
		InputStream is = null;
		BufferedReader mBufReader = null;
		// 存流水
		try {
//			cTranLogDB = insertTranLog(inXmlDoc);
			Document inNoStdDoc = null;
			// 汇总后再调用相应的对账接口
			Element reqBodyEle = new Element("Body");
			//处理日常保全（犹退、退保、满期）
			List<Element> detailBQEleList = XPath.selectNodes(inXmlDoc.getRootElement(),"//Detail");
			System.out.println("===========日常保全文件转换报文输出开始===============");
    		JdomUtil.print(inXmlDoc);
    		System.out.println("===========日常保全全文件转换报文输出结束===============");
			for (Element detailEle : detailBQEleList) {
				reqBodyEle.addContent(detailEle.detach());
			}
			
			// 1.读取本地某行日终对账文件（包含两个文件：柜面日终对账文件和网银日终对账文件）
			Element mBankEle = thisRootConf.getChild("bank");
			Element mTranDataEle = inXmlDoc.getRootElement();
			Element mHeadEle = mTranDataEle.getChild("Head");
			//日常对账文件
			String riBQname = mBankEle.getAttributeValue("insu")+mBankEle.getAttributeValue(id)+mHeadEle.getChildText("TranDate")+"BAOQUAN.txt";
            //保单质押对账文件名称
			String guimianBQName = mBankEle.getAttributeValue("insu")+"_"+mBankEle.getAttributeValue(id)+"_"+mHeadEle.getChildText("TranDate")+"_LMIMPAW.txt";
			//日常保全对账文件
			File richangBQFile = new File(localFilePath+riBQname);
			//保单质押对账文件文件
			File guimianBQFile = new File(localFilePath+guimianBQName);
            /**
             * 开始处理保单质押对账文件文件
             */
            if(guimianBQFile.exists()){//文件存在
            	is = new FileInputStream(guimianBQFile);
            	mBufReader = new BufferedReader(new InputStreamReader(is));
            	Element mBodyEle = new Element(Body);				
        		Element pubContInfo = initPubContInfoNode();
							
        		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
        			cLogger.info(tLineMsg);       			
        			//空行，直接跳过
        			tLineMsg = tLineMsg.trim();
        			if ("".equals(tLineMsg)) {
        				cLogger.warn("空行，直接跳过，继续下一条！");
        				continue;
        			}						
        			//银行交易流水号|地区号|网点号|操作员|单证号码|交易日期|交易金额|处理标志|销售渠道|备用字段1|备用字段2|备用字段3|备用字段4|
        			String[] tSubMsgs = tLineMsg.split("\\|", -1);
        			for(int i=0 ; i < tSubMsgs.length ; i++){
        				System.out.println("tSubMsgs[+"+i+"]=="+tSubMsgs[i]);
        			}
        			//<!-- 交易类型 --根据交易流水号到tranlog表获取funflag判断edortyp>
        			Element tEdorTypeEle = new Element("EdorType");	  
                    String mSqlStr = "select FUNCFLAG,Bak5 from TranLog where Rcode ='0' and TRANNO='" + tSubMsgs[0] + "'";
            		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
            		if (1 != mSSRS.MaxRow) {
            			throw new MidplatException("查询上一交易日志失败！");
            		} 
            		System.out.println("FUNCFLAG: "+mSSRS.GetText(1, 1));           		
            		String cFUNCFLAG=  mSSRS.GetText(1, 1);
            		String cBak5=  mSSRS.GetText(1, 2);  
            		String setFlag = " ";
            		if ("162".equals(cFUNCFLAG) ) {  
            			tEdorTypeEle.setText("BL"); 
            			setFlag = "19";  
             		}
            		if ("163".equals(cFUNCFLAG)) { 
             			tEdorTypeEle.setText("BD"); 
             			setFlag = "29";
             		}
            		System.out.println("setFlag: " + setFlag);
            		setEdrTypeFlag(setFlag);       			
        			//<!-- 保全申请书号码 -->	
        			Element tEdorAppNoEle = new Element("EdorAppNo");
        			tEdorAppNoEle.setText("");       			
        			//<!-- 保全批单号码[非必须] -->
        			Element tEdorNoEle = new Element("EdorNo");
        			tEdorNoEle.setText(cBak5);     			
        			//<!-- 保全批改申请日期 YYYY-MM-DD-->
        			Element tEdorAppDateEle = new Element("EdorAppDate");
        			tEdorAppDateEle.setText(tSubMsgs[5]);       			
        			// <!-- 保单号 -->		<!--必填项-->
        			Element tContNoEle = new Element(ContNo);
        			tContNoEle.setText(tSubMsgs[4]);	        			
        			//银行代码
        			Element tBankCodeEle = new Element("BankCode");
        			tBankCodeEle.setText(tSubMsgs[1]+tSubMsgs[2]);			       			
        			// <!-- 交易金额 单位（分）1000000分代表10000元--> <!--必填项-->
        			Element tTranMoneyEle = new Element("TranMoney");
        			tTranMoneyEle.setText(tSubMsgs[6]);        			
        			//银行账户
        			Element tAccNoEle = new Element(AccNo);
        			tAccNoEle.setText("");        			
        			//账户名称
        			Element tAccNameEle = new Element(AccName);
        			tAccNameEle.setText("");       					
        			//  <!-- 响应码 0成功，1失败-->
        			Element tRCodeEle = new Element("RCode");
        			tRCodeEle.setText(tSubMsgs[7]);
        			
        			Element tDetailEle = new Element(Detail);						
        			tDetailEle.addContent(tBankCodeEle);
        			tDetailEle.addContent(tEdorTypeEle);
        			tDetailEle.addContent(tEdorAppNoEle);
        			tDetailEle.addContent(tEdorNoEle);
        			tDetailEle.addContent(tEdorAppDateEle);
        			tDetailEle.addContent(tContNoEle);			
        			tDetailEle.addContent(tTranMoneyEle);
        			tDetailEle.addContent(tAccNoEle);
        			tDetailEle.addContent(tAccNameEle);
        			tDetailEle.addContent(tRCodeEle);       			
        			mBodyEle.addContent(tDetailEle);					
        		}      		
        		this.setPubContInfoValue(pubContInfo) ;
        		mBodyEle.addContent(pubContInfo);
//        		mBufReader.close(); // 关闭流
        		inNoStdDoc = new Document(mBodyEle);
        		System.out.println("===========保单质押文件转换报文输出开始===============");
        		JdomUtil.print(inNoStdDoc);
        		System.out.println("===========保单质押全文件转换报文输出结束===============");
                List<Element> detailEleList = XPath.selectNodes(inNoStdDoc.getRootElement(),"//Detail");		
				for (Element detailEle : detailEleList) {
					reqBodyEle.addContent(detailEle.detach());
				}
            }
            //只有当所有对账文件才能开始与核心进行对账处理
            if(richangBQFile.exists() && guimianBQFile.exists()){
            	// 组织报文，供后续日终对账交易转换使用
    			Document totalDetail = new Document(new Element(TranData));
    			Element pubContInfoEle = (Element)inXmlDoc.getRootElement().getChild("Body").getChild("PubContInfo").clone();		
    			Element bLBlcType = new Element("BLBlcType");
    			Element bDBlcType = new Element("BDBlcType");
    			if(hasBL){
    				bLBlcType.setText("1");
    			}else{
    				bLBlcType.setText("0");
    			}
    			if(hasBD){
    				bDBlcType.setText("1");
    			}else{
    				bDBlcType.setText("0");
    			}
    			pubContInfoEle.addContent(bLBlcType);
    			pubContInfoEle.addContent(bDBlcType);
    			
    			totalDetail.getRootElement().addContent(reqBodyEle);
    			totalDetail.getRootElement().getChild("Body").addContent(pubContInfoEle);
    			Element cHeadEle = (Element)inXmlDoc.getRootElement().getChild(Head).clone();

//    			cHeadEle.getChild(TranDate).setText(DateUtil.getDateStr(new Date(), "yyyyMMdd"));
    			cHeadEle.getChild(TranDate).setText(mHeadEle.getChildText("TranDate"));
    			totalDetail.getRootElement().addContent(cHeadEle);
    			System.out.println("===========对账前报文格式输出开始===============");
        		JdomUtil.print(totalDetail);
        		System.out.println("===========对账前报文格式输出结束===============");	
    			//综合保全对账，包括原保全对账和保单质押
    			callServiceThread(FUNCFLAG_BLC_EDR, totalDetail);	
            }else{
            	cLogger.error("对账文件不存在，文件名为："+guimianBQName + "或"+riBQname);
            	throw new MidplatException("对账文件不存在，文件名为："+guimianBQName +"或"+riBQname);
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
		cLogger.info("Out PsbcFinanceBlc.service()!");
		return cOutXmlDoc;
	}


	/**
	 * 调用核心WebService服务接口
	 * @param funcFlag
	 * @param noStdXmlDoc
	 * @return
	 * @throws Exception
	 */
	private void callServiceThread(final String funcFlag, final Document noStdXmlDoc) throws Exception {
		// 新建线程
		new Thread(String.valueOf(NoFactory.nextTranLogNo())) {
			@Override
			public void run() {
				try {
					Element thisBusiConf = (Element) XPath.selectSingleNode(thisRootConf, "business[funcFlag='" + funcFlag + "']");
					// 需要设置一下交易码
//					Element funcFlagEle = (Element) XPath.selectSingleNode(noStdXmlDoc.getRootElement(), "//Head/FuncFlag");
//					funcFlagEle.setText(funcFlag);
					// 保存非标准报文
					StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
							.getName()).append('_').append(NoFactory.nextAppNo()).append(
							'_').append(funcFlag).append("_in.xml");
					SaveMessage.save(noStdXmlDoc,((Element) thisRootConf.getChild(TranCom).clone()).getText(), mSaveName.toString());
					// 2. 调用日终对账服务
					sendRequest(noStdXmlDoc, thisBusiConf);
				} catch (Exception e) {
					cLogger.error("日终交易失败，交易码[" + funcFlag + "]", e);
				}
			}
		}.start();
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
	
	private void setPubContInfoValue(Element pubContInfo){		
		pubContInfo.getChild("BLBlcType").setText(this.hasBL ? "1" : "0") ;
		pubContInfo.getChild("BDBlcType").setText(this.hasBD ? "1" : "0") ;
	}
	
	private Element initPubContInfoNode(){
		Element pubContInfoEle = new Element("PubContInfo");
		
 		Element bLBlcType = new Element("BLBlcType");
		Element bDBlcType = new Element("BDBlcType");

		pubContInfoEle.addContent(bLBlcType);
		pubContInfoEle.addContent(bDBlcType);
		return pubContInfoEle ;
		
	}	
	
	private void setEdrTypeFlag(String flag) throws Exception{	
	    if ("19".equals(flag)){	    	
	    	if(!this.hasBL){
				this.hasBL = true ;
				cLogger.info("19");			
			}
	    }	    
       if ("29".equals(flag)){   	  
	       if(!this.hasBD){
			this.hasBD = true ;
			cLogger.info("29");
	       }
        }		
	}	
	
	public static void main(String[] args) {
		try {
			Element tCcbConfEle = IcbcConf.newInstance().getConf().getRootElement();
			Element tBusiConf = (Element) XPath.selectSingleNode(tCcbConfEle, "business[funcFlag='321']");
			IcbcAllEdrBlcService tCcbFinanceBlc = new IcbcAllEdrBlcService(tBusiConf);
			
			Document inNoStdDoc = JdomUtil.build(IOTrans.toString(new FileReader(new File("D:/CCBfile/put/653598_23_321_in.xml"))));
			tCcbFinanceBlc.service(inNoStdDoc);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}

