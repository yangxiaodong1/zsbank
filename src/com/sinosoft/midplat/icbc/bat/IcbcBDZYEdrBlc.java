/**
 * 工行保单质押、解押、强卖对账
 */

package com.sinosoft.midplat.icbc.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance; 
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.icbc.IcbcConf; 
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class IcbcBDZYEdrBlc extends Balance {
	
	private boolean hasTB = false ;
	private boolean hasYYTB = false ;
	private boolean hasMQ = false ;
	private boolean hasXQ = false ;
	private boolean hasPN = false ;
	private boolean hasBL = false ;
	private boolean hasBD = false ;
	
	public IcbcBDZYEdrBlc() {
//funcflag=165 		
		super(IcbcConf.newInstance(), 165);
	}
	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);
		return mHead;

	}
	
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		return mBankEle.getAttributeValue("insu")+"_"+mBankEle.getAttributeValue(id)+"_"+DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"_LMIMPAW.txt";
	}
	
	private Element initPubContInfoNode(){
		Element pubContInfoEle = new Element("PubContInfo");
		
		Element edrFlagEle = new Element("EdorFlag");
		Element cTBlcType = new Element("CTBlcType");	
		Element wTBlcType = new Element("WTBlcType");
		Element mQBlcType = new Element("MQBlcType");
		Element xQBlcType = new Element("XQBlcType");
		Element pNBlcType = new Element("PNBlcType");
 		Element bLBlcType = new Element("BLBlcType");
		Element bDBlcType = new Element("BDBlcType");
		
		pubContInfoEle.addContent(edrFlagEle);
		pubContInfoEle.addContent(cTBlcType);
		pubContInfoEle.addContent(wTBlcType);
		pubContInfoEle.addContent(mQBlcType);
		pubContInfoEle.addContent(xQBlcType);
		pubContInfoEle.addContent(pNBlcType);
		pubContInfoEle.addContent(bLBlcType);
		pubContInfoEle.addContent(bDBlcType);
		return pubContInfoEle ;
		
	}	
	
	
	private void setPubContInfoValue(Element pubContInfo){		
		pubContInfo.getChild("EdorFlag").setText("8") ; //对账
		pubContInfo.getChild("CTBlcType").setText(this.hasTB ? "1" : "0") ;
		pubContInfo.getChild("WTBlcType").setText(this.hasYYTB ? "1" : "0" ) ;					
		pubContInfo.getChild("MQBlcType").setText(this.hasMQ ? "1" : "0") ;
		pubContInfo.getChild("XQBlcType").setText(this.hasXQ ? "1" : "0") ;
		pubContInfo.getChild("PNBlcType").setText(this.hasPN ? "1" : "0") ;
		pubContInfo.getChild("BLBlcType").setText(this.hasBL ? "1" : "0") ;
		pubContInfo.getChild("BDBlcType").setText(this.hasBD ? "1" : "0") ;
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
	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into IcbcPeriodBlc.parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		
		BufferedReader mBufReader = new BufferedReader(
				new InputStreamReader(pBatIs, mCharset));
		
		Element mBodyEle = new Element(Body);
				
		Element pubContInfo = initPubContInfoNode();
		mBodyEle.addContent(pubContInfo);
									
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
//			tEdorNoEle.setText("301320153100000748");
			
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
		
		mBufReader.close();	//关闭流
		
		cLogger.info("Out IcbcPeriodBlc.parse()!");
		return mBodyEle;
	}
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger.getLogger("com.sinosoft.midplat.icbc.bat.IcbcPeriodBlc.main");
		mLogger.info("程序开始...");
		
		IcbcBDZYEdrBlc mBatch = new IcbcBDZYEdrBlc();
		
		//用于补对账，设置补对账日期
		if (0 != args.length) {
			mLogger.info("args[0] = " + args[0]);
			
			/**
			 * 严格日期校验的正则表达式：\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))。
			 * 4位年-2位月-2位日。
			 * 4位年：4位[0-9]的数字。
			 * 1或2位月：单数月为0加[0-9]的数字；双数月必须以1开头，尾数为0、1或2三个数之一。
			 * 1或2位日：以0、1或2开头加[0-9]的数字，或者以3开头加0或1。
			 * 
			 * 简单日期校验的正则表达式：\\d{4}\\d{2}\\d{2}。
			 */
			if (args[0].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				mBatch.setDate(args[0]);
			} else {
				throw new MidplatException("日期格式有误，应为yyyyMMdd！" + args[0]);
			}
		}
		
		mBatch.setDate("20160107") ;//跟文件名相关
		mBatch.run();
		
		mLogger.info("成功结束！");
	}
}
