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
    
    //Ĭ�ϲ����
    RecordPacker defaultPacker = null;
    //�Զ�������
    Map<Integer, RecordPacker> packers = new HashMap<Integer, RecordPacker>();
    
    //����ת����
    Format format = null;
    
    //ҵ������
    Service service = null;
    
    public UploadFileBatchService(XmlConf conf, String funcFlag) {
        super(conf, funcFlag);
    }
    
    /**
     * ��ʼ��ת���ࡢ������
     * @throws Exception
     */
    private void init()throws Exception{
        // ��ȡ���������
        String tServiceClassName = thisBusiConf.getChildText("service");
        if (tServiceClassName == null && "".equals(tServiceClassName)){
            throw new Exception("�ý���û������service");
        }
        cLogger.debug("ҵ����ģ�飺"+tServiceClassName);
        // ��ʼ������
        Constructor tServiceConstructor = Class.forName(tServiceClassName)
                .getConstructor(new Class[] { org.jdom.Element.class });
        service = (Service) tServiceConstructor
                .newInstance(new Object[] { thisBusiConf });

        // ��ȡ����ת������
        String tFormatClassName = thisBusiConf.getChildText("format");
        if(tFormatClassName!=null && !"".equals(tFormatClassName)){
            //������xslת��
            cLogger.info("����ת��ģ�飺"+tFormatClassName);
            //��ʼ��ת��ģ��
            Constructor tFormatConstructor = Class.forName(tFormatClassName)
            .getConstructor(new Class[] { org.jdom.Element.class });
            this.format = (Format) tFormatConstructor
            .newInstance(new Object[] { thisBusiConf });
        }
        
        //��ʼ��Ĭ�ϴ����
        defaultPacker = getDefaultRecordPacker();
        //��ʼ���������Ի��д����
        this.packers.putAll(getLineRecordPacker());
    }
    
    @Override
    public void run() {
        Thread.currentThread().setName(
                String.valueOf(NoFactory.nextTranLogNo()));
        cLogger.debug("Into UploadFileBatchService.run()...");
        // ��ȡ�����׼����
        Element tTranData = new Element("TranData");
        //��ʼ��������
        Document tInNoStdXml = new Document(tTranData);
        //�����׼���ģ�Ĭ�ϵ��ڷǱ�׼����
        Document tInStdXml=tInNoStdXml;
        
        //����Ĭ������ʱ��
        if(calendar == null){
            this.calendar = Calendar.getInstance();
        }
        try {
            // ����ͷ
            Element tHeadEle = getHead();
            setHead(tHeadEle);
            tTranData.addContent(tHeadEle);
            // ������
            Element tBodyEle = getBody();
            tTranData.addContent(tBodyEle);
            
            // ��ʼ��ת��ģ�顢������
            init();
            
            if(format!=null){
                //���������xslת������ô�͵���ת��
                //����Ǳ�׼����
                StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
                        .getName()).append('_').append(NoFactory.nextAppNo()).append(
                        '_').append(thisBusiConf.getChildText(XmlTag.funcFlag)).append("_in.xml");
                SaveMessage
                .save(tInNoStdXml, thisRootConf.getChildText(XmlTag.TranCom), mSaveName.toString());
                cLogger.info("����Ǳ�׼������ϣ�" + mSaveName);
                
                //����׼����ת���ɷǱ�׼����
                tInStdXml = format.noStd2Std(tInNoStdXml);
            }
            
            //����ҵ�����߼�
            Document tOutStdXml = service.service(tInStdXml);
            String tFlag =XPath.newInstance("//Head/Flag").valueOf(tOutStdXml.getRootElement());
            resultMsg =XPath.newInstance("//Head/Desc").valueOf(tOutStdXml.getRootElement());
            if ( !"0".equals(tFlag)){
                //����service����
                throw new MidplatException("ִ��service����"+resultMsg);
            }
            
            if(format !=null ){
                //���������xslת������ô�͵���ת��
                //����׼����ת���ɷǱ�׼����
                tOutStdXml = format.std2NoStd(tOutStdXml);
                
                //����Ǳ�׼����
                StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
                        .getName()).append('_').append(NoFactory.nextAppNo()).append(
                        '_').append(thisBusiConf.getChildText(XmlTag.funcFlag)).append("_out.xml");
                SaveMessage
                        .save(tOutStdXml, thisRootConf.getChildText(XmlTag.TranCom), mSaveName.toString());
                cLogger.info("����Ǳ�׼������ϣ�" + mSaveName);
            }
            
            //�������ر���
            tOutStdXml = adjustOutXml(tOutStdXml);
            
            /* 
             *������Ӧ���ģ����û������xslת��ģ�飬��ô�����ľ��Ǳ�׼���ģ�
             *���������ת��ģ�飬��ô�������ǷǱ�׼����
            */
            cLogger.debug("�������ĵķ��ر���....");
            String fileContent = parse(tOutStdXml);

            // �����ļ�
            cLogger.debug("�����ļ�....");
            byte[] content = prepareFileContent(fileContent);
            saveFile(content);

            //���ô���
            postProcess();
            
            // ftp�ϴ��ļ�
            ftpFile();

        } catch (Exception e) {
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
        cLogger.debug("Out UploadFileBatchService.run()!");

    }
    
    /**
     * ������ı��ĵı�����
     * 
     * @return ������body
     */
    protected byte[] prepareFileContent(String fileContent) throws Exception{
        return fileContent.getBytes(fileCharset);
    }
    
    /**
     * ��ȡ�ļ��������
     * @param packer
     */
    protected FileTransportor getFileTransportor(){
        return null;
    }
    
    /**
     * �������ģ�����ת�����ļ���ʽ���ַ�����
     * ���û������xslת��ģ�飬��ô�����ľ��Ǳ�׼���ģ�
     * ���������ת��ģ�飬��ô�������ǷǱ�׼����;
     * @param tOutNoStdXml
     * @return �����ļ���ʽ���ַ���
     */
    protected String parse(Document tOutNoStdXml) throws Exception{
        StringBuffer content = new StringBuffer();
            // ��������
        List<Element> tDetailList = XPath.selectNodes(tOutNoStdXml
                .getRootElement(), "//Body/Detail");

        cLogger.debug("��Ҫת���ļ�¼��" + tDetailList.size());
        int i = 0;
        //����ÿ��detail�ڵ�
        for (Element tDetailEle : tDetailList) {
            //��ȡ���еĴ����
            RecordPacker p = packers.get(i)==null? defaultPacker : packers.get(i);
            //�����¼
            String c = p.pack(tDetailEle, null);
            cLogger.debug("������¼��" + c);
            content.append(c);
            i++;
        }
        return content.toString();
    }

    private void saveFile(byte[] content) throws Exception {
        BufferedOutputStream out = null;
        BufferedInputStream in = null;
        try {
            // ��ȡ�ļ�
            in = new BufferedInputStream(new ByteArrayInputStream(content));
            out = new BufferedOutputStream(new FileOutputStream(thisLocalDir
                    + getFileName()));
            // �����ļ�
            int len = -1;
            byte[] buffer = new byte[5 * 1024];
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
            out.flush();
        } finally {
            // �ر��ļ�
            if (in != null) {
                in.close();
            }
            if (out != null) {
                out.close();
            }
        }
    }

    /**
     * ������ı��ĵı�����
     * 
     * @return ������body
     * @throws Exception 
     */
    protected Element getBody() throws Exception {
        Element mBodyEle = new Element(XmlTag.Body);
        setBody(mBodyEle);
        return mBodyEle;
    }

    /**
     * ���ú��ı��ĵı�����
     * 
     * @return ������body
     */
    protected abstract void setBody(Element mBodyEle) throws Exception;

    /**
     * ����������ı��ĵı���ͷ
     * 
     * @return ������Head
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

    /**
     * ���ô��������÷��������ɱ��ط�������á�
     * һ����������ļ�����Ҫ������Ի����������ʵ�ָ÷�����
     * @return
     * @throws Exception
     */
    protected boolean postProcess()throws Exception{
        return true;
    }

    /**
     * ���ô��������÷��������ɱ��ط�������á�
     * һ����������ļ�����Ҫ������Ի����������ʵ�ָ÷�����
     * @return
     * @throws Exception
     */
    protected void ftpFile()throws Exception{
        //����ftp�ϴ��ļ�
        Element ftpElement = thisBusiConf.getChild("ftp");
        if(ftpElement==null){
            cLogger.debug("δ����ftp��Ϣ...");
        }else{
            //������ftp�ϴ�
            FileTransportor t = new FtpUploadTransportor(thisBusiConf);
            t.transport(getFtpName());
        }
        
        //�Զ��巽ʽ�ϴ��ļ�
        Element transEle = thisBusiConf.getChild("transport");
        if(transEle==null){
            //û�����������ļ�
            cLogger.info("û�������ļ���������ڵ�<transport>...");
        }else{
            //�Զ��崫��
            FileTransportor t = this.getFileTransportor();
            t.transport(getFtpName());
        }
        return;
    }
    /**
     * �����ļ����ļ���
     * 
     * @return �ļ���
     */
    protected abstract String getFileName();

    /**
     * ftp�ļ���
     * 
     * @return �ļ���
     */
    protected String getFtpName(){
        return getFileName();
    }
    
    protected abstract void setHead(Element head);
    
    
    /**
     * ����Ĭ�ϲ����
     * @param packer
     */
    protected RecordPacker getDefaultRecordPacker(){
        return new FixedDelimiterPacker("\\|",'|');
    }

    /**
     * Ϊĳ�е��������Զ�������
     * @param index ����������0��ʼ 
     * @param packer
     */
    protected Map<Integer, RecordPacker> getLineRecordPacker(){
        return new HashMap<Integer, RecordPacker>();
    }
    
    /**
     * ����ת����ı��ġ�
     * @param noStdXml ת����ı���
     */
    protected Document adjustOutXml(Document outXml) throws Exception{
    	return outXml;
    }
}
