package com.sinosoft.midplat.cebbank.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.check.CheckFieldManager;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		// ADD 2014-02-20, PBKINSR-238,  ���뽡����֪���Ϊ�յ�У��
		// ������֪
		String mHealthNotice = ((Element)XPath.newInstance("//HealthNotice").selectSingleNode(pNoStdXml.getRootElement())).getText().trim();
		if("".equals(mHealthNotice) || null==mHealthNotice){
			throw new MidplatException("������֪���Ϊ��");
		}
		
		// ��������ְҵ����
		String mInsuJobCode = ((Element)XPath.newInstance("//Insured/JobCode").selectSingleNode(pNoStdXml.getRootElement())).getText().trim();
		if("".equals(mInsuJobCode) || null==mInsuJobCode){
			throw new MidplatException("��������ְҵ���벻��Ϊ��");
		}
		
		// ADD 2014-03-10,PBKINSR-286, ���ӶԵ�֤���ȵ�У��
		String mContPrtNo = ((Element)XPath.newInstance("//ContPrtNo").selectSingleNode(pNoStdXml.getRootElement())).getText().trim();
		if(mContPrtNo.length()!=20){
			throw new MidplatException("��֤��������Ϊ20λ");
		}
		
		Document mStdXml =  NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		
		Element rootEle = mStdXml.getRootElement();
		
		//У�鱨���ֶ�
		String tranCom = XPath.newInstance("//Head/TranCom").valueOf(rootEle);
		String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
		if(errorMsg!=null){
		    throw new MidplatException(errorMsg);
		}
		
		//�ײʹ���
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(rootEle);
		if("50015".equals(tContPlanCode)){
		    // �������Ӯ���ռƻ���50002��Ϊ50015��PBKINSR-696_�������ʢ2��ʢ3��50002��Ʒ��������
		    // У�鱣���ڼ��Ƿ�¼����ȷ������Ӧ�ú���ϵͳУ�飬���Ǹ��ײͱȽ�����
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
		
		//���������˵�У�飬���Ƚ�����
        List<Element> tBnfList = XPath.selectNodes(mStdXml.getRootElement(), "//Body/Bnf");

        for (Element tBnfEle : tBnfList) {
            if("".equals(tBnfEle.getChildText("Name"))){
                throw new MidplatException("��������������Ϊ��");
            }
            if("".equals(tBnfEle.getChildText("RelaToInsured"))){
                throw new MidplatException("�������뱻�����˹�ϵ����Ϊ��");
            }
            if("".equals(tBnfEle.getChildText("IDType"))){
                throw new MidplatException("������֤�����Ͳ���Ϊ��");
            }
            if("".equals(tBnfEle.getChildText("IDNo"))){
                throw new MidplatException("������֤�����벻��Ϊ��");
            }
            if("".equals(tBnfEle.getChildText("Sex"))){
                throw new MidplatException("�������Ա���Ϊ��");
            }
            if("".equals(tBnfEle.getChildText("Birthday"))){
                throw new MidplatException("�����˳������ڲ���Ϊ��");
            }
        }
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		Document mNoStdXml = null;
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
			
		if("50015".equals(tContPlanCode)){
			/*
			 * �򱣼�Ҫ���޸Ĳ�Ʒ������50002��Ϊ50015
			 * ��ϲ�Ʒ 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			 * ��ϲ�Ʒ 50015: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ����
			 */
			mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else{	// ����ϲ�Ʒ
			mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		}
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\����\\abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}