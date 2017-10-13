package com.sinosoft.midplat.hxb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirm extends XmlSimpFormat{

	private String appNo = "";	// 返回规银行的投保单号
	
	public ContConfirm(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.noStd2Std()...");
		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);	
		
		//银行编号
		String trancom = XPath.newInstance("Head/TranCom").valueOf(mStdXml.getRootElement()) ;
		//华夏银行，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where ");
		mSqlStr.append("  proposalprtno='" + mBodyEle.getChildTextTrim(ProposalPrtNo)+"'");
		mSqlStr.append("  and OtherNo='" + mBodyEle.getChildTextTrim(ContPrtNo)+"'");
		mSqlStr.append("  and trandate=" + DateUtil.getCur8Date());
		mSqlStr.append("  and rcode=0 and Funcflag = '1501'");
		mSqlStr.append("  and trancom="+trancom);
		mSqlStr.append(" order by Maketime desc");
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
		if (mSSRS.MaxRow < 1) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		
		appNo = mBodyEle.getChildTextTrim(ProposalPrtNo);
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");

		Document mNoStdXml = null;
		Element rootEle = pStdXml.getRootElement();
		// 获取产品组合代码
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
		
		if("50015".equals(tContPlanCode)){ 
			// 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成
			// 50015: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、L12081-安邦长寿添利终身寿险（万能型）组成
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("hxb_华夏银行，进入ContConfirmOutXsl50002进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}
		//add 20150807 增加安享3号和安享5号  begin
		else if("50011".equals(tContPlanCode)){ 
			// 50011: L12068-安邦长寿安享3号年金保险、L12069-安邦附加长寿添利3号两全保险（万能型）组成
			mNoStdXml = ContConfirmOutXsl50011.newInstance().getCache().transform(pStdXml);
			cLogger.info("hxb_华夏银行，进入ContConfirmOutXsl50011进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}else if("50012".equals(tContPlanCode)){ 
			// 50012: L12070-安邦长寿安享5号年金保险、L12071-安邦附加长寿添利5号两全保险（万能型）组成
			mNoStdXml = ContConfirmOutXsl50012.newInstance().getCache().transform(pStdXml);
			cLogger.info("hxb_华夏银行，进入ContConfirmOutXsl50012进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}
		
		//add 20150807 增加安享3号和安享5号  end
		else{
			//按险种出单
			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootEle);
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("hxb_华夏银行，进入ContConfirmOutXsl进行报文转换，产品编码riskCode=[" + mainRiskCode + "]");
		}		
		
		Element mainEle = mNoStdXml.getRootElement().getChild("MAIN");
		
		Element mHeadEle = pStdXml.getRootElement().getChild(Head);
		
		if(String.valueOf(CodeDef.RCode_ERROR).equals(mHeadEle.getChildText(Flag))){	//1-交易失败
			if(appNo==null || appNo.equals("")){	// 投保单号不存在
				// do nothing...这个地方不能抛出异常，不然保单重打调用这段逻辑时，会因appNo为空抛异常，导致正常重打无法执行
			}else{
				Element appNoEle = new Element("APP");
				appNoEle.setText(appNo);
				mainEle.addContent(appNoEle);	
			}
		}
	
		if (String.valueOf(CodeDef.RCode_OK).equals(mHeadEle.getChildText(Flag))) {  //0-交易成功
			
			// 填充总行数
			List mPAGE_LISTList = XPath.selectNodes(mainEle, "//FILE_LIST/PAGE_LIST");
			for (int i = 0; i < mPAGE_LISTList.size(); i++) {
				
				Element mmPAGE_LISTListEle = (Element) mPAGE_LISTList.get(i);
                List mBKDETAILList = XPath.selectNodes(mmPAGE_LISTListEle, "Detail/BKDETAIL");
                mmPAGE_LISTListEle.getChild("DETAIL_COUNT").setText(String.valueOf(mBKDETAILList.size()));
			}
		}
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/桌面/abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
	
}
