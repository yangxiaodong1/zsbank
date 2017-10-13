package com.sinosoft.midplat.cgb.format;

import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class Cgb_TransForm {

	public static String proPosalNOToPolicyNO(String proposalPrtNo) {
		StringBuffer mSqlStr = new StringBuffer();
	    mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where ProposalPrtNo = '"+proposalPrtNo+"' " +
	    		" and Funcflag = '3801' and Rcode = '0' order by Maketime desc");
	    
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (mSSRS.MaxRow < 1) {
            return proposalPrtNo;
        }      
        return mSSRS.GetText(1,2);

     }
	
	public static String get8Date(String dateStr) {
		
		if(dateStr != null && !"".equals(dateStr.trim())){
			return dateStr.substring(0,8);
		}
             
        return dateStr;

     }
}
