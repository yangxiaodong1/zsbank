package com.sinosoft.midplat.hxb.bat;

import java.io.InputStream;
import java.lang.reflect.Constructor;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.cgb.bat.CgbBusiBlc;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.format.Format;
import com.sinosoft.midplat.hxb.HxbConf;

/**
 * @Title: com.sinosoft.midplat.hxb.bat.HxbBusiBlc.java
 * @Description: 华夏银行日终对账处理类
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Apr 10, 2014 10:38:07 AM
 * @version 
 *
 */
public class HxbBusiBlc extends Balance{

	
	public HxbBusiBlc() {
		super(HxbConf.newInstance(), 1505);	// 华夏银行日终对账
	}
	
	/* 设置对账报文头
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getHead()
	 */
	protected Element getHead() {
		
        Element mHead = super.getHead();
        Element mBankCode = new Element("BankCode");
        mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
        mHead.addContent(mBankCode);
        return mHead;
    }

	/* 获取对账文件名
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	protected String getFileName() {
		/*
		 * 文件命名规则：B+银行代码（3041000）+保险公司代码（银行定义）+业务日期(8位) + .xml
		 */
		Element mBankEle = cThisConfRoot.getChild("bank");
		StringBuffer strBuff = new StringBuffer();
		String tFileName = strBuff.append("B").append(
				mBankEle.getAttributeValue("id")).append(
				mBankEle.getAttributeValue("insu")).append(
				DateUtil.get8Date(cTranDate)).append(".xml").toString();
		
		return tFileName;
	}
	
	/* 进行报文格式转
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		
		cLogger.info("Into HxbBusiBlc.parse()...");
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		Document pNoStdXml = JdomUtil.build(pBatIs, mCharset);
		
		//日志前缀
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cThisBusiConf.getChildText(funcFlag)).append(
				"_in.xml");
        
		SaveMessage.save(pNoStdXml, cThisConfRoot.getChildText(TranCom), mSaveName.toString());
		cLogger.info("保存非标准请求报文完毕！");

		String tFormatClassName = cThisBusiConf.getChildText(format);

		//报文转换模块
		cLogger.info((new StringBuilder("报文转换模块：")).append(tFormatClassName).toString());
        
		Constructor tFormatConstructor =  Class.forName(tFormatClassName).getConstructor(new Class[] { Element.class });
		Format tFormat = (Format) tFormatConstructor.newInstance(new Object[] { cThisBusiConf });

		//将xml转换成标准报文
		cLogger.info("convert nonstandard xml to standard xml...");
		Document pStdXml = tFormat.noStd2Std(pNoStdXml);
		
		Element mBody = pStdXml.getRootElement().getChild(Body);
		mBody.detach();
//		JdomUtil.print(mBody);
		return mBody;
	}

    public static void main(String[] Str) throws Exception {
    	
    	HxbBusiBlc blc = new HxbBusiBlc();
    	
    	blc.run();
    }	
}


