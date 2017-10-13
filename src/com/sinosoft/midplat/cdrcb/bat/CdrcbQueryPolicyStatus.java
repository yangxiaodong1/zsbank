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
 * ��ȡ���������б���״̬�������
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
	 * �������Ĵ�����xml���ģ��γɽ���ļ�
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 * 
	 */
	@Override
	protected String parse(Document outStdXml) throws Exception {
        StringBuffer content = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            //��������
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
            
            cLogger.debug("���ķ��غ˱������¼��"+tDetailList.size());
            
            for(Element tDetailEle : tDetailList){ 
            	content.append(getLine(tDetailEle));	
            }
        }else{
            //������
            cLogger.warn("���ķ��ش����ģ����ɿ��ļ�:"+getFileName());
        }
        
        return content.toString();
	}
	
	/**
	 * ��֯����ļ��е�����Ϣ
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();		
		//��˾����
		line.append("0024|");
		//������
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//Ͷ������
		line.append(tDetailEle.getChildText(XmlTag.SignDate)+"|");
		//�������� YYYYMMDD����ǰ����
//		line.append(DateUtil.getCur8Date()+"|");
		//�˱�ԭ��
		String businessType = tDetailEle.getChildText("BusinessType");
        if("CT".equals(businessType)){//�˱�
			line.append("�˱�|");
		}else if("WT".equals(businessType)){//����
			line.append("��ԥ���˱�|");
		}else if("MQ".equals(businessType)){//���ڸ���
			line.append("����|");
		}else if("XT".equals(businessType)){//Э���˱�
			line.append("Э���˱�|");
		}
		//ҵ�������� YYYYMMDD������״̬�������
        line.append(tDetailEle.getChildText("EdorCTDate")+"|");
		//����״̬
        if("CT".equals(businessType)){//�˱�
			line.append("2|");
		}else if("WT".equals(businessType)){//����
			line.append("1|");
		}else if("MQ".equals(businessType)){//���ڸ���
			line.append("3|");
		}else if("XT".equals(businessType)){//Э���˱�
			line.append("2|");
		}
        // ���з�
        line.append("\n"); 
		return line;
	}
	
	/** 
	 * ����ļ���ʽ��
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
            cLogger.warn("�����ļ�Ŀ¼Ϊ�գ������б��ݲ�����");
            return;
        }
        File mDirFile = new File(pFileDir);
        if (!mDirFile.exists() || !mDirFile.isDirectory()) {
            cLogger.warn((new StringBuilder("�����ļ�Ŀ¼�����ڣ������б��ݲ�����")).append(
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
                cLogger.error(tFile.getAbsoluteFile() + "����ʧ�ܣ�", ex);
            }
        }

        cLogger.info("Out UploadFileBatchService.bakFiles()!");
    }
    
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.icbc.bat.CdrcbQueryPolicyStatus.main");
		mLogger.info("����ʼ...");

		CdrcbQueryPolicyStatus mBatch = new CdrcbQueryPolicyStatus();

		// ���ڲ����ˣ����ò���������
		if (0 != args.length) {
			mLogger.info("args[0] = " + args[0]);

			/**
			 * �ϸ�����У���������ʽ��\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))��
			 * 4λ��-2λ��-2λ�ա� 4λ�꣺4λ[0-9]�����֡�
			 * 1��2λ�£�������Ϊ0��[0-9]�����֣�˫���±�����1��ͷ��β��Ϊ0��1��2������֮һ��
			 * 1��2λ�գ���0��1��2��ͷ��[0-9]�����֣�������3��ͷ��0��1��
			 * 
			 * ������У���������ʽ��\\d{4}\\d{2}\\d{2}��
			 */
			if (args[0].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				Element headEle = mBatch.getHead();
	        	headEle.getChild("TranDate").setText(args[0]);
			} else {
				throw new MidplatException("���ڸ�ʽ����ӦΪyyyyMMdd��" + args[0]);
			}
		}

		mBatch.run();

		mLogger.info("�ɹ�������");
	}
	
}

