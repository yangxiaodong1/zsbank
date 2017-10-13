package com.sinosoft.midplat.cmb.service;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.icbc.service.IcbcEdrBlcService;
import com.sinosoft.midplat.service.NewContBlc;
import com.sinosoft.midplat.service.ServiceImpl;

public class CmbNewContBlc extends ServiceImpl {

    String cThreadName;

    public CmbNewContBlc(Element pThisBusiConf) {
        super(pThisBusiConf);
    }

    public Document service(Document pInXmlDoc) {
        cLogger.info("Into CmbNewContBlc.service()...");
        try {
            cThreadName = Thread.currentThread().getName();

            // ��ȡ�µ����˱���
            Element newContBlcEle = (Element) XPath.selectSingleNode(pInXmlDoc
                    .getRootElement(), "//NewCont/TranData");
            newContBlcEle = (Element) newContBlcEle.detach();
            final Document cBusiBlcInXml = new Document(newContBlcEle);

            // �����µ������߳�
            new Thread() {
                @Override
                public void run() {
                    // TODO Auto-generated method stub
                    // ����logno
                    Thread.currentThread().setName(cThreadName);

                    // ����ͨ�ö��˷���
                    new NewContBlc(cThisBusiConf).service(cBusiBlcInXml);
                }

            }.start();

            
            // ��ȡ���˶��˱���
            Element wtBlcEle = (Element) XPath.selectSingleNode(pInXmlDoc
                    .getRootElement(), "//WT/TranData");
            wtBlcEle = (Element) wtBlcEle.detach();
            // �������˶��˽�����
            Element headEle = wtBlcEle.getChild("Head");
            headEle.getChild("FuncFlag").setText("1009");
            // ����ԭlogno
            Element fileNameEle = new Element("OldTranNo");
            fileNameEle.setText("" + cThreadName);
            headEle.addContent(fileNameEle);

            
            final Document wtInXml = new Document(wtBlcEle);

            // �������˶����߳�
            new Thread() {
                @Override
                public void run() {
                    // TODO Auto-generated method stub
                    // ����logno
                    Thread.currentThread().setName(
                            String.valueOf(NoFactory.nextTranLogNo()));

                    // ����ͨ�����˶��˷���
                    new IcbcEdrBlcService(cThisBusiConf).service(wtInXml);
                }

            }.start();

        } catch (Exception ex) {
            cLogger.error("��ֶ��˽���ʧ��", ex);
        }

        cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "���׳ɹ�");

        cLogger.info("Out CmbNewContBlc.service()!");
        return cOutXmlDoc;
    }
}
