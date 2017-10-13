package com.sinosoft.midplat.citic.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

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
		
		//中信银行传上一步流水号，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where LogNo=" + mBodyEle.getChildText("OldLogNo");
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}
	
	@SuppressWarnings("unchecked")
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		
		Document mNoStdXml = null;
		
		//获取产品组合代码
        String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());

		if(null == tContPlanCode || "".equals(tContPlanCode)){	// 不是产品组合的返回报文
			
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("CITIC_中信银行，ContConfirmOutXsl进行报文转换(非产品组合)");
		}else if("50015".equals(tContPlanCode)){	// 是产品组合返回的报文,产品已从50002升级为50015
//			JdomUtil.print(pStdXml);
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("CITIC_中信银行，进入ContConfirmOutXsl50002进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}else if("50006".equals(tContPlanCode)){ 
		    // 50006: 长寿智赢1号年金保险计划
		    mNoStdXml = ContConfirmOutXsl50006.newInstance().getCache().transform(pStdXml);
		    cLogger.info("CITIC_中信银行，进入ContConfirmOutXsl50006进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}
		//add by duanjz 2015-6-17 增加 安邦长寿安享5号保险计划50012   begin
		else if("50012".equals(tContPlanCode)){ 
		    //50012: 安邦长寿安享5号保险计划
		    mNoStdXml = ContConfirmOutXsl50012.newInstance().getCache().transform(pStdXml);
		    cLogger.info("CITIC_中信银行，进入ContConfirmOutXsl50012进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}
		//add by duanjz 2015-6-17 增加 安邦长寿安享5号保险计划50012   end
		//add by duanjz 2015-10-20 增加 安邦长寿安享3号保险计划50011   begin
		else if("50011".equals(tContPlanCode)){ 
		    //50011: 安邦长寿安享3号保险计划
		    mNoStdXml = ContConfirmOutXsl50011.newInstance().getCache().transform(pStdXml);
		    cLogger.info("CITIC_中信银行，进入ContConfirmOutXsl50011进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}
		//add by duanjz 2015-10-20 增加 安邦长寿安享5号保险计划50012   end
		
		List<Element> mDetail_list = mNoStdXml.getRootElement().getChild("Transaction_Body").getChildren("Detail_List");
		for (Element e : mDetail_list) {
			Element tDetail = e.getChild(Detail);
			Element tBkRecNum = e.getChild("BkRecNum");
			List<Element> tBkDetail1 = tDetail.getChildren("BkDetail1");
			tBkRecNum.setText(String.valueOf(tBkDetail1.size()));
		}
		
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
    public static void main(String[] args) throws Exception{

    	/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/citic/1101/2.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/citic/1101/22.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));*/

    	Document doc = JdomUtil.build(new FileInputStream("E:\\银保通项目\\测试报文\\50002\\测试打印模板_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:\\银保通项目\\测试报文\\50002\\测试打印模板_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        
        out.close();
        System.out.println("******ok*********");
        
    }
}
