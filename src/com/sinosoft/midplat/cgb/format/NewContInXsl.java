package com.sinosoft.midplat.cgb.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class NewContInXsl extends XslCache {
	private static NewContInXsl cThisIns = new NewContInXsl();//yxd 创建一个NewContInXsl对象？  自己对象可以在自己中创建自己的对象吗？？

	private String cPath = "com/sinosoft/midplat/cgb/format/NewContIn.xsl"; //yxd NewContIn.xsl文件的路径

	private NewContInXsl() {  //NewContInXsl类的构造方法
		load();// yxd 加载
		FileCacheManage.newInstance().register(cPath, this);// yxd 点击不进去，这个注册不知道是什么意思？？
	}

	public void load() { //加载这个作用是啥？？ 看完load方法还是不知道
		cLogger.info("Into NewContInXsl.load()...");//yxd 日志输出进入NewContInXsl 类中的加载方法

		String mFilePath = SysInfo.cBasePath + cPath; //yxd SysInfo.cBasePath这个点击不进去不知道这个路径是什么
		cLogger.info("Start load " + mFilePath + "...");//yxd 打印出现在拼接好的路径

		cXslFile = new File(mFilePath); //yxd 创建一个文件流对象 根据mFilePath 这个路径

		recordStatus(); //调用记录状态方法？？？？不知道干嘛的啥意思

		cXslTrsf = loadXsl(cXslFile);//yxd ？？？？？
		cLogger.info("End load " + mFilePath + "!");

		// 是否输出xsl文件
		if (MidplatConf.newInstance().outConf()) { //如果核心接口类的 是输出xsl的就执行下面的
			try {
				cLogger.info(
						JdomUtil.toString(
								JdomUtil.build(new FileInputStream(cXslFile)), "")); //yxd输出cXslFile 文件？？？到底是什么样的格式作用是啥
			} catch (IOException ex) {
				cLogger.error("输出xsl异常！", ex); //当输出错误的时候 输出错误信息
			}
		}

		cLogger.info("Out NewContInXsl.load()!");//yxd 输出日志
	}

	public static NewContInXsl newInstance() {  //这一个方法是干嘛的？？？ 静态方法
		return cThisIns;
	}
}
