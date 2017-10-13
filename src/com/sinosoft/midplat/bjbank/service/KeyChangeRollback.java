package com.sinosoft.midplat.bjbank.service;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Calendar;
import java.util.Date;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.lis.db.TranLogDB;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.bjbank.net.BjbankKeyCache;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class KeyChangeRollback extends ServiceImpl {
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
            //校验是否有并发冲突
            if (hasConcurrent()) {
                //其它线程正在（已经）回滚密钥
                throw new MidplatException("当天已经（正在）执行过回滚密钥！");
            }
            //记录日志，并且依赖该日志实现互斥
            cTranLogDB = insertTranLog(pInXmlDoc);

            //读取原密钥
            byte[] oldkey = null;
            FileInputStream mOldFos = null;
            try {
                mOldFos = new FileInputStream(SysInfo.cHome
                        + "key/oldBjbankKey.dat");
                if (mOldFos != null) {
                    oldkey = new byte[16];
                    IOTrans.readFull(oldkey, mOldFos);
                    cLogger.info("读取原密钥成功["+new String(oldkey)+"]");
                }
            } catch (Exception e) {
                cLogger.error("读取原密钥失败!", e);
                throw e;
            } finally {
                if (mOldFos != null) {
                    mOldFos.close();
                }
            }

            //是否存在备份文件
            if (oldkey == null) {
                throw new MidplatException("获取密钥备份文件失败！");
            }
            
            //新密钥写入密钥文件
            FileOutputStream mNewKeyFos = null;
            try {
                mNewKeyFos = new FileOutputStream(SysInfo.cHome
                        + "key/bjbankKey.dat");
                mNewKeyFos.write(oldkey);
                mNewKeyFos.flush();
                cLogger.info("回滚密钥文件成功[bjbankKey.dat]");
            } catch (Exception e) {
                cLogger.error("写新密钥失败!", e);
                throw e;
            } finally {
                if (mNewKeyFos != null) {
                    mNewKeyFos.close();
                }
            }

            // 重新加载密钥缓存
            BjbankKeyCache.newInstance().load();

            //更新日志
            cTranLogDB.setBak2(new String(oldkey));
            cTranLogDB.setRCode(CodeDef.RCode_OK);
            cTranLogDB.setRText("交易成功");
        } catch (Exception ex) {
            cLogger.error("回滚密钥失败", ex);
            if (null != cTranLogDB) {
                cTranLogDB.setRCode(CodeDef.RCode_ERROR);
                cTranLogDB.setRText("交易失败！" + ex.getMessage());
            }
        }

        if (null != cTranLogDB) { // 插入日志失败时cTranLogDB=null
            long tCurMillis = System.currentTimeMillis();
            cTranLogDB.setUsedTime((int) (tCurMillis - mStartMillis) / 1000);
            cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
            cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
            if (!cTranLogDB.update()) {
                cLogger.error("更新日志信息失败！" + cTranLogDB.mErrors.getFirstError());
            }
        }

        cLogger.info("Out KeyChangeRollback.service()!");
        return cOutXmlDoc;
    }

    /**
     * 判断是否有其他密钥更新交易也在并发执行
     * 
     * @return
     * @throws Exception
     */
    private boolean hasConcurrent() throws Exception {

        String tSqlStr2 = new StringBuilder(
                "select bak2 from TranLog where RCode in( -1, 0 ) ").append(
                " and trancom=1").append(" and TranDate =").append(
                DateUtil.getCur8Date()).append(" and FuncFlag=100").toString();

        SSRS ssrs = new SSRS();
        ssrs = new ExeSQL().execSQL(tSqlStr2);
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
        mTranLogDB.setTranCom("1");
        mTranLogDB.setNodeNo("-");
        mTranLogDB.setTranNo("-");
        mTranLogDB.setOperator("bjbank");
        mTranLogDB.setFuncFlag("100");
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
            throw new MidplatException("插入日志失败！");
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
