/**
 * 工行保全对账
 * 	包含的保全业务有：
 * 	满期给付、退保、投连险转换、部分领取等
 */

package com.sinosoft.midplat.icbc.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.ABlifeConstants;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.icbc.IcbcConf;

public class IcbcEdrBlc extends Balance {

	private boolean hasTB = false ;
	private boolean hasYYTB = false ;
	private boolean hasMQ = false ;
	private boolean hasXQ = false ;
	private boolean hasXT = false ;
	
	public IcbcEdrBlc() {
		super(IcbcConf.newInstance(), 112);
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
		return mBankEle.getAttributeValue("insu")+mBankEle.getAttributeValue(id)+DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"BAOQUAN.txt";
	}
	
	private Element initPubContInfoNode(){
		Element pubContInfoEle = new Element("PubContInfo");
		
		Element edrFlagEle = new Element("EdorFlag");
		Element cTBlcType = new Element("CTBlcType");	
		Element wTBlcType = new Element("WTBlcType");
		Element mQBlcType = new Element("MQBlcType");
		Element xQBlcType = new Element("XQBlcType");
		Element xTBlcType = new Element("XTBlcType");
		
		pubContInfoEle.addContent(edrFlagEle);
		pubContInfoEle.addContent(cTBlcType);
		pubContInfoEle.addContent(wTBlcType);
		pubContInfoEle.addContent(mQBlcType);
		pubContInfoEle.addContent(xQBlcType);
		pubContInfoEle.addContent(xTBlcType);
		return pubContInfoEle ;
		
	}
	
	private void setPubContInfoValue(Element pubContInfo){		
		pubContInfo.getChild("EdorFlag").setText("8") ; //对账
		pubContInfo.getChild("CTBlcType").setText(this.hasTB ? "1" : "0") ;
		pubContInfo.getChild("WTBlcType").setText(this.hasYYTB ? "1" : "0" ) ;					
		pubContInfo.getChild("MQBlcType").setText(this.hasMQ ? "1" : "0") ;
		pubContInfo.getChild("XQBlcType").setText(this.hasXQ ? "1" : "0") ;
		pubContInfo.getChild("XTBlcType").setText(this.hasXT ? "1" : "0") ;
	}		
	
	private void setEdrTypeFlag(String flag) throws Exception{
		
		switch(Integer.valueOf(flag)){		
			case 9 : 
				if(!this.hasMQ){
					this.hasMQ = true ;
					break ;
				}
			case 10 :
				if(!this.hasTB){
					this.hasTB = true ;
					 break ;
				}
			case 7 : 
				if(!this.hasYYTB){
					this.hasYYTB = true ;
					this.hasXT = true ;
					break ;					
				}
			default : 
				if(this.hasMQ || this.hasTB || this.hasYYTB){					
				}else{
					throw new Exception("错误的保全标识");	
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
			//业务类型(2位)+交易流水号(8位)+银行代码(2位) +地区号(5位)+网点号(5位)+渠道(1位)+处理标志(2位) +保单号(30位)+批单号(30位)+领取账户(19位)+账户姓名(20位)+交易日期(8位)		

			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			
			for(int i=0 ; i < tSubMsgs.length ; i++){
				System.out.println("tSubMsgs[+"+i+"]=="+tSubMsgs[i]);
			}
			//交易流水号
			Element tTranNoEle = new Element("TranNo");			
			tTranNoEle.setText(tSubMsgs[1]);	
			//
			Element tNodeNoEle = new Element("NodeNo");			
			tNodeNoEle.setText(tSubMsgs[3] + tSubMsgs[4]);	
			
			//<!-- 交易类型 -->
			Element tEdorTypeEle = new Element("EdorType");			
			tEdorTypeEle.setText(ABlifeConstants.icbcBlcEdorTypeMap.get(tSubMsgs[0]));			
			setEdrTypeFlag(tSubMsgs[0]);
			
			//<!-- 保全申请书号码 -->	
			Element tEdorAppNoEle = new Element("EdorAppNo");
			tEdorAppNoEle.setText("");
			
			//<!-- 保全批单号码[非必须] -->
			Element tEdorNoEle = new Element("EdorNo");
			tEdorNoEle.setText(tSubMsgs[8]);
			
			//<!-- 保全批改申请日期 YYYY-MM-DD-->
			Element tEdorAppDateEle = new Element("EdorAppDate");
			tEdorAppDateEle.setText(tSubMsgs[11]);
			
			// <!-- 保单号 -->		<!--必填项-->
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[7]);	
			
			//银行代码
			Element tBankCodeEle = new Element("BankCode");
			tBankCodeEle.setText(tSubMsgs[2]);			
			
			// <!-- 交易金额 单位（分）1000000分代表10000元--> <!--必填项-->
			Element tTranMoneyEle = new Element("TranMoney");
			tTranMoneyEle.setText("");
			
			//银行账户
			Element tAccNoEle = new Element(AccNo);
			tAccNoEle.setText(tSubMsgs[9]);
			
			//账户名称
			Element tAccNameEle = new Element(AccName);
			tAccNameEle.setText(tSubMsgs[10]);
					
			//  <!-- 响应码 0成功，1失败-->
			Element tRCodeEle = new Element("RCode");
			tRCodeEle.setText(tSubMsgs[6]);
			
			Element tDetailEle = new Element(Detail);	
			tDetailEle.addContent(tTranNoEle);
			tDetailEle.addContent(tNodeNoEle);
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
		
		IcbcEdrBlc mBatch = new IcbcEdrBlc();
		
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
		
//		mBatch.setDate("20130103") ;//跟文件名相关
		mBatch.run();
		
		mLogger.info("成功结束！");
	}
}
