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
		 * 一定要在加载之前记录文件属性。 文件的加载到文件属性设置之间存在细微的时间差， 如果恰巧在此时间差内外部修改了文件，
		 * 那么记录的数据就是新修改后的，导致这次修改不会自动被加载； 将文件属性设置放在加载之前，就算在时间差内文件发生改变，
		 * 由于记录的是旧的属性，系统会在下一个时间单元重新加载， 这样顶多会导致同一文件多加载一次，但不会出现修改而不被加载的bug。
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
		    cLogger.error("加载北京农商行职业代码失败", e);
		}
		cLogger.info("End load " + mFilePath + "!");

		// 是否输出xsl文件
		if (MidplatConf.newInstance().outConf()) {
			try {
				cLogger.info(JdomUtil.toString(JdomUtil
						.build(new FileInputStream(cXslFile)), ""));
			} catch (IOException ex) {
				cLogger.error("输出xsl异常！", ex);
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
