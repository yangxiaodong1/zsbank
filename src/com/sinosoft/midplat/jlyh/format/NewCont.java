package com.sinosoft.midplat.jlyh.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
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
		    //������Ӯ�ײͣ���50002����Ϊ50015
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
	 * �������ֽ�ɷ�
	 * Ͷ���˺��˻���һ��
	 * @throws Exception
	 */
	private void checkInNoStdDoc(Document cNoStdXml) throws Exception{
		
		Element noStdRoot = cNoStdXml.getRootElement();
		
		String tPayMode = XPath.newInstance("//Risk/PayMode").valueOf(noStdRoot);
		if("1".equals(tPayMode)){
			throw new MidplatException("����ͨ������֧���ֽ�ɷѡ�");
		}
		
		// Ͷ��������
		String appName = XPath.newInstance("//Appnt/Name").valueOf(noStdRoot).trim();
		// �ɷ��˻�����
		String accName = XPath.newInstance("//AccName").valueOf(noStdRoot).trim();
		if(!appName.equals(accName)){
			throw new MidplatException("Ͷ������ɷ��˻���������ͬһ�ˡ�");
		}
		
		String jobNotice = XPath.newInstance("//Body/JobNotice").valueOf(noStdRoot).trim();
		if(jobNotice.equals("Y")){
			throw new MidplatException("����ͨ����������������ְҵ��֪����");
		}
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("D:/YBT_TEST/jlyh/122010_1800_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("D:/YBT_TEST/jlyh/122010_1800_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    	
    }
}
