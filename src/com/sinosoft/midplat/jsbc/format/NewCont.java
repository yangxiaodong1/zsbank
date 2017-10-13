package com.sinosoft.midplat.jsbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.check.CheckFieldManager;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

/**   
 * @Title: NewCont.java 
 * @Package com.sinosoft.midplat.jsbc.format 
 * @Description: 江苏银行新单试算交易 
 * @date Apr 23, 2015 2:22:03 PM 
 * @version V1.0   
 */
public class NewCont extends XmlSimpFormat {

	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
//	Element tTRANSRNOEle = null;
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		
//		tTRANSRNOEle = (Element) XPath.newInstance("//Head/TranNo").selectSingleNode(mStdXml.getRootElement());
		//FIXME 配置校验报文字段
		String tranCom = XPath.newInstance("//Head/TranCom").valueOf(mStdXml.getRootElement());
		String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
		if(errorMsg!=null){
		    throw new MidplatException(errorMsg);
		}
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		
		Document mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		
//		Element tMAINEle = (Element) XPath.newInstance("//MAIN/TRANSRNO").selectSingleNode(mNoStdXml.getRootElement());
//		tMAINEle.addContent(tTRANSRNOEle);
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:/563686_73_2300_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/563686_73_2300_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
