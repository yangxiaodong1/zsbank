/**
 * 
 */
package com.sinosoft.midplat.icbc.bat;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IcbcCipherUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.icbc.IcbcCodeMapping;
import com.sinosoft.midplat.icbc.IcbcConf;

/**
 * 非实时核保结果文件，触发之后调用核心得到结果
 * @author ChengNing
 * @date   Apr 2, 2013
 */
public class IcbcBlcResultFile extends UploadFileBatchService  {
	public IcbcBlcResultFile() {
		super(IcbcConf.newInstance(), "123");	// funFlag="123"-非实时核保上传结果文件
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
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            //正常报文
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
            
            cLogger.debug("核心返回核保结果记录："+tDetailList.size());
            
            String tContPlanCode = "";
            for(Element tDetailEle : tDetailList){ 
            	//按行添加到对账文件
            	tContPlanCode = tDetailEle.getChildText("ContPlanCode").trim();	// 组合产品编码标签
            	//PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级
            	if("50002".equals(tContPlanCode) || "50015".equals(tContPlanCode)){	// 组合产品50002按如下形式组织一行信息。
            		content.append(getLine4ContPlan50002(tDetailEle));
            	}else if("".equals(tContPlanCode) || null==tContPlanCode){	// 非组合产品按如下形式组织一行信息
            		content.append(getLine(tDetailEle));	
            	}
            }
        }else{
            //错误报文
            cLogger.warn("核心返回错误报文，生成空文件:"+getFileName());
        }
        
