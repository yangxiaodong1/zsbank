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
		// 获取产品组合代码
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
		if("50015".equals(tContPlanCode)){ 
			// 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成
			// 50015: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、L12081-安邦长寿添利终身寿险（万能型）组成
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else{
		    //其他产品
		    mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
		}
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
        Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc.xml"));
        JdomUtil.print(new ContConfirm(null).std2NoStd(doc));
        System.out.println("******ok*********");
	}
}
