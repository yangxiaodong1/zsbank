package com.sinosoft.midplat.icbczj.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.midplat.icbc.IcbcUtil;

/**   
 * @Title: WithdrawMoney.java 
 * @Package com.sinosoft.midplat.icbczj.format 
 * @Description: �㽭�������ֽ��� 
 * @date Dec 17, 2015 3:10:45 PM 
 * @version V1.0   
 */

public class WithdrawMoney extends XmlSimpFormat {
	
	// ���еĽ�����ˮ�ţ�ȡ���������ĵĽ�����ˮ�ţ��ڸ����е�Ӧ�����з��ء�
	private String tranNo = "";
	
	public WithdrawMoney(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into WithdrawMoney.noStd2Std()...");

		tranNo = XPath.newInstance("//transrefguid").valueOf(pNoStdXml.getRootElement());
		Document mStdXml = WithdrawMoneyInXsl.newInstance().getCache().transform(pNoStdXml);

		//�㽭����ר����Ʒ����ֻ�����㽭���н��б����˺ű������������ͨϵͳ���ݵ������ڡ�01202--01211����Χ���ҹ�Ա����Ϊ��231���������жϣ�
		String regionCode = XPath.newInstance("//regioncode").valueOf(pNoStdXml.getRootElement());
		String teller = XPath.newInstance("//teller").valueOf(pNoStdXml.getRootElement());
		if("0".equals(IcbcUtil.zjCheck(regionCode, teller)))  {
			throw new MidplatException("���㽭����ר����������������д˽��ף�");
		}
		cLogger.info("Out WithdrawMoney.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into WithdrawMoney.std2NoStd()...");
		
		Document mNoStdXml = WithdrawMoneyOutXsl.newInstance().getCache().transform(pStdXml);
		
		Element tranNoEle = (Element)XPath.selectSingleNode(mNoStdXml.getRootElement(), "//ans/transrefguid");
		if(null !=tranNoEle ){
			tranNoEle.setText(tranNo);	
		}
		cLogger.info("Out WithdrawMoney.std2NoStd()!");
		return mNoStdXml;
	}
}
