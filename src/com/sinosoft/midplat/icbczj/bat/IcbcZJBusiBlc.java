/**
 * 
 */
package com.sinosoft.midplat.icbczj.bat;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.common.DateUtil;

import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.XmlTag;

import com.sinosoft.midplat.icbczj.IcbcZJCodeMapping;
import com.sinosoft.midplat.icbczj.IcbcZJConf;

/**
 * 浙江工行专属产品：公司投保对账文件，触发之后调用核心得到结果
 * @author liying
 * @date   20150805
 */
public class IcbcZJBusiBlc extends UploadFileBatchService  {
	public IcbcZJBusiBlc() {
		super(IcbcZJConf.newInstance(), "183");	// funFlag="3403"-公司投保对账文件
	}
	
	/**
	 * 解析核心传来的xml报文，形成对账文件格式
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 * 
	 */
	@Override
	protected String parse(Document outStdXml) throws Exception {
        StringBuffer content = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            //正常报文
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
            
            cLogger.debug("核心返回核保结果记录："+tDetailList.size());
            if(tDetailList.size() == 0) {
            	//增加首行汇总信息
                String count = "0";
                String sumPrem = "0";
                content.append(count+ "|" + NumberUtil.fenToYuan(sumPrem) + "|" + "\n");
            }else {
            	//增加首行汇总信息
                String count = XPath.newInstance("//Body/Count").valueOf(outStdXml.getRootElement());
                String sumPrem = XPath.newInstance("//Body/SumPrem").valueOf(outStdXml.getRootElement());
                content.append(count+ "|" + NumberUtil.fenToYuan(sumPrem) + "|" + "\n");
            }
            

            for(Element tDetailEle : tDetailList){ 
            	content.append(getLine(tDetailEle));
            }
        }else{
            //错误报文
            cLogger.warn("核心返回错误报文，生成空文件:"+getFileName());
        }
        
        return content.toString();
	}
	
	/**
	 * 组织结果文件中的行信息
	 * 保险公司（固定044）＋交易日期（YYYYMMDD）＋地区号（5位）＋网点号（5位）＋对帐交易码（固定0001）+应对帐银行交易流水号（30位）+保险产品代码(3位)＋保单号（30位）+银行账号（20位）＋金额（12位，带小数点）
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();
		//银行编号（固定01）
//		line.append("01"+"|"); 
		line.append("044"+"|"); 
		//交易日期（YYYYMMDD）
		line.append(tDetailEle.getChildText(XmlTag.TranDate)+"|");
        //地区码，前5位表示地区码
//		line.append(tDetailEle.getChildText("AreaCode").substring(0, 5)+"|");
		line.append(tDetailEle.getChildText("AreaCode")+"|");
		//网点号（5位）
		line.append(tDetailEle.getChildText("BankCode")+"|");
		//对帐交易码（固定0001）
		line.append("0001"+"|"); 
        //应对帐银行交易流水号（30位）
		line.append(tDetailEle.getChildText(XmlTag.TranNo)+"|");
        //保险产品代码(3位)
		line.append(IcbcZJCodeMapping.riskCodeFromPGI(tDetailEle.getChildText(XmlTag.RiskCode))+"|");
		//保单号（30位）
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//银行账号（20位）
		line.append(tDetailEle.getChildText("AccNo")+"|");
		//金额（12位，带小数点）
		line.append(NumberUtil.fenToYuan(tDetailEle.getChildText("Prem"))+"|");
		
		
        // 换行符
        line.append("\n"); 
		return line;
	}

	
	/** 
	 * 结果文件格式：
	 * ICBCZJ+保险公司代码+银行代码（01）+日期+TOUBAO.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "ICBCZJ" + mBankEle.getAttributeValue("insu")+ mBankEle.getAttributeValue("id")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "TOUBAO.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
        //查询日期
        Element mPolApplyDate = new Element("PolApplyDate");
        mPolApplyDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        bodyEle.addContent(mPolApplyDate);
	}


    /**
	 * @param args
	 */
	public static void main(String[] args) throws Exception{
		IcbcZJBusiBlc blc = new IcbcZJBusiBlc();
//		blc.postProcess();
		blc.run();
		System.out.println(" 测试后台 print info : ");
	}

	@Override
	protected void setHead(Element head) {
		// TODO Auto-generated method stub
		
	}



}
