package com.sinosoft.midplat.bjrcb.bat;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.bat.packer.FixedDelimiterPacker;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.bjrcb.BjrcbConf;
import com.sinosoft.midplat.common.DateUtil;

/**
 * @Title: com.sinosoft.midplat.bjrcb.bat.BjrcbNoRealTimeBlc.java
 * @Description: ����ũ���з�ʵʱ���ն���
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Jul 12, 2014 9:47:56 AM
 * @version 
 *
 */
public class BjrcbNoRealTimeBlc extends ABBalance {

	public BjrcbNoRealTimeBlc() {
		super(BjrcbConf.newInstance(), "1209");	// ��ʵʱ���ն���funFlag='1209'
	}

	/* (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 * ��ʵʱ���ն����ļ�����ʽ��BRCB_HANDTB_H_����.txt
	 */
	@Override
	protected String getFileName() {
		return  "BRCB_HANDTB_H_" + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".txt";
	}
	
    /* (non-Javadoc)
     * @see com.sinosoft.midplat.bat.ABBalance#getDefaultRecordPacker()
     * ����ũ���еķ�ʵʱ���˷ָ���Ϊ��";"������Ĭ�ϵģ�"|"���̴˴��踲д��
     */
    protected RecordPacker getDefaultRecordPacker(){
        return new FixedDelimiterPacker("\\;",';');
    }

	public static void main(String[] args) throws Exception{
		BjrcbNoRealTimeBlc blc = new BjrcbNoRealTimeBlc();
		blc.run();
		System.out.println("******ok*********");
    }
}
