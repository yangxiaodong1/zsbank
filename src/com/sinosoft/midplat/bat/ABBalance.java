package com.sinosoft.midplat.bat;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.util.HashMap;
import java.util.Map;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.bat.packer.FixedDelimiterPacker;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.common.XmlConf;
import com.sinosoft.midplat.format.Format;

/**
 * 对账批处理交易父类。此类通过xsl方式，将对账文件转换成标准报文的。
 * @author ab033862
 * Jun 12, 2014
 */
public abstract class ABBalance extends Balance {
    
    //默认拆包器
    RecordPacker defaultPacker = null;
    //自定义拆包器
    Map<Integer, RecordPacker> packers = null;
    
    public ABBalance(XmlConf thisConf, int funcFlag) {
        this(thisConf, funcFlag+"");
    }

    public ABBalance(XmlConf thisConf, String funcFlag) {
        super(thisConf, funcFlag);
        //初始化默认打包器
        defaultPacker = getDefaultRecordPacker();
        //初始化各个个性化行打包器
        packers = getLineRecordPacker();
    }

    @Override
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
    private Document parseNoStd(InputStream batIs) throws Exception{
        cLogger.info("In ABBalance.parseNoStd()!");
        String mCharset = cThisBusiConf.getChildText(charset);
        if (null==mCharset || "".equals(mCharset)) {
            mCharset = "GBK";
        }
        //初始化xml报文
        Element mHead = getHead();
        Element mBody = new Element(Body);
        
        Element mTranData = new Element(TranData);
        mTranData.addContent(mHead);
        mTranData.addContent(mBody);
        
        Document doc = new Document(mTranData);
        
        //对账记录行号
        int lineNum = 0;
        
        //处理对账文件
        BufferedReader mBufReader = new BufferedReader(
                new InputStreamReader(batIs, mCharset));
        for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
            cLogger.info(tLineMsg);
            
            //空行，直接跳过
            if ("".equals(tLineMsg.trim())) {
                cLogger.warn("空行，直接跳过，继续下一条！");
                continue;
            }
            
            //获取改行的打包器
            RecordPacker p = packers.get(lineNum)==null? defaultPacker : packers.get(lineNum);
            //解析对账记录字段
            Element tDetailEle = p.unpack(tLineMsg, mCharset);
            //行号
            Element tLineNumEle = new Element("LineNum");
            tLineNumEle.setText( ""+ lineNum++);
            tDetailEle.addContent(tLineNumEle);
            
            mBody.addContent(tDetailEle);
        }  
        
        cLogger.info("Out ABBalance.parseNoStd()!");
        return doc;
    }
    
    /**
     * 为文件流增加装饰器，进行特殊处理，比如解密。
     * @param in 原文件流
     * @return
     * @throws Exception
     */
    protected byte[] prepareFileContent( byte[] in )throws Exception{
        return in;
    }
    
    /**
     * 调整转换后的标准报文。
     * </br>对于绝大部分银行，xsl转换后得到的标准报文就可以传给核心。
     * </br>但是有的银行需要微调，比如交通银行。
     * @param body 经过xsl转换后的标准报文
     */
    protected Element adjustBody(Element body) throws Exception{
        return body;
    }

    /**
     * 设置默认拆包器
     * @param packer
     */
    protected RecordPacker getDefaultRecordPacker(){
        return new FixedDelimiterPacker("\\|",'|');
    }

    /**
     * 为某行单独设置自定义拆包器
     * @param index 行索引，从0开始 
     * @param packer
     */
    protected Map<Integer, RecordPacker> getLineRecordPacker(){
        return new HashMap<Integer, RecordPacker>();
    }

    @Override
    protected String getFileName() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    protected Element getHead() {
        Element mHead = super.getHead();
        //设置银行类型，核心系统通过此标签判断银行类型
        Element mBankCode = new Element("BankCode");
        mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
        mHead.addContent(mBankCode);
        return setHead(mHead);
    }
    
    /**
     * 设置标准报文头，添加一些自定义标签（用于扩展）。
     * <br>如果某个对账交易需要添加一些额外标签，那么可以overrider此方法。
     * @param head 标准报文头结点，此结点已经添加了一些公共标签
     * @return 调整后的标准报文头结点，此节点将放置在标准报文中
     */
    protected Element setHead(Element head) {
        return head;
    }
    
    
}
