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

            // 获取新单对账报文
            Element newContBlcEle = (Element) XPath.selectSingleNode(pInXmlDoc
                    .getRootElement(), "//NewCont/TranData");
            newContBlcEle = (Element) newContBlcEle.detach();
            final Document cBusiBlcInXml = new Document(newContBlcEle);

            // 启动新单对账线程
            new Thread() {
                @Override
                public void run() {
                    // TODO Auto-generated method stub
                    // 设置logno
                    Thread.currentThread().setName(cThreadName);

                    // 调用通用对账服务
                    new NewContBlc(cThisBusiConf).service(cBusiBlcInXml);
                }

            }.start();

            
            // 获取犹退对账报文
            Element wtBlcEle = (Element) XPath.selectSingleNode(pInXmlDoc
                    .getRootElement(), "//WT/TranData");
            wtBlcEle = (Element) wtBlcEle.detach();
            // 设置犹退对账交易码
            Element headEle = wtBlcEle.getChild("Head");
            headEle.getChild("FuncFlag").setText("1009");
            // 保存原logno
            Element fileNameEle = new Element("OldTranNo");
            fileNameEle.setText("" + cThreadName);
            headEle.addContent(fileNameEle);

            
            final Document wtInXml = new Document(wtBlcEle);

            // 启动犹退对账线程
            new Thread() {
                @Override
                public void run() {
                    // TODO Auto-generated method stub
                    // 设置logno
                    Thread.currentThread().setName(
                            String.valueOf(NoFactory.nextTranLogNo()));

                    // 调用通用犹退对账服务
                    new IcbcEdrBlcService(cThisBusiConf).service(wtInXml);
                }

            }.start();

        } catch (Exception ex) {
            cLogger.error("拆分对账交易失败", ex);
        }

        cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "交易成功");

        cLogger.info("Out CmbNewContBlc.service()!");
        return cOutXmlDoc;
    }
}
