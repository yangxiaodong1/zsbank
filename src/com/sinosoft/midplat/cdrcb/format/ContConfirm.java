package com.sinosoft.midplat.cdrcb.format;

//import java.util.List;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirm extends XmlSimpFormat {
	public ContConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		
		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//传上一步流水号，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
//		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where LogNo=" + mBodyEle.getChildText("OldLogNo");
		
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo,Makedate,Maketime from TranLog where Rcode = '0' and Funcflag = '2801' and ProposalPrtNo = '"+ mBodyEle.getChildText("ProposalPrtNo")+"' and Makedate ='"
				+ DateUtil.getCur8Date() + "' order by Maketime desc";
		
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (mSSRS.MaxRow <1) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mBodyEle.getChildText("ContPrtNo"));
		
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
		    // 50002(50015): 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048(L12081)-安邦长寿添利终身寿险（万能型）组成
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("CDRCB_成都农商银行，进入ContConfirmOutXsl50002进行报文转换");
		}
		//add by duanjz 2015-6-17 增加安享5号组合产品50012 返回  begin
		else if("50012".equals(tContPlanCode)){
		    //50012组合产品包括：L12070：安邦长寿安享5号年金保险 、L12071：安邦附加长寿添利5号两全保险（万能型）
			mNoStdXml = ContConfirmOutXsl50012.newInstance().getCache().transform(pStdXml);
			cLogger.info("CDRCB_成都农商银行，进入ContConfirmOutXsl50012进行报文转换");
		}
		//add by duanjz 2015-6-17 增加安享5号组合产品返回    end
		else{
			
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("CDRCB_成都农商银行，进入ContConfirmOutXsl进行报文转换");
		}
		
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("E:\\银保通项目\\测试报文\\50002\\测试打印模板_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:\\银保通项目\\测试报文\\50002\\测试打印模板_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
