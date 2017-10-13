package com.sinosoft.midplat.bat.packer;

import java.util.HashMap;
import java.util.Map;

import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.XmlTag;

/**
 * �������Ľ�����
 * @author ab033862
 * Sep 23, 2013
 */
public class FixedLengthPacker implements RecordPacker {
    /**
     * �����ֶγ���(�ֽ���)
     */
    int[] colLength = null;
    Map<Integer, Character> filledChar = new HashMap<Integer, Character>();
    Map<Integer, Boolean> align = new HashMap<Integer, Boolean>();
    char defaultChar=' ';
    boolean  rightAlign = true;
    
    /**
     * �����м�¼�ܳ���
     */
    int totalLength = 0;
    
    /**
     * �������Ĳ�������
     * @param colLength �����ֶγ��ȣ�byte��
     * @param filledChar ����ַ�
     * @param align ���ı���䣨r/l��
     */
    public FixedLengthPacker(int[] colLength){
        this.colLength = colLength;
        for(int i : colLength){
            totalLength += i;
        }
    }
    
    public Element unpack(String record, String charsetName)throws Exception {
        byte[] c = record.getBytes(charsetName);
        if(totalLength>c.length){
            throw new Exception("ʵ�ʼ�¼����С�ڶ���ĳ���:"+record);
        }
        Element detailEle = new Element(XmlTag.Detail);
        int count = 0;
        for(int i : colLength){
            byte[] col = new byte[i];
            System.arraycopy(c, count, col, 0, i);
            count+=i;
            Element columnEle = new Element("Column");
            columnEle.setText(new String(col,charsetName).trim());
            detailEle.addContent(columnEle);
        }
        return detailEle;
    }
    

    public String pack(Element detailEle, String charsetName)
            throws Exception {
        StringBuffer content = new StringBuffer();
        int i = 0;
        for (Object tColEle : detailEle.getChildren()) {
            Element eleCol = (Element) tColEle;
            // �ֶ�ֵ
            String value = eleCol.getTextTrim();
            int len = colLength[i];
            char filled = filledChar.get(i)==null ? defaultChar : filledChar.get(i);
            boolean al = align.get(i)==null ? rightAlign : align.get(i);
            if(!al){
                //�Ҷ��룬���ַ�
                value = NumberUtil.fillStr(value, len, filled, true);
            }else{
                //����룬�Ҳ��ַ�
                value = NumberUtil.fillStr(value, len, filled, false);
            }
            content.append(value);
            i++;
        }
        // ���з�
        content.append("\n");
        return content.toString();
    }

    public static void main(String[] args )throws Exception {
        FixedLengthPacker p = new FixedLengthPacker(new int[]{16,4,5,8,80,30,13,2,1});
        p.putAlign(6, false);
        p.putFilledChar(6, '0');
        Element e = p.unpack("201204270000002200290270420120427������                                                                          8888887387312393              0000005000.0002     ", "GBK");
        JdomUtil.print(e);
        String s = p.pack(e, "GBK");
        System.out.println("s="+s);
    }

    public char getDefaultChar() {
        return defaultChar;
    }

    public void setDefaultChar(char defaultChar) {
        this.defaultChar = defaultChar;
    }

    public boolean getDefaultAlign() {
        return rightAlign;
    }

    /**
     * ����Ĭ��������ַ�
     * @param rightAlign
     */
    public void setDefaultAlign(boolean rightAlign) {
        this.rightAlign = rightAlign;
    }
    
    /**
     * �����ֶε�����ַ�
     * @param index �ֶ���������0��ʼ
     * @param c
     */
    public void putFilledChar(int index, char c){
        this.filledChar.put(index, c);
    }

    /**
     * �����ֶ��Ƿ�������ַ�
     * @param index �ֶ���������0��ʼ
     * @param rightAlign true������䣬false�������
     */
    public void putAlign(int index, boolean rightAlign){
        this.align.put(index, rightAlign);
    }
}
