package com.sinosoft.midplat.cmb.service;

import java.lang.reflect.Constructor;
import java.util.Date;
import java.util.TimerTask;

import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.XmlConf;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.service.Service;

public abstract class CmbBalance extends TimerTask implements XmlTag {
	protected final Logger cLogger = Logger.getLogger(getClass());
	
	private final XmlConf cThisConf;
	private final int cFuncFlag;	//���״���
	
	/**
	 * �ṩһ��ȫ�ַ��ʵ㣬ֻ��ÿ�ζ��˿�ʼʱ��ʼ����
	 * ȷ���ڸôζ��˴������������������һ���ԣ�
	 * ���ܿ���(ǰ��Ĵ�����0��ǰ���������0���)��Ӱ�졣
	 */
	protected Date cTranDate;
	
	protected String cResultMsg;
	
	/**
	 * �ṩһ��ȫ�ַ��ʵ㣬ֻ��ÿ�ζ��˿�ʼʱ���³�ʼ����
	 * ȷ���ڸôζ��˴������������������һ���ԣ�
	 * ���������ļ��Զ����ص�Ӱ�졣Ҳ����˵�����ζ�ʱ����һ��������
	 * ��������ļ����޸Ľ�������һ������ʱ��Ч����Ӱ�챾�Ρ�
	 */
	protected Element cMidplatRoot = null;
	protected Element cThisConfRoot = null;
	protected Element cThisBusiConf = null;
	
	public CmbBalance(XmlConf pThisConf, String pFuncFlag) {
		this(pThisConf, Integer.parseInt(pFuncFlag));
	}
	
	public CmbBalance(XmlConf pThisConf, int pFuncFlag) {
		cThisConf = pThisConf;
		cFuncFlag = pFuncFlag;
	}
	
	/**
	 * Ϊ��֤����Timer������Ϊĳ���һ���쳣����ֹ��������벶��run()�е������쳣��
	 */
	@SuppressWarnings("unchecked")
	public void run() {
		Thread.currentThread().setName(
				String.valueOf(NoFactory.nextTranLogNo()));
		cLogger.info("Into Balance.run()...");
		
		//�����һ�ν����Ϣ
		cResultMsg = null;
		
		try {
			if (null == cTranDate) {
				cTranDate = new Date();
			}
			
			cMidplatRoot = MidplatConf.newInstance().getConf().getRootElement();
			cThisConfRoot = cThisConf.getConf().getRootElement();
			cThisBusiConf = (Element) XPath.selectSingleNode(
					cThisConfRoot, "business[funcFlag='"+cFuncFlag+"']");
			
			Element tTranData = new Element(TranData);
			Document tInStdXml = new Document(tTranData);
			
			Element tHeadEle = getHead();
			tTranData.addContent(tHeadEle);
			
			//����ҵ������ȡ��׼���ر���
			String tServiceClassName = "com.sinosoft.midplat.service.ServiceImpl";
			//��midplat.xml���зǿ�Ĭ�����ã����ø�����
			String tServiceValue = cMidplatRoot.getChildText(service);
			if (null!=tServiceValue && !"".equals(tServiceValue)) {
				tServiceClassName = tServiceValue;
			}
			//����ϵͳ�ĸ��Ի������ļ����зǿ�Ĭ�����ã����ø�����
			tServiceValue = cThisConfRoot.getChildText(service);
			if (null!=tServiceValue && !"".equals(tServiceValue)) {
				tServiceClassName = tServiceValue;
			}
			tServiceValue = cThisBusiConf.getChildText(service);
			if (null!=tServiceValue && !"".equals(tServiceValue)) {
				tServiceClassName = tServiceValue;
			}
			cLogger.info("ҵ����ģ�飺" + tServiceClassName);
			Constructor<Service> tServiceConstructor = (Constructor<Service>) Class.forName(
					tServiceClassName).getConstructor(new Class[]{Element.class});
			Service tService = tServiceConstructor.newInstance(new Object[]{cThisBusiConf});
			Document tOutStdXml = tService.service(tInStdXml);
			
			cResultMsg = tOutStdXml.getRootElement().getChild(Head).getChildText(Desc);
			System.out.println("cResultMsg========="+cResultMsg);
			
			//����һЩ��������(һ���ǿ�ʵ�֣���Щ���׿�����Ҫ�ڴ˽���һЩ�ļ��ϴ�����)
			ending(tOutStdXml);
			
		} catch (Throwable ex) {
			cLogger.error("���׳���", ex);
			cResultMsg = ex.toString();
			
		}
		
		cTranDate = null;	//ÿ�����꣬�������
		
		cLogger.info("Out Balance.run()!");
	}
	
	protected Element getHead() {
		cLogger.info("Into Balance.getHead()...");
		
		Element mTranDate = new Element(TranDate);
		mTranDate.setText(DateUtil.getDateStr(cTranDate, "yyyyMMdd"));
		
		Element mTranTime = new Element(TranTime);
		mTranTime.setText(DateUtil.getDateStr(cTranDate, "HHmmss"));
		
		Element mTranCom = (Element) cThisConfRoot.getChild(TranCom).clone();
		
		Element mNodeNo = (Element) cThisBusiConf.getChild(NodeNo).clone();
		
		Element mTellerNo = new Element(TellerNo);
		mTellerNo.setText(CodeDef.SYS);
		
		Element mTranNo = new Element(TranNo);
		mTranNo.setText(getFileName());
		
		Element mFuncFlag = new Element(FuncFlag);
		mFuncFlag.setText(cThisBusiConf.getChildText(funcFlag));
		
		Element mHead = new Element(Head);
		mHead.addContent(mTranDate);
		mHead.addContent(mTranTime);
		mHead.addContent(mTranCom);
		mHead.addContent(mNodeNo);
		mHead.addContent(mTellerNo);
		mHead.addContent(mTranNo);
		mHead.addContent(mFuncFlag);

		cLogger.info("Out Balance.getHead()!");
		return mHead;
	}
	
	public final void setDate(Date pDate) {
		cTranDate = pDate;
	}
	
	public final void setDate(String p8DateStr) {
		cTranDate = DateUtil.parseDate(p8DateStr, "yyyyMMdd");
	}
	
	/**
	 * ���ݶ����ļ������������ɵ�������ļ���
	 */
	protected abstract String getFileName();
	
	/**
	 * �÷������ڵ������̨����֮�󱻵��á�
	 * Ĭ���ǿ�ʵ�֣���һЩ���⽻���п���������һЩ���Ի��Ķ����������
	 * ��������������з�ʵʱ�˱����ˣ��ڵ������̨�󣬽����ļ��ϴ������������ڴ˷�����ʵ�֡�
	 * @param Document pOutStdXml: ��̨���صı�׼���ġ�
	 */
	protected void ending(Document pOutStdXml) throws Exception {
		cLogger.info("Into Balance.ending()...");
		
		cLogger.info("do nothing, just out!");
		
		cLogger.info("Out Balance.ending()!");
	}
	
	public String getResultMsg() {
		return cResultMsg;
	}
}
