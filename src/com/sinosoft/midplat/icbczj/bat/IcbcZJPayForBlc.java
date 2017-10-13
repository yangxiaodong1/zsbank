/**
 * 
 */
package com.sinosoft.midplat.icbczj.bat;

import java.lang.reflect.Constructor;
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
import com.sinosoft.midplat.service.Service;

/**
 * 浙江工行专属产品：支付入账交易，触发之后调用收付得到结果
 * @author liying
 * @date   20150810
 */
public class IcbcZJPayForBlc extends UploadFileBatchService  {
	public IcbcZJPayForBlc() {
		super(IcbcZJConf.newInstance(), "185");	// funFlag="3405"-支付入账交易
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
        StringBuffer content2 = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            
            int count = 0;
            long sumPrem = 0;
            
            //正常报文
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");   
            if(tDetailList.size() == 0) {
            	//增加首行汇总信息
                count = 0;
                sumPrem = 0;
            }else {
            	 //增加首行汇总信息
                count = count + Integer.parseInt(XPath.newInstance("//Body/Count").valueOf(outStdXml.getRootElement()));
                sumPrem = sumPrem + Long.parseLong((XPath.newInstance("//Body/SumPrem").valueOf(outStdXml.getRootElement())));
            }
            cLogger.debug("核心返回核保结果记录："+tDetailList.size());
            
            //如果还有其他险种，则需要再次请求财务系统进行查询
            String riskCodes = IcbcZJCodeMapping.riskCode_add();
            String[] riskCodeStr = riskCodes.split(",");
            if(riskCodeStr != null && riskCodeStr.length>0){
            	for(int i=0;i<riskCodeStr.length;i++){
            		
            		// 获取服务的配置
                    String tServiceClassName = thisBusiConf.getChildText("service");
                    if (tServiceClassName == null && "".equals(tServiceClassName)){
                        throw new Exception("该交易没有配置service");
                    }
                    cLogger.debug("业务处理模块："+tServiceClassName);
                    // 初始化服务
                    Constructor tServiceConstructor = Class.forName(tServiceClassName)
                            .getConstructor(new Class[] { org.jdom.Element.class });
                    Service service = (Service) tServiceConstructor
                            .newInstance(new Object[] { thisBusiConf });
                    //组织请求报文
                    Element tTranData = new Element("TranData");
                    Element tHeadEle = getHead();
                    setHead(tHeadEle);
                    tTranData.addContent(tHeadEle);
                    // 报文体
                    Element tBodyEle = getBody();
                    tBodyEle.getChild("RiskCode").setText(riskCodeStr[i]);
                    tTranData.addContent(tBodyEle);
                                   
                    Document tOutStdXml = service.service(new Document(tTranData));
                    List<Element> tDetailList2 = XPath.selectNodes(tOutStdXml.getRootElement(), "//Body/Detail");   
                    if(tDetailList2.size() == 0) {
                    	//增加首行汇总信息
                        count = count + 0;
                        sumPrem = sumPrem + 0;
                    }else {
                    	 //增加首行汇总信息
                        count = count + Integer.parseInt(XPath.newInstance("//Body/Count").valueOf(tOutStdXml.getRootElement()));
                        sumPrem = sumPrem + Long.parseLong((XPath.newInstance("//Body/SumPrem").valueOf(tOutStdXml.getRootElement())));
                        
                        for(Element tDetailEle : tDetailList2){ 
                        	content2.append(getLine(tDetailEle));
                        }
                    }  
            	}
            } 
            if(tDetailList.size() == 0) {
            	//增加首行汇总信息
                content.append(count+ "|" + NumberUtil.fenToYuan(sumPrem+"") + "|" + "\n");
            }else {
            	 //增加首行汇总信息
                content.append(count+ "|" + NumberUtil.fenToYuan(sumPrem+"") + "|" + "\n");
            }
            
            for(Element tDetailEle : tDetailList){ 
            	content.append(getLine(tDetailEle));
            }
            if(content2 != null && !"".equals(content2.toString())){
            	 content.append(content2);
            }
           
        }else{
            //错误报文
            cLogger.warn("核心返回错误报文，生成空文件:"+getFileName());
        }
        
        return content.toString();
	}
	
	/**
	 * 组织结果文件中的行信息
	 * 银行编号（固定01）＋交易申请日期（YYYYMMDD）＋批单号（30位）+保险产品代码(3位)＋保单号（30位）+新银行账号（20位）+金额（12位，带小数点）
	 * +入账日期（YYYYMMDD）+成功失败标志（1位）+失败原因（200位）+交易类型（2位）+二次入账标志(1位)
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();
		//银行编号（固定01）
		line.append("044"+"|"); 
		//交易日期（YYYYMMDD）
		line.append(tDetailEle.getChildText("ApplyTranDate")+"|");
		//批单号
		line.append(tDetailEle.getChildText("FormNumber")+"|");
        //保险产品代码(3位)
		line.append(IcbcZJCodeMapping.riskCodeFromPGI(tDetailEle.getChildText(XmlTag.RiskCode))+"|");
		//保单号（30位）
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//银行账号（20位）
		line.append(tDetailEle.getChildText("AccNo")+"|");
		//金额（12位，带小数点）
		line.append(NumberUtil.fenToYuan(tDetailEle.getChildText("Prem"))+"|");
		//入账日期（YYYYMMDD）
		line.append(tDetailEle.getChildText("AccDate")+"|");
		//成功失败标志（1位）
		line.append(tDetailEle.getChildText("ResultFlag")+"|");
		//失败原因（200位）
		line.append(tDetailEle.getChildText("ResultMsg")+"|");
		//交易类型（2位）
		line.append(IcbcZJCodeMapping.tranTypeFromPGI(tDetailEle.getChildText("BusinessType"))+"|");
		//二次入账标志(1位)二次入账标志指变更账号后再次重新入账：0否 1是；收付区分不出来，此处给固定值“否”
		line.append(tDetailEle.getChildText("AccFlag")+"|"); 
		line.append("|"); 
		line.append("|"); 
        // 换行符
        line.append("\n"); 
		return line;
	}

	
	/** 
	 * 结果文件格式：
	 * ICBCZJ+保险公司代码(3位)+银行代码(01)+YYYYMMDD+PAY.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "ICBCZJ" + mBankEle.getAttributeValue("insu")+ mBankEle.getAttributeValue("id")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "PAY.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
        //查询日期
        Element mAccDate = new Element("AccDate");
        mAccDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        bodyEle.addContent(mAccDate);
        
        //浙江工行专属产品险种代码
        Element mRiskCode = new Element("RiskCode");
        mRiskCode.setText(IcbcZJCodeMapping.riskCodes());
        bodyEle.addContent(mRiskCode);
       
	}


    /**
	 * @param args
	 */
	public static void main(String[] args) throws Exception{
		IcbcZJPayForBlc blc = new IcbcZJPayForBlc();
//		blc.postProcess();
		blc.run();
//		Calendar calendar = Calendar.getInstance();
//		calendar.add(Calendar.DAY_OF_MONTH, -1);
//		System.out.println(DateUtil.getDateStr(calendar, "yyyyMMdd"));
		
		System.out.println(" 测试后台 print info : ");
	}

	@Override
	protected void setHead(Element head) {
		// TODO Auto-generated method stub
//		calendar.add(Calendar.DAY_OF_MONTH, -1);
//
//		Element mTranNo = head.getChild("TranNo");
//        mTranNo.setText(getFileName());
//        
//        Element mTranDate = head.getChild("TranDate");
//        mTranDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
	}

}
