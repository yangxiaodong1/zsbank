package com.sinosoft.midplat.bat;

import java.util.Calendar;
import java.util.TimerTask;

import org.apache.log4j.Logger;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.XmlConf;
import com.sinosoft.midplat.common.XmlTag;

/**
 * ͨ������������.
 * <br/>ͨ�����������಻�漰���������ҵ���߼�
 * <br/>ֻ�������ͨ�õ����������������Ϣ
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
     * ���������ļ�
     */
    protected boolean reDownload;
    protected String resultMsg = "";
    /**
     * ��չ����
     */
    protected String otherParam = "";
    
    /**
     * 
     * @param conf
     * @param funcFlag
     * @param batchType
     *            �����ػ����ϴ��ļ� {@link #BATCH_TYPE_UP},{@link #BATCH_TYPE_DOWN},
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
                //û������ȫ���ַ���
                fileCharset = "GBK";
            }else{
                fileCharset = mCharset;
            }
            mCharset = thisBusiConf.getChildText(XmlTag.charset);
            if (null!=mCharset && !"".equals(mCharset)) {
                //ʹ�ý���ָ�����ַ���
                fileCharset = mCharset;
            }
        } catch (Exception e) {
            cLogger.error("�������������ô���", e);
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
