package com.sinosoft.midplat.bat.packer;

import org.jdom.Element;

/**
 * ���˱��ļ�¼�������������������Ĺ��̡�
 * </br>�����㷨�Ĳ�ͬ����ʵ������в�ͬ��ʵ�֡����õ��ж������̶��ָ�����
 * @author ab033862
 * Sep 24, 2013
 */
public interface RecordPacker {
    /**
     * ���ı���¼������xml�ڵ㣺
     * @param conent
     * @return
     */
    public Element unpack(String conent, String charsetName)throws Exception;

    /**
     * ��xml�ڵ������ı���¼
     * @param conent
     * @return
     */
    public String pack(Element element, String charsetName)throws Exception;
}
