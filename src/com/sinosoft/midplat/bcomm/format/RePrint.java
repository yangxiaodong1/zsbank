package com.sinosoft.midplat.bcomm.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.bcomm.format.ContConfirm;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class RePrint extends XmlSimpFormat{

	public RePrint(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	/* 
	 * 将银行传递的非标准报文转化为标准报文
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into RePrint.noStd2Std()...");
		
		Document mStdXml =RePrintInXsl.newInstance().getCache().transform(pNoStdXml);
		
		Element mHead = mStdXml.getRootElement().getChild(Head);
		// 交通银行传contno，我方从tranlog表中中查出成功承保的保单数据;	交通银行收费签单,FuncFlag=1402
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo from TranLog where FuncFlag = '1402' and ContNo = '"
			+ mBodyEle.getChildText(ContNo)
			+ "' and trandate="
			+ mHead.getChildText(TranDate)
			+ " and trancom="
			+ mHead.getChildText(TranCom)
			+ " and rcode=0";
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		
		cLogger.info("Out RePrint.noStd2Std()!");
		return mStdXml;
	}
	
	/* 
	 * 将核心传递的标准报文转换为银行的非标准报文
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into RePrint.std2NoStd()...");
		
		//重打和新单返回报文基本完全一样，所以直接调用
		ContConfirm mContConfirm = new ContConfirm(cThisBusiConf);
		Document mNoStdXml = mContConfirm.std2NoStd(pStdXml);
		
		cLogger.info("Out RePrint.std2NoStd()!");
		return mNoStdXml;
	}
	
	
	public static void main(String[] args){
		
	}
}


