package com.sinosoft.midplat.jlyh.bat;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.jlyh.JlyhConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.XmlTag;

/**
 * 
* @名称: [JlyhEdorCTInfoBatch]
* @作者: 常洪伟  ab037259ChangHongwei@ab-insurance.com
* @日期: Jul 25, 2014 3:21:51 PM
* <p>版权所有:(C)1998-2014 AB.COM</p>
 */
public class JlyhEdorCTInfoBatch extends UploadFileBatchService {

    public JlyhEdorCTInfoBatch() {
        super(JlyhConf.newInstance(), "1805");
    }

    @Override
    protected void setHead(Element head) {
        // TODO Auto-generated method stub
        
    }

    @Override
    protected void setBody(Element mBodyEle) {
        // TODO Auto-generated method stub
    	Element mBusinessTypes = new Element("BusinessTypes");
    	
        Element mBusinessType = new Element("BusinessType");
        //CT退保
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("CT");
        mBusinessTypes.addContent(mBusinessType);

        //WT犹豫期退保
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("WT");
        mBusinessTypes.addContent(mBusinessType);

        mBodyEle.addContent(mBusinessTypes);
        
    	// 退保信息数据日期
        Element mEdorCTDateEle = new Element("EdorCTDate");
        mEdorCTDateEle.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        mBodyEle.addContent(mEdorCTDateEle);
        
    }

    @Override
    protected String getFileName() {
    	// 文件名规则： WAVER+公司代码(4位)+银行代码(4位)+YYYYMMDD
    	Element mBankEle = thisRootConf.getChild("bank");
        return  "WAVER" + mBankEle.getAttributeValue("insu")
        		+ mBankEle.getAttributeValue("id")
        		+ DateUtil.getDateStr(calendar, "yyyyMMdd");
    }

    @Override
    protected String parse(Document outStdXml) throws Exception{
        // TODO Auto-generated method stub
    	//公司代码
    	String insuId = thisRootConf.getChild("bank").getAttributeValue("insu");
    	//银行代码
        String bankId = thisRootConf.getChild("bank").getAttributeValue("id");
        
        StringBuffer content = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            //正常报文
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
            
            cLogger.debug("核心返回犹退记录："+tDetailList.size());
            
            //文件头 格式：公司代码|银行代码|退保总笔数|退保总金额
            content.append(insuId+"|");
            content.append(bankId+"|");
            content.append(tDetailList.size()+"|");
            long mSumPrem = 0;
            for(Element tDetailEle : tDetailList){ 
            	long tPremFen = Long.parseLong(tDetailEle.getChildText("EdorCTPrem"));
            	mSumPrem += tPremFen;
            }
            content.append(NumberUtil.fenToYuan(mSumPrem));
            
            for(Element tDetailEle : tDetailList){ 
                // 格式：产品代码|投保人证件号码|投保人姓名|被保人姓名|保单号|签单日期|
            	//      退保日期|退保金额|退保类型
                // 换行符
                content.append("\n"); 
                //产品代码
                content.append(tranRiskcode(tDetailEle.getChildText("RiskCode"))+"|");
                //投保人证件号码
                content.append(tDetailEle.getChildText("AppntIDNo")+"|");
                //投保人姓名
                content.append(tDetailEle.getChildText("AppntName")+"|");
                //被保人姓名
                content.append(tDetailEle.getChildText("InsuredName")+"|");
                //保单号
                content.append(tDetailEle.getChildText("ContNo")+"|");
                //签单日期
                content.append(tDetailEle.getChildText("SignDate")+"|");
                //退保日期
                content.append(tDetailEle.getChildText("EdorCTDate")+"|");
                //退保金额
                content.append(NumberUtil.fenToYuan(tDetailEle.getChildText("EdorCTPrem"))+"|");
                //退保类型
                content.append(getBusinessType(tDetailEle.getChildText("BusinessType")));
            }
        }else{
            cLogger.warn("核心返回错误报文，生成只有首行记录的文件:"+getFileName());
            //无犹豫期撤单数据，则也需上送只含文件头的对账文件，退保总笔数和退保总金额均为0,  示意 0001|jlyh|0|0.00
            content.append(insuId+"|");
            content.append(bankId+"|");
            content.append("0|0.00");
        }
        
        return content.toString();
    }

    /**
	 * 业务类型映射（核心--吉林银行）。
	 * </br>核心：	CT退保、WT犹豫期退保
	 * </br>吉林银行：8退保、3犹豫期撤保
	 * @param type 
	 * @return
	 */
	private String getBusinessType( String type) {
	    if("CT".equals(type)){
            //CT退保---8退保
            return "8";
        }else if("WT".equals(type)){
            //WT犹豫期退保--->3犹豫期撤保
            return "3";
        }
	    return "";
	}
	
	/**
	 * 产品代码转换，因万能型产品升级改造，
	 * @param tRiskCode
	 * @return
	 */
	private String tranRiskcode(String cRiskCode){
		
		String riskCode = cRiskCode;
		
		if("122046".equals(cRiskCode)){
    		riskCode = "50002";
    	}else if("L12079".equals(cRiskCode)  || "122012".equals(riskCode) ){
    		// 安邦盛世2号终身寿险（万能型）核心产品改造代码由122012变为L12079
    		riskCode = "122012";
    	/* 盛世3号产品代码变更start */
    	//}else if("L12078".equals(cRiskCode)  || "122010".equals(riskCode)){
    	}else if("L12100".equals(cRiskCode) || "L12078".equals(cRiskCode) || "122010".equals(riskCode)){
    	/* 盛世3号产品代码变更end */
    		// 安邦盛世3号终身寿险（万能型）核心产品改造代码由122010变为L12078
    		riskCode = "122010";    		
    	}else if("L12087".equals(cRiskCode)){
    		// 东风5号
    		riskCode = "L12087";    		
    	}
		return riskCode;
	}
	
}
