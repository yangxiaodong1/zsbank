package com.sinosoft.midplat.cib.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class SurrenderDataReturnOutXsl extends XslCache {
	
	private static SurrenderDataReturnOutXsl sdr = new SurrenderDataReturnOutXsl();
	
	private String path = "com/sinosoft/midplat/cib/format/SurrenderDataReturnOut.xsl";
	
	public SurrenderDataReturnOutXsl(){
		load();
		FileCacheManage.newInstance().register(path, this);
	}

	public void load() {

		cLogger.info("Into load SurrenderDataReturnOutXsl.load()...");
		
		String mpath = SysInfo.cBasePath + path;
		cLogger.info("Start load " + mpath +"...");
		cXslFile = new File(mpath);
		recordStatus();
		cXslTrsf = loadXsl(cXslFile);
		cLogger.info("End load " + mpath +"!");
		
		if(MidplatConf.newInstance().outConf()){
			try {
				cLogger.info(JdomUtil.toString(JdomUtil.build(new FileInputStream(cXslFile))));
			} catch (IOException e) {
				cLogger.error(" ‰≥ˆxsl“Ï≥££°",e);
			}
		}
		
		cLogger.info("Out load SurrenderDataReturnOutXsl.load()!");
		
	}
	
	public static SurrenderDataReturnOutXsl newInstance(){
		return sdr;
	}

}
