/**
 * 险险公司工行保全对账（浙江工行专属产品）
 * 	包含的保全业务有：
 * 	01犹豫期退保，02满期给付，03提款
 */

package com.sinosoft.midplat.icbczj.bat;

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
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class IcbcZJEdrBlc extends UploadFileBatchService {

	public IcbcZJEdrBlc() {
		super(IcbcZJConf.newInstance(), "184");
	}
	
	/** 
	 * 文件名称：
	 * ICBCZJ+保险公司代码(3位)+银行代码(01)+YYYYMMDD+BAOQUAN.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "ICBCZJ" + mBankEle.getAttributeValue("insu")+ mBankEle.getAttributeValue("id")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "BAOQUAN.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
        //查询日期
        Element mEdorAppDate = new Element("EdorAppDate");
        mEdorAppDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        bodyEle.addContent(mEdorAppDate);
        
        //保全类型
        Element mEdorTypes = new Element("EdorTypes");
        //犹退保全
        Element mEdorType1 = new Element("EdorType");
        mEdorType1.setText("WT");
        mEdorTypes.addContent(mEdorType1);
//        //满期保全
//        Element mEdorType2 = new Element("EdorType");
//        mEdorType2.setText("MQ");
//        mEdorTypes.addContent(mEdorType2);
        
        bodyEle.addContent(mEdorTypes);
	}
	
	
	
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
	 * 业务类型(2位)+交易流水号(8位)+银行代码(2位) +地区号(5位)+网点号(5位)+渠道(3位)+处理标志(2位) +
	 * 保单号(30位)+批单号(30位)+领取账户(19位)+账户姓名(20位)+交易日期(8位)+金额（12位，带小数点）+交易类型（2位）
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();
		//业务类型(2位)：业务类型：07犹豫期撤保，09 满期给付 
		line.append(IcbcZJCodeMapping.edorTypeFromPGI(tDetailEle.getChildText("EdorType"))+"|"); 
		//应对帐银行交易流水号（30位）
		line.append(tDetailEle.getChildText(XmlTag.TranNo)+"|");
		//保险公司代码(2位) 
		line.append("044"+"|");
		//地区码，前5位表示地区码
		line.append(tDetailEle.getChildText("AreaCode")+"|");
		//网点号（5位）
		line.append(tDetailEle.getChildText("BankCode")+"|");
		//销售渠道(3位)：0-柜面;1-网银;2-电银;3-法人营销;5-手机银行; 6-业务中心;7- 理财销售服务终端;8-自助终端;10-个人营销；除上述之外，公司请按其他字典处理；
		line.append(IcbcZJCodeMapping.sourceTypeFromPGI(tDetailEle.getChildText("SourceType"))+"|"); 
		//处理标志：成功01
		line.append("01"+"|");
		//保单号（30位）
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//批单号（30位）
		line.append(tDetailEle.getChildText("EdorNo")+"|");
		//领取账户(19位)
		line.append(tDetailEle.getChildText("AccNo")+"|");
		//账户姓名(20位)
		line.append(tDetailEle.getChildText("AccName")+"|");
		//交易日期（YYYYMMDD）
		line.append(tDetailEle.getChildText("EdorAppDate")+"|");
		//金额（12位，带小数点）
		line.append(NumberUtil.fenToYuan(tDetailEle.getChildText("TranMoney"))+"|");
		//保险产品代码(3位)
		String sqlStr = "select BAK1 from cont where TranCom='1' and contno = '"+tDetailEle.getChildText(XmlTag.ContNo)+"'";
		SSRS results = new ExeSQL().execSQL(sqlStr);
		if (results.MaxRow < 1) {
			line.append("|");
		} else {		
			line.append(IcbcZJCodeMapping.riskCodeFromPGI(results.GetText(1, 1))+"|");
		}
		/**
		//交易类型(2位)：01犹豫期退保，02满期给付，03提款； 
		line.append(IcbcZJCodeMapping.tranType1FromPGI(tDetailEle.getChildText("EdorType"))+"|"); 
		**/
		//收益金额
		line.append("0.00|");		
		
        // 换行符
        line.append("\n"); 
		return line;
	}
	
	public static void main(String[] args) throws Exception {
		IcbcZJEdrBlc blc = new IcbcZJEdrBlc();
//		blc.postProcess();
		blc.run();
		System.out.println(" 测试后台 print info : ");
	}

	@Override
	protected void setHead(Element head) {
		// TODO Auto-generated method stub
		
	}
}
