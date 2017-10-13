package com.sinosoft.midplat.hxb.service;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.lis.pubfun.MMap;
import com.sinosoft.lis.pubfun.PubSubmit;
import com.sinosoft.lis.schema.HxbankInfoSchema;
import com.sinosoft.lis.vschema.HxbankInfoSet;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.hxb.format.HxbConstant;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.VData;

public class HxbAgentComBlcService extends ServiceImpl {

	public HxbAgentComBlcService(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document pInXmlDoc) {
		long mStartMillis = System.currentTimeMillis();
		cLogger.info("Into HxbAgentComBlcService.service()...");
		cInXmlDoc = pInXmlDoc;
		
		try {

			cTranLogDB = insertTranLog(cInXmlDoc);
			
			String tSqlStr = new StringBuilder("select 1 from TranLog where RCode=").append(CodeDef.RCode_OK)
				.append(" and TranDate=").append(cTranLogDB.getTranDate())
				.append(" and FuncFlag=").append(cTranLogDB.getFuncFlag())
				.append(" and TranCom=").append(cTranLogDB.getTranCom())
				.append(" and NodeNo='").append(cTranLogDB.getNodeNo()).append('\'')
				.toString();
			
			ExeSQL tExeSQL = new ExeSQL();
			if ("1".equals(tExeSQL.getOneValue(tSqlStr))) {
				throw new MidplatException("�ѳɹ�����������Ϣ���£������ظ�������");
			} else if (tExeSQL.mErrors.needDealError()) {
				throw new MidplatException("��ѯ���������ʷ��Ϣ�쳣��");
			}
			
			//����ǰ�û��������ı�����Ϣ(ɨ�賬ʱ��)
			String tErrorStr = cInXmlDoc.getRootElement().getChildText(Error);
			if (null != tErrorStr) {
				throw new MidplatException(tErrorStr);
			}
			
			//����������ϸ��Ϣ
			cOutXmlDoc = saveDetails(cInXmlDoc);
			
			Element tOutHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			if (CodeDef.RCode_ERROR == Integer.parseInt(tOutHeadEle.getChildText(Flag))) {	//����ʧ��
				throw new MidplatException(tOutHeadEle.getChildText(Desc));
			}
			
		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"����ʧ�ܣ�", ex);
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
		}
		
		if (null != cTranLogDB) {	//������־ʧ��ʱcTranLogDB=null
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));	//-1-δ���أ�0-���׳ɹ������أ�1-����ʧ�ܣ�����
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("������־��Ϣʧ�ܣ�" + cTranLogDB.mErrors.getFirstError());
			}
		}
		
		cLogger.info("Out HxbAgentComBlcService.service()!");
		return cOutXmlDoc;
	}
	
	/**
	 * ����������ϸ�����ش���������
	 */
	@SuppressWarnings("unchecked")
	private Document saveDetails(Document pXmlDoc) throws Exception {
		cLogger.debug("Into HxbAgentComBlcService.saveDetails()...");
		
		String currDate = DateUtil.getCur10Date();
		String currTime = DateUtil.getCur8Time();
		Document retDoc = new Document();	// ���صĽ������
		boolean flag = true;
		String msg = "hxb�ύ�ͻ������������ɹ�";
		
		Element mTranDataEle = pXmlDoc.getRootElement();
		String mTranCom = mTranDataEle.getChild(Head).getChildTextTrim(TranCom);
		Element mBodyEle = mTranDataEle.getChild(Body);
		
		List<Element> mDetailList = mBodyEle.getChildren(Detail);
		int count = mDetailList.size();
		cLogger.debug("����hxb����������" + count + "��");
		
		if(count>0){	// �и������ݣ����������
			
			String mSqlStr = "delete from hxbankinfo";	// ɾ�������ȫ������
			boolean tSSRS = new ExeSQL().execUpdateSQL(mSqlStr);
			if(!tSSRS){
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "hxbɾ����������ʧ��");
				throw new MidplatException("hxbɾ����������ʧ�ܣ�");
			}
			
			HxbankInfoSet mHxbankInfoSet = new HxbankInfoSet();
			for(Element tDetailEle : mDetailList){
				
				HxbankInfoSchema tHxbankInfoSchema = new HxbankInfoSchema();

				tHxbankInfoSchema.setTranCom(mTranCom);
				tHxbankInfoSchema.setBankCode(tDetailEle.getChildTextTrim(HxbConstant.BankCode));
				tHxbankInfoSchema.setBankFullName(tDetailEle.getChildTextTrim(HxbConstant.BankFullName));
				tHxbankInfoSchema.setBankShortName(tDetailEle.getChildTextTrim(HxbConstant.BankShortName));
				tHxbankInfoSchema.setBankType(tDetailEle.getChildTextTrim(HxbConstant.BankType));
				tHxbankInfoSchema.setUpBankCode(tDetailEle.getChildTextTrim(HxbConstant.UpBankCode));
				tHxbankInfoSchema.setUpBankShotName(tDetailEle.getChildTextTrim(HxbConstant.UpBankShotName));
				
				tHxbankInfoSchema.setMakeDate(currDate);
				tHxbankInfoSchema.setMakeTime(currTime);
				tHxbankInfoSchema.setModifyDate(currDate);
				tHxbankInfoSchema.setModifyTime(currTime);
				tHxbankInfoSchema.setOperator(HxbConstant.midplat);
				
				mHxbankInfoSet.add(tHxbankInfoSchema);
				
				if (mHxbankInfoSet.size() % 500 == 0) {
					if(!commonPart4GetCommision(mHxbankInfoSet)){
						cLogger.debug("hxb�ύ�ͻ��������ݲ��ֻ�ȫ�����ʧ��");
						msg = "hxb�ύ�ͻ��������ݲ��ֻ�ȫ�����ʧ��";
						flag = false;
					}
					mHxbankInfoSet.clear();
				}
			}
			
			if(!commonPart4GetCommision(mHxbankInfoSet)){
				cLogger.debug("hxb�ύ�ͻ��������ݲ��ֻ�ȫ�����ʧ��");
				msg = "hxb�ύ�ͻ��������ݲ��ֻ�ȫ�����ʧ��";
				flag = false;
			}
			
			if(flag){	// �����������ɹ� 
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, msg);	
			}else{	// �����������ʧ��
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, msg);
			}
			
		}else{	// �������򲻸���������Ϣ
			retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "���׳ɹ��������ļ������ݣ��������ݸ��£�����ǰһ�����������");
		}
		
		cLogger.debug("Out HxbAgentComBlcService.saveDetails()!");
		return retDoc;
	}
	
	/**
	 * �ύ���ݣ�����ɹ�����ture������ύ����ʧ�ܷ���false
	 * @param cHxbankInfoSet
	 * @return
	 */
	private boolean commonPart4GetCommision(HxbankInfoSet cHxbankInfoSet){
		
		MMap cMap = new MMap();

		cMap.put(cHxbankInfoSet, "INSERT");
		VData tInputData = new VData();
		tInputData.clear();
		tInputData.add(cMap);
		PubSubmit tPubSubmit = new PubSubmit();

		if(!tPubSubmit.submitData(tInputData, "")){
			cLogger.error("���������Ϣʧ�ܣ�" + tPubSubmit.mErrors.getFirstError());
			return false;
		}
		return true;
		
	}
}
