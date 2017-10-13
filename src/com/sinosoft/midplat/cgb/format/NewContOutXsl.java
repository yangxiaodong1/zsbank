package com.sinosoft.midplat.cgb.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class NewContOutXsl extends XslCache {
	private static NewContOutXsl cThisIns = new NewContOutXsl(); //yxd  NewContOutXslde 的静态对象，为什么要这样写有什么好处？？？？

	private String cPath = "com/sinosoft/midplat/cgb/format/NewContOut.xsl";//yxd   NewContOut.xsl  文件的配置路径

	private NewContOutXsl() {    //NewContOutXsl 类的构造函数 
		load();             //yxd加载NewContOut.xsl 文件是要加载应答 报文的格式？？NewContOut.xsl有点看不懂呀
		FileCacheManage.newInstance().register(cPath, this);
	}

	public void load() {
		cLogger.info("Into NewContOutXsl.load()...");

		String mFilePath = SysInfo.cBasePath + cPath; // yxd 拼接路径
		cLogger.info("Start load " + mFilePath + "...");

		cXslFile = new File(mFilePath); //创建这个mFilePath路径的文件对象

		recordStatus();

		cXslTrsf = loadXsl(cXslFile); 
		cLogger.info("End load " + mFilePath + "!");

		// 是否输出xsl文件
		if (MidplatConf.newInstance().outConf()) {
			try {
				cLogger.info(
						JdomUtil.toString(
								JdomUtil.build(new FileInputStream(cXslFile)), ""));//yxd肯定转化什么 的都在这里
			} catch (IOException ex) {
				cLogger.error("输出xsl异常！", ex);
			}
		}

		cLogger.info("Out NewContOutXsl.load()!");
	}

	public static NewContOutXsl newInstance() {
		return cThisIns;
	}
}

