package com.sinosoft.midplat.hrbcb.format;

import java.io.FileInputStream;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class ContConfirm extends XmlSimpFormat {

	public ContConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.noStd2Std()...");
		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		Document mNoStdXml = pStdXml;
		Element rootEle = pStdXml.getRootElement();
		// ��ȡ��Ʒ��ϴ���
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
		if("50015".equals(tContPlanCode)){ 
			// 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			// 50015: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ����
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else{
		    //������Ʒ
		    mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
		}
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
        Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\����\\abc.xml"));
        JdomUtil.print(new ContConfirm(null).std2NoStd(doc));
        System.out.println("******ok*********");
	}
}
