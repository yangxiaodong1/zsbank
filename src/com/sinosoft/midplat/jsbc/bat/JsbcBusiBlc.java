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
     * 0017    ���չ�˾���
                20150422  ����
                01   ��ˮ�� ����ʱ�����ģ�

     */
    protected String getFileName() {
        Element mBankEle = cThisConfRoot.getChild("bank");
        return  mBankEle.getAttributeValue("insu") 
                + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + "01.xml";
    }
    
    /**
     * ����Ĭ�ϲ����
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
    public Document parseNoStd(InputStream batIs) throws Exception{
        cLogger.info("In JsbcBusiBlc.parseNoStd()!");
        
        
        //��������ļ�
        Document mXmlDoc = JdomUtil.build(batIs);
        //��ʼ��xml����
        Element mHead = getHead();
        
        mXmlDoc.getRootElement().addContent(mHead);
        
        cLogger.info("Out JsbcBusiBlc.parseNoStd()!");
        return mXmlDoc;
    }
    
    
}
