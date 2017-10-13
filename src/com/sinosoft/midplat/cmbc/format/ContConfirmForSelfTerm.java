package com.sinosoft.midplat.cmbc.format;

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

public class ContConfirmForSelfTerm extends XmlSimpFormat {

	public ContConfirmForSelfTerm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirmForSelfTerm.noStd2Std()...");

		Document mStdXml = ContConfirmForSelfTermInXsl.newInstance().getCache().transform(pNoStdXml);
		
		Element mHeadEle = mStdXml.getRootElement().getChild(Head);
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		
        StringBuffer mSqlStr = new StringBuffer();
	    mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo,NodeNo from TranLog where Rcode = '0' and Funcflag = '3014' and ContNo = '"
	    		+ mBodyEle.getChildText(ContNo)
//	    		+ "' and OtherNo= '"+ mBodyEle.getChildText(ContPrtNo)
	    		+ "' and Makedate ='" + mHeadEle.getChildText(TranDate)
	    		+ "' order by Maketime desc");
	    
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (mSSRS.MaxRow < 1) {
            throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
        }
		
        mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		// ����ǩ��ʹ�õ���������������ʱ��¼��Ϊ׼��--�����������е���ϢΪ׼
//		mHeadEle.getChild(NodeNo).setText(mSSRS.GetText(1, 4));
//		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out ContConfirmForSelfTerm.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into ContConfirmForSelfTerm.Std2StdnoStd()...");
		Document mNoStdXml = null;
		Element rootEle = pStdXml.getRootElement();
		
		//���׳ɹ���־
		String tFlag = XPath.newInstance("/TranData/Head/Flag").valueOf(rootEle);
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(rootEle);
//		if("50015".equals(tContPlanCode)){	// 50002��Ʒ�������������ִ����Ϊ��50015
//			mNoStdXml = ContConfirmForSelfTermOutXsl50002.newInstance().getCache().transform(pStdXml);
//		}
//		else{
			mNoStdXml = ContConfirmForSelfTermOutXsl.newInstance().getCache().transform(pStdXml);
//		}
		
		//��̬���������ֶ�
//			JdomUtil.print(mNoStdXml);
		if (tFlag.equals("0")){
            // ���ӱ�����ӡ������
			Element printEle  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//RETURN/Prnts[Type=8]/Page");
			Element prtCountEle  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//RETURN/Prnts[Type=8]/Count");
            
			if(printEle != null){
				List<Element> pagePrintList = printEle.getChildren("Prnt");
				prtCountEle.setText(pagePrintList.size() + "");
			}else {
				prtCountEle.setText("0");
			}
			
			if("50015".equals(tContPlanCode)){	// 50002��Ʒ���������ִ�����50002��Ϊ50015
				Element msgPrintEle  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//RETURN/Messages[Type=9]/Page");
				Element msgCountEle  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//RETURN/Messages[Type=9]/Count");
				System.out.println("msgCountEle======="+msgCountEle);
				if(msgPrintEle != null){
					List<Element> pageMessageList = msgPrintEle.getChildren("Message");
					msgCountEle.setText(pageMessageList.size() + "");
				}else {
				
						msgCountEle.setText("0");
				
				}
			}
		}
		if (tFlag.equals("0")){
			//������ʶ���ǿո����ｫ��ӡ���еĿո�ȫ���滻Ϊ����ȫ�ǿո�
			List<Element> prntValueList = XPath.selectNodes(mNoStdXml.getRootElement(), "//Prnts/Page/Prnt/Value");
			if(prntValueList != null){
				for(Element valueEle : prntValueList){
					String valueRep = valueEle.getText().replaceAll("  ", "��");
					valueEle.setText(valueRep);
				}
			}
			//50002��Ʒ����
			if("50015".equals(tContPlanCode)){
				List<Element> msgValueList = XPath.selectNodes(mNoStdXml.getRootElement(), "//Messages/Page/Message/Value");
				if(msgValueList != null){	
					for(Element valueEle : msgValueList){
						String valueRep = valueEle.getText().replaceAll("  ", "��");
						valueEle.setText(valueRep);
					}
				}
			}
		}
		cLogger.info("Out ContConfirmForSelfTerm.Std2StdnoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("E:\\����ͨ��Ŀ\\���Ա���\\50002\\���Դ�ӡģ��_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:\\����ͨ��Ŀ\\���Ա���\\50002\\���Դ�ӡģ��_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirmForSelfTerm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
	}
}
