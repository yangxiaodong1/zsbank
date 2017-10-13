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
 * <p>非实时核保结果文件回盘</p>
 * NRT = Not-Real-Time
 * @author liying
 * @date  2015-05-11
 */
/**
 * @author liying
 * @date   2015-05-11
 */
public class IcbcBlcResultFileBack extends Balance  {
	
	private static final String BLC_FILE_TAG = "ENY";

	public IcbcBlcResultFileBack() {
		super(IcbcConf.newInstance(), "126");
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
	 * ENY+保险公司代码+ENY(3位)+IAAS+保险公司代码(3位)+银行代码（2位）+日期（8位，yyyymmdd）+03_back.txt.des
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		return BLC_FILE_TAG + mBankEle.getAttributeValue("insu")+ BLC_FILE_TAG + "IAAS" + mBankEle.getAttributeValue("insu")+
		mBankEle.getAttributeValue(id)+DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"03_back.txt.des";
	}

	protected String getBackupFileName() {
	    Element mBankEle = cThisConfRoot.getChild("bank");
	    return BLC_FILE_TAG + mBankEle.getAttributeValue("insu")+ BLC_FILE_TAG + "IAAS" + mBankEle.getAttributeValue("insu")+
	    mBankEle.getAttributeValue(id)+DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"03_back.txt";
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
     * 当前条数0|成功失败标志1|导入文件名2|失败原因3|地区号4| 保险公司代码5|  银行交易流水号6| 投保单印刷号7| 保单号8| 
     * 核保结论 9| 备注10 | 首期总保费11 | 被保人姓名12|  被保人证件类型13| 被保人证件号码14| 交费方式15|
     * 主险险种代码16| 核保结论状态17| 份数18| 保费19| 保额20| 保险期间类型21 | 保险期间22 | 缴费年期类型23 | 缴费年期24。。。。
     * 
     * @param lineMsg
     * @return
     */
	private Element lineToNode(String lineMsg){
		String[] tSubMsgs = lineMsg.split("\\|", -1);
		
		Element tDetailEle = new Element(Detail);
		
		//保单号
		Element tContNo = new Element(ContNo);
		tContNo.setText(tSubMsgs[8]);
		tDetailEle.addContent(tContNo);
		//<!-- 投保日期(yyyyMMdd)-->
		
		//<!-- 承保日期(yyyyMMdd)-->
		
		//<!--首期总保费-->
		Element tPremEle = new Element(Prem);
		tPremEle.setText(tSubMsgs[11]);
		tDetailEle.addContent(tPremEle);
		
		//<!-- 投保人(工行没有投保人信息)-->
		Element tAppnt = new Element("Appnt");
		tDetailEle.addContent(tAppnt);
		
		//<!--被保人信息-->
		Element tInsured = new Element("Insured");
		//<!--被保人姓名-->
		Element tName = new Element("Name");
		tName.setText(tSubMsgs[12]);
		tInsured.addContent(tName);
		
		//<!-- 性别 新增-->
		
		//<!-- 出生日期(yyyyMMdd) 新增--> 
		
		//<!--被保人证件类型--> 
		Element tIDType = new Element("IDType");
		tIDType.setText(IcbcCodeMapping.idTypeToPGI(tSubMsgs[13]));
		tInsured.addContent(tIDType);
		
		//<!--被保人证件号--> 
		Element tIDNo = new Element("IDNo");
		tIDNo.setText(tSubMsgs[14]);
		tInsured.addContent(tIDNo);
		
		tDetailEle.addContent(tInsured);
		
		//<!-- 银行端处理情况-->
		Element tHandleInfo = new Element("HandleInfo");
		//<!-- 处理日期（yyyymmdd）-->
		Element tTranDateEle = new Element(TranDate);
		tTranDateEle.setText(DateUtil.getDateStr(cTranDate, "yyyyMMdd"));
		tHandleInfo.addContent(tTranDateEle);
		
		//<!--银行端流水号-->
		Element tTranNoEle = new Element("TranNo");
		tTranNoEle.setText(tSubMsgs[6]);
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
	 * @param args
	 */
	public static void main(String[] args) {
		IcbcBlcResultFileBack blc = new IcbcBlcResultFileBack();
		blc.run();
	}

}
