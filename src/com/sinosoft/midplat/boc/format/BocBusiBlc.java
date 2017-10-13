package com.sinosoft.midplat.boc.format;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class BocBusiBlc extends XmlSimpFormat {

	public BocBusiBlc(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into BocBusiBlc.noStd2Std()...");
		
		Document mStdXml = BocBusiBlcInXsl.newInstance().getCache().transform(pNoStdXml);
		
        Element mBodyEle = mStdXml.getRootElement().getChild(Body);		
		@SuppressWarnings("rawtypes")
		List mDetailList = mBodyEle.getChildren("Detail");
		long mSumPrem = 0;
		int mCount = 0;
		if ( mDetailList.size()>0 ){
			mCount = mDetailList.size();
			for (int i = 0; i < mDetailList.size(); i++) {
				Element mDetailEle = (Element)mDetailList.get(i);
				int mFlagInt = Integer.parseInt(mDetailEle.getChildText(Prem));//�Է�Ϊ��λ
				mSumPrem = mSumPrem + mFlagInt;
			}
		}
		
		/**
		 * ���¸��ܱ������ܽ�ֵ����Ϊ���д��͵��������ֶ����г��������ݣ�
		 * �����Ǵ������ĵı��붼�ǳа��ɹ������ݡ�
		 */
		mBodyEle.getChild("Count").setText(String.valueOf(mCount));
		mBodyEle.getChild("Prem").setText(mSumPrem+"");
		
		cLogger.info("Out BocBusiBlc.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into BocBusiBlc.std2NoStd()...");
		
		Document mNoStdXml = pStdXml;

		cLogger.info("Out BocBusiBlc.std2NoStd()!");
		return mNoStdXml;
	}
}