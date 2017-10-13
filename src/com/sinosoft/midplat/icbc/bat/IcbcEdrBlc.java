/**
 * ���б�ȫ����
 * 	�����ı�ȫҵ���У�
 * 	���ڸ������˱���Ͷ����ת����������ȡ��
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
		pubContInfo.getChild("EdorFlag").setText("8") ; //����
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
					throw new Exception("����ı�ȫ��ʶ");	
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
			
			//���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}			
			//ҵ������(2λ)+������ˮ��(8λ)+���д���(2λ) +������(5λ)+�����(5λ)+����(1λ)+�����־(2λ) +������(30λ)+������(30λ)+��ȡ�˻�(19λ)+�˻�����(20λ)+��������(8λ)		

			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			
			for(int i=0 ; i < tSubMsgs.length ; i++){
				System.out.println("tSubMsgs[+"+i+"]=="+tSubMsgs[i]);
			}
			//������ˮ��
			Element tTranNoEle = new Element("TranNo");			
			tTranNoEle.setText(tSubMsgs[1]);	
			//
			Element tNodeNoEle = new Element("NodeNo");			
			tNodeNoEle.setText(tSubMsgs[3] + tSubMsgs[4]);	
			
			//<!-- �������� -->
			Element tEdorTypeEle = new Element("EdorType");			
			tEdorTypeEle.setText(ABlifeConstants.icbcBlcEdorTypeMap.get(tSubMsgs[0]));			
			setEdrTypeFlag(tSubMsgs[0]);
			
			//<!-- ��ȫ��������� -->	
			Element tEdorAppNoEle = new Element("EdorAppNo");
			tEdorAppNoEle.setText("");
			
			//<!-- ��ȫ��������[�Ǳ���] -->
			Element tEdorNoEle = new Element("EdorNo");
			tEdorNoEle.setText(tSubMsgs[8]);
			
			//<!-- ��ȫ������������ YYYY-MM-DD-->
			Element tEdorAppDateEle = new Element("EdorAppDate");
			tEdorAppDateEle.setText(tSubMsgs[11]);
			
			// <!-- ������ -->		<!--������-->
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[7]);	
			
			//���д���
			Element tBankCodeEle = new Element("BankCode");
			tBankCodeEle.setText(tSubMsgs[2]);			
			
			// <!-- ���׽�� ��λ���֣�1000000�ִ���10000Ԫ--> <!--������-->
			Element tTranMoneyEle = new Element("TranMoney");
			tTranMoneyEle.setText("");
			
			//�����˻�
			Element tAccNoEle = new Element(AccNo);
			tAccNoEle.setText(tSubMsgs[9]);
			
			//�˻�����
			Element tAccNameEle = new Element(AccName);
			tAccNameEle.setText(tSubMsgs[10]);
					
			//  <!-- ��Ӧ�� 0�ɹ���1ʧ��-->
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
		
		mBufReader.close();	//�ر���
		
		cLogger.info("Out IcbcPeriodBlc.parse()!");
		return mBodyEle;
	}
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger.getLogger("com.sinosoft.midplat.icbc.bat.IcbcPeriodBlc.main");
		mLogger.info("����ʼ...");
		
		IcbcEdrBlc mBatch = new IcbcEdrBlc();
		
		//���ڲ����ˣ����ò���������
		if (0 != args.length) {
			mLogger.info("args[0] = " + args[0]);
			
			/**
			 * �ϸ�����У���������ʽ��\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))��
			 * 4λ��-2λ��-2λ�ա�
			 * 4λ�꣺4λ[0-9]�����֡�
			 * 1��2λ�£�������Ϊ0��[0-9]�����֣�˫���±�����1��ͷ��β��Ϊ0��1��2������֮һ��
			 * 1��2λ�գ���0��1��2��ͷ��[0-9]�����֣�������3��ͷ��0��1��
			 * 
			 * ������У���������ʽ��\\d{4}\\d{2}\\d{2}��
			 */
			if (args[0].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				mBatch.setDate(args[0]);
			} else {
				throw new MidplatException("���ڸ�ʽ����ӦΪyyyyMMdd��" + args[0]);
			}
		}
		
//		mBatch.setDate("20130103") ;//���ļ������
		mBatch.run();
		
		mLogger.info("�ɹ�������");
	}
}
