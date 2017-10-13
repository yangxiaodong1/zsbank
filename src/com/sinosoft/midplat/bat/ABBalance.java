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
 * �����������׸��ࡣ����ͨ��xsl��ʽ���������ļ�ת���ɱ�׼���ĵġ�
 * @author ab033862
 * Jun 12, 2014
 */
public abstract class ABBalance extends Balance {
    
    //Ĭ�ϲ����
    RecordPacker defaultPacker = null;
    //�Զ�������
    Map<Integer, RecordPacker> packers = null;
    
    public ABBalance(XmlConf thisConf, int funcFlag) {
        this(thisConf, funcFlag+"");
    }

    public ABBalance(XmlConf thisConf, String funcFlag) {
        super(thisConf, funcFlag);
        //��ʼ��Ĭ�ϴ����
        defaultPacker = getDefaultRecordPacker();
        //��ʼ���������Ի��д����
        packers = getLineRecordPacker();
    }

    @Override
    protected Element parse(InputStream batIs) throws Exception {
        // TODO Auto-generated method stub
        cLogger.info("Into ABBalance.parse()...");

        cLogger.info("begin to read file...");
        ByteArrayOutputStream fileBaos = new ByteArrayOutputStream();
        try{
            //��ȡ�ļ�
            byte[] b = new byte[2048];
            int length = -1;
            while ( (length = batIs.read(b)) != -1) {
                fileBaos.write(b, 0, length);
            }
            fileBaos.flush();
        }catch(Exception e){
            cLogger.error("��ȡ�ļ�����.....");
            throw e;
        }finally{
            if(batIs != null){
                batIs.close();
            }
        }

        //�������ļ�������xml
        Document pNoStdXml = null;
        try{
            cLogger.info("prepare the file content...");
            //����װ�������������⴦��
            byte[] content = prepareFileContent(fileBaos.toByteArray());
            
            cLogger.info("convert the file to xml...");
            //������������ת����xml
            pNoStdXml = parseNoStd(new ByteArrayInputStream(content));
            
            //��־ǰ׺
            StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
                    .getName()).append('_').append(NoFactory.nextAppNo())
                    .append('_').append(cThisBusiConf.getChildText(funcFlag))
                    .append("_in.xml");
            //��¼�Ǳ�׼����
            SaveMessage.save(pNoStdXml, cThisConfRoot.getChildText(TranCom), mSaveName.toString());
            cLogger.info("����Ǳ�׼��������ϣ�");
        }catch(Exception e){
            cLogger.error("�����ļ�����.....");
            throw e;
        }

        String tFormatClassName = cThisBusiConf.getChildText("format");
        //����ת��ģ��
        cLogger.info((new StringBuilder("����ת��ģ�飺")).append(tFormatClassName).toString());
        Constructor tFormatConstructor = Class.forName(tFormatClassName)
                .getConstructor(new Class[] { org.jdom.Element.class });
        Format tFormat = (Format) tFormatConstructor
                .newInstance(new Object[] { cThisBusiConf });
        //��xmlת���ɱ�׼����
        cLogger.info("convert nonstandard xml to standard xml...");
        Document pstd = tFormat.noStd2Std(pNoStdXml);
        
        //ȡ����׼���ĵ�body�ڵ�
        Element mBody = pstd.getRootElement().getChild(Body);
        mBody.detach();
        
        //����һ�����ӣ�����΢����׼����
        mBody = adjustBody(mBody);
        
        return mBody;
    }

    /**
     * �������ļ���ת���ɼ���xml����
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
        //��ʼ��xml����
        Element mHead = getHead();
        Element mBody = new Element(Body);
        
        Element mTranData = new Element(TranData);
        mTranData.addContent(mHead);
        mTranData.addContent(mBody);
        
        Document doc = new Document(mTranData);
        
        //���˼�¼�к�
        int lineNum = 0;
        
        //��������ļ�
        BufferedReader mBufReader = new BufferedReader(
                new InputStreamReader(batIs, mCharset));
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
            Element tDetailEle = p.unpack(tLineMsg, mCharset);
            //�к�
            Element tLineNumEle = new Element("LineNum");
            tLineNumEle.setText( ""+ lineNum++);
            tDetailEle.addContent(tLineNumEle);
            
            mBody.addContent(tDetailEle);
        }  
        
        cLogger.info("Out ABBalance.parseNoStd()!");
        return doc;
    }
    
    /**
     * Ϊ�ļ�������װ�������������⴦��������ܡ�
     * @param in ԭ�ļ���
     * @return
     * @throws Exception
     */
    protected byte[] prepareFileContent( byte[] in )throws Exception{
        return in;
    }
    
    /**
     * ����ת����ı�׼���ġ�
     * </br>���ھ��󲿷����У�xslת����õ��ı�׼���ľͿ��Դ������ġ�
     * </br>�����е�������Ҫ΢�������罻ͨ���С�
     * @param body ����xslת����ı�׼����
     */
    protected Element adjustBody(Element body) throws Exception{
        return body;
    }

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

    @Override
    protected String getFileName() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    protected Element getHead() {
        Element mHead = super.getHead();
        //�����������ͣ�����ϵͳͨ���˱�ǩ�ж���������
        Element mBankCode = new Element("BankCode");
        mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
        mHead.addContent(mBankCode);
        return setHead(mHead);
    }
    
    /**
     * ���ñ�׼����ͷ�����һЩ�Զ����ǩ��������չ����
     * <br>���ĳ�����˽�����Ҫ���һЩ�����ǩ����ô����overrider�˷�����
     * @param head ��׼����ͷ��㣬�˽���Ѿ������һЩ������ǩ
     * @return ������ı�׼����ͷ��㣬�˽ڵ㽫�����ڱ�׼������
     */
    protected Element setHead(Element head) {
        return head;
    }
    
    
}
