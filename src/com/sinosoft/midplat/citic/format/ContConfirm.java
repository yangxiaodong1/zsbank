package com.sinosoft.midplat.citic.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirm extends XmlSimpFormat {
	public ContConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		
		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//�������д���һ����ˮ�ţ��ҷ���TranLog�в��ProposalPrtNo��ContNo��ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where LogNo=" + mBodyEle.getChildText("OldLogNo");
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}
	
	@SuppressWarnings("unchecked")
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		
		Document mNoStdXml = null;
		
		//��ȡ��Ʒ��ϴ���
        String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());

		if(null == tContPlanCode || "".equals(tContPlanCode)){	// ���ǲ�Ʒ��ϵķ��ر���
			
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("CITIC_�������У�ContConfirmOutXsl���б���ת��(�ǲ�Ʒ���)");
		}else if("50015".equals(tContPlanCode)){	// �ǲ�Ʒ��Ϸ��صı���,��Ʒ�Ѵ�50002����Ϊ50015
//			JdomUtil.print(pStdXml);
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("CITIC_�������У�����ContConfirmOutXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}else if("50006".equals(tContPlanCode)){ 
		    // 50006: ������Ӯ1������ռƻ�
		    mNoStdXml = ContConfirmOutXsl50006.newInstance().getCache().transform(pStdXml);
		    cLogger.info("CITIC_�������У�����ContConfirmOutXsl50006���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}
		//add by duanjz 2015-6-17 ���� ����ٰ���5�ű��ռƻ�50012   begin
		else if("50012".equals(tContPlanCode)){ 
		    //50012: ����ٰ���5�ű��ռƻ�
		    mNoStdXml = ContConfirmOutXsl50012.newInstance().getCache().transform(pStdXml);
		    cLogger.info("CITIC_�������У�����ContConfirmOutXsl50012���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}
		//add by duanjz 2015-6-17 ���� ����ٰ���5�ű��ռƻ�50012   end
		//add by duanjz 2015-10-20 ���� ����ٰ���3�ű��ռƻ�50011   begin
		else if("50011".equals(tContPlanCode)){ 
		    //50011: ����ٰ���3�ű��ռƻ�
		    mNoStdXml = ContConfirmOutXsl50011.newInstance().getCache().transform(pStdXml);
		    cLogger.info("CITIC_�������У�����ContConfirmOutXsl50011���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}
		//add by duanjz 2015-10-20 ���� ����ٰ���5�ű��ռƻ�50012   end
		
		List<Element> mDetail_list = mNoStdXml.getRootElement().getChild("Transaction_Body").getChildren("Detail_List");
		for (Element e : mDetail_list) {
			Element tDetail = e.getChild(Detail);
			Element tBkRecNum = e.getChild("BkRecNum");
			List<Element> tBkDetail1 = tDetail.getChildren("BkDetail1");
			tBkRecNum.setText(String.valueOf(tBkDetail1.size()));
		}
		
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
    public static void main(String[] args) throws Exception{

    	/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/citic/1101/2.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/citic/1101/22.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));*/

    	Document doc = JdomUtil.build(new FileInputStream("E:\\����ͨ��Ŀ\\���Ա���\\50002\\���Դ�ӡģ��_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:\\����ͨ��Ŀ\\���Ա���\\50002\\���Դ�ӡģ��_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        
        out.close();
        System.out.println("******ok*********");
        
    }
}
