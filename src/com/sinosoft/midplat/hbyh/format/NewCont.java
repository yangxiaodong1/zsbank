package com.sinosoft.midplat.hbyh.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");

		//У��
		checkInNoStdDoc(pNoStdXml);
		
		Document mStdXml =  NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		Element rootEle = mStdXml.getRootElement();
		//�ײʹ���
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(rootEle);
		if("50015".equals(tContPlanCode)){
		    //������Ӯ�ײͣ��ײʹ�����50002����Ϊ50015
		    //У�鱣���ڼ��Ƿ�¼����ȷ������Ӧ�ú���ϵͳУ�飬���Ǹ��ײͱȽ�����
		    Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(rootEle);
		    Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(rootEle);
		    if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
		        //¼��Ĳ�Ϊ������
		       throw new MidplatException("���ײͱ����ڼ�Ϊ������"); 
		    }
		    //�������ڼ�����Ϊ��5��
		    insuYearFlag.setText("Y");
		    insuYear.setText("5");
		    
		}
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
			
		Document mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
	/**
	 * �����ж�����ı��Ľ���У��
	 * ��������������ְҵ��֪����
	 * @throws Exception
	 */
	private void checkInNoStdDoc(Document cNoStdXml) throws Exception{
		
		Element noStdRoot = cNoStdXml.getRootElement();
		
		String jobNotice = XPath.newInstance("//Body/JobNotice").valueOf(noStdRoot).trim();
		if(jobNotice.equals("Y")){
			throw new MidplatException("����ͨ����������������ְҵ��֪����");
		}
		
		String healthNotice = XPath.newInstance("//Body/HealthNotice").valueOf(noStdRoot).trim();
		if(healthNotice.equals("Y")){
			throw new MidplatException("����ͨ�������н�����֪����");
		}
	}

}
