package com.sinosoft.midplat.abc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisConf) {
		super(pThisConf);
	}

	/* 
	 * ���ж˷Ǳ�׼����ת��Ϊ��׼����
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");

		Document mStdXml = null;
		
		//��ȡ���մ���
		String mainRiskCode = XPath.newInstance("/Req/Risks/Risk/MainRiskCode").valueOf(pNoStdXml.getRootElement());
        
		// ũ�����ߵ���ϲ�Ʒ50001�����ж˴�����ϲ�Ʒ�����մ���122046�������ݲ�Ʒ�����50001
		if("122046".equals(mainRiskCode)){ // ��ϲ�Ʒ50001��122046-�������Ӯ1����ȫ���� + 122047-����ӳ�����Ӯ��ȫ����
			
			mStdXml = NewContIn50001.newInstance().getCache().transform(pNoStdXml);
			cLogger.info("ABC-�й�ũҵ���У�����NewContIn50001���б���ת������Ʒ��ϱ���contPlanCode=[50001]");
		}else{
			
			mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
			cLogger.info("ABC-�й�ũҵ���У�NewContInXsl���б���ת��������riskCode=[" + mainRiskCode + "]");
		}
        
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
        
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;

	}

	/* 
	 * ���ı�׼����ת��Ϊ���ж˷Ǳ�׼����
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		
		Document mNoStdXml = null;
		
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
        
		if(null == tContPlanCode || "".equals(tContPlanCode)){	// ���ǲ�Ʒ���
			//��ȡ���մ���
			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(pStdXml.getRootElement());

			if("122035".equals(mainRiskCode) || "122036".equals(mainRiskCode)){
				// 122035-����ʢ��9����ȫ���գ������ͣ�,122036-����ƽ�6����ȫ���գ��ֺ��ͣ�A��
            	
				mNoStdXml = ContConfirmOutXsl4SpeFormat.newInstance().getCache().transform(pStdXml);
				cLogger.info("ABC-�й�ũҵ���У�����ContConfirmOutXsl4SpeFormat���б���ת�������riskcode=[" + mainRiskCode + "]");
			}else{	// ��ͳģ��
				
				mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
				cLogger.info("ABC-�й�ũҵ���У�NewContOutXsl���б���ת�������riskcode=[" + mainRiskCode + "]");
			}
		}else if("50001".equals(tContPlanCode)){	// ����ϲ�Ʒ
			mNoStdXml = ContConfirmOut50001.newInstance().getCache().transform(pStdXml);
			cLogger.info("ABC-�й�ũҵ���У�����ContConfirmOut50001���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}else if("50002".equals(tContPlanCode)){
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("ABC-�й�ũҵ���У�����ContConfirmOut50002���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}
		
		
		Element mMessages=mNoStdXml.getRootElement().getChild("Messages");
		Element mPrnts=mNoStdXml.getRootElement().getChild("Prnts");
		if(mMessages!=null){
			cLogger.info("��Messages�µ�count��ֵ");
			List mMessageList=mMessages.getChildren("Message");
			Element mCount=mMessages.getChild("Count");
			cLogger.info("Count====="+String.valueOf(mMessageList.size()));
			mCount.setText(String.valueOf(mMessageList.size()));
		}
		if(mPrnts!=null){
			cLogger.info("��Prnts�µ�count��ֵ");
			List mPrntList=mPrnts.getChildren("Prnt");
			cLogger.info("Count====="+String.valueOf(mPrntList.size()));
			Element mCount=mPrnts.getChild("Count");
			cLogger.info("Count object==="+mCount);
			mCount.setText(String.valueOf(mPrntList.size()));
		}

		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
	   public static void main(String[] args) throws Exception {
	        
	        Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/abc/funcflag=401�б�/out_std.xml"));
	    
		    BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/abc/funcflag=401�б�/out_nostd.xml")));
		    out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
		    out.close();
		    System.out.println("******ok*********");
	    }
}