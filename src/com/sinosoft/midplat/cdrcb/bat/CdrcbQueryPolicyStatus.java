package com.sinosoft.midplat.cdrcb.bat;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.Calendar;
import java.util.List;

import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.cdrcb.CdrcbConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.exception.MidplatException;

/**
 * 获取哈尔滨银行保单状态变更数据
 * @author 
 *
 */
public class CdrcbQueryPolicyStatus extends UploadFileBatchService {
    
	public CdrcbQueryPolicyStatus() {
		super(CdrcbConf.newInstance(), "2811");
	}
	
	protected Element getHead() {		 
	      Element mHead = super.getHead();
	      calendar.add(Calendar.DATE,-1);
	      mHead.getChild("TranDate").setText(DateUtil.getDateStr(calendar.getTime(), "yyyyMMdd"));
	      return mHead;
	    }
	
	/**
	 * 解析核心传来的xml报文，形成结果文件
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
            
            for(Element tDetailEle : tDetailList){ 
            	content.append(getLine(tDetailEle));	
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
		//公司代码
		line.append("0024|");
		//保单号
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//投保日期
		line.append(tDetailEle.getChildText(XmlTag.SignDate)+"|");
		//交易日期 YYYYMMDD，当前日期
//		line.append(DateUtil.getCur8Date()+"|");
		//退保原因
		String businessType = tDetailEle.getChildText("BusinessType");
        if("CT".equals(businessType)){//退保
			line.append("退保|");
		}else if("WT".equals(businessType)){//犹退
			line.append("犹豫期退保|");
		}else if("MQ".equals(businessType)){//满期给付
			line.append("满期|");
		}else if("XT".equals(businessType)){//协议退保
			line.append("协议退保|");
		}
		//业务变更日期 YYYYMMDD，保单状态变更日期
        line.append(tDetailEle.getChildText("EdorCTDate")+"|");
		//保单状态
        if("CT".equals(businessType)){//退保
			line.append("2|");
		}else if("WT".equals(businessType)){//犹退
			line.append("1|");
		}else if("MQ".equals(businessType)){//满期给付
			line.append("3|");
		}else if("XT".equals(businessType)){//协议退保
			line.append("2|");
		}
        // 换行符
        line.append("\n"); 
		return line;
	}
	
	/** 
	 * 结果文件格式：
	 * XXXX_DBDATA_YYYYMMDD.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		
        return  "0024_DBDATA_" + DateUtil.getDateStr(calendar, "yyyyMMdd") + ".txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
		
	}

	@Override
	protected void setHead(Element head) {
		
	}
	
    @Override
    protected String getFtpName() {
        return getFileName();
    }
    
    
    protected void bakFiles(String pFileDir) {
    	
        cLogger.info("Into UploadFileBatchService.bakFiles()...");
        if (pFileDir == null || "".equals(pFileDir)) {
            cLogger.warn("本地文件目录为空，不进行备份操作！");
            return;
        }
        File mDirFile = new File(pFileDir);
        if (!mDirFile.exists() || !mDirFile.isDirectory()) {
            cLogger.warn((new StringBuilder("本地文件目录不存在，不进行备份操作！")).append(
                    mDirFile).toString());
            return;
        }
        File mOldFiles[] = mDirFile.listFiles(new FileFilter() {
            public boolean accept(File pFile) {
                if (!pFile.isFile()) {
                    return false;
                } else {
                    Calendar tCurCalendar = Calendar.getInstance();
                    tCurCalendar.set(Calendar.HOUR_OF_DAY, 1);
                    Calendar tFileCalendar = Calendar.getInstance();
                    tFileCalendar.setTimeInMillis(pFile.lastModified());
                    return tFileCalendar.before(tCurCalendar);
                }
            }

        });
        Calendar mCalendar = Calendar.getInstance();
        mCalendar.add(Calendar.MONTH, -1);
        File mNewDir = new File(mDirFile, DateUtil.getDateStr(mCalendar,
                "yyyy/yyyyMM"));
        for (int i = 0; i < mOldFiles.length; i++) {
            File tFile = mOldFiles[i];
            cLogger.info(tFile.getAbsoluteFile() + " start move...");
            try {
                IOTrans.fileMove(tFile, mNewDir);
                cLogger.info(tFile.getAbsoluteFile() + " end move!");
            } catch (IOException ex) {
                cLogger.error(tFile.getAbsoluteFile() + "备份失败！", ex);
            }
        }

        cLogger.info("Out UploadFileBatchService.bakFiles()!");
    }
    
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.icbc.bat.CdrcbQueryPolicyStatus.main");
		mLogger.info("程序开始...");

		CdrcbQueryPolicyStatus mBatch = new CdrcbQueryPolicyStatus();

		// 用于补对账，设置补对账日期
		if (0 != args.length) {
			mLogger.info("args[0] = " + args[0]);

			/**
			 * 严格日期校验的正则表达式：\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))。
			 * 4位年-2位月-2位日。 4位年：4位[0-9]的数字。
			 * 1或2位月：单数月为0加[0-9]的数字；双数月必须以1开头，尾数为0、1或2三个数之一。
			 * 1或2位日：以0、1或2开头加[0-9]的数字，或者以3开头加0或1。
			 * 
			 * 简单日期校验的正则表达式：\\d{4}\\d{2}\\d{2}。
			 */
			if (args[0].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				Element headEle = mBatch.getHead();
	        	headEle.getChild("TranDate").setText(args[0]);
			} else {
				throw new MidplatException("日期格式有误，应为yyyyMMdd！" + args[0]);
			}
		}

		mBatch.run();

		mLogger.info("成功结束！");
	}
	
}

