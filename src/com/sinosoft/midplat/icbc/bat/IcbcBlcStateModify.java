/**
 * 
 */
package com.sinosoft.midplat.icbc.bat;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.icbc.IcbcCodeMapping;
import com.sinosoft.midplat.icbc.IcbcConf;

/**
 * 人工核保状态变更通知
 * @author ChengNing
 * @date   Apr 2, 2013
 */
public class IcbcBlcStateModify extends UploadFileBatchService  {
	public IcbcBlcStateModify() {
		super(IcbcConf.newInstance(), "124");
	}

	/**
	 * 文件组成
	 * 地区号(5号) | 保险公司代码(3位) |  银行交易流水号(25位) |  投保单印刷号(20位) |  投保人姓名(30位) | 受理状态（2位） | 备注（120位）|
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.UploadFileBatchService#parse(org.jdom.Document)
	 */
	@Override
	protected String parse(Document outStdXml) throws Exception {
        StringBuffer content = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            //正常报文
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
            
            cLogger.debug("核心返回状态变更记录："+tDetailList.size());

            for(Element tDetailEle : tDetailList){ 
            	//按行添加到对账文件
            	content.append(getLine(tDetailEle));
            }
        }else{
            //错误报文
            cLogger.warn("核心返回错误报文，生成空文件:"+getFileName());
        }
        
        return content.toString();
	}
	
	/**
	 * 组织对账文件中的行信息
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();
        //地区码，前5位表示地区码
		line.append(tDetailEle.getChildText(XmlTag.NodeNo).substring(0, 5)+"|");
        //保险公司代码(3位)
		line.append(thisRootConf.getChild("bank").getAttributeValue("insu")+"|");
        //银行交易流水号(25位)
		line.append(tDetailEle.getChildText(XmlTag.TranNo)+"|");
        //投保单印刷号(20位)
		line.append(tDetailEle.getChildText(XmlTag.ProposalPrtNo)+"|");
		//投保人姓名(30位)
		line.append(tDetailEle.getChildText("AppntName")+"|");
		//受理状态（2位）
		line.append(IcbcCodeMapping.processStateFromPGI(tDetailEle.getChildText("Progress"))+"|");
		//备注（120位）
		line.append(tDetailEle.getChildText("ReMark")+"|");
		
        // 换行符
        line.append("\n"); 
		return line;
	}

	/** 
	 * 变更状态文件名称
	 * TOICBC＋保险公司代码（3位）+银行代码（2位）+日期（8位）+05.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.UploadFileBatchService#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "TOICBC" + mBankEle.getAttributeValue("insu")+ mBankEle.getAttributeValue("id")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "05.txt";
	}

	@Override
	protected void setBody(Element bodyEle) {
	}
	
	
	@Override
	protected void setHead(Element head) {
	}
	
	
	

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		IcbcBlcStateModify blc = new IcbcBlcStateModify();
		blc.run();

	}

}
