/**
 * 
 */
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
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * @author ChengNing
 * 
 */
public class IcbcMQEdrConfirmFormat extends XmlSimpFormat {

	public IcbcMQEdrConfirmFormat(Element thisBusiConf) {
		super(thisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcMQEdrConfirmFormat.noStd2Std()...");

		Document mStdXml = IcbcMQEdrConfirmFormatInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//�������
        XPath certifyCodePath = XPath.newInstance("//Certify/CertifyCode");
        String certifyCode = certifyCodePath.valueOf(mStdXml.getRootElement());
        
        if(certifyCode == null || certifyCode.trim().equals("")){
        	//����û�д������������
        	
        	
        	//������
            XPath contNoPath = XPath.newInstance("//PubContInfo/ContNo");
            String contNo = contNoPath.valueOf(mStdXml.getRootElement());

            //��ȫ��������
            XPath tranDatePath = XPath.newInstance("//PubEdorInfo/EdorAppDate");
            String tranDate = tranDatePath.valueOf(mStdXml.getRootElement());
            
            StringBuffer tSqlStr = new StringBuffer();
            tSqlStr.append("select otherno, contno from TranLog where RCode=0 ");
            tSqlStr.append(" and contno='"+contNo+"'");
            tSqlStr.append(" and TranDate =").append(DateUtil.date10to8(tranDate));
            //���ڲ�ѯ������117
            tSqlStr.append(" and FuncFlag=117");
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
        
        
		cLogger.info("Out IcbcMQEdrConfirmFormat.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcMQEdrConfirmFormat.std2NoStd()...");

		Document mNoStdXml = null;
		String tMainRiskCode = XPath.newInstance("/TranData/Body/PubContInfo/ContPlanCode").valueOf(pStdXml.getRootElement());
		//PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ����
		if("50002".equals(tMainRiskCode) || "50015".equals(tMainRiskCode)){
			
			/*
			 * ��ϲ�Ʒ50002-�������Ӯ���ռƻ�: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���ɣ�
			 * ǰ����50002����Ʒ������Ϊ122046�������������յĲ�ƷΪ122048,���5������˱�ʱ���Ĵ����������ֱ����122048
			 */
			
			mNoStdXml = IcbcMQEdrConfirmFormatOutXsl50002.newInstance().getCache().transform(pStdXml);
			
			cLogger.info("ICBC_�������У�����IcbcMQEdrConfirmFormatOutXsl50002���б���ת����");
			
		}else{	// ������Ʒ
			
			mNoStdXml = IcbcMQEdrConfirmFormatOutXsl.newInstance().getCache().transform(pStdXml);
			
			cLogger.info("ICBC_�������У�����IcbcMQEdrConfirmFormatOutXsl���б���ת����");
		}
		

		cLogger.info("Out IcbcMQEdrConfirmFormat.std2NoStd()!");
		return mNoStdXml;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {

		
//		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/icbc/1_in.xml"));
//		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/icbc/11_out.xml")));
//		out.write(JdomUtil.toStringFmt(new IcbcMQEdrConfirmFormat(null).noStd2Std(doc)));
		
		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/icbc/3_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/icbc/33_out.xml")));
		out.write(JdomUtil.toStringFmt(new IcbcMQEdrConfirmFormat(null).std2NoStd(doc)));
		
		out.close();
		System.out.println("******ok*********");
		
	}
	
}

