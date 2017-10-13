package com.sinosoft.midplat.bat;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileFilter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.packer.FixedDelimiterPacker;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.bat.trans.FileTransportor;
import com.sinosoft.midplat.bat.trans.FtpUploadTransportor;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.common.XmlConf;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.Format;
import com.sinosoft.midplat.service.Service;

public abstract class UploadFileBatchService extends BatchService {
    protected final Logger cLogger = Logger.getLogger(getClass());
    
    //默认拆包器
    RecordPacker defaultPacker = null;
    //自定义拆包器
    Map<Integer, RecordPacker> packers = new HashMap<Integer, RecordPacker>();
    
    //报文转换器
    Format format = null;
    
    //业务处理器
    Service service = null;
    
    public UploadFileBatchService(XmlConf conf, String funcFlag) {
        super(conf, funcFlag);
    }
    
    /**
     * 初始化转换类、服务类
     * @throws Exception
     */
    private void init()throws Exception{
        // 获取服务的配置
        String tServiceClassName = thisBusiConf.getChildText("service");
        if (tServiceClassName == null && "".equals(tServiceClassName)){
            throw new Exception("该交易没有配置service");
        }
        cLogger.debug("业务处理模块："+tServiceClassName);
        // 初始化服务
        Constructor tServiceConstructor = Class.forName(tServiceClassName)
                .getConstructor(new Class[] { org.jdom.Element.class });
        service = (Service) tServiceConstructor
                .newInstance(new Object[] { thisBusiConf });

        // 获取报文转换配置
        String tFormatClassName = thisBusiConf.getChildText("format");
        if(tFormatClassName!=null && !"".equals(tFormatClassName)){
            //配置了xsl转换
            cLogger.info("报文转换模块："+tFormatClassName);
            //初始化转换模块
            Constructor tFormatConstructor = Class.forName(tFormatClassName)
            .getConstructor(new Class[] { org.jdom.Element.class });
            this.format = (Format) tFormatConstructor
            .newInstance(new Object[] { thisBusiConf });
        }
        
        //初始化默认打包器
        defaultPacker = getDefaultRecordPacker();
        //初始化各个个性化行打包器
        this.packers.putAll(getLineRecordPacker());
    }
    
    @Override
    public void run() {
        Thread.currentThread().setName(
                String.valueOf(NoFactory.nextTranLogNo()));
        cLogger.debug("Into UploadFileBatchService.run()...");
        // 获取请求标准报文
        Element tTranData = new Element("TranData");
        //初始化请求报文
        Document tInNoStdXml = new Document(tTranData);
        //请求标准报文，默认等于非标准报文
        Document tInStdXml=tInNoStdXml;
        
        //设置默认运行时间
        if(calendar == null){
            this.calendar = Calendar.getInstance();
        }
        try {
            // 报文头
            Element tHeadEle = getHead();
            setHead(tHeadEle);
            tTranData.addContent(tHeadEle);
            // 报文体
            Element tBodyEle = getBody();
            tTranData.addContent(tBodyEle);
            
            // 初始化转换模块、服务类
            init();
            
            if(format!=null){
                //如果配置了xsl转换，那么就调用转换
                //保存非标准报文
                StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
                        .getName()).append('_').append(NoFactory.nextAppNo()).append(
                        '_').append(thisBusiConf.getChildText(XmlTag.funcFlag)).append("_in.xml");
                SaveMessage
                .save(tInNoStdXml, thisRootConf.getChildText(XmlTag.TranCom), mSaveName.toString());
                cLogger.info("保存非标准报文完毕！" + mSaveName);
                
                //将标准报文转换成非标准报文
                tInStdXml = format.noStd2Std(tInNoStdXml);
            }
            
            //调用业务处理逻辑
            Document tOutStdXml = service.service(tInStdXml);
            String tFlag =XPath.newInstance("//Head/Flag").valueOf(tOutStdXml.getRootElement());
            resultMsg =XPath.newInstance("//Head/Desc").valueOf(tOutStdXml.getRootElement());
            if ( !"0".equals(tFlag)){
                //调用service出错
                throw new MidplatException("执行service出错："+resultMsg);
            }
            
            if(format !=null ){
                //如果配置了xsl转换，那么就调用转换
                //将标准报文转换成非标准报文
                tOutStdXml = format.std2NoStd(tOutStdXml);
                
                //保存非标准报文
                StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
                        .getName()).append('_').append(NoFactory.nextAppNo()).append(
                        '_').append(thisBusiConf.getChildText(XmlTag.funcFlag)).append("_out.xml");
                SaveMessage
                        .save(tOutStdXml, thisRootConf.getChildText(XmlTag.TranCom), mSaveName.toString());
                cLogger.info("保存非标准报文完毕！" + mSaveName);
            }
            
