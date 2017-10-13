package com.sinosoft.midplat.cgb.service;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Calendar;
import java.util.Date;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.lis.db.TranLogDB;
import com.sinosoft.midplat.cgb.net.CgbKeyCache;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class KeyChangeRollback extends ServiceImpl {
    private static String FUNC_FLAG = "2207";
    public KeyChangeRollback(Element pThisBusiConf) {
        super(pThisBusiConf);
    }

    public KeyChangeRollback() {
        this(null);
    }

    public Document service(Document pInXmlDoc) {
        long mStartMillis = System.currentTimeMillis();
        cLogger.info("Into KeyChangeRollback.service()...");
        cInXmlDoc = pInXmlDoc;

        try {
            //У���Ƿ��в�����ͻ
            if (hasConcurrent()) {
                //�����߳����ڣ��Ѿ����ع���Կ
                throw new MidplatException("�����Ѿ������ڣ�ִ�й��ع���Կ��");
            }
            //��¼��־��������������־ʵ�ֻ���
            cTranLogDB = insertTranLog(pInXmlDoc);

            //��ȡԭ��Կ
            byte[] oldkey = null;
            FileInputStream mOldFos = null;
            try {
                mOldFos = new FileInputStream(SysInfo.cHome
                        + "key/oldCgbKey.dat");
                if (mOldFos != null) {
                    oldkey = new byte[16];
                    IOTrans.readFull(oldkey, mOldFos);
                    cLogger.info("��ȡԭ��Կ�ɹ�["+new String(oldkey)+"]");
                }
            } catch (Exception e) {
                cLogger.error("��ȡԭ��Կʧ��!", e);
                throw e;
            } finally {
                if (mOldFos != null) {
                    mOldFos.close();
                }
            }

            //�Ƿ���ڱ����ļ�
            if (oldkey == null) {
                throw new MidplatException("��ȡ��Կ�����ļ�ʧ�ܣ�");
            }
            
            //����Կд����Կ�ļ�
            FileOutputStream mNewKeyFos = null;
            try {
                mNewKeyFos = new FileOutputStream(SysInfo.cHome
                        + "key/cgbKey.dat");
                mNewKeyFos.write(oldkey);
                mNewKeyFos.flush();
                cLogger.info("�ع���Կ�ļ��ɹ�[cgbKey.dat]");
            } catch (Exception e) {
                cLogger.error("д����Կʧ��!", e);
                throw e;
            } finally {
                if (mNewKeyFos != null) {
                    mNewKeyFos.close();
                }
            }

            // ���¼�����Կ����
            CgbKeyCache.newInstance().load();

            //������־
            cTranLogDB.setBak2(new String(oldkey));
            cTranLogDB.setRCode(CodeDef.RCode_OK);
            cTranLogDB.setRText("���׳ɹ�");
        } catch (Exception ex) {
            cLogger.error("�ع���Կʧ��", ex);
            if (null != cTranLogDB) {
                cTranLogDB.setRCode(CodeDef.RCode_ERROR);
                cTranLogDB.setRText("����ʧ�ܣ�" + ex.getMessage());
            }
        }

        if (null != cTranLogDB) { // ������־ʧ��ʱcTranLogDB=null
            long tCurMillis = System.currentTimeMillis();
            cTranLogDB.setUsedTime((int) (tCurMillis - mStartMillis) / 1000);
            cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
            cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
            if (!cTranLogDB.update()) {
                cLogger.error("������־��Ϣʧ�ܣ�" + cTranLogDB.mErrors.getFirstError());
            }
        }

        cLogger.info("Out KeyChangeRollback.service()!");
        return cOutXmlDoc;
    }

    /**
     * �ж��Ƿ���������Կ���½���Ҳ�ڲ���ִ��
     * 
     * @return
     * @throws Exception
     */
    private boolean hasConcurrent() throws Exception {
        StringBuffer tSqlStr2 = new StringBuffer();
        tSqlStr2.append("select bak2 from TranLog where RCode in( -1, 0 ) ");
        tSqlStr2.append(" and trancom="+cThisBusiConf.getChildText(XmlTag.TranCom));
        tSqlStr2.append(" and TranDate ="+ DateUtil.getCur8Date());
        tSqlStr2.append(" and FuncFlag="+FUNC_FLAG);

        SSRS ssrs = new SSRS();
        ssrs = new ExeSQL().execSQL(tSqlStr2.toString());
        if (ssrs.MaxRow > 0) {
            return true;
        } else {
            return false;
        }
    }

    protected TranLogDB insertTranLog(Document pXmlDoc) throws MidplatException {
        cLogger.debug("Into KeyChangeRollback.insertTranLog()...");

        TranLogDB mTranLogDB = new TranLogDB();
        mTranLogDB.setLogNo(Thread.currentThread().getName());
        mTranLogDB.setTranCom(cThisBusiConf.getChildText(XmlTag.TranCom));
        mTranLogDB.setNodeNo("-");
        mTranLogDB.setTranNo("-");
        mTranLogDB.setOperator("cgb");
        mTranLogDB.setFuncFlag(FUNC_FLAG);
        mTranLogDB.setBak1("ִ����Կ�ع�");
        mTranLogDB.setTranDate(DateUtil.getCur8Date());
        mTranLogDB.setTranTime(DateUtil.getCur6Time());
        mTranLogDB.setRCode(CodeDef.RCode_NULL);
        mTranLogDB.setUsedTime(-1);
        Date mCurDate = new Date();
        mTranLogDB.setMakeDate(DateUtil.get8Date(mCurDate));
        mTranLogDB.setMakeTime(DateUtil.get6Time(mCurDate));
        mTranLogDB.setModifyDate(mTranLogDB.getMakeDate());
        mTranLogDB.setModifyTime(mTranLogDB.getMakeTime());
        if (!mTranLogDB.insert()) {
            cLogger.error(mTranLogDB.mErrors.getFirstError());
            throw new MidplatException("������־ʧ�ܣ�");
        }

        cLogger.debug("Out KeyChangeRollback.insertTranLog()!");
        return mTranLogDB;
    }

    public static void main(String[] args) {
        Calendar mCurCalendar = Calendar.getInstance();
        mCurCalendar.add(Calendar.DAY_OF_MONTH, -2);

        System.out.println(DateUtil.get8Date(mCurCalendar));
    }
}
