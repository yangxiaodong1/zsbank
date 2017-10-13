package com.sinosoft.midplat.common.check;

import org.jaxen.jdom.JDOMXPath;

public class Field {
    //���д���
    private String tranCom;
    //���ȼ�
    private String priority;
    //ִ��У���xpath���ʽ
    private String checkXpath;
    //���ص���ʾ��Ϣ
    private String message;

    private JDOMXPath xpath;

    public Field(String tranCom, String priority, String checkXpath,
            String message) {
        this.tranCom = tranCom;
        this.priority = priority;
        this.checkXpath = checkXpath;
        this.message = message;
    }

    void setXpath(JDOMXPath xpath) {
        this.xpath = xpath;
    }

    JDOMXPath getXpath() {
        return xpath;
    }

    public String getTranCom() {
        return tranCom;
    }

     void setTranCom(String tranCom) {
        this.tranCom = tranCom;
    }

    public String getPriority() {
        return priority;
    }

    void setPriority(String priority) {
        this.priority = priority;
    }

    public String getCheckXpath() {
        return checkXpath;
    }

    void setCheckXpath(String checkXpath) {
        this.checkXpath = checkXpath;
    }

    public String getMessage() {
        return message;
    }

    void setMessage(String message) {
        this.message = message;
    }

    /* (non-Javadoc)
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        // TODO Auto-generated method stub
        return "[trancom="+tranCom+",priority="+priority+",checkXpath="+checkXpath+"]";
    }
    
    
}