            //调整返回报文
            tOutStdXml = adjustOutXml(tOutStdXml);
            
            /* 
             *解析响应报文，如果没有配置xsl转换模块，那么解析的就是标准报文；
             *如果配置了转换模块，那么解析的是非标准报文
            */
            cLogger.debug("解析核心的返回报文....");
            String fileContent = parse(tOutStdXml);

            // 保存文件
            cLogger.debug("保存文件....");
            byte[] content = prepareFileContent(fileContent);
            saveFile(content);

            //后置处理
            postProcess();
            
            // ftp上传文件
            ftpFile();

        } catch (Exception e) {
            cLogger.error("批处理出错", e);
            resultMsg = e.getMessage();
        }
        
        try{
            // 备份文件
            if ("01".equals(DateUtil.getDateStr(calendar, "dd"))) {
                cLogger.debug("备份上个月的文件....");
                bakFiles(this.thisLocalDir);
            }
        }catch(Exception e){
            cLogger.error("备份上个月的文件出错",e);
        }
        
        calendar = null;
        cLogger.debug("Out UploadFileBatchService.run()!");

    }
    
    /**
     * 请求核心报文的报文体
     * 
     * @return 报文体body
     */
    protected byte[] prepareFileContent(String fileContent) throws Exception{
        return fileContent.getBytes(fileCharset);
    }
    
    /**
     * 获取文件传输组件
     * @param packer
     */
    protected FileTransportor getFileTransportor(){
        return null;
    }
    
    /**
     * 解析报文，将其转换成文件格式的字符串。
     * 如果没有配置xsl转换模块，那么解析的就是标准报文；
     * 如果配置了转换模块，那么解析的是非标准报文;
     * @param tOutNoStdXml
     * @return 符合文件格式的字符串
     */
    protected String parse(Document tOutNoStdXml) throws Exception{
        StringBuffer content = new StringBuffer();
            // 正常报文
        List<Element> tDetailList = XPath.selectNodes(tOutNoStdXml
                .getRootElement(), "//Body/Detail");

        cLogger.debug("需要转换的记录：" + tDetailList.size());
        int i = 0;
        //处理每个detail节点
        for (Element tDetailEle : tDetailList) {
            //获取改行的打包器
            RecordPacker p = packers.get(i)==null? defaultPacker : packers.get(i);
            //打包记录
            String c = p.pack(tDetailEle, null);
            cLogger.debug("打包后记录：" + c);
            content.append(c);
            i++;
        }
        return content.toString();
    }

    private void saveFile(byte[] content) throws Exception {
        BufferedOutputStream out = null;
        BufferedInputStream in = null;
        try {
            // 读取文件
            in = new BufferedInputStream(new ByteArrayInputStream(content));
            out = new BufferedOutputStream(new FileOutputStream(thisLocalDir
                    + getFileName()));
            // 拷贝文件
            int len = -1;
            byte[] buffer = new byte[5 * 1024];
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
            out.flush();
        } finally {
            // 关闭文件
            if (in != null) {
                in.close();
            }
            if (out != null) {
                out.close();
            }
        }
    }

    /**
     * 请求核心报文的报文体
     * 
     * @return 报文体body
     * @throws Exception 
     */
    protected Element getBody() throws Exception {
        Element mBodyEle = new Element(XmlTag.Body);
        setBody(mBodyEle);
        return mBodyEle;
    }

    /**
     * 设置核心报文的报文体
     * 
     * @return 报文体body
     */
    protected abstract void setBody(Element mBodyEle) throws Exception;

    /**
     * 返回请求核心报文的报文头
     * 
     * @return 报文体Head
     */
    protected Element getHead() {
        cLogger.info("Into UploadFileBatchService.getHead()...");
        Element mTranDate = new Element("TranDate");
        mTranDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        Element mTranTime = new Element("TranTime");
        mTranTime.setText(DateUtil.getDateStr(calendar, "HHmmss"));
        Element mTranCom = (Element) thisRootConf.getChild("TranCom").clone();
        Element mNodeNo = (Element) thisBusiConf.getChild("NodeNo").clone();
        Element mTellerNo = new Element("TellerNo");
        mTellerNo.setText("sys");
        Element mTranNo = new Element("TranNo");
        mTranNo.setText(getFileName());
        Element mFuncFlag = new Element("FuncFlag");
        mFuncFlag.setText(thisBusiConf.getChildText("funcFlag"));
        Element mBankCode = new Element("BankCode");
        mBankCode.setText(thisRootConf.getChild("TranCom").getAttributeValue(
                XmlTag.outcode));
        Element mHead = new Element("Head");
        mHead.addContent(mTranDate);
        mHead.addContent(mTranTime);
        mHead.addContent(mTranCom);
        mHead.addContent(mNodeNo);
        mHead.addContent(mTellerNo);
        mHead.addContent(mTranNo);
        mHead.addContent(mFuncFlag);
        mHead.addContent(mBankCode);
        cLogger.info("Out UploadFileBatchService.getHead()!");
        return mHead;
    }

    protected void bakFiles(String pFileDir) {
        cLogger.info("Into UploadFileBatchService.bakFiles()...");
        if (pFileDir == null || "".equals(pFileDir)) {
            cLogger.warn("本地文件目录为空，不进行备份操作！");
            return;
        }
        File mDirFile = new File(pFileDir);
        if (!mDirFile.exists() || !mDirFile.isDirectory()) {
            cLogger.warn((new StringBuilder("本地文件目录不存在，不进行备份操作！")).append(
                    mDirFile).toString());
            return;
        }
        File mOldFiles[] = mDirFile.listFiles(new FileFilter() {
            public boolean accept(File pFile) {
                if (!pFile.isFile()) {
                    return false;
                } else {
                    Calendar tCurCalendar = Calendar.getInstance();
                    tCurCalendar.set(Calendar.HOUR_OF_DAY, 8);
                    Calendar tFileCalendar = Calendar.getInstance();
                    tFileCalendar.setTimeInMillis(pFile.lastModified());
                    return tFileCalendar.before(tCurCalendar);
                }
            }

        });
        Calendar mCalendar = Calendar.getInstance();
        mCalendar.add(Calendar.MONTH, -1);
        File mNewDir = new File(mDirFile, DateUtil.getDateStr(mCalendar,
                "yyyy/yyyyMM"));
        for (int i = 0; i < mOldFiles.length; i++) {
            File tFile = mOldFiles[i];
            cLogger.info(tFile.getAbsoluteFile() + " start move...");
            try {
                IOTrans.fileMove(tFile, mNewDir);
                cLogger.info(tFile.getAbsoluteFile() + " end move!");
            } catch (IOException ex) {
                cLogger.error(tFile.getAbsoluteFile() + "备份失败！", ex);
            }
        }

        cLogger.info("Out UploadFileBatchService.bakFiles()!");
    }

    /**
     * 后置处理方法，该方法在生成本地方法后调用。
     * 一般如果生成文件后需要加入个性化处理，则可以实现该方法。
     * @return
     * @throws Exception
     */
    protected boolean postProcess()throws Exception{
        return true;
    }

    /**
     * 后置处理方法，该方法在生成本地方法后调用。
     * 一般如果生成文件后需要加入个性化处理，则可以实现该方法。
     * @return
     * @throws Exception
     */
    protected void ftpFile()throws Exception{
        //常用ftp上传文件
        Element ftpElement = thisBusiConf.getChild("ftp");
        if(ftpElement==null){
            cLogger.debug("未配置ftp信息...");
        }else{
            //配置了ftp上传
            FileTransportor t = new FtpUploadTransportor(thisBusiConf);
            t.transport(getFtpName());
        }
        
        //自定义方式上传文件
        Element transEle = thisBusiConf.getChild("transport");
        if(transEle==null){
            //没有配置下载文件
            cLogger.info("没有配置文件传输组件节点<transport>...");
        }else{
            //自定义传输
            FileTransportor t = this.getFileTransportor();
            t.transport(getFtpName());
        }
        return;
    }
    /**
     * 批量文件的文件名
     * 
     * @return 文件名
     */
    protected abstract String getFileName();

    /**
     * ftp文件名
     * 
     * @return 文件名
     */
    protected String getFtpName(){
        return getFileName();
    }
    
    protected abstract void setHead(Element head);
    
    
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
    
    /**
     * 调整转换后的报文。
     * @param noStdXml 转换后的报文
     */
    protected Document adjustOutXml(Document outXml) throws Exception{
    	return outXml;
    }
}
