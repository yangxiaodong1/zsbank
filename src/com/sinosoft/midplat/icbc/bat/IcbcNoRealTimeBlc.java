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
import com.sinosoft.midplat.icbc.IcbcCodeMapping;
import com.sinosoft.midplat.icbc.IcbcConf;

/**
 * <p>工行非实时(NRT)核保</p>
 * NRT = Not-Real-Time
 * @author ChengNing
 * @date   Mar 28, 2013
 */
/**
 * @author ChengNing
 * @date   Mar 28, 2013
 */
public class IcbcNoRealTimeBlc extends Balance  {
	
	private static final String BLC_FILE_TAG = "ENY";

	public IcbcNoRealTimeBlc() {
		super(IcbcConf.newInstance(), "121");
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
	 * ENY(3位)+保险公司代码(3位)+银行代码（2位）+日期（8位，yyyymmdd）+03.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		return BLC_FILE_TAG + mBankEle.getAttributeValue("insu")+
		mBankEle.getAttributeValue(id)+DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"03.txt.des";
	}

	protected String getBackupFileName() {
	    Element mBankEle = cThisConfRoot.getChild("bank");
	    return BLC_FILE_TAG + mBankEle.getAttributeValue("insu")+
	    mBankEle.getAttributeValue(id)+DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"03.txt";
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
     * @param lineMsg
     * @return
     */
	private Element lineToNode(String lineMsg){
		String[] tSubMsgs = lineMsg.split("\\|", -1);
		
		Element tTranDateEle = new Element(TranDate);
		tTranDateEle.setText(tSubMsgs[1]);
		
		Element tNodeNoEle = new Element(NodeNo);
		tNodeNoEle.setText(tSubMsgs[2]+tSubMsgs[3]);
		
		Element tTranNoEle = new Element(TranNo);
		tTranNoEle.setText(tSubMsgs[5]);
		
		Element tProposalPrtNoEle = new Element(ProposalPrtNo);
		tProposalPrtNoEle.setText(tSubMsgs[6]);

		Element tAccNoEle = new Element(AccNo);
		tAccNoEle.setText(tSubMsgs[12]);
		
		Element tAppntNameEle = new Element("AppntName");
		tAppntNameEle.setText(tSubMsgs[9]);
		
		Element tAppntIDTypeEle = new Element("AppntIDType");
		tAppntIDTypeEle.setText(IcbcCodeMapping.idTypeToPGI(tSubMsgs[10]));
		
		Element tAppntIDNoEle = new Element("AppntIDNo");
		tAppntIDNoEle.setText(tSubMsgs[11]);

		Element tSourTypeEle = new Element("SourceType");
		tSourTypeEle.setText(tSubMsgs[7]);
		
		Element tDetailEle = new Element(Detail);
		tDetailEle.addContent(tTranDateEle);
		tDetailEle.addContent(tNodeNoEle);
		tDetailEle.addContent(tTranNoEle);
		tDetailEle.addContent(tProposalPrtNoEle);
		tDetailEle.addContent(tAccNoEle);
		tDetailEle.addContent(tAppntNameEle);
		tDetailEle.addContent(tAppntIDTypeEle);
		tDetailEle.addContent(tAppntIDNoEle);
		tDetailEle.addContent(tSourTypeEle);
		
		return tDetailEle;
	}
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		IcbcNoRealTimeBlc blc = new IcbcNoRealTimeBlc();
		blc.run();
	}

}
