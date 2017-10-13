package com.sinosoft.midplat.bat.packer;

import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.XmlTag;

/**
 * 固定分隔符报文解析器
 * @author ab033862
 * Sep 23, 2013
 */
public class FixedDelimiterPacker implements RecordPacker {
    
    String xpath = null;
    char delimiter;
    
    public FixedDelimiterPacker(String xpath, char delimiter){
        this.xpath = xpath;
        this.delimiter = delimiter;
    }
    
    public Element unpack(String record, String charsetName)throws Exception {
        Element detailEle = new Element(XmlTag.Detail);
        String[] tSubMsgs = record.trim().split(xpath, -1);
        for(String value : tSubMsgs){
            Element columnEle = new Element("Column");
            columnEle.setText(value);
            detailEle.addContent(columnEle);
        }
        return detailEle;
    }
    
    public String pack(Element detailEle, String charsetName)throws Exception {
        StringBuffer content = new StringBuffer();
        for (Object tColEle : detailEle.getChildren()) {
            Element eleCol = (Element) tColEle;
            // 字段值
            content.append(eleCol.getTextTrim()+delimiter);
        }
        // 换行符
        content.append("\n");
        return content.toString();
    }

    public static void main(String[] args )throws Exception{
        FixedDelimiterPacker p = new FixedDelimiterPacker("\\|",'|');
        Element e = p.unpack("1|2|3|4|", null);
        JdomUtil.print(e);
        String s = p.pack(e, null);
        System.out.println("s="+s);
    }
}
