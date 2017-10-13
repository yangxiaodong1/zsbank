package com.sinosoft.midplat.cib.bat;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.cib.CibConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * 
 * @author guoxl
 * @desc ��ʱ����ÿ�춨ʱ��ѯ��ҵ�����˱�����-����
 * @date 2016-06-23 14:35:00
 * 
 */
public class CibQueryPolicyStatus extends UploadFileBatchService {

	public CibQueryPolicyStatus() {
		super(CibConf.newInstance(), "2308");
	}

	@Override
	protected String getFileName() {

		StringBuilder sb = new StringBuilder();
		sb.append("CIB_").append("1004_");
		sb.append("0007_");
		sb.append(DateUtil.getDateStr(calendar, "yyyyMMdd"));
		sb.append(".txt");
		return sb.toString();
	}

	@Override
	protected void setHead(Element head) {
		
	}


	/**
	 * @desc ����xml���ģ�������Ϣ
	 * @date 2016-06-23 14:22:24
	 * @param args
	 */
	protected String parse(Document tOutNoStdXml) throws Exception {
		StringBuffer sBuffer = new StringBuffer();

		Element element = (Element) XPath.selectSingleNode(tOutNoStdXml
				.getRootElement(), "//Head/Flag");

		List<Element> eList = XPath.selectNodes(tOutNoStdXml.getRootElement(),
				"//Body/Detail");

		// ���ر�����Ϣ����װ
		if (element != null && "0".equals(element.getValue())) {

			cLogger.info("���ķ�����Ϣ������" + eList.size());

			// �����ļ����ݱ���ͷ
			sBuffer.append(setFtpTxtHead(eList));

			for (Element e : eList) {
				sBuffer.append(getReadLine(e));
			}

		} else {

			// ���ÿ��ļ��ı���ͷ��Ϣ
			sBuffer.append(setFtpTxtHead(eList));

			cLogger.info("���ķ��ش����ģ����ɿ��ļ���" + getFileName());
		}

		return sBuffer.toString();

	}

	// ��ȡ���ķ��ر��ģ������÷���ftp���������ļ��ı���ͷ
	public StringBuffer setFtpTxtHead(List<Element> eList) {
		StringBuffer sb = new StringBuffer();
		sb.append("F").append("|0007|1004|");
		sb.append(eList.size());
		sb.append("|");
		sb.append("||");
		sb.append("\n");
		return sb; 

	}

	// ��ȡ���ķ��ص�ÿ�����ģ�����װ
	public StringBuffer getReadLine(Element element) {
		StringBuffer sBuffer = new StringBuffer();
		
		// ������ͬ��
		String contNo = element.getChildText("ContNo");
		StringBuffer mSqlStr = new StringBuffer();
	    mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where ContNo = '"+contNo+"' " +
	    		" and Rcode = '0' order by Maketime desc");
	    
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (mSSRS.MaxRow < 1) {
        	sBuffer.append("01");// ���±���
        }else{
        	sBuffer.append("00");// ���ϱ���
        }
	
		sBuffer.append("|");
		// ҵ��������
		String editDate = element.getChildText("EdorCTDate");
		sBuffer.append(editDate).append("|");
		
		sBuffer.append(contNo).append("|");
		// ��������״̬ --BusinessType ���ķ��ص�ҵ������
		// 00-��ԥ���ڲ����˱���01-��ԥ����ȫ���˱���02-�������ڲ����˱���03-��������ȫ���˱���
		//	04-��������������ֹ��05-���ڸ�����ֹ��06-��������ʧЧ״̬
		/**
			00������Ч  01������ֹ 02	�˱���ֹ 04	������ֹ WT	��ԥ���˱���ֹ A�ܱ�  B	��ǩ��
		 */
		String state = element.getChildText("ContState");//���ķ��ص�״̬����ContState
		if ("WT".equals(state)) {
			sBuffer.append("00|");//00-��ԥ���ڲ����˱�
		}else if ("02".equals(state)) {
			sBuffer.append("02|");//02-�������ڲ����˱�
		}else if("03".equals(state)) {
			sBuffer.append("03|");//03-��������ȫ���˱�
		}else if ("04".equals(state)) {
			sBuffer.append("04|");//04-��������������ֹ
		}else if ("01".equals(state)) {
			sBuffer.append("05|");//05-���ڸ�����ֹ
		}else {
			sBuffer.append("06|");
		}

		// �˱����
		String amt = element.getChildText("EdorCTPrem");
		sBuffer.append(NumberUtil.fenToYuan(amt)).append("|");
		// �˱�����
		/* 00-���չ�˾ 01-���й��� 02-���� 03-����ͨ 04-�绰���� 05-�ֻ����� */
		//String channelType = element.getChildText("");
		sBuffer.append("00").append("|");
		// �˱�������
		String NodeNo = element.getChildText("NodeNo");
		sBuffer.append(NodeNo).append("|");

		// �����ֶ�
		sBuffer.append("|").append("|").append("|").append("|").append("\n");

		return sBuffer;
	}

	public static void main(String[] args) throws Exception {
		
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.psbc.bat.CibBusiBlc.main");
		mLogger.info("����ʼ...");

		CibQueryPolicyStatus mBatch = new CibQueryPolicyStatus();

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
				// mBatch.setDate(args[0]);
				System.out.println("�ļ�������ȷ��");
			} else {
				throw new MidplatException("���ڸ�ʽ����ӦΪyyyyMMdd��" + args[0]);
			}
		}

		mBatch.run();

		mLogger.info("�ɹ�������");
		/*Calendar   cal   =   Calendar.getInstance();
		  cal.add(Calendar.DATE,   -1);
		  String yesterday = new SimpleDateFormat( "yyyyMMdd ").format(cal.getTime());
		  System.out.println(yesterday);*/
	}

	@Override
	protected void setBody(Element bodyEle) throws Exception {
		// TODO Auto-generated method stub
		
	}

}
