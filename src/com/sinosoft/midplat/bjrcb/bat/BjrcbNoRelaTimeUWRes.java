package com.sinosoft.midplat.bjrcb.bat;

import org.jdom.Element;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.bjrcb.BjrcbConf;
import com.sinosoft.midplat.common.DateUtil;

/**
 * @Title: com.sinosoft.midplat.bjrcb.bat.BjrcbNoRelaTimeUWRes.java
 * @Description: 北京农商非实时核保结果文件上传
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Jul 12, 2014 3:35:40 PM
 * @version 
 *
 */
public class BjrcbNoRelaTimeUWRes extends UploadFileBatchService{
	
	public BjrcbNoRelaTimeUWRes() {
		super(BjrcbConf.newInstance(), "1210");	// funFlag="1210"-北京农商银行非实时核保结果文件上传
	}

	/* (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.UploadFileBatchService#getFileName()
	 * 非实时核保结果文件名格式：BRCB_HANDTB_L_日期.txt
	 */
	@Override
	protected String getFileName() {
		return  "BRCB_HANDTB_L_" + DateUtil.getCur8Date() + ".txt";
	}

	/* (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.UploadFileBatchService#setBody(org.jdom.Element)
	 * 因北京农商行要求返给银行的日终对账文件首行内容为汇总信息，且每条投保记录中的保额需要汇总，故在此进行处理。
	 * 上述方案不可行...
	 */
	@Override
	protected void setBody(Element bodyEle) {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void setHead(Element head) {
		// TODO Auto-generated method stub
		
	}
	
	public static void main(String[] args) throws Exception{
		BjrcbNoRelaTimeUWRes blc = new BjrcbNoRelaTimeUWRes();
		blc.run();
		System.out.println("******ok*********");
    }

}
