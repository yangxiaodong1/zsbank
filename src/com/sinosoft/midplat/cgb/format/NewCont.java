package com.sinosoft.midplat.cgb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisConf) {  // ？？？？？
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");

		Document mStdXml = NewContInXsl.newInstance().getCache().transform(
				pNoStdXml);             //yxd将银行传递过来的报文转换为保险需要的报文格式？NewContInXsl类中没有getCache（）transform 方法呀？
        //套餐代码,由50002升级为50015
        String riskCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(mStdXml.getRootElement());//yxd NewContln.xml的ContPlan/ContPlanCode路径下面的产品组合编码值
        if("50015".equals(riskCode)){ //yxd如果50015和这个保险代码相同就执行下面代码
            //长寿稳赢套餐
            //校验保险期间是否录入正确，本来应该核心系统校验，但是改套餐比较特殊
            Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(mStdXml.getRootElement());//yxd获得保险年期年龄标志元素
            Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(mStdXml.getRootElement());//yxd 保险年期年龄 元素
            if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){ //yxd 如果保险年期年龄标志值不等于A或者年期年龄不等于106 执行下面代码
                //录入的不为保终身
               throw new MidplatException("该套餐保险期间为保终身"); //yxd 符合上面条件抛出异常“改套餐保险起见为保终身”
            }
            //将保险期间重置为保5年
            insuYearFlag.setText("Y"); //yxd 设置保险年期年龄标志位年‘Y’
            insuYear.setText("5"); //yxd 将保险期间重置为5年， 在 录入不为保终身的情况下这样设置
        }
		cLogger.info("Out NewCont.noStd2Std()!"); //yxd输入这句话作为日志
		return mStdXml; //yxd返回格式化的报文 ，疑惑：这里是接受银行这样岂不是直接返给银行里，没有体现把数据给核心保险公司
	}

	public Document std2NoStd(Document pStdXml) throws Exception {//yxd 
		cLogger.info("Into NewCont.std2NoStd()...");

		Document mNoStdXml = NewContOutXsl.newInstance().getCache().transform(
				pStdXml);//yxd 转换响应报文的格式，封装成银行需要报文

		cLogger.info("Out NewCont.std2NoStd()!");//输出日志
		return mNoStdXml;//yxd 返回应答报文
	}
	
	 public static void main(String[] args) throws Exception{
	     Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc.xml"));//将桌面上的abc.xml文档 封装为不知道文件的格式？？？？？
	        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
         out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));//yxd 将转换好的格式报文写入到桌面abc_out.xml中
         out.close();
         System.out.println("******ok*********");
     }
}