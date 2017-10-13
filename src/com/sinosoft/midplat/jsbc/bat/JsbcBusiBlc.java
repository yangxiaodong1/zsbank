package com.sinosoft.midplat.jsbc.bat;


import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.lang.reflect.Constructor;


import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.jsbc.JsbcConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.format.Format;

public class JsbcBusiBlc extends ABBalance {

    public JsbcBusiBlc() {
        super(JsbcConf.newInstance(), 3304);
    }

    /**
     * 0017    保险公司编号
                20150422  日期
                01   流水号 （暂时定死的）

     */
    protected String getFileName() {
        Element mBankEle = cThisConfRoot.getChild("bank");
        return  mBankEle.getAttributeValue("insu") 
                + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + "01.xml";
    }
    
    /**
     * 设置默认拆包器
     * @param packer
     */
    protected RecordPacker getDefaultRecordPacker(){
        return  null;
    }
    protected Element parse(InputStream batIs) throws Exception {
        // TODO Auto-generated method stub
        cLogger.info("Into ABBalance.parse()...");

        cLogger.info("begin to read file...");
        ByteArrayOutputStream fileBaos = new ByteArrayOutputStream();
        try{
            //读取文件
            byte[] b = new byte[2048];
            int length = -1;
            while ( (length = batIs.read(b)) != -1) {
                fileBaos.write(b, 0, length);
            }
            fileBaos.flush();
        }catch(Exception e){
            cLogger.error("读取文件出错.....");
            throw e;
        }finally{
            if(batIs != null){
                batIs.close();
            }
        }

        //将对账文件解析成xml
        Document pNoStdXml = null;
        try{
            cLogger.info("prepare the file content...");
            //增加装饰器，进行特殊处理
            byte[] content = prepareFileContent(fileBaos.toByteArray());
            
            cLogger.info("convert the file to xml...");
            //解析流，将其转换成xml
            pNoStdXml = parseNoStd(new ByteArrayInputStream(content));
            
            //日志前缀
            StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
                    .getName()).append('_').append(NoFactory.nextAppNo())
                    .append('_').append(cThisBusiConf.getChildText(funcFlag))
                    .append("_in.xml");
            //记录非标准报文
            SaveMessage.save(pNoStdXml, cThisConfRoot.getChildText(TranCom), mSaveName.toString());
            cLogger.info("保存非标准请求报文完毕！");
        }catch(Exception e){
            cLogger.error("解析文件出错.....");
            throw e;
        }

        String tFormatClassName = cThisBusiConf.getChildText("format");
        //报文转换模块
        cLogger.info((new StringBuilder("报文转换模块：")).append(tFormatClassName).toString());
        Constructor tFormatConstructor = Class.forName(tFormatClassName)
                .getConstructor(new Class[] { org.jdom.Element.class });
        Format tFormat = (Format) tFormatConstructor
                .newInstance(new Object[] { cThisBusiConf });
        //将xml转换成标准报文
        cLogger.info("convert nonstandard xml to standard xml...");
        Document pstd = tFormat.noStd2Std(pNoStdXml);
        
        //取出标准报文的body节点
        Element mBody = pstd.getRootElement().getChild(Body);
        mBody.detach();
        
        //加入一个钩子，用于微调标准报文
        mBody = adjustBody(mBody);
        
        return mBody;
    }
    /**
     * 将对账文件流转换成简易xml报文
     * @param batIs
     * @return
     * @throws Exception
     */
    public Document parseNoStd(InputStream batIs) throws Exception{
        cLogger.info("In JsbcBusiBlc.parseNoStd()!");
        
        
        //处理对账文件
        Document mXmlDoc = JdomUtil.build(batIs);
        //初始化xml报文
        Element mHead = getHead();
        
        mXmlDoc.getRootElement().addContent(mHead);
        
        cLogger.info("Out JsbcBusiBlc.parseNoStd()!");
        return mXmlDoc;
    }
    
    
}
