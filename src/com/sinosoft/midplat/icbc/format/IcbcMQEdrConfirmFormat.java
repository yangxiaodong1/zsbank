/**
 * 
 */
package com.sinosoft.midplat.icbc.format;

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

/**
 * @author ChengNing
 * 
 */
public class IcbcMQEdrConfirmFormat extends XmlSimpFormat {

	public IcbcMQEdrConfirmFormat(Element thisBusiConf) {
		super(thisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcMQEdrConfirmFormat.noStd2Std()...");

		Document mStdXml = IcbcMQEdrConfirmFormatInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//申请书号
        XPath certifyCodePath = XPath.newInstance("//Certify/CertifyCode");
        String certifyCode = certifyCodePath.valueOf(mStdXml.getRootElement());
        
        if(certifyCode == null || certifyCode.trim().equals("")){
        	//银行没有传递了申请书号
        	
        	
        	//保单号
            XPath contNoPath = XPath.newInstance("//PubContInfo/ContNo");
            String contNo = contNoPath.valueOf(mStdXml.getRootElement());

            //保全申请日期
            XPath tranDatePath = XPath.newInstance("//PubEdorInfo/EdorAppDate");
            String tranDate = tranDatePath.valueOf(mStdXml.getRootElement());
            
            StringBuffer tSqlStr = new StringBuffer();
            tSqlStr.append("select otherno, contno from TranLog where RCode=0 ");
            tSqlStr.append(" and contno='"+contNo+"'");
            tSqlStr.append(" and TranDate =").append(DateUtil.date10to8(tranDate));
            //满期查询交易码117
            tSqlStr.append(" and FuncFlag=117");
            tSqlStr.append(" Order by MakeTime desc");
            
            SSRS ssrs = new SSRS();
            ssrs = new ExeSQL().execSQL( tSqlStr.toString());
            if (ssrs.MaxRow > 0) {
                Element certifyCodeEle = (Element)XPath.selectSingleNode(mStdXml.getRootElement(), "//Certify/CertifyCode");
                certifyCodeEle.setText(ssrs.GetText(1, 1));
            }else{
                throw new MidplatException("查询上一交易日志失败！");
            }
        }
        
        
		cLogger.info("Out IcbcMQEdrConfirmFormat.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcMQEdrConfirmFormat.std2NoStd()...");

		Document mNoStdXml = null;
		String tMainRiskCode = XPath.newInstance("/TranData/Body/PubContInfo/ContPlanCode").valueOf(pStdXml.getRootElement());
		//PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级
		if("50002".equals(tMainRiskCode) || "50015".equals(tMainRiskCode)){
			
			/*
			 * 组合产品50002-安邦长寿稳赢保险计划: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成，
			 * 前五年50002这款产品的主险为122046，五年后这款主险的产品为122048,如果5年后做退保时核心传的主险险种便成了122048
			 */
			
			mNoStdXml = IcbcMQEdrConfirmFormatOutXsl50002.newInstance().getCache().transform(pStdXml);
			
			cLogger.info("ICBC_工商银行，进入IcbcMQEdrConfirmFormatOutXsl50002进行报文转换。");
			
		}else{	// 其它产品
			
			mNoStdXml = IcbcMQEdrConfirmFormatOutXsl.newInstance().getCache().transform(pStdXml);
			
			cLogger.info("ICBC_工商银行，进入IcbcMQEdrConfirmFormatOutXsl进行报文转换。");
		}
		

		cLogger.info("Out IcbcMQEdrConfirmFormat.std2NoStd()!");
		return mNoStdXml;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {

		
//		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/icbc/1_in.xml"));
//		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/icbc/11_out.xml")));
//		out.write(JdomUtil.toStringFmt(new IcbcMQEdrConfirmFormat(null).noStd2Std(doc)));
		
		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/icbc/3_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/icbc/33_out.xml")));
		out.write(JdomUtil.toStringFmt(new IcbcMQEdrConfirmFormat(null).std2NoStd(doc)));
		
		out.close();
		System.out.println("******ok*********");
		
	}
	
}

