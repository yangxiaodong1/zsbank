package com.sinosoft.midplat.icbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.check.CheckFieldManager;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {
	
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement(); // �Ǳ�׼����
		

		//��ȡ���մ��룬�˴�Ϊ��δת��Ϊ��׼���ĵ����б���
		String mainRiskCode = XPath.newInstance("/TXLife/TXLifeRequest/OLifE/Holding/Policy/Life/Coverage[IndicatorCode='1']/ProductCode").valueOf(rootNoStdEle);
		
			
		// ְҵ��֪��:����ְҵ��֪У�飬�����д�"��"����˱���ͨ�����������ߴ�"��"����˱�ͨ����
		String jobNotice = XPath.newInstance("//OLifEExtension/OccupationIndicator").valueOf(rootNoStdEle);
		if("Y".equals(jobNotice)){
			throw new MidplatException("����ͨ����������������ְҵ��֪����");
		}

		if("013".equals(mainRiskCode)){// �߲�Ʒ���,���ж���ò�Ʒ����Ϊ'013'
			// 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			
			String durationMode = XPath.newInstance("/TXLife/TXLifeRequest/OLifE/Holding/Policy/Life/Coverage[IndicatorCode='1']/OLifEExtension/DurationMode").valueOf(rootNoStdEle);
			if("5".equals(durationMode)){	// ����������������:1-����ĳȷ������,2-�걣,3-�±�,4-�ձ�,5-������,9-����
				// donothing...
			}else{
				throw new MidplatException("�������󣺱����ڼ�ӦΪ����!");
			}
			mStdXml = NewContInXsl50002.newInstance().getCache().transform(pNoStdXml);
			
			cLogger.info("ICBC_�������У�����NewContInXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[50002]");
			
		}else{	// ������ϲ�Ʒ50002
			mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
			
			/*if("014".equals(mainRiskCode)){	// ���ж˸����ֱ���='014',riskcode='122038'
				String tranCom = XPath.newInstance("//Head/TranCom").valueOf(mStdXml.getRootElement());
		        String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
		        if(errorMsg!=null){
		            throw new MidplatException(errorMsg);
		        }
			}*/
			cLogger.info("ICBC_�������У�����NewContInXsl���б���ת��");
		}
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		Document mNoStdXml = null;
		
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		//���׳ɹ���־
		Element tFlag  = (Element) XPath.selectSingleNode(pStdXml.getRootElement(), "//Head/Flag");
		
		// MODIFY 20140319 PBKINSR-311 ��ͬģ���ӡ�����ֵ�����
		if(null == tContPlanCode || "".equals(tContPlanCode)){	
		    // ���ǲ�Ʒ���
			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(pStdXml.getRootElement());
			
			if("122038".equals(mainRiskCode)){
				
				mNoStdXml = ContConfirmOutXsl4SpeFormat.newInstance().getCache().transform(pStdXml);
			}else{
				mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);	
			}
		//PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ����
		}else if("50002".equals(tContPlanCode)||"50015".equals(tContPlanCode)){	
		    // 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);	
		}
		
		//��̬���������ֶ�
		if (tFlag.getValue().equals("0")){
		    //�ɹ����صı���
		    List<Element> tSubVoucherList = XPath.selectNodes(mNoStdXml.getRootElement(), "//SubVoucher");
		    // �������������к�
		    for (Element tSubVoucherEle : tSubVoucherList) {
		        List<Element> tTextContentList = tSubVoucherEle.getChild("Text").getChildren("TextContent");
		        Element tTextEle = tSubVoucherEle.getChild("Text");
		        for (int i = 0; i < tTextContentList.size(); i++) {
		            Element tTextContentEle = tTextContentList.get(i);
		            // �����к�
		            Element mRowNumEle = new Element("RowNum");
		            mRowNumEle.setText(String.valueOf(i + 1));
		            tTextContentEle.addContent(mRowNumEle);
		        }
		        // ����������
		        Element mRowTotalEle = new Element("RowTotal");
		        mRowTotalEle.setText(tTextContentList.size() + "");
		        tTextEle.addContent(mRowTotalEle);
		    }
		}
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("e:/13966_99_1_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("e:/13966_99_1_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}