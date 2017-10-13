package com.sinosoft.midplat.cgb.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.cgb.CgbConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;

/**   
 * @Title: CgbLNWithDrawBlc.java 
 * @Package com.sinosoft.midplat.cgb.bat 
 * @Description: 提款对账交易。将银行报文进行格式转换。 
 * @date Dec 22, 2015 3:55:38 PM 
 * @version V1.0   
 */

public class CgbLNWithDrawBlc extends Balance{
	
	public CgbLNWithDrawBlc() {
		super(CgbConf.newInstance(), "2215");
	}
	
	private Element initPubContInfoNode(){
		Element pubContInfoEle = new Element("PubContInfo");
		
		Element edrFlagEle = new Element("EdorFlag");
		edrFlagEle.setText("8");	//对账
		
		// <!--对账：1=对账，0=不对账-->
		Element cTBlcType = new Element("CTBlcType");	// 退保保全
		cTBlcType.setText("0");
		Element wTBlcType = new Element("WTBlcType");	// 犹退保全
		wTBlcType.setText("0");
		Element mQBlcType = new Element("MQBlcType");	// 满期保全
		mQBlcType.setText("0");
		Element xQBlcType = new Element("XQBlcType");	// 续期保全
		xQBlcType.setText("0");
		Element cABlcType = new Element("CABlcType");	// 修改客户信息保全
		cABlcType.setText("0");
		Element pNBlcType = new Element("PNBlcType");	// 提款保全
		pNBlcType.setText("1");
		
		
		pubContInfoEle.addContent(edrFlagEle);
		pubContInfoEle.addContent(cTBlcType);
		pubContInfoEle.addContent(wTBlcType);
		pubContInfoEle.addContent(mQBlcType);
		pubContInfoEle.addContent(xQBlcType);
		pubContInfoEle.addContent(pNBlcType);
		return pubContInfoEle ;
		
	}
	
	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into CgbLNWithDrawBlc.parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		
		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(pBatIs, mCharset));
		
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
			/*
			 * 银行编号（固定01）＋交易日期（YYYYMMDD）＋地区号（5位）＋网点号（5位）
			 * +银行交易流水号（30位）+保险产品代码(3位)＋保单号（30位）+新银行账号（20位）
			 * +金额（12位，带小数点）+批单号（30位）
			 */		

			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			
			for(int i=0 ; i < tSubMsgs.length ; i++){
				System.out.println("tSubMsgs[+"+i+"]=="+tSubMsgs[i]);
			}
			//交易流水号
			Element tTranNoEle = new Element("TranNo");			
			tTranNoEle.setText(tSubMsgs[4]);	
			//
			Element tNodeNoEle = new Element("NodeNo");			
			tNodeNoEle.setText(tSubMsgs[2] + tSubMsgs[3]);	
			
			//<!-- 交易类型 -->
			Element tEdorTypeEle = new Element("EdorType");			
			tEdorTypeEle.setText("PN");	// CT 退保,MQ 满期,XQ 续期,WT	犹退,PN	提现,CA	修改客户信息
			
			//<!-- 保全申请书号码 -->	
			Element tEdorAppNoEle = new Element("EdorAppNo");
			tEdorAppNoEle.setText("");
			
			//<!-- 保全批单号码[非必须] -->
			Element tEdorNoEle = new Element("EdorNo");
			tEdorNoEle.setText(tSubMsgs[10]);
			
			//<!-- 保全批改申请日期 YYYY-MM-DD-->
			Element tEdorAppDateEle = new Element("EdorAppDate");
			tEdorAppDateEle.setText(tSubMsgs[1]);
			
			// <!-- 保单号 -->		<!--必填项-->
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[6]);	
			
			//银行代码
			Element tBankCodeEle = new Element("BankCode");
			tBankCodeEle.setText(tSubMsgs[0]);			
			
			// <!-- 交易金额 单位（分）1000000分代表10000元--> <!--必填项-->
			Element tTranMoneyEle = new Element("TranMoney");
			tTranMoneyEle.setText(tSubMsgs[9]);
			
			//银行账户
			Element tAccNoEle = new Element(AccNo);
			tAccNoEle.setText(tSubMsgs[7]);
			
			//账户名称
			Element tAccNameEle = new Element(AccName);
			tAccNameEle.setText(tSubMsgs[8]);
					
			//  <!-- 响应码 0成功，1失败-->
			Element tRCodeEle = new Element("RCode");
			tRCodeEle.setText("0");
			
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
		
		mBufReader.close();	//关闭流
		
		cLogger.info("Out CgbLNWithDrawBlc.parse()!");
		return mBodyEle;
	}

	
	/** 
	 * 结果文件格式：
	 * 保险公司代码+银行代码+YYYYMMDD+TIKUAN.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		StringBuffer strBuf = new StringBuffer();
		strBuf.append(mBankEle.getAttributeValue("insu"))
				.append(mBankEle.getAttributeValue("id"))
				.append(DateUtil.getDateStr(cTranDate, "yyyyMMdd"))
				.append("TIKUAN.txt");
		
		return strBuf.toString();
	}
	
	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);
		return mHead;
	}
	

    /**
	 * @param args
	 */
	public static void main(String[] args) throws Exception{
		CgbLNWithDrawBlc blc = new CgbLNWithDrawBlc();
//		Calendar calendar = Calendar.getInstance();
//		calendar.add(Calendar.DAY_OF_MONTH, -1);
//		System.out.println(DateUtil.getDateStr(calendar, "yyyyMMdd"));
		blc.run();
		System.out.println(" 测试后台 print info : ");
	}


}
