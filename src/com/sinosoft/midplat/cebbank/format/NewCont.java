package com.sinosoft.midplat.cebbank.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.check.CheckFieldManager;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		// ADD 2014-02-20, PBKINSR-238,  加入健康告知项不能为空的校验
		// 健康告知
		String mHealthNotice = ((Element)XPath.newInstance("//HealthNotice").selectSingleNode(pNoStdXml.getRootElement())).getText().trim();
		if("".equals(mHealthNotice) || null==mHealthNotice){
			throw new MidplatException("健康告知项不能为空");
		}
		
		// 被保险人职业代码
		String mInsuJobCode = ((Element)XPath.newInstance("//Insured/JobCode").selectSingleNode(pNoStdXml.getRootElement())).getText().trim();
		if("".equals(mInsuJobCode) || null==mInsuJobCode){
			throw new MidplatException("被保险人职业代码不能为空");
		}
		
		// ADD 2014-03-10,PBKINSR-286, 增加对单证长度的校验
		String mContPrtNo = ((Element)XPath.newInstance("//ContPrtNo").selectSingleNode(pNoStdXml.getRootElement())).getText().trim();
		if(mContPrtNo.length()!=20){
			throw new MidplatException("单证长度限制为20位");
		}
		
		Document mStdXml =  NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		
		Element rootEle = mStdXml.getRootElement();
		
		//校验报文字段
		String tranCom = XPath.newInstance("//Head/TranCom").valueOf(rootEle);
		String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
		if(errorMsg!=null){
		    throw new MidplatException(errorMsg);
		}
		
		//套餐代码
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(rootEle);
		if("50015".equals(tContPlanCode)){
		    // 安邦长寿稳赢保险计划有50002变为50015。PBKINSR-696_光大银行盛2、盛3、50002产品升级改造
		    // 校验保险期间是否录入正确，本来应该核心系统校验，但是改套餐比较特殊
		    Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(rootEle);
		    Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(rootEle);
		    if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
		        //录入的不为保终身
		       throw new MidplatException("该套餐保险期间为保终身"); 
		    }
		    //将保险期间重置为保5年
		    insuYearFlag.setText("Y");
		    insuYear.setText("5");
		    
		}
		
		//加入受益人的校验，光大比较特殊
        List<Element> tBnfList = XPath.selectNodes(mStdXml.getRootElement(), "//Body/Bnf");

        for (Element tBnfEle : tBnfList) {
            if("".equals(tBnfEle.getChildText("Name"))){
                throw new MidplatException("受益人姓名不能为空");
            }
            if("".equals(tBnfEle.getChildText("RelaToInsured"))){
                throw new MidplatException("受益人与被保险人关系不能为空");
            }
            if("".equals(tBnfEle.getChildText("IDType"))){
                throw new MidplatException("受益人证件类型不能为空");
            }
            if("".equals(tBnfEle.getChildText("IDNo"))){
                throw new MidplatException("受益人证件号码不能为空");
            }
            if("".equals(tBnfEle.getChildText("Sex"))){
                throw new MidplatException("受益人性别不能为空");
            }
            if("".equals(tBnfEle.getChildText("Birthday"))){
                throw new MidplatException("受益人出生日期不能为空");
            }
        }
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		Document mNoStdXml = null;
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
			
		if("50015".equals(tContPlanCode)){
			/*
			 * 因保监要求，修改产品代码由50002变为50015
			 * 组合产品 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成
			 * 组合产品 50015: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、L12081-安邦长寿添利终身寿险（万能型）组成
			 */
			mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else{	// 非组合产品
			mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		}
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}