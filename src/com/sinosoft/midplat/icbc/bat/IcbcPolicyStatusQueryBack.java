/**
 * 
 */
package com.sinosoft.midplat.icbc.bat;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IcbcCipherUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.icbc.IcbcCodeMapping;
import com.sinosoft.midplat.icbc.IcbcConf;

/**
 * <p>保单状态变更回盘</p>
 * NRT = Not-Real-Time
 * @author liying
 * @date  2015-05-11
 */
/**
 * @author liying
 * @date   2015-05-11
 */
public class IcbcPolicyStatusQueryBack extends Balance  {
	
	private static final String BLC_FILE_TAG = "ENY";

	public IcbcPolicyStatusQueryBack() {
		super(IcbcConf.newInstance(), "127");
	}

	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}

	/** 
	 * 对账文件格式：
	 * ENY+保险公司代码+ENYIAAS保险公司代码_银行代码_批量日期_UPDATESTATUS_back.txt.des
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		return BLC_FILE_TAG + mBankEle.getAttributeValue("insu")+ BLC_FILE_TAG + "IAAS" + mBankEle.getAttributeValue("insu") + "_" +
		mBankEle.getAttributeValue(id)+"_" +DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"_UPDATESTATUS_back.txt.des";
	}

	protected String getBackupFileName() {
	    Element mBankEle = cThisConfRoot.getChild("bank");
	    return BLC_FILE_TAG + mBankEle.getAttributeValue("insu")+ BLC_FILE_TAG + "IAAS" + mBankEle.getAttributeValue("insu")+ "_" +
	    mBankEle.getAttributeValue(id) +"_" +DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"_UPDATESTATUS_back.txt";
	}
	
	/**
	 * 解析对账文件，组织成XML报文用于发送
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 * 
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into " + this.getClass().getName() + ".parse()...");
		InputStream fInput = null;
		try{
		    //解密文件
		    byte[] content = this.decrypt(pBatIs);
		    
		    //保存明文文件
		    this.saveFile(content, getBackupFileName());
		    
		    //新建流
		    fInput = new ByteArrayInputStream(content);
		}catch(Exception e){
		    cLogger.error("解密文件失败" + getFileName(), e);
		    throw new Exception ("解密文件失败"+ getFileName(),e);
		}finally{
		    if(pBatIs!=null){
		        pBatIs.close();
		    }
		}
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		BufferedReader mBufReader = new BufferedReader(
				new InputStreamReader(fInput, mCharset));
		
		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		//Element mPremEle = new Element(Prem);
		mBodyEle.addContent(mCountEle);
		//mBodyEle.addContent(mPremEle);
		long mSumPrem = 0;
		int mCount = 0;
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			
			//空行，直接跳过
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("空行，直接跳过，继续下一条！");
				continue;
			}
			
			Element tDetailEle = lineToNode(tLineMsg);
			
			mBodyEle.addContent(tDetailEle);
			
			mCount++;
			//mSumPrem += tPremFen;
		}
		mCountEle.setText(String.valueOf(mCount));
		//mPremEle.setText(String.valueOf(mSumPrem));
		mBufReader.close();	//关闭流
		
		cLogger.info("Out " + this.getClass().getName() + ".parse()!");
		return mBodyEle;
	}
	
	private byte[] decrypt(InputStream pBatIs)
            throws Exception {
        ByteArrayOutputStream fileBaos = new ByteArrayOutputStream();
        // 读取文件
        byte[] b = new byte[2048];
        int length = -1;
        while ((length = pBatIs.read(b)) != -1) {
            fileBaos.write(b, 0, length);
        }
        fileBaos.flush();

        // 解密文件
        byte[] content = fileBaos.toByteArray();
        content = new IcbcCipherUtil().decrypt(content, true);

        return content;
    }
	
	private void saveFile(byte[] content, String fileName){
        //新密钥写入密钥文件
        FileOutputStream temp = null;
        try {
            String path = this.cThisBusiConf.getChildTextTrim("localDir");
            String pathName = path+File.separator+fileName;
            cLogger.info("保存文件："+pathName+"...");
            temp = new FileOutputStream(pathName);
            temp.write(content);
            temp.flush();
        } catch (Exception e) {
            cLogger.error("保存文件失败!"+fileName, e);
        } finally {
            if (temp != null) {
                try{
                    temp.close();
                }catch(Exception e){
                    cLogger.error("关闭文件失败!"+fileName, e);
                }
            }
        }
	}
	
	/**
     * 将对账文件的每行数据转换为报文中的一个XML节点
     * 
     * 当前条数0|成功失败标志1|导入文件名2|失败原因3|交易日期4|业务种类5|	业务变更日期6|保险公司代码7|银行地区号8|投保单号9|保单合同号10|
     * 客户姓名11|客户证件类型12|客户证件号码13|保单最新状态14|保单到期日期15|备用字段1|备用字段2|备用字段3|备用字段4|
     * 
     * @param lineMsg
     * @return
     */
	private Element lineToNode(String lineMsg){
		String[] tSubMsgs = lineMsg.split("\\|", -1);
		
		Element tDetailEle = new Element(Detail);
		
		//保单号
		Element tContNo = new Element(ContNo);
		tContNo.setText(tSubMsgs[10]);
		tDetailEle.addContent(tContNo);
		//<!-- 投保人姓名-->
		Element tAppntName = new Element("AppntName");
		tAppntName.setText(tSubMsgs[11]);
		tDetailEle.addContent(tAppntName);
		//<!-- 投保人证件类型-->
		Element tAppntIDType = new Element("AppntIDType");
		tAppntIDType.setText(IcbcCodeMapping.idTypeToPGI(tSubMsgs[12]));
		tDetailEle.addContent(tAppntIDType);
		//<!-- 投保人证件号-->
		Element tAppntIDNo = new Element("AppntIDNo");
		tAppntIDNo.setText(tSubMsgs[13]);
		tDetailEle.addContent(tAppntIDNo);
		//<!-- 业务类型 -->
		Element tBusinessType = new Element("BusinessType");
		tBusinessType.setText(getBusinessType(tSubMsgs[5]));
		tDetailEle.addContent(tBusinessType);
		//<!-- 业务金额（分）-->
		
		
		//<!-- 银行端处理情况-->
		Element tHandleInfo = new Element("HandleInfo");
		//<!-- 处理日期（yyyymmdd）-->
		Element tTranDateEle = new Element(TranDate);
		tTranDateEle.setText(tSubMsgs[6]);
		tHandleInfo.addContent(tTranDateEle);
		
		//<!--银行端流水号-->
		Element tTranNoEle = new Element("TranNo");
		tTranNoEle.setText("");
		tHandleInfo.addContent(tTranNoEle);
		
		//<!-- 是否成功（0成功 1失败）-->
		Element tResultFlagEle = new Element("ResultFlag");
		tResultFlagEle.setText(tSubMsgs[1]);
		tHandleInfo.addContent(tResultFlagEle);
		
		//<!-- 错误码-->
		
		//<!-- 错误描述-->
		Element tResultMsgEle = new Element("ResultMsg");
		tResultMsgEle.setText(tSubMsgs[3]);
		tHandleInfo.addContent(tResultMsgEle);
		
		//<!-- 备注-->
		
		tDetailEle.addContent(tHandleInfo);
		
		
		return tDetailEle;
	}
	/**
	 * 业务类型映射（工行--核心）。
	 * </br>核心：RENEW-续期；CLAIM-理赔；AA个人增加保额、UP万能追加保费、ZP万能追加保费(双帐户)、CT退保、WT犹豫期退保、MQ满期给付
	 * </br>工行：001满期给付，002犹豫期撤保，003退保，004续期交费，005追加投保，099理赔终止
	 * @param type 
	 * @return
	 */
	private String getBusinessType( String type) {
	    if("004".equals(type)){
	        //RENEW-续期--->004续期交费
	        return "RENEW";
	    }else if("099".equals(type)){
	        //CLAIM-理赔--->099理赔终止
	        return "CLAIM";
	    }else if("005".equals(type)){
	        //AA个人增加保额--->005追加投保
	        return "AA";
        }else if("003".equals(type)){
            //CT退保--->003退保
            return "CT";
        }else if("002".equals(type)){
            //WT犹豫期退保--->002犹豫期撤保
            return "WT";
        }else if("001".equals(type)){
            //MQ满期给付--->001满期给付
            return "MQ";
        }
	    return "";
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		IcbcPolicyStatusQueryBack blc = new IcbcPolicyStatusQueryBack();
		blc.run();
	}

}
