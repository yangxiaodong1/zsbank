package com.sinosoft.midplat.cmb.format;

import java.io.FileInputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.cmb.CmbConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class NewContBlc extends XmlSimpFormat {
	
	Map<String,String> hashMap = new HashMap<String,String>();
	
	public NewContBlc(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContBlc.noStd2Std()...");
		//加入招行报文的校验
		//招行报文中的公司id
		String insuId = XPath.newInstance("//TXLifeRequest/CarrierCode").valueOf(pNoStdXml.getRootElement());
		//配置文件中的公司id
		String companyId=XPath.newInstance("//bank/@insu").valueOf(CmbConf.newInstance().getConf().getRootElement());
		if(!insuId.equals(companyId)){
			throw new MidplatException("报文中保险公司编号错误，非我司对账报文："+insuId);
		}
		Document mStdXml = NewContBlcInXsl.newInstance().getCache().transform(pNoStdXml);
        
       
		Element newContBlcEle = (Element) XPath.selectSingleNode(mStdXml.getRootElement(), "//NewCont/TranData");
		Element tHeadEle = newContBlcEle.getChild(Head);
		
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select l.contno from tranlog l where l.trancom='")
				.append(tHeadEle.getChildText(TranCom))
				.append("' and l.trandate='")
				.append(tHeadEle.getChildText(TranDate))
				.append("' and l.funcflag='1013' and l.rcode='0' order by l.logno desc");
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        
        
		if(mSSRS.MaxRow==0){	// 没有符合条件的网银保单，日终对账不用处理网银保单对账的sourcetype（xsl文件中sourcetype默认为0=柜面出单）
//			throw new MidplatException("未查询到符合条件的招行网银保单...");
		}else{// 有网银的单子
        	
			hashMap.clear();
        	
			for(int i=1; i<=mSSRS.MaxRow; i++){
				hashMap.put(mSSRS.GetText(i, 1).trim(), mSSRS.GetText(i, 1).trim());
			}
        	
			List<Element> tDetailList = XPath.selectNodes(newContBlcEle, "//Body/Detail");
        	
			for(Element tDetail:tDetailList){
				if(hashMap.containsKey(tDetail.getChildText(ContNo))){
					tDetail.getChild("SourceType").setText("1");	// 交易渠道：0-柜面，1-网银，8自助终端,默认为0，招行过来的对账报文不区分，需要处理
					hashMap.remove(tDetail.getChildText(ContNo));
				}
			}
		}
		cLogger.info("Out NewContBlc.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContBlc.std2NoStd()...");

		Document mNoStdXml = new Cancel(this.cThisBusiConf).std2NoStd(pStdXml);

		cLogger.info("Out NewContBlc.std2NoStd()!");
		return mNoStdXml;
	}
    
	public static void main(String[] args) throws Exception{
		Document doc = JdomUtil.build(new FileInputStream("D:/工作文档/寿险银保通文档/招商银行/03XML报文实例/日终明细对账请求V1.0（安邦）.xml"));
		System.out.println(JdomUtil.toStringFmt(new NewContBlc(null).noStd2Std(doc)));
	}
}