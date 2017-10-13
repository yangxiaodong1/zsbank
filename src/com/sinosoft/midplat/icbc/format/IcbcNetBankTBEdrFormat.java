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
import com.sinosoft.midplat.icbc.IcbcUtil;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * @Title: com.sinosoft.midplat.icbc.format.IcbcNetBankTBEdrFormat.java
 * @Description: ���������˱�ȷ�Ͻ���
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Jul 18, 2014 3:41:23 PM
 * @version 
 *
 */
public class IcbcNetBankTBEdrFormat extends XmlSimpFormat{
	
	public IcbcNetBankTBEdrFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcNetBankTBEdrFormat.noStd2Std()...");

		Document mStdXml = IcbcNetBankTBEdrFormatInXsl.newInstance().getCache().transform(pNoStdXml);
		/**
		 * �ж��Ƿ�Ϊ�㽭����ר����Ʒ������ǣ�����Ҫ���и�У��
		 * PBKINSR-818 �㽭����ר���Ʒ��Ŀ��һ�ڣ�
		 */
		String regionCode = XPath.newInstance("//RegionCode").valueOf(pNoStdXml);
		String teller = XPath.newInstance("//Teller").valueOf(pNoStdXml);
		//���㽭����ר����Ʒ
		if("0".equals(IcbcUtil.zjCheck(regionCode, teller))){
			//�������
			XPath certifyCodePath = XPath.newInstance("//Certify/CertifyCode");
			String certifyCode = certifyCodePath.valueOf(mStdXml.getRootElement());
			if(certifyCode == null || certifyCode.trim().equals("")){
			    //����û�д������������
			    
			    //������
			    XPath funcPath = XPath.newInstance("//Head/FuncFlag");

			    //������
			    XPath contNoPath = XPath.newInstance("//PubContInfo/ContNo");
			    String contNo = contNoPath.valueOf(mStdXml.getRootElement());

			    //��ȫ��������
			    XPath tranDatePath = XPath.newInstance("//PubEdorInfo/EdorAppDate");
			    String tranDate = tranDatePath.valueOf(mStdXml.getRootElement());

			    //���ݲ�ѯ���׻�ȡ�������
			    StringBuffer tSqlStr = new StringBuffer();
			    tSqlStr.append("select otherno, contno from TranLog where RCode=0 ");
			    tSqlStr.append(" and contno='"+contNo+"'");
			    tSqlStr.append(" and TranDate =").append(DateUtil.date10to8(tranDate));
		        //�������˲�ѯ����
		        tSqlStr.append(" and FuncFlag=132");
			    tSqlStr.append(" Order by MakeTime desc");

			    SSRS ssrs = new SSRS();
			    ssrs = new ExeSQL().execSQL( tSqlStr.toString());
			    if (ssrs.MaxRow > 0) {
			        Element certifyCodeEle = (Element)XPath.selectSingleNode(mStdXml.getRootElement(), "//Certify/CertifyCode");
			        certifyCodeEle.setText(ssrs.GetText(1, 1));
			    }else{
			        throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
			    }
			}
		}
		
		cLogger.info("Out IcbcNetBankTBEdrFormat.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into IcbcNetBankTBEdrFormat.std2NoStd()...");

		Document mNoStdXml = null;
		String tMainRiskCode = XPath.newInstance("/TranData/Body/PubContInfo/ContPlanCode").valueOf(pStdXml.getRootElement());
		//PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ����
		if("50002".equals(tMainRiskCode) || "50015".equals(tMainRiskCode)){
			/*
			 * ��ϲ�Ʒ-50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���ɣ�
			 * ǰ����50002����Ʒ������Ϊ122046�������������յĲ�ƷΪ122048,���5������˱�ʱ���Ĵ����������ֱ����122048
			 */
			mNoStdXml = IcbcNetBankTBEdrFormatOutXsl50002.newInstance().getCache().transform(pStdXml);
			
			cLogger.info("ICBC_�������У�����IcbcNetBankTBEdrFormatOutXsl50002���б���ת����");
			
		}else{	// ����ϲ�Ʒ
			mNoStdXml = IcbcNetBankTBEdrFormatOutXsl.newInstance().getCache().transform(pStdXml);
			
			cLogger.info("ICBC_�������У�����IcbcNetBankTBEdrFormatOutXsl���б���ת����");
		}
		
		cLogger.info("Out IcbcNetBankTBEdrFormat.std2NoStd()!");
		return mNoStdXml;
	}
	
	
	public static void main(String[] args) throws Exception {
		
//		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/icbc/1_in.xml"));
//		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/icbc/11_out.xml")));
//		out.write(JdomUtil.toStringFmt(new IcbcNetBankTBEdrFormat(null).noStd2Std(doc)));
		
		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/icbc/2_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/icbc/22_out.xml")));
		out.write(JdomUtil.toStringFmt(new IcbcNetBankTBEdrFormat(null).std2NoStd(doc)));
		
		out.close();
		System.out.println("******ok*********");
	}
}
