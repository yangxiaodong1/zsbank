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
 * @Description: �����˽��ס������б��Ľ��и�ʽת���� 
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
		edrFlagEle.setText("8");	//����
		
		// <!--���ˣ�1=���ˣ�0=������-->
		Element cTBlcType = new Element("CTBlcType");	// �˱���ȫ
		cTBlcType.setText("0");
		Element wTBlcType = new Element("WTBlcType");	// ���˱�ȫ
		wTBlcType.setText("0");
		Element mQBlcType = new Element("MQBlcType");	// ���ڱ�ȫ
		mQBlcType.setText("0");
		Element xQBlcType = new Element("XQBlcType");	// ���ڱ�ȫ
		xQBlcType.setText("0");
		Element cABlcType = new Element("CABlcType");	// �޸Ŀͻ���Ϣ��ȫ
		cABlcType.setText("0");
		Element pNBlcType = new Element("PNBlcType");	// ��ȫ
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

			
			//���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}			
			/*
			 * ���б�ţ��̶�01�����������ڣ�YYYYMMDD���������ţ�5λ��������ţ�5λ��
			 * +���н�����ˮ�ţ�30λ��+���ղ�Ʒ����(3λ)�������ţ�30λ��+�������˺ţ�20λ��
			 * +��12λ����С���㣩+�����ţ�30λ��
			 */		

			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			
			for(int i=0 ; i < tSubMsgs.length ; i++){
				System.out.println("tSubMsgs[+"+i+"]=="+tSubMsgs[i]);
			}
			//������ˮ��
			Element tTranNoEle = new Element("TranNo");			
			tTranNoEle.setText(tSubMsgs[4]);	
			//
			Element tNodeNoEle = new Element("NodeNo");			
			tNodeNoEle.setText(tSubMsgs[2] + tSubMsgs[3]);	
			
			//<!-- �������� -->
			Element tEdorTypeEle = new Element("EdorType");			
			tEdorTypeEle.setText("PN");	// CT �˱�,MQ ����,XQ ����,WT	����,PN	����,CA	�޸Ŀͻ���Ϣ
			
			//<!-- ��ȫ��������� -->	
			Element tEdorAppNoEle = new Element("EdorAppNo");
			tEdorAppNoEle.setText("");
			
			//<!-- ��ȫ��������[�Ǳ���] -->
			Element tEdorNoEle = new Element("EdorNo");
			tEdorNoEle.setText(tSubMsgs[10]);
			
			//<!-- ��ȫ������������ YYYY-MM-DD-->
			Element tEdorAppDateEle = new Element("EdorAppDate");
			tEdorAppDateEle.setText(tSubMsgs[1]);
			
			// <!-- ������ -->		<!--������-->
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[6]);	
			
			//���д���
			Element tBankCodeEle = new Element("BankCode");
			tBankCodeEle.setText(tSubMsgs[0]);			
			
			// <!-- ���׽�� ��λ���֣�1000000�ִ���10000Ԫ--> <!--������-->
			Element tTranMoneyEle = new Element("TranMoney");
			tTranMoneyEle.setText(tSubMsgs[9]);
			
			//�����˻�
			Element tAccNoEle = new Element(AccNo);
			tAccNoEle.setText(tSubMsgs[7]);
			
			//�˻�����
			Element tAccNameEle = new Element(AccName);
			tAccNameEle.setText(tSubMsgs[8]);
					
			//  <!-- ��Ӧ�� 0�ɹ���1ʧ��-->
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
		
		mBufReader.close();	//�ر���
		
		cLogger.info("Out CgbLNWithDrawBlc.parse()!");
		return mBodyEle;
	}

	
	/** 
	 * ����ļ���ʽ��
	 * ���չ�˾����+���д���+YYYYMMDD+TIKUAN.txt
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
		System.out.println(" ���Ժ�̨ print info : ");
	}


}
