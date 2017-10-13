package com.sinosoft.midplat.cgb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirm extends XmlSimpFormat {
	public ContConfirm(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.noStd2Std()...");
		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(
				pNoStdXml);	
		//���б��
		String trancom = XPath.newInstance("Head/TranCom").valueOf(mStdXml.getRootElement()) ;
		//�㷢����һ����ˮ�ţ��ҷ���TranLog�в��ProposalPrtNo��ContNo��ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where ");
		mSqlStr.append("  tranno='" + mBodyEle.getChildText("OldTranNo")+"'");
		mSqlStr.append("  and proposalprtno='" + mBodyEle.getChildText("ProposalPrtNo")+"'");
		mSqlStr.append("  and trandate=" + DateUtil.getCur8Date());
		mSqlStr.append("  and rcode=0");
		mSqlStr.append("  and trancom="+trancom);
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");

        // ���մ���
        String mainRiskCode = XPath.newInstance(
                "//ContPlan/ContPlanCode").valueOf(
                pStdXml.getRootElement());
        Document mNoStdXml = null;
        if ("50015".equals(mainRiskCode)) {
            // 50002�ײ͵����մ���
        	// ��50002�ײ�����Ϊ50015
            mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache()
                    .transform(pStdXml);
        } else {
            // ��������
            mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(
                    pStdXml);
        }
		Element mOutStdRoot = pStdXml.getRootElement();
        Element mHeadEle = mOutStdRoot.getChild(Head);
        if ("0".equals(mHeadEle.getChildText(Flag))) {  //0-���׳ɹ�
            List mTextList = XPath.selectNodes(mNoStdXml.getRootElement(), "//SUB_VOUCHER/TEXT");
            for (int i = 0; i < mTextList.size(); i++) {
                Element mTextEle = (Element) mTextList.get(i);
                List mLineList = XPath.selectNodes(mTextEle, "TEXT_ROW_CONTEXT");;
                //����������
                mTextEle.getChild("ROW_TOTAL").setText(mLineList.size()+"");
                
                //Ϊÿ�������к�
                for (int j = 0; j < mLineList.size(); j++) {
                    Element mTextContent = new Element("TEXT_CONTENT");
                    //ԭTEXT_CONTENT�ڵ���뵽TEXT��
                    mTextEle.addContent(mTextContent);
                    //�к�
                    Element mRowNo = new Element("ROWNO");
                    mRowNo.setText(j+1+"");
                    mTextContent.addContent(mRowNo);
                    
                    //ԭTEXT_ROW_CONTEXT�ڵ���뵽TEXT_CONTENT��
                    mTextContent.addContent((Element)((Element)mLineList.get(j)).clone());
                    mTextEle.removeContent((Element)mLineList.get(j));
                    
                }
            }
        }
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/����/abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}