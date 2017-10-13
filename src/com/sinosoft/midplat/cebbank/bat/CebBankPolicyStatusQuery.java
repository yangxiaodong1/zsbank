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
 * 查询保单状态
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

				// 空行，直接跳过
				if ("".equals(lineMsg.trim())) {
					cLogger.warn("空行，直接跳过，继续下一条！");
					continue;
				}
				// 获取改行的打包器
				Element detailEle = packer.unpack(lineMsg, null);
				//这里会重复赋值，目前各条记录日期相同暂时如此，性能影响不大
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
			cLogger.warn("本地文件目录为空，不进行备份操作！");
			return;
		}
		File mDirFile = new File(fileDir);
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
					// 获取前两天8:00前的文件
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
				cLogger.error(tFile.getAbsoluteFile() + "备份失败！", ex);
			}
		}

		cLogger.info("Out CebBankPolicyStatusQuery.bakFiles()!");
	}

	/**
	 * 结果文件格式： CEB＋保险公司代码(2位)+ +"REBD"+ 日期（8位，yyyymmdd).txt
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
