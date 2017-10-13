package com.sinosoft.midplat.common.check;

import org.jaxen.jdom.JDOMXPath;

public class Field {
    //银行代码
    private String tranCom;
    //优先级
    private String priority;
    //执行校验的xpath表达式
    private String checkXpath;
    //返回的提示消息
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
