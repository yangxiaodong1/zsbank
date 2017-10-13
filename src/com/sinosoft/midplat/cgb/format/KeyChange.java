package com.sinosoft.midplat.cgb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class KeyChange extends XmlSimpFormat {
	public KeyChange(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into KeyChange.noStd2Std()...");
		
		Document mStdXml = 
		    KeyChangeInXsl.newInstance().getCache().transform(pNoStdXml);
		        
		cLogger.info("Out KeyChange.noStd2Std()!");
		return mStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("D:\\工作文档\\寿险银保通文档\\广发\\广发银行银保数据交换接口文档\\测试报文\\密钥告知请求.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("D:\\工作文档\\寿险银保通文档\\广发\\广发银行银保数据交换接口文档\\测试报文\\密钥告知请求std.xml")));
        out.write(JdomUtil.toStringFmt(new KeyChange(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
	
}
