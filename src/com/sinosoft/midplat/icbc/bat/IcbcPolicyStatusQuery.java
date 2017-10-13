/**
 * 
 */
package com.sinosoft.midplat.icbc.bat;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IcbcCipherUtil;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.icbc.IcbcConf;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * 查询当天状态有变化的保单（仅限工行所出保单）
 */
public class IcbcPolicyStatusQuery extends UploadFileBatchService  {
	public IcbcPolicyStatusQuery() {
		super(IcbcConf.newInstance(), "125");
	}
	
	/**
	 * 解析核心传来的xml报文，形成对账文件格式
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 * 
	 */
	@Override
	protected String parse(Document outStdXml) throws Exception {
        StringBuffer content = new StringBuffer();
        //正常报文
        List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
        cLogger.debug("核心返回核保结果记录："+tDetailList.size());
        //保险公司代码(3位)
        String insuId = thisRootConf.getChild("bank").getAttributeValue("insu");
        
        String tempPro = "";
        for(Element tDetailEle : tDetailList){ 
            //交易日期
            content.append(tDetailEle.getChildText("EdorCTDate")+"|");
            //业务种类
            content.append(getBusinessType(tDetailEle.getChildText("BusinessType"))+"|");
            //业务变更日期
            content.append(tDetailEle.getChildText("EdorCTDate")+"|");
            //保险公司代码(3位)
            content.append(insuId+"|");
            //地区码，前5位表示地区码
            content.append(tDetailEle.getChildText(XmlTag.NodeNo).substring(0, 5)+"|");
            //投保单印刷号(20位)
            
            tempPro = getProByContNO(tDetailEle.getChildText(XmlTag.ContNo));
            if(StringUtils.isEmpty(tempPro)){	// 没有查询到相应的数据，说明是柜面出的单子，走原逻辑
            
            	content.append(tDetailEle.getChildText(XmlTag.ProposalPrtNo)+"|");
            }else{	// 查询到投保单号，说明是网银or自助终端，采用查询出的数据。
            	content.append(tempPro+"|");
            }
            
            //保单号（30位）
            content.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
            //客户姓名
            content.append(tDetailEle.getChildText("AppntName")+"|");
            //客户证件类型
            content.append(getIdType(tDetailEle.getChildText("AppntIDType"))+"|");
            //客户证件号
            content.append(tDetailEle.getChildText("AppntIDNo")+"|");
            //保单最新状态
            content.append(getContState(tDetailEle.getChildText("ContState"))+"|");
            //保单到期日
            content.append(tDetailEle.getChildText("ContEndDate")+"|");
            //金额
            content.append(tDetailEle.getChildText("EdorCTPrem")+"|");
            //三个占位符
            content.append("|||");

            // 换行符
            content.append("\n"); 
        }
        
        return content.toString();
	}
	
	/**
	 * 针对工行网银、自助终端，通过保单号获取银行的投保单号。
	 * (因工行系统自己有一套针对网银、自助终端生产投保单号的算法，该算法与保险公司的投保单号算法不一样，所以需要进行映射转换)
	 * @param cContNo
	 * @return
	 */
	private String getProByContNO(String cContNo){
		
		StringBuffer mSqlStr = new StringBuffer();
		String tProposalprtno = "";
        mSqlStr.append("select l.proposalprtno from tranlog l where l.contno='")
//				.append(cContNo).append("' and (l.funcflag='131' or l.funcflag='141' or l.funcflag='151')");
        //浙江工行手机渠道采用的是网银渠道出单，此处不需要增加手机渠道
        		.append(cContNo).append("' and (l.funcflag='131' or l.funcflag='141')");
        
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        try{
        
        	if(mSSRS.MaxRow==0){
            	throw new MidplatException("未查询到工行相应的保单数据，保单号='" + cContNo +"' ");
            }else if(mSSRS.MaxRow!=1){
            	throw new MidplatException("查询到的工行相应的保单数据不唯一，保单号='" + cContNo +"' ");
            }else{
            	tProposalprtno = mSSRS.GetText(1, 1);
            }
        	
        }catch(Exception exp){
        	cLogger.info(exp.getMessage());
        }
        
        return tProposalprtno; 
	}
	
