package com.sinosoft.midplat.jsbc.bat;

import org.jdom.Element;
import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.bat.packer.FixedDelimiterPacker;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.jsbc.JsbcConf;
import com.sinosoft.midplat.common.DateUtil;

/**
 * 江苏银行非实时业务对账
 * @author AB044104
 *
 */
public class JsbcNoRealTimeBlc extends ABBalance {

    public JsbcNoRealTimeBlc() {
        super(JsbcConf.newInstance(), 3305);
    }

    /**
     *JSYH_F_+保险公司编号+对账日期（YYYYMMDD）.txt（例如：JSYH_F_0051_20140805.txt）；
     */
    protected String getFileName() {
        Element mBankEle = cThisConfRoot.getChild("bank");
        return  "JSYH_F_" + mBankEle.getAttributeValue("insu") + "_"
                + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".txt";
    }
    
    /**
     * 设置默认拆包器
     * @param packer
     */
    protected RecordPacker getDefaultRecordPacker(){
    	 return new FixedDelimiterPacker("\\※",'※');
    }
    
}
