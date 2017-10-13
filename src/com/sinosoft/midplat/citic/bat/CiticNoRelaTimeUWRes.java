package com.sinosoft.midplat.citic.bat;

import org.jdom.Element;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.citic.CiticConf;
import com.sinosoft.midplat.common.DateUtil;

/**
 * @Title: com.sinosoft.midplat.citic.bat.CiticNoRelaTimeUWRes.java
 * @Description: ��ʵʱ�˱�����ļ��ش�
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date May 29, 2014 2:47:32 PM
 * @version 
 *
 */
public class CiticNoRelaTimeUWRes extends UploadFileBatchService{

	public CiticNoRelaTimeUWRes() {
		super(CiticConf.newInstance(), "1107");	// funFlag="1107"-�������з�ʵʱ�˱�����ļ��ϴ�
	}

	@Override
	protected String getFileName() {

		Element mBankEle = thisRootConf.getChild("bank");
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("CITIC").append(mBankEle.getAttributeValue("insu"))
				.append("FSS").append(DateUtil.getDateStr(calendar, "yyyyMMdd")).append("RSP.txt");
		return strBuff.toString();
	}

	@Override
	protected void setBody(Element bodyEle) {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void setHead(Element head) {
		// TODO Auto-generated method stub
		
	}
	
}
