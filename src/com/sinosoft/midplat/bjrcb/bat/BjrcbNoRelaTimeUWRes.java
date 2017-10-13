package com.sinosoft.midplat.bjrcb.bat;

import org.jdom.Element;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.bjrcb.BjrcbConf;
import com.sinosoft.midplat.common.DateUtil;

/**
 * @Title: com.sinosoft.midplat.bjrcb.bat.BjrcbNoRelaTimeUWRes.java
 * @Description: ����ũ�̷�ʵʱ�˱�����ļ��ϴ�
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Jul 12, 2014 3:35:40 PM
 * @version 
 *
 */
public class BjrcbNoRelaTimeUWRes extends UploadFileBatchService{
	
	public BjrcbNoRelaTimeUWRes() {
		super(BjrcbConf.newInstance(), "1210");	// funFlag="1210"-����ũ�����з�ʵʱ�˱�����ļ��ϴ�
	}

	/* (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.UploadFileBatchService#getFileName()
	 * ��ʵʱ�˱�����ļ�����ʽ��BRCB_HANDTB_L_����.txt
	 */
	@Override
	protected String getFileName() {
		return  "BRCB_HANDTB_L_" + DateUtil.getCur8Date() + ".txt";
	}

	/* (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.UploadFileBatchService#setBody(org.jdom.Element)
	 * �򱱾�ũ����Ҫ�󷵸����е����ն����ļ���������Ϊ������Ϣ����ÿ��Ͷ����¼�еı�����Ҫ���ܣ����ڴ˽��д���
	 * ��������������...
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
