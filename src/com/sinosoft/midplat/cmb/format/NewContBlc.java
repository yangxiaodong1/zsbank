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
		//�������б��ĵ�У��
		//���б����еĹ�˾id
		String insuId = XPath.newInstance("//TXLifeRequest/CarrierCode").valueOf(pNoStdXml.getRootElement());
		//�����ļ��еĹ�˾id
		String companyId=XPath.newInstance("//bank/@insu").valueOf(CmbConf.newInstance().getConf().getRootElement());
		if(!insuId.equals(companyId)){
			throw new MidplatException("�����б��չ�˾��Ŵ��󣬷���˾���˱��ģ�"+insuId);
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
        
        
		if(mSSRS.MaxRow==0){	// û�з����������������������ն��˲��ô��������������˵�sourcetype��xsl�ļ���sourcetypeĬ��Ϊ0=���������
//			throw new MidplatException("δ��ѯ������������������������...");
		}else{// �������ĵ���
        	
			hashMap.clear();
        	
			for(int i=1; i<=mSSRS.MaxRow; i++){
				hashMap.put(mSSRS.GetText(i, 1).trim(), mSSRS.GetText(i, 1).trim());
			}
        	
			List<Element> tDetailList = XPath.selectNodes(newContBlcEle, "//Body/Detail");
        	
			for(Element tDetail:tDetailList){
				if(hashMap.containsKey(tDetail.getChildText(ContNo))){
					tDetail.getChild("SourceType").setText("1");	// ����������0-���棬1-������8�����ն�,Ĭ��Ϊ0�����й����Ķ��˱��Ĳ����֣���Ҫ����
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
		Document doc = JdomUtil.build(new FileInputStream("D:/�����ĵ�/��������ͨ�ĵ�/��������/03XML����ʵ��/������ϸ��������V1.0�����.xml"));
		System.out.println(JdomUtil.toStringFmt(new NewContBlc(null).noStd2Std(doc)));
	}
}