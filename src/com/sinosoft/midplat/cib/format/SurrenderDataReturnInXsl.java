package com.sinosoft.midplat.cib.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class SurrenderDataReturnInXsl extends XslCache {
	private static SurrenderDataReturnInXsl sdr = new SurrenderDataReturnInXsl();
	private String path = "com/sinosoft/midplat/cib/format/SurrenderDataReturnIn.xsl";
	
	public SurrenderDataReturnInXsl(){
		load();
		FileCacheManage.newInstance().register(path, this);
	}
	
	public void load() {
		cLogger.info("Into load SurrenderDataReturnInXsl.load()...");
		
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

		cLogger.info("Out load SurrenderDataReturnInXsl.load()!");
	}
	
	public static SurrenderDataReturnInXsl newInstance(){
		return sdr;
	}

}
