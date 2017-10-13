package com.sinosoft.midplat.bat.packer;

import java.util.HashMap;
import java.util.Map;

import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.XmlTag;

/**
 * 定长报文解析器
 * @author ab033862
 * Sep 23, 2013
 */
public class FixedLengthPacker implements RecordPacker {
    /**
     * 各个字段长度(字节数)
     */
    int[] colLength = null;
    Map<Integer, Character> filledChar = new HashMap<Integer, Character>();
    Map<Integer, Boolean> align = new HashMap<Integer, Boolean>();
    char defaultChar=' ';
    boolean  rightAlign = true;
    
    /**
     * 整个行记录总长度
     */
    int totalLength = 0;
    
    /**
     * 定长报文拆解包器。
     * @param colLength 各个字段长度（byte）
     * @param filledChar 填充字符
     * @param align 从哪边填充（r/l）
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
            throw new Exception("实际记录长度小于定义的长度:"+record);
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
            // 字段值
            String value = eleCol.getTextTrim();
            int len = colLength[i];
            char filled = filledChar.get(i)==null ? defaultChar : filledChar.get(i);
            boolean al = align.get(i)==null ? rightAlign : align.get(i);
            if(!al){
                //右对齐，左补字符
                value = NumberUtil.fillStr(value, len, filled, true);
            }else{
                //左对齐，右补字符
                value = NumberUtil.fillStr(value, len, filled, false);
            }
            content.append(value);
            i++;
        }
        // 换行符
        content.append("\n");
        return content.toString();
    }

    public static void main(String[] args )throws Exception {
        FixedLengthPacker p = new FixedLengthPacker(new int[]{16,4,5,8,80,30,13,2,1});
        p.putAlign(6, false);
        p.putFilledChar(6, '0');
        Element e = p.unpack("201204270000002200290270420120427李青云                                                                          8888887387312393              0000005000.0002     ", "GBK");
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
     * 设置默认右填充字符
     * @param rightAlign
     */
    public void setDefaultAlign(boolean rightAlign) {
        this.rightAlign = rightAlign;
    }
    
    /**
     * 设置字段的填充字符
     * @param index 字段索引，从0开始
     * @param c
     */
    public void putFilledChar(int index, char c){
        this.filledChar.put(index, c);
    }

    /**
     * 设置字段是否右填充字符
     * @param index 字段索引，从0开始
     * @param rightAlign true：右填充，false：左填充
     */
    public void putAlign(int index, boolean rightAlign){
        this.align.put(index, rightAlign);
    }
}
