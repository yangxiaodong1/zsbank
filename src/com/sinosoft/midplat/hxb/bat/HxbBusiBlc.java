package com.sinosoft.midplat.hxb.bat;

import java.io.InputStream;
import java.lang.reflect.Constructor;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.cgb.bat.CgbBusiBlc;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.format.Format;
import com.sinosoft.midplat.hxb.HxbConf;

/**
 * @Title: com.sinosoft.midplat.hxb.bat.HxbBusiBlc.java
 * @Description: �����������ն��˴�����
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Apr 10, 2014 10:38:07 AM
 * @version 
 *
 */
public class HxbBusiBlc extends Balance{

	
	public HxbBusiBlc() {
		super(HxbConf.newInstance(), 1505);	// �����������ն���
	}
	
	/* ���ö��˱���ͷ
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getHead()
	 */
	protected Element getHead() {
		
        Element mHead = super.getHead();
        Element mBankCode = new Element("BankCode");
        mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
        mHead.addContent(mBankCode);
        return mHead;
    }

	/* ��ȡ�����ļ���
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	protected String getFileName() {
		/*
		 * �ļ���������B+���д��루3041000��+���չ�˾���루���ж��壩+ҵ������(8λ) + .xml
		 */
		Element mBankEle = cThisConfRoot.getChild("bank");
		StringBuffer strBuff = new StringBuffer();
		String tFileName = strBuff.append("B").append(
				mBankEle.getAttributeValue("id")).append(
				mBankEle.getAttributeValue("insu")).append(
				DateUtil.get8Date(cTranDate)).append(".xml").toString();
		
		return tFileName;
	}
	
	/* ���б��ĸ�ʽת
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		
		cLogger.info("Into HxbBusiBlc.parse()...");
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		Document pNoStdXml = JdomUtil.build(pBatIs, mCharset);
		
		//��־ǰ׺
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cThisBusiConf.getChildText(funcFlag)).append(
				"_in.xml");
        
		SaveMessage.save(pNoStdXml, cThisConfRoot.getChildText(TranCom), mSaveName.toString());
		cLogger.info("����Ǳ�׼��������ϣ�");

		String tFormatClassName = cThisBusiConf.getChildText(format);

		//����ת��ģ��
		cLogger.info((new StringBuilder("����ת��ģ�飺")).append(tFormatClassName).toString());
        
		Constructor tFormatConstructor =  Class.forName(tFormatClassName).getConstructor(new Class[] { Element.class });
		Format tFormat = (Format) tFormatConstructor.newInstance(new Object[] { cThisBusiConf });

		//��xmlת���ɱ�׼����
		cLogger.info("convert nonstandard xml to standard xml...");
		Document pStdXml = tFormat.noStd2Std(pNoStdXml);
		
		Element mBody = pStdXml.getRootElement().getChild(Body);
		mBody.detach();
//		JdomUtil.print(mBody);
		return mBody;
	}

    public static void main(String[] Str) throws Exception {
    	
    	HxbBusiBlc blc = new HxbBusiBlc();
    	
    	blc.run();
    }	
}


