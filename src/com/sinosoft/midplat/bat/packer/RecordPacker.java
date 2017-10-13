package com.sinosoft.midplat.bat.packer;

import org.jdom.Element;

/**
 * 对账报文记录打包器，负责拆包、打包的过程。
 * </br>根据算法的不同，各实现类进行不同的实现。常用的有定长、固定分隔符。
 * @author ab033862
 * Sep 24, 2013
 */
public interface RecordPacker {
    /**
     * 将文本记录解析成xml节点：
     * @param conent
     * @return
     */
    public Element unpack(String conent, String charsetName)throws Exception;

    /**
     * 将xml节点打包成文本记录
     * @param conent
     * @return
     */
    public String pack(Element element, String charsetName)throws Exception;
}
