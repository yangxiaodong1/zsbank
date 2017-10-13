package com.sinosoft.midplat.bjrcb.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class NewContJobCode extends XslCache {
	private static NewContJobCode cThisIns = new NewContJobCode();

	private String cPath = "com/sinosoft/midplat/bjrcb/format/NewContJobCode.xml";
	private HashMap<String, String> jobMap = new HashMap<String, String>();
	private NewContJobCode() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}

	public void load() {
		cLogger.info("Into NewContJobCode.load()...");

		String mFilePath = SysInfo.cBasePath + cPath;
		cLogger.info("Start load " + mFilePath + "...");

		cXslFile = new File(mFilePath);

		/**
		 * һ��Ҫ�ڼ���֮ǰ��¼�ļ����ԡ� �ļ��ļ��ص��ļ���������֮�����ϸ΢��ʱ�� ���ǡ���ڴ�ʱ������ⲿ�޸����ļ���
		 * ��ô��¼�����ݾ������޸ĺ�ģ���������޸Ĳ����Զ������أ� ���ļ��������÷��ڼ���֮ǰ��������ʱ������ļ������ı䣬
		 * ���ڼ�¼���Ǿɵ����ԣ�ϵͳ������һ��ʱ�䵥Ԫ���¼��أ� ��������ᵼ��ͬһ�ļ������һ�Σ�����������޸Ķ��������ص�bug��
		 */
		recordStatus();

		try{
		    Document doc = JdomUtil.build(new FileInputStream(cXslFile),"GBK");
		    Iterator<Element> it = doc.getRootElement().getChildren().iterator();
		    while(it.hasNext()){
		        Element codeEle = it.next();
		        String outcode = codeEle.getAttributeValue("outcode");
		        String code = codeEle.getTextTrim();
		        jobMap.put(outcode, code);
		       // cLogger.debug(outcode +"--->" +code);
		    }
		}catch(Exception e){
		    cLogger.error("���ر���ũ����ְҵ����ʧ��", e);
		}
		cLogger.info("End load " + mFilePath + "!");

		// �Ƿ����xsl�ļ�
		if (MidplatConf.newInstance().outConf()) {
			try {
				cLogger.info(JdomUtil.toString(JdomUtil
						.build(new FileInputStream(cXslFile)), ""));
			} catch (IOException ex) {
				cLogger.error("���xsl�쳣��", ex);
			}
		}

		cLogger.info("Out NewContJobCode.load()!");
	}

	public static NewContJobCode newInstance() {
		return cThisIns;
	}
	
	public String getJobCode(String outCode){
	    if(outCode==null){
	        return "--";
	    }else{
	        String code = jobMap.get(outCode);
	        if(code == null){
	            return "--";
	        }
	        return code;
	    }
	}
	
	public static void main(String args[]){
	    System.out.println(NewContJobCode.newInstance().getJobCode("010108"));
	}
}
