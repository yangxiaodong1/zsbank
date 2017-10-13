package com.sinosoft.midplat.hrbcb.bat;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.hrbcb.HrbcbConf;

/**
 * 获取哈尔滨银行保单状态变更数据
 * @author 
 *
 */
public class HrbQueryPolicyStatus extends UploadFileBatchService {
    
	public HrbQueryPolicyStatus() {
		super(HrbcbConf.newInstance(), "2605");
	}
	
	/**
	 * 解析核心传来的xml报文，形成结果文件
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
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();		
		//交易日期 YYYYMMDD，当前日期
		line.append(DateUtil.getCur8Date()+"|");
		//业务种类 001满期给付，002犹豫期撤保，003退保，004续期交费， 099理赔终止，999 其他项目
		String businessType = tDetailEle.getChildText("BusinessType");
        if("CT".equals(businessType)){//退保
			line.append("003|");
		}else if("WT".equals(businessType)){//犹退
			line.append("002|");
		}else if("MQ".equals(businessType)){//满期给付
			line.append("001|");
		}else if("CLAIM".equals(businessType)){//理赔
			line.append("099|");
		}else if("RENEW".equals(businessType)){//续期交费
			line.append("004|");
		}else{//其他项目
			line.append("999|");
		}
		//业务变更日期 YYYYMMDD，保单状态变更日期
		String contState = tDetailEle.getChildText("ContState");
		if("00".equals(contState)){
			line.append(tDetailEle.getChildText(XmlTag.SignDate)+"|");
		}else{
			line.append(tDetailEle.getChildText("EdorCTDate")+"|");
		}
		//银行代码
		line.append("26"+"|");
        //银行网点码（哈尔滨银行没有地区码）
		line.append(tDetailEle.getChildText(XmlTag.NodeNo)+"|");
        //投保单印刷号(20位)
		line.append(tDetailEle.getChildText(XmlTag.ProposalPrtNo)+"|");
		//保单号（30位）
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//投保人姓名
		line.append(tDetailEle.getChildText("AppntName")+"|");
		//投保人证件类型
		line.append(tDetailEle.getChildText("AppntIDType")+"|");
		//投保人证件号码
		line.append(tDetailEle.getChildText("AppntIDNo")+"|");
		//保单最新状态
		if("00".equals(contState)||"01".equals(contState) || "02".equals(contState) || "04".equals(contState) ){
			line.append(tDetailEle.getChildText("ContState")+"|");
		}else if("WT".equals(contState)){
			line.append("03|");
		}else{
			line.append("08|");
		}
		//保单最新到期日期
		line.append(tDetailEle.getChildText("ContEndDate")+"|");
		//备用字段1
		line.append(""+"|");
		//备用字段2
		line.append(""+"|");
		//备用字段3
		line.append(""+"|");
		//备用字段4
		line.append(""+"|");
        // 换行符
        line.append("\n"); 
		return line;
	}
	
	/** 
	 * 结果文件格式：
	 * HRBB(4位)+日期（8位，yyyymmdd）+UPDATESTATUS.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
        return  "HRBB" + DateUtil.getDateStr(calendar, "yyyyMMdd") + "UPDATESTATUS.txt";
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
	public static void main(String[] args) throws Exception{
		HrbQueryPolicyStatus blc = new HrbQueryPolicyStatus();
		blc.run();
		
		System.out.println(" 测试后台 print info : ");
	}

    @Override
    protected String getFtpName() {
        return getFileName();
    }
	
}

