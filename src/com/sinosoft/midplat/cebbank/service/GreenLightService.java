/**
 * 
 */
package com.sinosoft.midplat.cebbank.service;

import java.util.Date;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.lis.db.TranLogDB;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.service.ServiceImpl;

/**
 * @author AB039365
 *
 */
public class GreenLightService extends ServiceImpl {

	public GreenLightService(Element thisBusiConf) {
		super(thisBusiConf);
	}

	public Document service(Document pInXmlDoc) throws Exception {
		cLogger.info("Into GreenLightService.service()...");
		long mStartMillis = System.currentTimeMillis();
		cInXmlDoc = pInXmlDoc;
		
		String mReMark = cInXmlDoc.getRootElement().getChild("Body").getChild("ReMark").getText();
		try {
		    //绿灯交易光大不传
		    cInXmlDoc.getRootElement().getChild("Head").getChild("ZoneNo").setText("38001");
		    cInXmlDoc.getRootElement().getChild("Head").getChild("NodeNo").setText("38001");
		    cInXmlDoc.getRootElement().getChild("Head").getChild("TellerNo").setText("sys");
			cTranLogDB = insertTranLog(cInXmlDoc);
			
			int ZoneNo = Integer.valueOf(cInXmlDoc.getRootElement().getChild("Head").getChild("ZoneNo").getText());
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(0, "交易成功！");
			
		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"交易失败！", ex);
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
		}
		Element reMark = new Element("ReMark");
		reMark.addContent(mReMark);
		Element mBody = new Element("Body");
		mBody.addContent(reMark);
		cOutXmlDoc.getRootElement().addContent(mBody);
		
		if (null != cTranLogDB) {	//插入日志失败时cTranLogDB=null
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));	//-1-未返回；0-交易成功，返回；1-交易失败，返回
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("更新日志信息失败！" + cTranLogDB.mErrors.getFirstError());
			}
		}
		
		cLogger.info("Out GreenLightService.service()...");
		return cOutXmlDoc;
	}

	
	protected TranLogDB insertTranLog(Document pXmlDoc) throws MidplatException {
	    this.cLogger.debug("Into GreenLightService.insertTranLog()...");

	    Element mTranDataEle = pXmlDoc.getRootElement();
	    Element mHeadEle = mTranDataEle.getChild("Head");
	    Element mBodyEle = mTranDataEle.getChild("Body");

	    TranLogDB mTranLogDB = new TranLogDB();
	    mTranLogDB.setLogNo(Thread.currentThread().getName());
	    mTranLogDB.setTranCom(mHeadEle.getChildText("TranCom"));
	    mTranLogDB.setNodeNo(mHeadEle.getChildText("NodeNo"));
	    mTranLogDB.setTranNo(mHeadEle.getChildText("TranNo"));
	    mTranLogDB.setOperator(mHeadEle.getChildText("TellerNo"));
	    mTranLogDB.setFuncFlag(mHeadEle.getChildText("FuncFlag"));
	    mTranLogDB.setTranDate(mHeadEle.getChildText("TranDate"));
	    mTranLogDB.setTranTime(mHeadEle.getChildText("TranTime"));

	    mTranLogDB.setRCode(-1);
	    mTranLogDB.setUsedTime(-1);
	    Date mCurDate = new Date();
	    mTranLogDB.setMakeDate(DateUtil.get8Date(mCurDate));
	    mTranLogDB.setMakeTime(DateUtil.get6Time(mCurDate));
	    mTranLogDB.setModifyDate(mTranLogDB.getMakeDate());
	    mTranLogDB.setModifyTime(mTranLogDB.getMakeTime());
	    if (!(mTranLogDB.insert())) {
	      this.cLogger.error(mTranLogDB.mErrors.getFirstError());
	      throw new MidplatException("插入日志失败！");
	    }

	    this.cLogger.debug("Out GreenLightService.insertTranLog()!");
	    return mTranLogDB;
	  }
	
	

}
