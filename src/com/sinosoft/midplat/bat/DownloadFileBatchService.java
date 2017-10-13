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
    //Ĭ�ϲ����
    RecordPacker defaultPacker = null;
    //�Զ�������
    Map<Integer, RecordPacker> packers = null;
    //�ļ��������
    FileTransportor trans = null;
    
    public DownloadFileBatchService(XmlConf conf, String funcFlag) {
        super(conf, funcFlag);
        //��ʼ��Ĭ�ϴ����
        defaultPacker = getDefaultRecordPacker();
        //��ʼ���������Ի��д����
        packers = getLineRecordPacker();
        //�ļ��������
        trans = getFileTransportor();
    }

    @Override
    public void run() {
        cLogger.debug("Into DownloadFileBatchService.run()...");
        Thread.currentThread().setName(
                String.valueOf(NoFactory.nextTranLogNo()));
        
        //����Ĭ������ʱ��
        if(calendar == null){
            this.calendar = Calendar.getInstance();
        }
        
        //��ʼ��xml����
        Element mHead = getHead();
        Element mBody = new Element(XmlTag.Body);
        
        Element mTranData = new Element(XmlTag.TranData);
        mTranData.addContent(mHead);
        mTranData.addContent(mBody);
        
        //����service�ı�׼����
        Document inStd = new Document(mTranData);
        //�����ǩ�����ݸ�service��
        Element errorEle = null;
        try{
            if(!manualTrigger || reDownload){
                //�Զ�������ѡ������������
                //�����ļ�
                downloadFile();
            }else{
                cLogger.info("�û�ѡ�����������ļ�...");
            }
        }catch(Exception e){
            cLogger.error("�����ļ�����", e);
            //�����ļ�������������Ϣ���ݸ�service��
            errorEle = new Element(XmlTag.Error);
            errorEle.setText("�����ļ�����:"+e.getMessage());
        }
        
        if(errorEle==null){
            //�����ļ��ɹ�
            try{
                //��ȡ���ص����ļ�
                byte[] content = readLocalFile();
                cLogger.info("prepare the file content...");
                //����װ�������������⴦��
                content = prepareFileContent(content);

                cLogger.info("convert the file to xml...");
                //������������ת����xml
                Document  pNoStdXml = parseNoStd(new ByteArrayInputStream(content), inStd);

                cLogger.info("convert nonstandard xml to standard xml...");
                //�Ǳ�׼����ת�ɱ�׼����
                inStd = nostd2std(pNoStdXml);

                //����һ�����ӣ�����΢����׼����
                inStd = adjustStd(inStd);

            }catch(Exception e){
                cLogger.error("�����ļ�����", e);
                //�����ļ�������������Ϣ���ݸ�service��
                errorEle = new Element(XmlTag.Error);
                errorEle.setText("�����ļ�����:"+e.getMessage());
            }
        }
        
        try{
            if(errorEle!=null){
                //ǰ�ڽ����ļ�������error��Ϣ���ݸ�service
                mTranData.addContent(errorEle);
            }
            //���÷�����
            Document outStd = sendRequest(inStd);
            
            //У������Ƿ���������
            resultMsg = XPath.newInstance("//Head/Desc").valueOf(outStd);
            
        }catch (Exception e) {
            cLogger.error("���������", e);
            resultMsg = e.getMessage();
        }
        
        try{
            // �����ļ�
            if ("01".equals(DateUtil.getDateStr(calendar, "dd"))) {
                cLogger.debug("�����ϸ��µ��ļ�....");
                bakFiles(this.thisLocalDir);
            }
        }catch(Exception e){
            cLogger.error("�����ϸ��µ��ļ�����",e);
        }
        
        calendar = null;

    }

    protected Document nostd2std(Document pNoStdXml) throws Exception {
        //��־ǰ׺
        StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
                .getName()).append('_').append(NoFactory.nextAppNo())
                .append('_').append(thisBusiConf.getChildText(XmlTag.funcFlag))
                .append("_in.xml");
        //��¼�Ǳ�׼����
        SaveMessage.save(pNoStdXml, thisRootConf.getChildText(XmlTag.TranCom), mSaveName.toString());
        cLogger.info("����Ǳ�׼��������ϣ�");
        
        String tFormatClassName = thisBusiConf.getChildText(XmlTag.format);
        //����ת��ģ��
        cLogger.info((new StringBuilder("����ת��ģ�飺")).append(tFormatClassName).toString());
        Constructor tFormatConstructor = Class.forName(tFormatClassName)
        .getConstructor(new Class[] { org.jdom.Element.class });
        Format tFormat = (Format) tFormatConstructor
        .newInstance(new Object[] { thisBusiConf });
        
        return tFormat.noStd2Std(pNoStdXml);
    }

    private void downloadFile() throws Exception {
        Element transEle = thisBusiConf.getChild("transport");
        if(transEle==null){
            //û�����������ļ�
            cLogger.info("û�����������ļ��ڵ�<transport>...");
            return;
        }
        //�����ļ�
        this.trans.transport(this.getFileName());
        
    }
    protected Document sendRequest(Document tInStd) throws Exception {
        //ҵ����
        String tServiceClassName = thisBusiConf.getChildText("service");
        cLogger.debug((new StringBuilder("ҵ����ģ�飺")).append(
                tServiceClassName).toString());
        Constructor tServiceConstructor = Class.forName(tServiceClassName)
        .getConstructor(new Class[] { org.jdom.Element.class });
        Service tService = (Service) tServiceConstructor
        .newInstance(new Object[] { thisBusiConf });
        Document tOutStdXml = tService.service(tInStd);
        
        return tOutStdXml;
    }

    private byte[] readLocalFile() throws Exception {
        cLogger.error("��ȡ�ļ�....."+thisLocalDir+this.getFileName());
        FileInputStream batIs = new FileInputStream(thisLocalDir+this.getFileName());
        ByteArrayOutputStream fileBaos = new ByteArrayOutputStream();
        try{
            //��ȡ�ļ�
            byte[] b = new byte[2048];
            int length = -1;
            while ( (length = batIs.read(b)) != -1) {
                fileBaos.write(b, 0, length);
            }
            fileBaos.flush();
            return fileBaos.toByteArray();
        }catch(Exception e){
            cLogger.error("��ȡ�ļ�����.....");
            throw e;
        }finally{
            if(batIs != null){
                batIs.close();
            }
        }
    }

    
    /**
     * ������ı��ĵı�����
     * 
     * @return ������body
     */
    protected byte[] prepareFileContent(byte[] fileContent) throws Exception{
        return fileContent;
    }
    /**
     * ����ת����ı�׼���ġ�
     * </br>���ھ��󲿷����У�xslת����õ��ı�׼���ľͿ��Դ������ġ�
     * </br>�����е�������Ҫ΢�������罻ͨ���С�
     * @param body ����xslת����ı�׼����
     */
    protected Document adjustStd(Document doc) throws Exception{
        return doc;
    }
    /**
     * �������ļ���ת���ɼ���xml����
     * @param batIs
     * @return
     * @throws Exception
     */
    protected Document parseNoStd(InputStream batIs,Document doc) throws Exception{
        cLogger.info("In DownloadFileBatchService.parseNoStd()!");

        //���˼�¼�к�
        int lineNum = 0;
        Element mBody = doc.getRootElement().getChild(XmlTag.Body);
        
        //��������ļ�
        BufferedReader mBufReader = new BufferedReader(
                new InputStreamReader(batIs, fileCharset));
        for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
            cLogger.info(tLineMsg);
            
            //���У�ֱ������
            if ("".equals(tLineMsg.trim())) {
                cLogger.warn("���У�ֱ��������������һ����");
                continue;
            }
            
            //��ȡ���еĴ����
            RecordPacker p = packers.get(lineNum)==null? defaultPacker : packers.get(lineNum);
            //�������˼�¼�ֶ�
            Element tDetailEle = p.unpack(tLineMsg, fileCharset);
            //�к�
            Element tLineNumEle = new Element("LineNum");
            tLineNumEle.setText( ""+ lineNum++);
            tDetailEle.addContent(tLineNumEle);
            
            mBody.addContent(tDetailEle);
        }  
        
        cLogger.info("Out DownloadFileBatchService.parseNoStd()!");
        return doc;
    }


    /**
     * ����������ı��ĵı���ͷ
     * 
     * @return ������Head
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
     * ����Ĭ�ϲ����
     * @param packer
     */
    protected RecordPacker getDefaultRecordPacker(){
        return new FixedDelimiterPacker("\\|",'|');
    }
    
    /**
     * ��ȡ�ļ��������
     * @param packer
     */
    protected abstract FileTransportor getFileTransportor();

    /**
     * Ϊĳ�е��������Զ�������
     * @param index ����������0��ʼ 
     * @param packer
     */
    protected Map<Integer, RecordPacker> getLineRecordPacker(){
        return new HashMap<Integer, RecordPacker>();
    }
    
    /**
     * �����ļ���
     * 
     * @return �ļ���
     */
    protected abstract String getFileName();

    
    protected void bakFiles(String pFileDir) {
        cLogger.info("Into UploadFileBatchService.bakFiles()...");
        if (pFileDir == null || "".equals(pFileDir)) {
            cLogger.warn("�����ļ�Ŀ¼Ϊ�գ������б��ݲ�����");
            return;
        }
        File mDirFile = new File(pFileDir);
        if (!mDirFile.exists() || !mDirFile.isDirectory()) {
            cLogger.warn((new StringBuilder("�����ļ�Ŀ¼�����ڣ������б��ݲ�����")).append(
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
                cLogger.error(tFile.getAbsoluteFile() + "����ʧ�ܣ�", ex);
            }
        }

        cLogger.info("Out UploadFileBatchService.bakFiles()!");
    }
}
