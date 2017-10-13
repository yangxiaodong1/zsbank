package com.sinosoft.midplat.cmb.bat.packer;

import java.io.FileInputStream;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.common.JdomUtil;

/**
 * 招行xml文件打包器
 * @author ab033862
 * Sep 23, 2013
 */
public class CmbXmlRecordPacker implements RecordPacker {
    //xml声明
    String xmlHead = "<?xml version=\"1.0\" encoding=\"GBK\"?>";
    //换行符
    String lineFeed = "\n";
    
    public CmbXmlRecordPacker(String lineFeed){
        this.lineFeed = lineFeed;
    }

    public CmbXmlRecordPacker(){
    }
    
    public Element unpack(String record, String charsetName)throws Exception {
        throw new Exception("解包方法目前不支持");
    }
    
    public String pack(Element detailEle, String charsetName)throws Exception {
        StringBuffer content = new StringBuffer();
        //加入xml声明
        content.append(xmlHead);
        //加入文本内容
        Element recordEle = (Element)detailEle.getChildren().get(0);
        content.append(JdomUtil.toString(recordEle));
        // 换行符
        content.append(lineFeed);
        return content.toString();
    }

    public static void main(String[] args )throws Exception{
        CmbXmlRecordPacker p = new CmbXmlRecordPacker();
        Document doc = JdomUtil.build(new FileInputStream("d:/tt.xml"));
        String s = p.pack(doc.getRootElement(), null);
        System.out.print("s="+s);
    }
}
