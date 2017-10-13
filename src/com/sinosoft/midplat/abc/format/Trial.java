package com.sinosoft.midplat.abc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.regex.Pattern;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class Trial extends XmlSimpFormat {
	public Trial(Element pThisConf) {
		super(pThisConf);
	}

	/**
	 * ���еķǱ�׼����-->���ĵı�׼���� 
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Trial.noStd2Std()...");

		Document mStdXml = null;
		
		//��ȡ���մ���
        String mainRiskCode = XPath.newInstance("/Req/Risks/Risk/MainRiskCode").valueOf(pNoStdXml.getRootElement());
        
        // ũ�����ߵ���ϲ�Ʒ50001�����ж˴�����ϲ�Ʒ�����մ���122046�������ݲ�Ʒ�����50001
        if("122046".equals(mainRiskCode)){// ��ϲ�Ʒ50001��122046-�������Ӯ1����ȫ���� + 122047-����ӳ�����Ӯ��ȫ���գ�
        	
        	mStdXml = NewContIn50001.newInstance().getCache().transform(pNoStdXml);
			cLogger.info("ABC-�й�ũҵ���У�����NewContIn50001���б���ת������Ʒ��ϱ���contPlanCode=[50001]");
        }else{
        	
        	mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
        	cLogger.info("ABC-�й�ũҵ���У�NewContInXsl���б���ת��������riskCode=[" + mainRiskCode + "]");
        }
        
		// �����ж�����ı��Ľ���У��
		checkNoStdDoc(mStdXml);
		
		//��ȡ�ײʹ���
        String planCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(mStdXml.getRootElement());
        if("50002".equals(planCode)){	// �������Ӯ���ռƻ���ȫ����

            //У�鱣���ڼ��Ƿ�¼����ȷ������Ӧ�ú���ϵͳУ�飬���Ǵ��ײͱȽ�����
            Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(mStdXml.getRootElement());
            Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(mStdXml.getRootElement());
            if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
                //¼��Ĳ�Ϊ������
                throw new MidplatException("�������󣺱����ڼ�ӦΪ����!"); 
            }

            //�������ڼ�����Ϊ��5��
            insuYearFlag.setText("Y");
            insuYear.setText("5");
        }

		cLogger.info("Out Trial.noStd2Std()!");
		return mStdXml;
	}
	
	/**
	 * �����ж�����ı��Ľ���У��
	 * @param cStdXml
	 * @return
	 * @throws Exception
	 */
	private void checkNoStdDoc(Document cStdXml) throws Exception {
		
		Element mBodyEle = cStdXml.getRootElement().getChild(Body);
		String appIDTypeEndDate = "";	// ֤����Чֹ��
		String retMsg = "";
		String insuIDTypeEndDate = "";
		
		appIDTypeEndDate = mBodyEle.getChild(Appnt).getChildText("IDTypeEndDate");	// IDTypeEndDate--Ͷ����֤����Чֹ��
		// 1. Ͷ����֤����Ч�ڲ���Ϊ��
		if(null == appIDTypeEndDate || "".equals(appIDTypeEndDate)){
			throw new MidplatException("Ͷ���˵�֤����Чֹ�ڲ���Ϊ��");
		}
		
		// 2. Ͷ����֤������У�飺8λ����
		retMsg = checkValidDate(appIDTypeEndDate);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("Ͷ����" + retMsg);	
		}
		
		// 3. ������֤����Ч�ڲ���Ϊ��
		insuIDTypeEndDate = mBodyEle.getChild(Insured).getChildText("IDTypeEndDate");	// IDTypeEndDate--������֤����Чֹ��
		if(null == insuIDTypeEndDate || "".equals(insuIDTypeEndDate)){
			throw new MidplatException("�����˵�֤����Чֹ�ڲ���Ϊ��");
		}
		
		// 4. Ͷ����֤������У�飺8λ����
		retMsg = checkValidDate(insuIDTypeEndDate);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("������" + retMsg);	
		}
		
	}
	
	/**
	 * ֤��Ϊ8λ���֣��粻�Ƿ�����Ӧ��ʾ����������������null
	 * @param cZipCode
	 * @return
	 */
	private String checkValidDate(String cValidDate){
		
		if(null == cValidDate || "".equals(cValidDate)){
			return "֤������Ϊ��";
		}else{
			if(cValidDate.length()!=8 || (!checkNumber(cValidDate))){
				return "֤��ӦΪ8λ����";
			}
			return null;
		}
	}
	
	/**
	 * @Description: �ж�������ַ��Ƿ�Ϊ���֣�����Ƿ���true�����򷵻�false����������ַ���Ϊ��Ҳ����false
	 * @param str �����ַ���
	 * @return
	 */
	private boolean checkNumber(String str){
		
			Pattern pattern = Pattern.compile("[0-9]*"); 
			if(!pattern.matcher(str).matches()){
				return false;
			}else{
				return true;
			}
	}

	/**
	 * ���ĵı�׼����-->���еķǱ�׼����
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Trial.std2NoStd()...");

		Document mNoStdXml = null;
		
		String  contPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		
		if(null == contPlanCode || "".equals(contPlanCode)){	// �߷ǲ�Ʒ���
			cLogger.info("ABC-�й�ũҵ���У�NewContOutXsl���б���ת��");
			mNoStdXml = TrialOutXsl.newInstance().getCache().transform(pStdXml);
		
		}else if("50001".equals(contPlanCode) || "50002".equals(contPlanCode)){	// ��ϲ�Ʒ50001��122046-�������Ӯ1����ȫ���� + 122047-����ӳ�����Ӯ��ȫ���գ�
        	
			cLogger.info("ABC-�й�ũҵ���У�����NewContOut50001���б���ת������Ʒ��ϱ���contPlanCode=[" + contPlanCode + "]");
			mNoStdXml = NewContOut50001.newInstance().getCache().transform(pStdXml);
		}
		
		cLogger.info("Out Trial.std2NoStd()!");
		return mNoStdXml;
	}
	
	
	public static void main(String[] args) throws Exception{
    	
        Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/abc/funcflag=400����/400_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/abc/funcflag=400����/400_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
        
    	/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/abc/1101/2_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/abc/1101/2_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));*/
        out.close();
        System.out.println("******ok*********");
    }
}