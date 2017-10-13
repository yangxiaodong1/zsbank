package com.sinosoft.midplat.cmb.bat.packer;

import java.io.FileInputStream;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.common.JdomUtil;

/**
 * ����xml�ļ������
 * @author ab033862
 * Sep 23, 2013
 */
public class CmbXmlRecordPacker implements RecordPacker {
    //xml����
    String xmlHead = "<?xml version=\"1.0\" encoding=\"GBK\"?>";
    //���з�
    String lineFeed = "\n";
    
    public CmbXmlRecordPacker(String lineFeed){
        this.lineFeed = lineFeed;
    }

    public CmbXmlRecordPacker(){
    }
    
    public Element unpack(String record, String charsetName)throws Exception {
        throw new Exception("�������Ŀǰ��֧��");
    }
    
    public String pack(Element detailEle, String charsetName)throws Exception {
        StringBuffer content = new StringBuffer();
        //����xml����
        content.append(xmlHead);
        //�����ı�����
        Element recordEle = (Element)detailEle.getChildren().get(0);
        content.append(JdomUtil.toString(recordEle));
        // ���з�
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
