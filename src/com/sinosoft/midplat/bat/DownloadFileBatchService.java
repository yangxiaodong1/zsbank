package com.sinosoft.midplat.bat;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.packer.FixedDelimiterPacker;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.bat.trans.FileTransportor;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.common.XmlConf;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.format.Format;
import com.sinosoft.midplat.service.Service;

public abstract class DownloadFileBatchService extends BatchService {
    protected final Logger cLogger = Logger.getLogger(getClass());
    //默认拆包器
    RecordPacker defaultPacker = null;
    //自定义拆包器
    Map<Integer, RecordPacker> packers = null;
    //文件传输组件
    FileTransportor trans = null;
    
    public DownloadFileBatchService(XmlConf conf, String funcFlag) {
        super(conf, funcFlag);
        //初始化默认打包器
        defaultPacker = getDefaultRecordPacker();
        //初始化各个个性化行打包器
        packers = getLineRecordPacker();
        //文件传输组件
        trans = getFileTransportor();
    }

    @Override
    public void run() {
        cLogger.debug("Into DownloadFileBatchService.run()...");
        Thread.currentThread().setName(
                String.valueOf(NoFactory.nextTranLogNo()));
        
        //设置默认运行时间
        if(calendar == null){
            this.calendar = Calendar.getInstance();
        }
        
        //初始化xml报文
        Element mHead = getHead();
        Element mBody = new Element(XmlTag.Body);
        
        Element mTranData = new Element(XmlTag.TranData);
        mTranData.addContent(mHead);
        mTranData.addContent(mBody);
        
        //调用service的标准报文
        Document inStd = new Document(mTranData);
        //错误标签，传递给service层
        Element errorEle = null;
        try{
            if(!manualTrigger || reDownload){
                //自动触发、选择了重新下载
                //下载文件
                downloadFile();
            }else{
                cLogger.info("用户选择不重新下载文件...");
            }
        }catch(Exception e){
            cLogger.error("下载文件出错", e);
            //下载文件出错，将错误信息传递给service层
            errorEle = new Element(XmlTag.Error);
            errorEle.setText("下载文件出错:"+e.getMessage());
        }
        
        if(errorEle==null){
            //下载文件成功
            try{
                //读取下载到的文件
                byte[] content = readLocalFile();
                cLogger.info("prepare the file content...");
                //增加装饰器，进行特殊处理
                content = prepareFileContent(content);

                cLogger.info("convert the file to xml...");
                //解析流，将其转换成xml
                Document  pNoStdXml = parseNoStd(new ByteArrayInputStream(content), inStd);

                cLogger.info("convert nonstandard xml to standard xml...");
                //非标准报文转成标准报文
                inStd = nostd2std(pNoStdXml);

                //加入一个钩子，用于微调标准报文
                inStd = adjustStd(inStd);

            }catch(Exception e){
                cLogger.error("解析文件出错", e);
                //下载文件出错，将错误信息传递给service层
                errorEle = new Element(XmlTag.Error);
                errorEle.setText("解析文件出错:"+e.getMessage());
            }
        }
        
        try{
            if(errorEle!=null){
                //前期解析文件出错，将error信息传递给service
                mTranData.addContent(errorEle);
            }
            //调用服务类
            Document outStd = sendRequest(inStd);
            
            //校验核心是否正常返回
            resultMsg = XPath.newInstance("//Head/Desc").valueOf(outStd);
            
        }catch (Exception e) {
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

    }

    protected Document nostd2std(Document pNoStdXml) throws Exception {
        //日志前缀
        StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
                .getName()).append('_').append(NoFactory.nextAppNo())
                .append('_').append(thisBusiConf.getChildText(XmlTag.funcFlag))
                .append("_in.xml");
        //记录非标准报文
        SaveMessage.save(pNoStdXml, thisRootConf.getChildText(XmlTag.TranCom), mSaveName.toString());
        cLogger.info("保存非标准请求报文完毕！");
        
        String tFormatClassName = thisBusiConf.getChildText(XmlTag.format);
        //报文转换模块
        cLogger.info((new StringBuilder("报文转换模块：")).append(tFormatClassName).toString());
        Constructor tFormatConstructor = Class.forName(tFormatClassName)
        .getConstructor(new Class[] { org.jdom.Element.class });
        Format tFormat = (Format) tFormatConstructor
        .newInstance(new Object[] { thisBusiConf });
        
        return tFormat.noStd2Std(pNoStdXml);
    }

    private void downloadFile() throws Exception {
        Element transEle = thisBusiConf.getChild("transport");
        if(transEle==null){
            //没有配置下载文件
            cLogger.info("没有配置下载文件节点<transport>...");
            return;
        }
        //下载文件
        this.trans.transport(this.getFileName());
        
    }
    protected Document sendRequest(Document tInStd) throws Exception {
        //业务处理
        String tServiceClassName = thisBusiConf.getChildText("service");
        cLogger.debug((new StringBuilder("业务处理模块：")).append(
                tServiceClassName).toString());
        Constructor tServiceConstructor = Class.forName(tServiceClassName)
        .getConstructor(new Class[] { org.jdom.Element.class });
        Service tService = (Service) tServiceConstructor
        .newInstance(new Object[] { thisBusiConf });
        Document tOutStdXml = tService.service(tInStd);
        
        return tOutStdXml;
    }

