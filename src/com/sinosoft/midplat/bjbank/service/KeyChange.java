package com.sinosoft.midplat.bjbank.service;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Date;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.lis.db.TranLogDB;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.bjbank.net.BjbankKeyCache;
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
			String tDesKey = XPath.newInstance("/TranData/DesInfo/DesKey").valueOf(pInXmlDoc.getRootElement());
//			String tDesKey = pInXmlDoc.getRootElement().getChildText("DesKey");
			if(16 != tDesKey.length()) {
				throw new MidplatException("密钥长度不是16！" + tDesKey);
			}
			
			//读取当前密钥（原密钥）
            byte[] oldkey = new byte[16];
            FileInputStream mOldFos = null;
            try{
                mOldFos = new FileInputStream(SysInfo.cHome
                        + "key/bjbankKey.dat");
                IOTrans.readFull(oldkey, mOldFos);
                cLogger.info("读取原密钥成功["+new String(oldkey)+"]");
            }catch(Exception e){
                cLogger.error("读取原密钥失败!",e);
            }finally{
                if(mOldFos != null){
                    mOldFos.close();
                }
            }

            //备份密钥文件
            FileOutputStream mKeyFos = null;
            try{
                mKeyFos = new FileOutputStream(SysInfo.cHome + "key/oldBjbankKey.dat");
                mKeyFos.write(oldkey);
                mKeyFos.flush();
                cLogger.info("备份密钥文件成功[oldBjbankKey.dat]");
            }catch(Exception e){
                cLogger.error("备份密钥失败!",e);
            }finally{
                if(mKeyFos != null){
                    mKeyFos.close();
                }
            }
	        
            //新密钥写入密钥文件
            FileOutputStream mNewKeyFos = null;
            try{
                mNewKeyFos = new FileOutputStream(SysInfo.cHome + "key/bjbankKey.dat");
                mNewKeyFos.write(tDesKey.getBytes());
                mNewKeyFos.flush();
                cLogger.info("写新密钥文件成功[bjbankKey.dat]");
            }catch(Exception e){
                cLogger.info("写新密钥失败!",e);
                throw e;
            }finally{
                if(mNewKeyFos != null){
                    mNewKeyFos.close();
                }
            }
			
			//重新加载密钥缓存
			BjbankKeyCache.newInstance().load();
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "交易成功");
			
			cTranLogDB.setBak2(tDesKey);
		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"交易失败！", ex);
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
		}
		
		
		if (null != cTranLogDB) {	//插入日志失败时cTranLogDB=null
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("更新日志信息失败！" + cTranLogDB.mErrors.getFirstError());
			}
		}
		//
		Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
		String cFlag = tHeadEle.getChildText(Flag);
		if("0".equals(cFlag)){
			cFlag = "1";
		}else {
			cFlag = "0";
		}
		tHeadEle.getChild(Flag).setText(cFlag);
		cOutXmlDoc.getRootElement().getChild(Head).setName("RetData");
		cLogger.info("Out KeyChange.service()!");
		return cOutXmlDoc;
	}
	
	protected TranLogDB insertTranLog(Document pXmlDoc) throws MidplatException {
		cLogger.debug("Into KeyChange.insertTranLog()...");
		
		Element mRootEle = pXmlDoc.getRootElement();
		Element mHeadEle = mRootEle.getChild(Head);
		Element mBaseInfoEle = mRootEle.getChild("BaseInfo");
		
		TranLogDB mTranLogDB = new TranLogDB();
		mTranLogDB.setLogNo(Thread.currentThread().getName());
		mTranLogDB.setTranCom(mHeadEle.getChildText(TranCom));
		mTranLogDB.setNodeNo("-");
		mTranLogDB.setTranNo(mBaseInfoEle.getChildText("TransrNo"));
		mTranLogDB.setOperator("bjbank");
		mTranLogDB.setFuncFlag(mHeadEle.getChildText(FuncFlag));
		mTranLogDB.setTranDate(DateUtil.date10to8(mBaseInfoEle.getChildText("BankDate")));
		mTranLogDB.setTranTime(DateUtil.time8to6(DateUtil.getCur8Time()));
		mTranLogDB.setRCode(CodeDef.RCode_NULL);
		mTranLogDB.setUsedTime(-1);
		mTranLogDB.setBak1(mHeadEle.getChildText(ClientIp));
		Date mCurDate = new Date();
		mTranLogDB.setMakeDate(DateUtil.get8Date(mCurDate));
		mTranLogDB.setMakeTime(DateUtil.get6Time(mCurDate));
		mTranLogDB.setModifyDate(mTranLogDB.getMakeDate());
		mTranLogDB.setModifyTime(mTranLogDB.getMakeTime());
		if (!mTranLogDB.insert()) {
			cLogger.error(mTranLogDB.mErrors.getFirstError());
			throw new MidplatException("插入日志失败！");
		}
		
		cLogger.debug("Out KeyChange.insertTranLog()!");
		return mTranLogDB;
	}
}
