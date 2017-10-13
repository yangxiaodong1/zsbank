/**
 * ���б�����Ѻ����Ѻ��ǿ������
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
		pubContInfo.getChild("EdorFlag").setText("8") ; //����
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
			
			//���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}						
			//���н�����ˮ��|������|�����|����Ա|��֤����|��������|���׽��|�����־|��������|�����ֶ�1|�����ֶ�2|�����ֶ�3|�����ֶ�4|
			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			
			for(int i=0 ; i < tSubMsgs.length ; i++){
				System.out.println("tSubMsgs[+"+i+"]=="+tSubMsgs[i]);
			}
			
			//<!-- �������� --���ݽ�����ˮ�ŵ�tranlog���ȡfunflag�ж�edortyp>
			Element tEdorTypeEle = new Element("EdorType");	  
            String mSqlStr = "select FUNCFLAG,Bak5 from TranLog where Rcode ='0' and TRANNO='" + tSubMsgs[0] + "'";
    		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
    		if (1 != mSSRS.MaxRow) {
    			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
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
			
			//<!-- ��ȫ��������� -->	
			Element tEdorAppNoEle = new Element("EdorAppNo");
			tEdorAppNoEle.setText("");
			
			//<!-- ��ȫ��������[�Ǳ���] -->
			Element tEdorNoEle = new Element("EdorNo");
			tEdorNoEle.setText(cBak5);	
//			tEdorNoEle.setText("301320153100000748");
			
			//<!-- ��ȫ������������ YYYY-MM-DD-->
			Element tEdorAppDateEle = new Element("EdorAppDate");
			tEdorAppDateEle.setText(tSubMsgs[5]);
			
			// <!-- ������ -->		<!--������-->
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[4]);	
			
			//���д���
			Element tBankCodeEle = new Element("BankCode");
			tBankCodeEle.setText(tSubMsgs[1]+tSubMsgs[2]);			
			
			// <!-- ���׽�� ��λ���֣�1000000�ִ���10000Ԫ--> <!--������-->
			Element tTranMoneyEle = new Element("TranMoney");
			tTranMoneyEle.setText(tSubMsgs[6]);
			
			//�����˻�
			Element tAccNoEle = new Element(AccNo);
			tAccNoEle.setText("");
			
			//�˻�����
			Element tAccNameEle = new Element(AccName);
			tAccNameEle.setText("");
					
			//  <!-- ��Ӧ�� 0�ɹ���1ʧ��-->
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
		
		mBufReader.close();	//�ر���
		
		cLogger.info("Out IcbcPeriodBlc.parse()!");
		return mBodyEle;
	}
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger.getLogger("com.sinosoft.midplat.icbc.bat.IcbcPeriodBlc.main");
		mLogger.info("����ʼ...");
		
		IcbcBDZYEdrBlc mBatch = new IcbcBDZYEdrBlc();
		
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
		
		mBatch.setDate("20160107") ;//���ļ������
		mBatch.run();
		
		mLogger.info("�ɹ�������");
	}
}
