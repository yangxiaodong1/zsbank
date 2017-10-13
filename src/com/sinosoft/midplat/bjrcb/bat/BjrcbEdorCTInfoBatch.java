package com.sinosoft.midplat.bjrcb.bat;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.bjrcb.BjrcbConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.XmlTag;

public class BjrcbEdorCTInfoBatch extends UploadFileBatchService {

    public BjrcbEdorCTInfoBatch() {
        super(BjrcbConf.newInstance(), "1207");
    }

    @Override
    protected void setHead(Element head) {
        
    }

    @Override
    protected void setBody(Element mBodyEle) {

    	Element tBusinessTypesEle = new Element("BusinessTypes");
    	// 撤单退保
    	Element tCTBusinessType = new Element("BusinessType");
    	tCTBusinessType.setText("CT");
    	// 犹豫期退保
    	Element tWTBusinessType = new Element("BusinessType");
    	tWTBusinessType.setText("WT");
    	// 满期
    	Element tMQBusinessType = new Element("BusinessType");
    	tMQBusinessType.setText("MQ");
    	
    	tBusinessTypesEle.addContent(tCTBusinessType);
    	tBusinessTypesEle.addContent(tWTBusinessType);
    	tBusinessTypesEle.addContent(tMQBusinessType);

    	Element mEdorCTDateEle = new Element("EdorCTDate");
    	mEdorCTDateEle.setText(DateUtil.getCurDate("yyyyMMdd"));
    	
        mBodyEle.addContent(mEdorCTDateEle);
        mBodyEle.addContent(tBusinessTypesEle);
        
    }

    @Override
    protected String getFileName() {
        return  "BRCB_BDZTTB_L_" + DateUtil.getCurDate("yyyyMMdd") + ".txt";
    }

    @Override
    protected String parse(Document outStdXml) throws Exception{

    	StringBuffer content = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            //正常报文
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
            
            cLogger.debug("核心返回犹退记录："+tDetailList.size());
            /*
             * 报文格式：
             * 第一行：笔数;总金额;日期
             * eg：
             * 首行：3|20110506|备注|
             */
            content.append(tDetailList.size()+"|");
            content.append(DateUtil.getCurDate("yyyyMMdd")+"||");
            for(Element tDetailEle : tDetailList){ 
                // 格式：保单号（30位）|保单印刷号（30位）|犹豫期退保日期(8位)|保单状态（1位）|备注（100位）|
                // 换行符
                content.append("\n"); 
                //保单号
                content.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
                //保单印刷号
                content.append(tDetailEle.getChildText(XmlTag.ContPrtNo)+"|");
                //业务确认日期
                content.append(tDetailEle.getChildText("EdorCTDate")+"|");
                //保单状态
                content.append(switchPolState(tDetailEle.getChildText("ContState"))).append("|");
                if("1".equals(tDetailEle.getChildText("LargeAmount"))){
                    //大额保单
                    content.append("DETZ"+tDetailEle.getChildText("ProposalContNo")+"|");
                }else{
                    //其他
                    content.append(switchBusinessType(tDetailEle.getChildText("BusinessType"))).append("|");
                }
            }
        }else{
            //错误报文
            cLogger.warn("核心返回错误报文，生成只有首行记录的文件:"+getFileName());
            //首行：3|20110506|备注|
            content.append("0|"+DateUtil.getCurDate("yyyyMMdd")+"||");
        }
        
        return content.toString();
    }
    
	/**
	 * 保单状态转码
	 * @param polState
	 * @return
	 */
	private String switchPolState(String polState){
		String tempValue = "";
		if("01".equals(polState)){	// 满期给付
			tempValue = "E";
		}else if("02".equals(polState)){	// 退保
			tempValue = "D";
		}else if("WT".equals(polState)){	// 犹豫期退保
			tempValue = "9";
		}
		return tempValue;
    }
    
	/**
	 * 业务类型转码
	 * @param businessType
	 * @return
	 */
	private String switchBusinessType(String businessType){
		String tempValue = "";
		if("MQ".equals(businessType)){	// 满期给付
			tempValue = "满期给付";
		}else if("CT".equals(businessType)){	// 退保
			tempValue = "正常退保";
		}else if("WT".equals(businessType)){	// 犹豫期退保
			tempValue = "犹豫期退保";
		}
		return tempValue;
    }
}
