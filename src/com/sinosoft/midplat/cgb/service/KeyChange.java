package com.sinosoft.midplat.cgb.service;

import java.io.FileInputStream;
import java.io.FileOutputStream;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.cgb.net.CgbKeyCache;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.service.ServiceImpl;

public class KeyChange extends ServiceImpl {
	public KeyChange(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document pInXmlDoc) {
		long mStartMillis = System.currentTimeMillis();
		cLogger.info("Into KeyChange.service()...");
		cInXmlDoc = pInXmlDoc;
		
		try {
			cTranLogDB = insertTranLog(pInXmlDoc);
			
			String tDesKey = XPath.newInstance("//DesKey").valueOf(pInXmlDoc.getRootElement());
			if(16 != tDesKey.length()) {
				throw new MidplatException("��Կ���Ȳ���16��" + tDesKey);
			}
			
			//��ȡ��ǰ��Կ��ԭ��Կ��
            byte[] oldkey = new byte[16];
            FileInputStream mOldFos = null;
            try{
                mOldFos = new FileInputStream(SysInfo.cHome
                        + "key/cgbKey.dat");
                IOTrans.readFull(oldkey, mOldFos);
                cLogger.info("��ȡԭ��Կ�ɹ�["+new String(oldkey)+"]");
            }catch(Exception e){
                cLogger.error("��ȡԭ��Կʧ��!",e);
            }finally{
                if(mOldFos != null){
                    mOldFos.close();
                }
            }

            //������Կ�ļ�
            FileOutputStream mKeyFos = null;
            try{
                mKeyFos = new FileOutputStream(SysInfo.cHome + "key/oldCgbKey.dat");
                mKeyFos.write(oldkey);
                mKeyFos.flush();
                cLogger.info("������Կ�ļ��ɹ�[oldCgbKey.dat]");
            }catch(Exception e){
                cLogger.error("������Կʧ��!",e);
            }finally{
                if(mKeyFos != null){
                    mKeyFos.close();
                }
            }
	        
            //����Կд����Կ�ļ�
            FileOutputStream mNewKeyFos = null;
            try{
                mNewKeyFos = new FileOutputStream(SysInfo.cHome + "key/cgbKey.dat");
                mNewKeyFos.write(tDesKey.getBytes());
                mNewKeyFos.flush();
                cLogger.info("д����Կ�ļ��ɹ�[cgbKey.dat]");
            }catch(Exception e){
                cLogger.info("д����Կʧ��!",e);
                throw e;
            }finally{
                if(mNewKeyFos != null){
                    mNewKeyFos.close();
                }
            }
			
			//���¼�����Կ����
			CgbKeyCache.newInstance().load();
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "���׳ɹ�");
			cTranLogDB.setBak2(tDesKey);
		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"����ʧ�ܣ�", ex);
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
		}
		
		if (null != cTranLogDB) {	//������־ʧ��ʱcTranLogDB=null
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("������־��Ϣʧ�ܣ�" + cTranLogDB.mErrors.getFirstError());
			}
		}
		
		cLogger.info("Out KeyChange.service()!");
		return cOutXmlDoc;
	}
	
}
