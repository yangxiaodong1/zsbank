/**
 * 
 */
package com.sinosoft.midplat.cebbank.bat;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileReader;
import java.io.IOException;
import java.util.Calendar;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.bat.packer.FixedDelimiterPacker;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.cebbank.CebBankConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;

/**
 * ��ѯ����״̬
 */
public class CebBankPolicyStatusQuery extends UploadFileBatchService {

	private RecordPacker packer = new FixedDelimiterPacker("\\|", '|');
	
	private String inQueryDate = "";

	public CebBankPolicyStatusQuery() {
		super(CebBankConf.newInstance(), "907");
	}

	@Override
	protected void setBody(Element bodyEle) throws Exception {

		BufferedReader reader = null;
		// Element mBankEle = thisRootConf.getChild("bank");
		String readFileName = "CEB10" + "BD01"
				+ DateUtil.getDateStr(calendar, "yyyyMMdd") + ".txt";
		try {
			reader = new BufferedReader(new FileReader(thisLocalDir
					+ readFileName));
			String lineMsg = null;
			while ((lineMsg = reader.readLine()) != null) {
				cLogger.info(lineMsg);

				// ���У�ֱ������
				if ("".equals(lineMsg.trim())) {
					cLogger.warn("���У�ֱ��������������һ����");
					continue;
				}
				// ��ȡ���еĴ����
				Element detailEle = packer.unpack(lineMsg, null);
				//������ظ���ֵ��Ŀǰ������¼������ͬ��ʱ��ˣ�����Ӱ�첻��
				this.inQueryDate = ((Element)detailEle.getChildren().get(0)).getText();
				bodyEle.addContent(detailEle);
			}

		} finally {
			if (reader != null) {
				reader.close();
			}
		}
	}

	@Override
	protected void setHead(Element head) {

	}

	@Override
	protected void bakFiles(String fileDir) {
		cLogger.info("Into CebBankPolicyStatusQuery.bakFiles()...");
		if (fileDir == null || "".equals(fileDir)) {
			cLogger.warn("�����ļ�Ŀ¼Ϊ�գ������б��ݲ�����");
			return;
		}
		File mDirFile = new File(fileDir);
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
					// ��ȡǰ����8:00ǰ���ļ�
					Calendar curCalendar = Calendar.getInstance();
					curCalendar.set(Calendar.HOUR_OF_DAY, 8);
					curCalendar.set(Calendar.DATE, curCalendar
							.get(Calendar.DATE) - 2);
					Calendar tFileCalendar = Calendar.getInstance();
					tFileCalendar.setTimeInMillis(pFile.lastModified());
					return tFileCalendar.before(curCalendar);
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

		cLogger.info("Out CebBankPolicyStatusQuery.bakFiles()!");
	}

	/**
	 * ����ļ���ʽ�� CEB�����չ�˾����(2λ)+ +"REBD"+ ���ڣ�8λ��yyyymmdd).txt
	 * 
	 */
	@Override
	protected String getFileName() {
		// Element mBankEle = thisRootConf.getChild("bank");
		return "CEB10" + "REBD" + DateUtil.getDateStr(calendar, "yyyyMMdd")
				+ ".txt";
	}

	@Override
	protected RecordPacker getDefaultRecordPacker() {
		return super.getDefaultRecordPacker();
	}
	
	@Override
	protected Document adjustOutXml(Document outXml) throws Exception {
		
		List<Element> detailList = XPath.selectNodes(outXml.getRootElement(), "//Body/Detail");
		if(detailList != null){
			for(Element detail : detailList){
				detail.getChild("QueryDate").setText(this.inQueryDate);
			}
		}
		
		return outXml;
	}

}
