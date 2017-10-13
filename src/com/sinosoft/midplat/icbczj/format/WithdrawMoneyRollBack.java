package com.sinosoft.midplat.icbczj.format;

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
import com.sinosoft.midplat.icbc.IcbcUtil;

/**   
 * @Title: WithdrawMoneyRollBack.java 
 * @Package com.sinosoft.midplat.icbczj.format 
 * @Description: ���ֳ������� 
 * @date Dec 18, 2015 1:32:36 PM 
 * @version V1.0   
 */

public class WithdrawMoneyRollBack extends XmlSimpFormat {

	// ���еĽ�����ˮ�ţ�ȡ���������ĵĽ�����ˮ�ţ��ڸ����е�Ӧ�����з��ء�
	private String tranNo = "";
	
	public WithdrawMoneyRollBack(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into WithdrawMoneyRollBack.noStd2Std()...");

		tranNo = XPath.newInstance("//transrefguid").valueOf(pNoStdXml.getRootElement());
		Document mStdXml = WithdrawMoneyRollBackInXsl.newInstance().getCache().transform(pNoStdXml);

		/*
		 * �㽭����ר����Ʒ����ֻ�����㽭���н��б����˺ű��������
		 * ����ͨϵͳ���ݵ������ڡ�01202--01211����Χ���ҹ�Ա����Ϊ��231���������жϣ�
		 */
		String regionCode = XPath.newInstance("//regioncode").valueOf(pNoStdXml.getRootElement());
		String teller = XPath.newInstance("//teller").valueOf(pNoStdXml.getRootElement());
		if("0".equals(IcbcUtil.zjCheck(regionCode, teller)))  {
			throw new MidplatException("���㽭����ר����������������д˽��ף�");
		}
		cLogger.info("Out WithdrawMoneyRollBack.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into WithdrawMoneyRollBack.std2NoStd()...");
		
		Document mNoStdXml = WithdrawMoneyRollBackOutXsl.newInstance().getCache().transform(pStdXml);
		Element tranNoEle = (Element)XPath.selectSingleNode(mNoStdXml.getRootElement(), "//ans/transrefguid");
		if(null !=tranNoEle ){
			tranNoEle.setText(tranNo);	
		}
		cLogger.info("Out WithdrawMoneyRollBack.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
        
        Document doc = JdomUtil.build(new FileInputStream("d:/139267_73_32_outSvc.xml"));
    
	    BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("d:/139267_73_32_out.xml")));
	    out.write(JdomUtil.toStringFmt(new WithdrawMoneyRollBack(null).std2NoStd(doc)));
	    out.close();
	    System.out.println("******ok*********");
    }
}
