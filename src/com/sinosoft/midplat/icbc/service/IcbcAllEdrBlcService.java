package com.sinosoft.midplat.icbc.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.Format;
import com.sinosoft.midplat.icbc.IcbcConf;
import com.sinosoft.midplat.service.Service;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class IcbcAllEdrBlcService extends ServiceImpl {

	private Element thisRootConf;
	
	private final static String FUNCFLAG_BLC_EDR = "128";	// ��ȫ���ˣ����ˣ�
	private boolean hasBL = false ;
	private boolean hasBD = false ;
	
	public IcbcAllEdrBlcService(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document inXmlDoc) throws Exception {
		
		long tStartMillis = System.currentTimeMillis();
		cLogger.info("Into IcbcAllEdrBlcService.service()...");
		cInXmlDoc = inXmlDoc;
		this.thisRootConf = IcbcConf.newInstance().getConf().getRootElement();

		String localFilePath = getOutLocalDir();
		InputStream is = null;
		BufferedReader mBufReader = null;
		// ����ˮ
		try {
//			cTranLogDB = insertTranLog(inXmlDoc);
			Document inNoStdDoc = null;
			// ���ܺ��ٵ�����Ӧ�Ķ��˽ӿ�
			Element reqBodyEle = new Element("Body");
			//�����ճ���ȫ�����ˡ��˱������ڣ�
			List<Element> detailBQEleList = XPath.selectNodes(inXmlDoc.getRootElement(),"//Detail");
			System.out.println("===========�ճ���ȫ�ļ�ת�����������ʼ===============");
    		JdomUtil.print(inXmlDoc);
    		System.out.println("===========�ճ���ȫȫ�ļ�ת�������������===============");
			for (Element detailEle : detailBQEleList) {
				reqBodyEle.addContent(detailEle.detach());
			}
			
			// 1.��ȡ����ĳ�����ն����ļ������������ļ����������ն����ļ����������ն����ļ���
			Element mBankEle = thisRootConf.getChild("bank");
			Element mTranDataEle = inXmlDoc.getRootElement();
			Element mHeadEle = mTranDataEle.getChild("Head");
			//�ճ������ļ�
			String riBQname = mBankEle.getAttributeValue("insu")+mBankEle.getAttributeValue(id)+mHeadEle.getChildText("TranDate")+"BAOQUAN.txt";
            //������Ѻ�����ļ�����
			String guimianBQName = mBankEle.getAttributeValue("insu")+"_"+mBankEle.getAttributeValue(id)+"_"+mHeadEle.getChildText("TranDate")+"_LMIMPAW.txt";
			//�ճ���ȫ�����ļ�
			File richangBQFile = new File(localFilePath+riBQname);
			//������Ѻ�����ļ��ļ�
			File guimianBQFile = new File(localFilePath+guimianBQName);
            /**
             * ��ʼ��������Ѻ�����ļ��ļ�
             */
            if(guimianBQFile.exists()){//�ļ�����
            	is = new FileInputStream(guimianBQFile);
            	mBufReader = new BufferedReader(new InputStreamReader(is));
            	Element mBodyEle = new Element(Body);				
        		Element pubContInfo = initPubContInfoNode();
							
        		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
        			cLogger.info(tLineMsg);       			
        			//���У�ֱ������
        			tLineMsg = tLineMsg.trim();
        			if ("".equals(tLineMsg)) {
        				cLogger.warn("���У�ֱ��������������һ����");
        				continue;
        			}						
        			//���н�����ˮ��|������|�����|����Ա|��֤����|��������|���׽��|�����־|��������|�����ֶ�1|�����ֶ�2|�����ֶ�3|�����ֶ�4|
        			String[] tSubMsgs = tLineMsg.split("\\|", -1);
        			for(int i=0 ; i < tSubMsgs.length ; i++){
        				System.out.println("tSubMsgs[+"+i+"]=="+tSubMsgs[i]);
        			}
        			//<!-- �������� --���ݽ�����ˮ�ŵ�tranlog���ȡfunflag�ж�edortyp>
        			Element tEdorTypeEle = new Element("EdorType");	  
                    String mSqlStr = "select FUNCFLAG,Bak5 from TranLog where Rcode ='0' and TRANNO='" + tSubMsgs[0] + "'";
            		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
            		if (1 != mSSRS.MaxRow) {
            			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
            		} 
            		System.out.println("FUNCFLAG: "+mSSRS.GetText(1, 1));           		
            		String cFUNCFLAG=  mSSRS.GetText(1, 1);
            		String cBak5=  mSSRS.GetText(1, 2);  
            		String setFlag = " ";
            		if ("162".equals(cFUNCFLAG) ) {  
            			tEdorTypeEle.setText("BL"); 
            			setFlag = "19";  
             		}
            		if ("163".equals(cFUNCFLAG)) { 
             			tEdorTypeEle.setText("BD"); 
             			setFlag = "29";
             		}
            		System.out.println("setFlag: " + setFlag);
            		setEdrTypeFlag(setFlag);       			
        			//<!-- ��ȫ��������� -->	
        			Element tEdorAppNoEle = new Element("EdorAppNo");
        			tEdorAppNoEle.setText("");       			
        			//<!-- ��ȫ��������[�Ǳ���] -->
        			Element tEdorNoEle = new Element("EdorNo");
        			tEdorNoEle.setText(cBak5);     			
        			//<!-- ��ȫ������������ YYYY-MM-DD-->
        			Element tEdorAppDateEle = new Element("EdorAppDate");
        			tEdorAppDateEle.setText(tSubMsgs[5]);       			
        			// <!-- ������ -->		<!--������-->
        			Element tContNoEle = new Element(ContNo);
        			tContNoEle.setText(tSubMsgs[4]);	        			
        			//���д���
        			Element tBankCodeEle = new Element("BankCode");
        			tBankCodeEle.setText(tSubMsgs[1]+tSubMsgs[2]);			       			
        			// <!-- ���׽�� ��λ���֣�1000000�ִ���10000Ԫ--> <!--������-->
        			Element tTranMoneyEle = new Element("TranMoney");
        			tTranMoneyEle.setText(tSubMsgs[6]);        			
        			//�����˻�
        			Element tAccNoEle = new Element(AccNo);
        			tAccNoEle.setText("");        			
        			//�˻�����
        			Element tAccNameEle = new Element(AccName);
        			tAccNameEle.setText("");       					
        			//  <!-- ��Ӧ�� 0�ɹ���1ʧ��-->
        			Element tRCodeEle = new Element("RCode");
        			tRCodeEle.setText(tSubMsgs[7]);
        			
        			Element tDetailEle = new Element(Detail);						
        			tDetailEle.addContent(tBankCodeEle);
        			tDetailEle.addContent(tEdorTypeEle);
        			tDetailEle.addContent(tEdorAppNoEle);
        			tDetailEle.addContent(tEdorNoEle);
        			tDetailEle.addContent(tEdorAppDateEle);
        			tDetailEle.addContent(tContNoEle);			
        			tDetailEle.addContent(tTranMoneyEle);
        			tDetailEle.addContent(tAccNoEle);
        			tDetailEle.addContent(tAccNameEle);
        			tDetailEle.addContent(tRCodeEle);       			
        			mBodyEle.addContent(tDetailEle);					
        		}      		
        		this.setPubContInfoValue(pubContInfo) ;
        		mBodyEle.addContent(pubContInfo);
//        		mBufReader.close(); // �ر���
        		inNoStdDoc = new Document(mBodyEle);
        		System.out.println("===========������Ѻ�ļ�ת�����������ʼ===============");
        		JdomUtil.print(inNoStdDoc);
        		System.out.println("===========������Ѻȫ�ļ�ת�������������===============");
                List<Element> detailEleList = XPath.selectNodes(inNoStdDoc.getRootElement(),"//Detail");		
				for (Element detailEle : detailEleList) {
					reqBodyEle.addContent(detailEle.detach());
				}
            }
            //ֻ�е����ж����ļ����ܿ�ʼ����Ľ��ж��˴���
            if(richangBQFile.exists() && guimianBQFile.exists()){
            	// ��֯���ģ����������ն��˽���ת��ʹ��
    			Document totalDetail = new Document(new Element(TranData));
    			Element pubContInfoEle = (Element)inXmlDoc.getRootElement().getChild("Body").getChild("PubContInfo").clone();		
    			Element bLBlcType = new Element("BLBlcType");
    			Element bDBlcType = new Element("BDBlcType");
    			if(hasBL){
    				bLBlcType.setText("1");
    			}else{
    				bLBlcType.setText("0");
    			}
    			if(hasBD){
    				bDBlcType.setText("1");
    			}else{
    				bDBlcType.setText("0");
    			}
    			pubContInfoEle.addContent(bLBlcType);
    			pubContInfoEle.addContent(bDBlcType);
    			
    			totalDetail.getRootElement().addContent(reqBodyEle);
    			totalDetail.getRootElement().getChild("Body").addContent(pubContInfoEle);
    			Element cHeadEle = (Element)inXmlDoc.getRootElement().getChild(Head).clone();

//    			cHeadEle.getChild(TranDate).setText(DateUtil.getDateStr(new Date(), "yyyyMMdd"));
    			cHeadEle.getChild(TranDate).setText(mHeadEle.getChildText("TranDate"));
    			totalDetail.getRootElement().addContent(cHeadEle);
    			System.out.println("===========����ǰ���ĸ�ʽ�����ʼ===============");
        		JdomUtil.print(totalDetail);
        		System.out.println("===========����ǰ���ĸ�ʽ�������===============");	
    			//�ۺϱ�ȫ���ˣ�����ԭ��ȫ���˺ͱ�����Ѻ
    			callServiceThread(FUNCFLAG_BLC_EDR, totalDetail);	
            }else{
            	cLogger.error("�����ļ������ڣ��ļ���Ϊ��"+guimianBQName + "��"+riBQname);
            	throw new MidplatException("�����ļ������ڣ��ļ���Ϊ��"+guimianBQName +"��"+riBQname);
            }
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "���׳ɹ�");	
			
		} catch (Exception e) {
			cLogger.error(cThisBusiConf.getChildText(name) + "����ʧ�ܣ�", e);

			if (null != cTranLogDB) { // ������־ʧ��ʱcTranLogDB=null
				cTranLogDB.setRCode(CodeDef.RCode_ERROR); // -1-δ���أ�0-���׳ɹ������أ�1-����ʧ�ܣ�����
				cTranLogDB.setRText(NumberUtil.cutStrByByte(e.getMessage(), 150, MidplatConf.newInstance().getDBCharset()));
			}
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, e.getMessage());
		}finally{//�ر���
			if(mBufReader != null){
				mBufReader.close();
			}
			if(is != null){
				is.close();
			}
		}
		
		if (null != cTranLogDB) {	//������־ʧ��ʱcTranLogDB=null
			
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));	//-1-δ���أ�0-���׳ɹ������أ�1-����ʧ�ܣ�����
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-tStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("������־��Ϣʧ�ܣ�" + cTranLogDB.mErrors.getFirstError());
			}
		}
		cLogger.info("Out PsbcFinanceBlc.service()!");
		return cOutXmlDoc;
	}


	/**
	 * ���ú���WebService����ӿ�
	 * @param funcFlag
	 * @param noStdXmlDoc
	 * @return
	 * @throws Exception
	 */
	private void callServiceThread(final String funcFlag, final Document noStdXmlDoc) throws Exception {
		// �½��߳�
		new Thread(String.valueOf(NoFactory.nextTranLogNo())) {
			@Override
			public void run() {
				try {
					Element thisBusiConf = (Element) XPath.selectSingleNode(thisRootConf, "business[funcFlag='" + funcFlag + "']");
					// ��Ҫ����һ�½�����
//					Element funcFlagEle = (Element) XPath.selectSingleNode(noStdXmlDoc.getRootElement(), "//Head/FuncFlag");
//					funcFlagEle.setText(funcFlag);
					// ����Ǳ�׼����
					StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
							.getName()).append('_').append(NoFactory.nextAppNo()).append(
							'_').append(funcFlag).append("_in.xml");
					SaveMessage.save(noStdXmlDoc,((Element) thisRootConf.getChild(TranCom).clone()).getText(), mSaveName.toString());
					// 2. �������ն��˷���
					sendRequest(noStdXmlDoc, thisBusiConf);
				} catch (Exception e) {
					cLogger.error("���ս���ʧ�ܣ�������[" + funcFlag + "]", e);
				}
			}
		}.start();
	}
	
	/**
	 * ����ת�������Ǳ�׼����ת��Ϊ���ĵı�׼���ġ�
	 * 
	 * @param pNoStdXml
	 * @param thisBusiConf
	 * @return
	 * @throws Exception
	 */
	private Document nostd2std(Document pNoStdXml, Element thisBusiConf) throws Exception {
		String tFormatClassName = thisBusiConf.getChildText(format);
		// ����ת��ģ��
		cLogger.info((new StringBuilder("����ת��ģ�飺")).append(tFormatClassName).toString());
		Constructor tFormatConstructor = Class.forName(tFormatClassName).getConstructor(new Class[] { org.jdom.Element.class });
		Format tFormat = (Format) tFormatConstructor.newInstance(new Object[] { thisBusiConf });
		return tFormat.noStd2Std(pNoStdXml);
	}
	
	/**
	 * ���ͽ�������
	 * 
	 * @param tInStd	��׼����
	 * @param thisBusiConf
	 * @return
	 * @throws Exception
	 */
	protected Document sendRequest(Document tInStd, Element thisBusiConf) throws Exception {

		// ҵ����
		String tServiceClassName = thisBusiConf.getChildText(service);
		cLogger.debug((new StringBuilder("ҵ����ģ�飺")).append(tServiceClassName).toString());
		Constructor tServiceConstructor = Class.forName(tServiceClassName).getConstructor(new Class[] { org.jdom.Element.class });
		Service tService = (Service) tServiceConstructor.newInstance(new Object[] { thisBusiConf });
		Document tOutStdXml = tService.service(tInStd);

		// У������Ƿ���������		
		Element tOutHeadEle = tOutStdXml.getRootElement().getChild(Head);
		if (CodeDef.RCode_ERROR == Integer.parseInt(tOutHeadEle.getChildText(Flag))) {	//����ʧ��
			throw new MidplatException(tOutHeadEle.getChildText(Desc));
		}
		return tOutStdXml;

	}

	/**
	 * ��ȡ�ļ����·��
	 * @return
	 */
	public String getOutLocalDir() {
		
		String filePath = cThisBusiConf.getChildText(localDir);
		if(filePath.endsWith("/")){
			// do nothing...
		}else{
			filePath = filePath + "/";
		}
		return filePath;
	}
	
	private void setPubContInfoValue(Element pubContInfo){		
		pubContInfo.getChild("BLBlcType").setText(this.hasBL ? "1" : "0") ;
		pubContInfo.getChild("BDBlcType").setText(this.hasBD ? "1" : "0") ;
	}
	
	private Element initPubContInfoNode(){
		Element pubContInfoEle = new Element("PubContInfo");
		
 		Element bLBlcType = new Element("BLBlcType");
		Element bDBlcType = new Element("BDBlcType");

		pubContInfoEle.addContent(bLBlcType);
		pubContInfoEle.addContent(bDBlcType);
		return pubContInfoEle ;
		
	}	
	
	private void setEdrTypeFlag(String flag) throws Exception{	
	    if ("19".equals(flag)){	    	
	    	if(!this.hasBL){
				this.hasBL = true ;
				cLogger.info("19");			
			}
	    }	    
       if ("29".equals(flag)){   	  
	       if(!this.hasBD){
			this.hasBD = true ;
			cLogger.info("29");
	       }
        }		
	}	
	
	public static void main(String[] args) {
		try {
			Element tCcbConfEle = IcbcConf.newInstance().getConf().getRootElement();
			Element tBusiConf = (Element) XPath.selectSingleNode(tCcbConfEle, "business[funcFlag='321']");
			IcbcAllEdrBlcService tCcbFinanceBlc = new IcbcAllEdrBlcService(tBusiConf);
			
			Document inNoStdDoc = JdomUtil.build(IOTrans.toString(new FileReader(new File("D:/CCBfile/put/653598_23_321_in.xml"))));
			tCcbFinanceBlc.service(inNoStdDoc);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}

