package com.sinosoft.midplat.bat;

import java.util.Calendar;
import java.util.TimerTask;

import org.apache.log4j.Logger;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.XmlConf;
import com.sinosoft.midplat.common.XmlTag;

/**
 * 通用批量服务类.
 * <br/>通用批量服务类不涉及具体的批量业务逻辑
 * <br/>只负责加载通用的批量服务的配置信息
 * @author AB033862
 * Sep 27, 2012
 */
public abstract class BatchService extends TimerTask {
    protected Logger cLogger = Logger.getLogger(getClass());
    protected Element thisRootConf;
    protected Element thisBusiConf;
    protected Calendar calendar = Calendar.getInstance();
    protected String thisFuncFlag;
    protected String thisLocalDir;
    protected String fileCharset;
    protected boolean manualTrigger;
    /**
     * 重新下载文件
     */
    protected boolean reDownload;
    protected String resultMsg = "";
    /**
     * 扩展参数
     */
    protected String otherParam = "";
    
    /**
     * 
     * @param conf
     * @param funcFlag
     * @param batchType
     *            是下载还是上传文件 {@link #BATCH_TYPE_UP},{@link #BATCH_TYPE_DOWN},
     *            {@link #BATCH_TYPE_READ}
     */
    public BatchService(XmlConf conf, String funcFlag) {
        this.thisRootConf = conf.getConf().getRootElement();
        this.thisFuncFlag = funcFlag;
        try {
            this.thisBusiConf = (Element) XPath.selectSingleNode(thisRootConf,
                    "business[funcFlag='" + thisFuncFlag + "']");
            
            thisLocalDir = thisBusiConf.getChildText("localDir");
            if (null != thisLocalDir && !"".equals(thisLocalDir)) {
                thisLocalDir.replace('\\', '/');
                if (!thisLocalDir.endsWith("/")) {
                    thisLocalDir += '/';
                }
            } else {
                thisLocalDir = null;
            }
            String mCharset = thisRootConf.getChildText(XmlTag.charset);
            if (null==mCharset || "".equals(mCharset)) {
                //没有设置全局字符集
                fileCharset = "GBK";
            }else{
                fileCharset = mCharset;
            }
            mCharset = thisBusiConf.getChildText(XmlTag.charset);
            if (null!=mCharset && !"".equals(mCharset)) {
                //使用交易指定的字符集
                fileCharset = mCharset;
            }
        } catch (Exception e) {
            cLogger.error("解析批处理配置错误", e);
        }
    }

    public String getThisFuncFlag() {
        return thisFuncFlag;
    }

    public void setThisFuncFlag(String thisFuncFlag) {
        this.thisFuncFlag = thisFuncFlag;
    }

    public boolean isManualTrigger() {
        return manualTrigger;
    }

    public void setManualTrigger(boolean manualTrigger) {
        this.manualTrigger = manualTrigger;
    }

    public void setCalendar(Calendar calendar) {
        this.calendar = calendar;
    }

    public String getResultMsg() {
        return resultMsg;
    }

    public void setResultMsg(String resultMsg) {
        this.resultMsg = resultMsg;
    }

    public boolean isReDownload() {
        return reDownload;
    }

    public void setReDownload(boolean reDownload) {
        this.reDownload = reDownload;
    }

    /**
     * @return the otherParam
     */
    public String getOtherParam() {
        return otherParam;
    }

    /**
     * @param otherParam the otherParam to set
     */
    public void setOtherParam(String otherParam) {
        this.otherParam = otherParam;
    }

}