	/** 
	 * 结果文件格式：
	 * ENY(3位)+IAAS(4位)＋保险公司代码(3位)+银行代码（2位）+日期（8位，yyyymmdd）+03.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "ENYIAAS" + mBankEle.getAttributeValue("insu")+ "_" +mBankEle.getAttributeValue("id")+ "_"+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "_UPDATESTATUS.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
        Element mBusinessTypes = new Element("BusinessTypes");
        //RENEW-续期
        Element mBusinessType = new Element("BusinessType");
        mBusinessType.setText("RENEW");
        mBusinessTypes.addContent(mBusinessType);

        //CLAIM-理赔
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("CLAIM");
        mBusinessTypes.addContent(mBusinessType);

        //AA个人增加保额
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("AA");
        mBusinessTypes.addContent(mBusinessType);

        //UP万能追加保费
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("UP");
        mBusinessTypes.addContent(mBusinessType);

        //ZP万能追加保费(双帐户)
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("ZP");
        mBusinessTypes.addContent(mBusinessType);

        //CT退保
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("CT");
        mBusinessTypes.addContent(mBusinessType);

        //WT犹豫期退保
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("WT");
        mBusinessTypes.addContent(mBusinessType);

        //MQ满期给付
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("MQ");
        mBusinessTypes.addContent(mBusinessType);

        
       //XT协议退保
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("XT");
        mBusinessTypes.addContent(mBusinessType);
        bodyEle.addContent(mBusinessTypes);
        
        //查询日期
        Element mEdorCTDate = new Element("EdorCTDate");
        mEdorCTDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        bodyEle.addContent(mEdorCTDate);
	}

	@Override
	protected void setHead(Element head) {
	    //全部文件名存不下
	    head.getChild("TranNo").setText(getFileName().substring(14));
	}

	
	@Override
    protected boolean postProcess() throws Exception {

	    OutputStream temp = null;
	    FileInputStream fin = null;
	    //明文文件
	    String unEncodedFile = null;
	    //密文文件
	    String encodedFile = null;
	    
        try {
            //本地地址
            String path = this.thisBusiConf.getChildTextTrim("localDir");
            unEncodedFile = path+File.separator+getFileName();
            encodedFile = path+File.separator+getFtpName();
            
            cLogger.info("加密文件："+unEncodedFile+"...");
            
            //生成的明文文件
            fin = new FileInputStream(unEncodedFile);
            //生成的密文文件
            temp = new FileOutputStream(encodedFile);
            //封装成机密流
            temp = new IcbcCipherUtil().encrypt(temp);
            int len = 0;
            byte[] content = new byte[2046];
            while((len=fin.read(content)) != -1){
                //生成加密文件
                temp.write(content, 0, len);
            }
            temp.flush();
        } catch (Exception e) {
            cLogger.error("加密文件失败!"+unEncodedFile, e);
        } finally {
            if (temp != null) {
                try{
                    temp.close();
                }catch(Exception e){
                    cLogger.error("关闭文件失败!"+encodedFile, e);
                }
            }
            if (fin != null) {
                try{
                    fin.close();
                }catch(Exception e){
                    cLogger.error("关闭文件失败!"+unEncodedFile, e);
                }
            }
        }
	    return true;
    }

    /**
	 * @param args
     * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
	    new IcbcPolicyStatusQuery().postProcess();
	    System.out.println("ooooooooo");
	}
    
	@Override
	protected String getFtpName() {
	    // TODO Auto-generated method stub
	    return getFileName().replaceFirst("txt", "des");
	}

	/**
	 * 业务类型映射（核心--工行）。
	 * </br>核心：RENEW-续期；CLAIM-理赔；AA个人增加保额、UP万能追加保费、ZP万能追加保费(双帐户)、CT退保、WT犹豫期退保、MQ满期给付
	 * </br>工行：001满期给付，002犹豫期撤保，003退保，004续期交费，005追加投保，099理赔终止
	 * @param type 
	 * @return
	 */
	private String getBusinessType( String type) {
	    if("RENEW".equals(type)){
	        //RENEW-续期--->004续期交费
	        return "004";
	    }else if("CLAIM".equals(type)){
	        //CLAIM-理赔--->099理赔终止
	        return "099";
	    }else if("AA".equals(type)){
	        //AA个人增加保额--->005追加投保
	        return "005";
        }else if("UP".equals(type)){
            //UP万能追加保费--->005追加投保
            return "005";
        }else if("ZP".equals(type)){
            //ZP万能追加保费(双帐户)--->005追加投保
            return "005";
        }else if("CT".equals(type)){
            //CT退保--->003退保
            return "003";
        }else if("WT".equals(type)){
            //WT犹豫期退保--->002犹豫期撤保
            return "002";
        }else if("MQ".equals(type)){
            //MQ满期给付--->001满期给付
            return "001";
        }else if("XT".equals(type)){
            //XT协议退保（针对浙江工行专属产品，特殊处理）--->002犹豫期撤保
        	//由于核心针对该交易的sql查询条件限制，如果此处由核心转换处理的话，改动较大，若将来工总行增加协议退保状态时，银保通与核心需要重新修改
            return "002";
        }
	    return "";
	}
	
	/**
	 * 映射证件类型（核心--工行）
	 * </br> 核心：0-居民身份证;1-护照;2-军官证;3-驾照;4-出生证明;5-户口簿;8-其他;9-异常身份证
	 * </br> 工行：0-身份证;1-护照;2-军官证;3-士兵证;4-港澳台通行证;5-临时身份证;6-户口本;9-警官证;12-外国人居留证
	 * @param type
	 * @return
	 */
	private String getIdType( String type) {
	    if("0".equals(type)){
            //0-居民身份证--->0-身份证
            return "0";
        }else if("1".equals(type)){
            //1-护照--->1-护照
            return "1";
        }else if("2".equals(type)){
            //2-军官证--->2-军官证
            return "2";
        }else if("5".equals(type)){
            //5-户口簿--->6-户口本
            return "6";
        }
        return "";
	}
	
	/**
	 * 保单状态映射（核心--工行）
	 * </br>核心： 00有效,01满期终止,02退保终止,03解约终止,04理赔终止,05自垫终止,06贷款终止,07失败终止,08其他终止,WT犹豫期退保终止
	 * </br>工行： 12-保单有效 14-犹豫期退保保单已终止 20-退保终止 21-理赔终止 23-满期给付终止
	 * @param type
	 * @return
	 */
	private String getContState( String type) {
	    if("00".equals(type)){
            //00有效-->12-保单有效
            return "12";
        }else if("01".equals(type)){
	        //01满期终止-->23-满期给付终止
	        return "23";
	    }else if("02".equals(type)){
	        //02退保终止-->20-退保终止
            return "20";
        }else if("04".equals(type)){
            //04理赔终止-->21-理赔终止
            return "21";
        }else if("WT".equals(type)){
            //WT犹豫期退保终止-->14-犹豫期退保保单已终止
            return "14";
        }else if("XT".equals(type)){
            //XT协议退保-->14-犹豫期退保保单已终止
        	//由于核心针对该交易的sql查询条件限制，如果此处由核心转换处理的话，改动较大，若将来工总行增加协议退保状态时，银保通与核心需要重新修改
            return "14";
        }
        return "";
	}

}
