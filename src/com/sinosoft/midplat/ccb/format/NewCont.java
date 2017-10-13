package com.sinosoft.midplat.ccb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	/* 
	 * ���зǱ�׼����ת��Ϊ���ı�׼����
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement();
		//��ȡ���մ��룬�˴�Ϊ��δת��Ϊ��׼���ĵ����б���
		String mainRiskCode = XPath.newInstance("/Transaction/Transaction_Body/PbInsuType").valueOf(rootNoStdEle);
		
		if("2046".equals(mainRiskCode)){// �߲�Ʒ���50002
			
			// ������, ��ϲ�Ʒ50002�����ж˴��ݱ�������Ϊ���������Ǻ��Ķ�У����Ϊ��������Ϊ��5�꣨�������ߣ�
			String tPbInsuYearFlag = XPath.newInstance("/Transaction/Transaction_Body/PbInsuYearFlag").valueOf(rootNoStdEle);
			if(null==tPbInsuYearFlag || "".equals(tPbInsuYearFlag)){
				throw new MidplatException("�������󣺱����������Ͳ���Ϊ��!");
			}else if(!"1".equals(tPbInsuYearFlag)){	// 0���޹�,1������,2������,3������,4������,5������,6����ĳȷ������

				throw new MidplatException("�������󣺱����ڼ�ӦΪ����!");
			}
			// 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			mStdXml = NewContInXsl50002.newInstance().getCache().transform(pNoStdXml);
			cLogger.info("CCB_�������У�����NewContInXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[" + mainRiskCode + "]");
			
		}else{
			
			mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
			cLogger.info("CCB_�������У�NewContInXsl���б���ת��������riskCode=[" + mainRiskCode + "]");
		}
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	/*
	 *	���ı�׼����ת��Ϊ���зǱ�׼����  
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		
		// ��Ʒ��ϱ���
		String contPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		Document mNoStdXml = null;
		if("50002".equals(contPlanCode)){	
			// �������Ӯ1����ȫ����
			cLogger.info("CCB_�������У�����NewContOutXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[" + contPlanCode + "]");
			mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else {   
		    // ������Ʒ
            mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
            cLogger.info("CCB_�������У�NewContInXsl���б���ת��");
        }
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\����\\abc.xml"));
		//BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/ccb/11_out.xml")));
		JdomUtil.output(new NewCont(null).noStd2Std(doc),System.out);
		
		/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/ccb/2_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/ccb/22_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));*/
		
		//out.close();
		System.out.println("******ok*********");
    }
	
}