    private byte[] readLocalFile() throws Exception {
        cLogger.error("读取文件....."+thisLocalDir+this.getFileName());
        FileInputStream batIs = new FileInputStream(thisLocalDir+this.getFileName());
        ByteArrayOutputStream fileBaos = new ByteArrayOutputStream();
        try{
            //读取文件
            byte[] b = new byte[2048];
            int length = -1;
            while ( (length = batIs.read(b)) != -1) {
                fileBaos.write(b, 0, length);
            }
            fileBaos.flush();
            return fileBaos.toByteArray();
        }catch(Exception e){
            cLogger.error("读取文件出错.....");
            throw e;
        }finally{
            if(batIs != null){
                batIs.close();
            }
        }
    }

    
    /**
     * 请求核心报文的报文体
     * 
     * @return 报文体body
     */
    protected byte[] prepareFileContent(byte[] fileContent) throws Exception{
        return fileContent;
    }
    /**
     * 调整转换后的标准报文。
     * </br>对于绝大部分银行，xsl转换后得到的标准报文就可以传给核心。
     * </br>但是有的银行需要微调，比如交通银行。
     * @param body 经过xsl转换后的标准报文
     */
    protected Document adjustStd(Document doc) throws Exception{
        return doc;
    }
    /**
     * 将对账文件流转换成简易xml报文
     * @param batIs
     * @return
     * @throws Exception
     */
    protected Document parseNoStd(InputStream batIs,Document doc) throws Exception{
        cLogger.info("In DownloadFileBatchService.parseNoStd()!");

        //对账记录行号
        int lineNum = 0;
        Element mBody = doc.getRootElement().getChild(XmlTag.Body);
        
        //处理对账文件
        BufferedReader mBufReader = new BufferedReader(
                new InputStreamReader(batIs, fileCharset));
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
            Element tDetailEle = p.unpack(tLineMsg, fileCharset);
            //行号
            Element tLineNumEle = new Element("LineNum");
            tLineNumEle.setText( ""+ lineNum++);
            tDetailEle.addContent(tLineNumEle);
            
            mBody.addContent(tDetailEle);
        }  
        
        cLogger.info("Out DownloadFileBatchService.parseNoStd()!");
        return doc;
    }


    /**
     * 返回请求核心报文的报文头
     * 
     * @return 报文体Head
     */
    protected Element getHead() {
        cLogger.info("Into DownloadFileBatchService.getHead()...");
        Element mTranDate = new Element(XmlTag.TranDate);
        mTranDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        
        Element mTranTime = new Element(XmlTag.TranTime);
        mTranTime.setText(DateUtil.getDateStr(calendar, "HHmmss"));
        
        Element mTranCom = (Element) thisRootConf.getChild(XmlTag.TranCom).clone();
        Element mNodeNo = (Element) thisBusiConf.getChild(XmlTag.NodeNo).clone();
        
        Element mTellerNo = new Element(XmlTag.TellerNo);
        mTellerNo.setText(CodeDef.SYS);
        
        Element mTranNo = new Element(XmlTag.TranNo);
        mTranNo.setText(getFileName());
        
        Element mFuncFlag = new Element(XmlTag.FuncFlag);
        mFuncFlag.setText(thisBusiConf.getChildText(XmlTag.funcFlag));
        
        Element mBankCode = new Element("BankCode");
        mBankCode.setText(mTranCom.getAttributeValue(XmlTag.outcode));
        
        Element mHead = new Element(XmlTag.Head);
        mHead.addContent(mTranDate);
        mHead.addContent(mTranTime);
        mHead.addContent(mTranCom);
        mHead.addContent(mNodeNo);
        mHead.addContent(mTellerNo);
        mHead.addContent(mTranNo);
        mHead.addContent(mFuncFlag);
        mHead.addContent(mBankCode);
        
        cLogger.info("Out DownloadFileBatchService.getHead()!");
        return mHead;
    }

    
    /**
     * 设置默认拆包器
     * @param packer
     */
    protected RecordPacker getDefaultRecordPacker(){
        return new FixedDelimiterPacker("\\|",'|');
    }
    
    /**
     * 获取文件传输组件
     * @param packer
     */
    protected abstract FileTransportor getFileTransportor();

    /**
     * 为某行单独设置自定义拆包器
     * @param index 行索引，从0开始 
     * @param packer
     */
    protected Map<Integer, RecordPacker> getLineRecordPacker(){
        return new HashMap<Integer, RecordPacker>();
    }
    
    /**
     * 本地文件名
     * 
     * @return 文件名
     */
    protected abstract String getFileName();

    
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
}
