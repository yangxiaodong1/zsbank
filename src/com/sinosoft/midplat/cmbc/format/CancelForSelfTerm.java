package com.sinosoft.midplat.cmbc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class CancelForSelfTerm extends XmlSimpFormat {

	public CancelForSelfTerm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into CancelForSelfTerm.noStd2Std()...");
		
		Document mStdXml = CancelForSelfTermInXsl.newInstance().getCache().transform(pNoStdXml);
		
		/*����仯�������д��ݵ�����Ϊ׼��
		 * Element mHeadEle = mStdXml.getRootElement().getChild(Head);
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		
		if(mHeadEle.getChildText("SourceType").equals("1") || mHeadEle.getChildText("SourceType").equals("17")){
			
			 * �������ֻ�����������߼�,SourceType=1 �������У�SourceType=17 �ֻ����У�
			 * ����߼����ǲ�ѯ�ý��׵�����������Ϣ��
			 
			StringBuffer mSqlStr = new StringBuffer();
		    if(mHeadEle.getChildText("SourceType").equals("1")){	// ������ǩ��funcflag=3006
		    	mSqlStr.append("select NodeNo from TranLog where Rcode = '0' and Funcflag = '3006' and ContNo = '"
			    		+ mBodyEle.getChildText(ContNo)
			    		+ "' and Makedate ='" + mHeadEle.getChildText(TranDate)
			    		+ "' order by Maketime desc");
		    }else if(mHeadEle.getChildText("SourceType").equals("17")){	// �ֻ����У�ǩ��funcflag=3008
		    	mSqlStr.append("select NodeNo from TranLog where Rcode = '0' and Funcflag = '3008' and ContNo = '"
			    		+ mBodyEle.getChildText(ContNo)
			    		+ "' and Makedate ='" + mHeadEle.getChildText(TranDate)
			    		+ "' order by Maketime desc");
		    }
		    
	        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
	        if (mSSRS.MaxRow < 1) {
	            throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
	        }
			// �������ֻ����е��ճ���ʹ�õ�����������ǩ��ʱ��¼��Ϊ׼��
			mHeadEle.getChild(NodeNo).setText(mSSRS.GetText(1, 1));
		}*/
		
		cLogger.info("Out CancelForSelfTerm.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into CancelForSelfTerm.std2NoStd()...");
		
		Document mNoStdXml = CancelForSelfTermOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out CancelForSelfTerm.std2NoStd()!");
		return mNoStdXml;
	}
}