        return content.toString();
	}
	
	/**
	 * 组织结果文件中的行信息
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();
		//被保险人节点
		Element tInsuredEle = tDetailEle.getChild(XmlTag.Insured);
		
		//险种节点,主险排第一个
		StringBuffer mainRiskBuffer = new StringBuffer();
		StringBuffer riskBuffer = new StringBuffer();
		List<Element> tRiskEles = tDetailEle.getChildren(XmlTag.Risk);
		//交费方式（3位）//在主险中取得
		String payIntv = "";
		for (Element tRiskEle : tRiskEles) {
			StringBuffer lineRisk = new StringBuffer();
			//判断是否主险
			if(tRiskEle.getChildText(XmlTag.RiskCode).equals(tRiskEle.getChildText(XmlTag.MainRiskCode))){
				lineRisk = mainRiskBuffer;
				payIntv = tRiskEle.getChildText(XmlTag.PayIntv);
			}
			else{
				lineRisk = riskBuffer;
			}
			// 主险险种代码（3位），第一个为主险，其他为附加险
			lineRisk.append(IcbcCodeMapping.riskCodeFromPGI(tRiskEle.getChildText(XmlTag.RiskCode))+"|");
			// 核保结论状态(2位)
			lineRisk.append(IcbcCodeMapping.uwResultStateFromPGI(tRiskEle.getChildText("UWResult"))+"|");
			// 份数（5位）
			lineRisk.append(tRiskEle.getChildText(XmlTag.Mult) + "|");
			// 保费（12位）
			lineRisk.append(tRiskEle.getChildText(XmlTag.Prem) + "|");
			// 保额（12位）
			lineRisk.append(tRiskEle.getChildText(XmlTag.Amnt) + "|");
			
			// 保险期间类型（1位），保险期间需要转换
			String insuYearFlag = tRiskEle.getChildText(XmlTag.InsuYearFlag);
			String insuYear = tRiskEle.getChildText(XmlTag.InsuYear);
			if("A".equals(insuYearFlag) && "106".equals(insuYear)){
			    //保终身
			    lineRisk.append( "5|999|");
			}else{
			    lineRisk.append(IcbcCodeMapping.insuYearFlagFromPGI(tRiskEle.getChildText(XmlTag.InsuYearFlag)) + "|");
			    lineRisk.append(tRiskEle.getChildText(XmlTag.InsuYear) + "|");
			}
			
			// 缴费年期类型（1位），// 缴费年期需要转换
			if("0".equals(tRiskEle.getChildText(XmlTag.PayIntv))){
			    //趸交
			    lineRisk.append( "5|0|");
			}else{
			    lineRisk.append(IcbcCodeMapping.payEndYearFlagFromPGI(tRiskEle.getChildText(XmlTag.PayEndYearFlag)) + "|");
			    lineRisk.append(tRiskEle.getChildText(XmlTag.PayEndYear) + "|");
			}
			
		}
		
        //地区码，前5位表示地区码
		line.append(tDetailEle.getChildText(XmlTag.NodeNo).substring(0, 5)+"|");
        //保险公司代码(3位)
		line.append(thisRootConf.getChild("bank").getAttributeValue("insu")+"|");
        //银行交易流水号(25位)
		line.append(tDetailEle.getChildText(XmlTag.TranNo)+"|");
        //投保单印刷号(20位)
		line.append(tDetailEle.getChildText(XmlTag.ProposalPrtNo)+"|");
		//保单号（30位）
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//核保结论 (2位) 
		line.append(IcbcCodeMapping.uwResultFromPGI(tDetailEle.getChildText("UWResult"))+"|");
		//备注（120位）
		line.append(tDetailEle.getChildText("ReMark")+"|");
		//首期总保费（12位）
		line.append(tDetailEle.getChildText(XmlTag.Prem)+"|");
		
		//被保人姓名(30位) 
		line.append(tInsuredEle.getChildText(XmlTag.Name)+"|");
		//被保人证件类型（2位）
		line.append(IcbcCodeMapping.idTypeFromPGI(tInsuredEle.getChildText(XmlTag.IDType))+"|");
		//被保人证件号码（20位）
		line.append(tInsuredEle.getChildText(XmlTag.IDNo)+"|");
		//交费方式（3位）
		line.append(IcbcCodeMapping.payIntvFromPGI(payIntv) +"|");
		//主险
		line.append(mainRiskBuffer);
		//附加险
		line.append(riskBuffer);
		
		/*加入占位符|*/
		for(int i= 5-tRiskEles.size(); i>0; i--){
		    //工行规定必须有4个附加险，所以如果附加险不住，需要补充缺少的字段
		    line.append("|||||||||");
		}
		
		
        // 换行符
        line.append("\n"); 
		return line;
	}

	/**
	 * 针对组合产品50002组织返回报文中的一条行信息
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine4ContPlan50002(Element tDetailEle){
		
		StringBuffer line = new StringBuffer();
		//被保险人节点
		Element tInsuredEle = tDetailEle.getChild(XmlTag.Insured);
		
		//险种节点,主险排第一个
		StringBuffer mainRiskBuffer = new StringBuffer();
		StringBuffer riskBuffer = new StringBuffer();
		List<Element> tRiskEles = tDetailEle.getChildren(XmlTag.Risk);
		//套餐代码节点
		Element tContPlanCodeEle = tDetailEle.getChild("ContPlanCode");
		String tContPlanCode = tContPlanCodeEle.getText();
		
		//交费方式（3位）//在主险中取得
		String payIntv = "";
		
		int riskSize = 0;	// 记录主险个数，用于后续构造返回给银行的核保结果文件
		for (Element tRiskEle : tRiskEles) {
			StringBuffer lineRisk = new StringBuffer();
			//判断是否主险
			if(tRiskEle.getChildText(XmlTag.RiskCode).equals(tRiskEle.getChildText(XmlTag.MainRiskCode))){
				lineRisk = mainRiskBuffer;
				payIntv = tRiskEle.getChildText(XmlTag.PayIntv);
				
				// 主险险种代码（3位）
//				lineRisk.append(IcbcCodeMapping.riskCodeFromPGI(tRiskEle.getChildText(XmlTag.RiskCode))+"|");
				//由于存在50015及50012两种产品代码共存的情况，这里改为取套餐代码做映射
				lineRisk.append(IcbcCodeMapping.riskCodeFromPGI(tContPlanCode)+"|");
				// 核保结论状态(2位)
				lineRisk.append(IcbcCodeMapping.uwResultStateFromPGI(tRiskEle.getChildText("UWResult"))+"|");
				// 份数（5位）, 组合产品份数取自<ContPlanMult>标签
				lineRisk.append(tDetailEle.getChildText("ContPlanMult") + "|");
				// 保费（12位）,组合产品份数取自<ActPrem>标签
				lineRisk.append(tDetailEle.getChildText("ActPrem") + "|");
				// 保额（12位）
				lineRisk.append(tDetailEle.getChildText(XmlTag.Amnt) + "|");
				
				// 保险期间类型（1位），保险期间需要转换,组合产品的保险年期为保终身，此处写死。
				lineRisk.append( "5|999|");
				
//				String insuYearFlag = tRiskEle.getChildText(XmlTag.InsuYearFlag);
//				String insuYear = tRiskEle.getChildText(XmlTag.InsuYear);
//				if("A".equals(insuYearFlag) && "106".equals(insuYear)){
//				    //保终身
//				    lineRisk.append( "5|999|");
//				}else{
//				    lineRisk.append(IcbcCodeMapping.insuYearFlagFromPGI(tRiskEle.getChildText(XmlTag.InsuYearFlag)) + "|");
//				    lineRisk.append(tRiskEle.getChildText(XmlTag.InsuYear) + "|");
//				}
				
				// 缴费年期类型（1位），// 缴费年期需要转换
				if("0".equals(tRiskEle.getChildText(XmlTag.PayIntv))){
				    //趸交
				    lineRisk.append( "5|0|");
				}else{
				    lineRisk.append(IcbcCodeMapping.payEndYearFlagFromPGI(tRiskEle.getChildText(XmlTag.PayEndYearFlag)) + "|");
				    lineRisk.append(tRiskEle.getChildText(XmlTag.PayEndYear) + "|");
				}
				
				riskSize++;	// 统计主险个数据，为后续组织银行非实时核保结果文件做准备
			}
			
		}
		
        //地区码，前5位表示地区码
		line.append(tDetailEle.getChildText(XmlTag.NodeNo).substring(0, 5)+"|");
        //保险公司代码(3位)
		line.append(thisRootConf.getChild("bank").getAttributeValue("insu")+"|");
        //银行交易流水号(25位)
		line.append(tDetailEle.getChildText(XmlTag.TranNo)+"|");
        //投保单印刷号(20位)
		line.append(tDetailEle.getChildText(XmlTag.ProposalPrtNo)+"|");
		//保单号（30位）
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//核保结论 (2位) 
		line.append(IcbcCodeMapping.uwResultFromPGI(tDetailEle.getChildText("UWResult"))+"|");
		//备注（120位）
		line.append(tDetailEle.getChildText("ReMark")+"|");
		//首期总保费（12位）,组合产品50002取实收的总保费，取自字段ActPrem
		line.append(tDetailEle.getChildText("ActPrem")+"|");
		
		//被保人姓名(30位) 
		line.append(tInsuredEle.getChildText(XmlTag.Name)+"|");
		//被保人证件类型（2位）
		line.append(IcbcCodeMapping.idTypeFromPGI(tInsuredEle.getChildText(XmlTag.IDType))+"|");
		//被保人证件号码（20位）
		line.append(tInsuredEle.getChildText(XmlTag.IDNo)+"|");
		//交费方式（3位）
		line.append(IcbcCodeMapping.payIntvFromPGI(payIntv) +"|");
		//主险
		line.append(mainRiskBuffer);
		//附加险
		line.append(riskBuffer);
		
		/*加入占位符|*/
		for(int i= 5-riskSize; i>0; i--){
		    //工行规定必须有4个附加险，所以如果附加险不住，需要补充缺少的字段
		    line.append("|||||||||");
		}
		
        // 换行符
        line.append("\n"); 
		return line;
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
        return  "ENYIAAS" + mBankEle.getAttributeValue("insu")+ mBankEle.getAttributeValue("id")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "03.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
		
	}

	@Override
	protected void setHead(Element head) {
		
	}

	
	@Override
    protected boolean postProcess() throws Exception {

	    OutputStream temp = null;
	    FileInputStream fin = null;
	    String pathName = null;
	    
        try {
            //本地地址
            String path = this.thisBusiConf.getChildTextTrim("localDir");
            pathName = path+File.separator+getFileName();
            cLogger.info("加密文件："+pathName+"...");
            
            //生成的明文文件
            fin = new FileInputStream(pathName);
            //生成的密文文件
            temp = new FileOutputStream(pathName+".des");
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
            cLogger.error("加密文件失败!"+pathName, e);
        } finally {
            if (temp != null) {
                try{
                    temp.close();
                }catch(Exception e){
                    cLogger.error("关闭文件失败!"+pathName, e);
                }
            }
            if (fin != null) {
                try{
                    fin.close();
                }catch(Exception e){
                    cLogger.error("关闭文件失败!"+pathName+".des", e);
                }
            }
        }
	    return true;
    }

    /**
	 * @param args
	 */
	public static void main(String[] args) throws Exception{
		IcbcBlcResultFile blc = new IcbcBlcResultFile();
		blc.postProcess();
		
		System.out.println(" 测试后台 print info : ");
	}

    @Override
    protected String getFtpName() {
        return getFileName()+".des";
    }
	
	


}
