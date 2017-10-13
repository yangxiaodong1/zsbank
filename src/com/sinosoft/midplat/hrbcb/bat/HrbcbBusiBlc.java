package com.sinosoft.midplat.hrbcb.bat;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.hrbcb.HrbcbConf;

public class HrbcbBusiBlc extends ABBalance {

    public HrbcbBusiBlc() {
        super(HrbcbConf.newInstance(), 2604);
    }

    protected String getFileName() {
        return  "HRBB"
                + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + "01.txt";
    }
    
    
}
