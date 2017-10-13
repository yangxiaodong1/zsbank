package com.sinosoft.midplat.bcomm.format;

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

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");

		Element noStdRoot = pNoStdXml.getRootElement();

		// FIXME ����������δ������ʱ���ۼƷ��������ǩҪת��
		// 2. ְҵ��֪��:��ͨ����ְҵ��֪У�飬�����д�"��"����˱���ͨ�����������ߴ�"��"����˱�ͨ����
		String insJobNotice = XPath.newInstance("//Ins/WorkFlag").valueOf(noStdRoot);
		if("1".equals(insJobNotice)){	// �������Ƿ�Σ��ְҵ:0=��1=��
			throw new MidplatException("����ͨ����������������ְҵ��֪����");
		}
		
		// 3. ���ж���ְҵ��֪��
		String jobNotice = XPath.newInstance("//Private/WorkFlag").valueOf(noStdRoot);
		if("Y".equals(jobNotice)){	// ְҵ��֪��־: Y=�ǣ�N=��
			throw new MidplatException("����ͨ��������ְҵ��֪����");
		}
		
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		Element rootEle = mStdXml.getRootElement();
		
		Element mBodyEle = rootEle.getChild(Body);
		String accName = mBodyEle.getChildText(AccName);
		String accNo = mBodyEle.getChildText(AccNo);
		
		// 4. �������ѷ�ʽ�˻�����Ϊ��
		if (accName == null || accName.trim().length() == 0 || accNo == null || accNo.trim().length() == 0) {
			throw new MidplatException("�ɷ��˻��Ż��˻�������Ϊ��");
		}
		
		String contPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(rootEle);
		// ��ϲ�Ʒ50002�ı�������Ϊ���������Ǻ��Ķ˶���ı�������Ϊ������122046Ϊ���ݣ�����5��
		if ("50002".equals(contPlanCode)) {
			Element insuYearFlag = (Element) XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(rootEle);
			Element insuYear = (Element) XPath.newInstance("//Risk/InsuYear").selectSingleNode(rootEle);
			if (!"A".equals(insuYearFlag.getText())) {
				// ¼��Ĳ�Ϊ������
				throw new MidplatException("���ݴ��󣺸��ײͱ����ڼ�Ϊ������");
			}
			// �����ڼ���Ϊ��5��
			insuYearFlag.setText("Y");
			insuYear.setText("5");
		}

		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");

		Document noStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out NewCont.std2NoStd()!");
		return noStdXml;
	}

	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("D:/679310_292_1401_in.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:/679310_292_1401_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));

		out.close();
		System.out.println("******ok*********");
	}
}