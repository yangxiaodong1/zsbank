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

/**   
 * @Title: NewContForNetBank.java 
 * @Package com.sinosoft.midplat.bcomm.format 
 * @Description: ���������µ����㽻�״��� 
 * @date Jan 5, 2016 3:52:22 PM 
 * @version V1.0   
 */

public class NewContForNetBank extends XmlSimpFormat {

	public NewContForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.noStd2Std()...");

		Element noStdRoot = pNoStdXml.getRootElement();

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
		
		Document mStdXml = NewContForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		Element rootEle = mStdXml.getRootElement();
		
		Element mBodyEle = rootEle.getChild(Body);
		String accName = mBodyEle.getChildText(AccName);
		String accNo = mBodyEle.getChildText(AccNo);
		
		// 4. �������ѷ�ʽ�˻�����Ϊ��
		if (accName == null || accName.trim().length() == 0 || accNo == null || accNo.trim().length() == 0) {
			throw new MidplatException("�ɷ��˻��Ż��˻�������Ϊ��");
		}
		
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.std2NoStd()...");

		Document noStdXml = NewContForNetBankOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out NewContForNetBank.std2NoStd()!");
		return noStdXml;
	}

	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("D:/679310_292_1401_in.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:/679310_292_1401_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewContForNetBank(null).noStd2Std(doc)));

		out.close();
		System.out.println("******ok*********");
	}
}
