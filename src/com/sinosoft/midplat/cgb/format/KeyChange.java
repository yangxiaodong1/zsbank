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
        Document doc = JdomUtil.build(new FileInputStream("D:\\�����ĵ�\\��������ͨ�ĵ�\\�㷢\\�㷢�����������ݽ����ӿ��ĵ�\\���Ա���\\��Կ��֪����.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("D:\\�����ĵ�\\��������ͨ�ĵ�\\�㷢\\�㷢�����������ݽ����ӿ��ĵ�\\���Ա���\\��Կ��֪����std.xml")));
        out.write(JdomUtil.toStringFmt(new KeyChange(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
	
}
