package com.sinosoft.midplat.common.check;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.jaxen.jdom.JDOMXPath;
import org.jdom.Document;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class CheckFieldManager {
    protected final static Logger cLogger = Logger.getLogger(CheckFieldManager.class);
    private static volatile CheckFieldManager manager;
    
    //各银行校验域
    Map<String, List<Field>> bankFields = new HashMap<String, List<Field>>();
    //通用校验域
    List<Field> commFields = new ArrayList<Field>();
    
    private CheckFieldManager(){
        init();
    }
    
    public static synchronized CheckFieldManager getInstance(){
        if(manager==null){
            manager = new CheckFieldManager();
        }
        return manager;
    }
    
    private void init(){
        StringBuffer mSqlStr = new StringBuffer();
        mSqlStr.append("select TRANCOM, PRIORITY, CHECKXPATH, MESSAGE FROM CHECKFIELD ");
        mSqlStr.append("  ORDER BY TRANCOM, PRIORITY");
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (mSSRS.MaxRow > 0) {
            for(int i=1 ; i<= mSSRS.MaxRow;i++){
                String tranCom=mSSRS.GetText(i, 1);
                String priority=mSSRS.GetText(i, 2);
                String checkXpath=mSSRS.GetText(i, 3);
                String message=mSSRS.GetText(i, 4);
                try{
                    //初始化xpath
                    JDOMXPath xpath = new JDOMXPath(checkXpath);
                    Field f = new Field(tranCom, priority, checkXpath, message);
                    f.setXpath(xpath);
                    
                    if("0".equals(tranCom)){
                        //通用银行规则
                        commFields.add(f);
                    }else{
                        //某银行规则
                        List<Field> bFields = bankFields.get(tranCom);
                        if(bFields==null){
                            bFields = new ArrayList<Field>();
                            bankFields.put(tranCom, bFields);
                        }
                        bFields.add(f);
                    }
                }catch(Exception e){
                    cLogger.error("转换XPath失败[trancom="+tranCom+",priority="+priority+",checkXpath="+checkXpath, e);
                }
            }
        }
    }
    
    
    /**
     * 校验报文是否符合规则
     * @param tranCom 银行代码
     * @param doc  xml报文
     * @return 错误提示信息，如果返回null，则表示校验通过
     */
    public String verify(String tranCom, Document doc)throws Exception{
        
        //先校验通用规则
        String result = check(this.commFields,doc);
        if(result != null){
            //通用规则不通过
            return result;
        }
        
        //校验各银行自定义规则
        List<Field> bFields = bankFields.get(tranCom);
        if(bFields!=null){
            return check(bFields,doc);
        }
        return null;
        
    }

    private String check(List<Field> fields, Document doc)throws Exception{
        for(Field f : fields){
            JDOMXPath xpath = f.getXpath();
            try{
                boolean result = xpath.booleanValueOf(doc);
                if(result){
                    //校验不通过
                    cLogger.debug("校验不通过:"+f);
                    return f.getMessage();
                }
            }catch(Exception e){
                throw new Exception("执行校验出现异常"+f,e);
            }
        }
        return null;
    }
    
    public static void main(String[] args) throws Exception {
         
         Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/桌面/abc.xml"));
         
         System.out.println(CheckFieldManager.getInstance().verify("1", doc));
         
         
     }

}
