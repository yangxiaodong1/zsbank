/**
 * Copyright (c) 2006 sinosoft Co. Ltd.
 * All right reserved.
 */

package com.sinosoft.lis.schema;

import java.sql.*;
import java.io.*;
import java.util.Date;
import com.sinosoft.lis.pubfun.*;
import com.sinosoft.utility.*;
import com.sinosoft.lis.db.HxbankInfoDB;

/**
 * <p>ClassName: HxbankInfoSchema </p>
 * <p>Description: DB�� Schema ���ļ� </p>
 * <p>Company: sinosoft </p>
 * @Database: PHYSICAL_DATA_MODEL_1
 * @author��Maker
 * @CreateDate��2014-04-23
 */
public class HxbankInfoSchema implements Schema, Cloneable
{
	// @Field
	/** ���б�� */
	private int TranCom;
	/** �������� */
	private String BankCode;
	/** ������� */
	private String BankShortName;
	/** ����ȫ�� */
	private String BankFullName;
	/** �������� */
	private String BankType;
	/** �ϼ��������� */
	private String UpBankCode;
	/** �ϼ�������� */
	private String UpBankShotName;
	/** ������� */
	private Date MakeDate;
	/** ���ʱ�� */
	private String MakeTime;
	/** ���һ���޸����� */
	private Date ModifyDate;
	/** ���һ���޸�ʱ�� */
	private String ModifyTime;
	/** ������ */
	private String Operator;

	public static final int FIELDNUM = 12;	// ���ݿ����ֶθ���

	private static String[] PK;				// ����

	private FDate fDate = new FDate();		// ��������

	public CErrors mErrors;			// ������Ϣ

	// @Constructor
	public HxbankInfoSchema()
	{
		mErrors = new CErrors();

		String[] pk = new String[2];
		pk[0] = "TranCom";
		pk[1] = "BankCode";

		PK = pk;
	}

            /**
             * Schema��¡
             * @return Object
             * @throws CloneNotSupportedException
             */
            public Object clone()
                    throws CloneNotSupportedException
            {
                HxbankInfoSchema cloned = (HxbankInfoSchema)super.clone();
                cloned.fDate = (FDate) fDate.clone();
                cloned.mErrors = (CErrors) mErrors.clone();
                return cloned;
            }

	// @Method
	public String[] getPK()
	{
		return PK;
	}

	public int getTranCom()
	{
		return TranCom;
	}
	public void setTranCom(int aTranCom)
	{
            TranCom = aTranCom;
	}
	public void setTranCom(String aTranCom)
	{
		if (aTranCom != null && !aTranCom.equals(""))
		{
			Integer tInteger = new Integer(aTranCom);
			int i = tInteger.intValue();
			TranCom = i;
		}
	}

	public String getBankCode()
	{
		return BankCode;
	}
	public void setBankCode(String aBankCode)
	{
            BankCode = aBankCode;
	}
	public String getBankShortName()
	{
		return BankShortName;
	}
	public void setBankShortName(String aBankShortName)
	{
            BankShortName = aBankShortName;
	}
	public String getBankFullName()
	{
		return BankFullName;
	}
	public void setBankFullName(String aBankFullName)
	{
            BankFullName = aBankFullName;
	}
	public String getBankType()
	{
		return BankType;
	}
	public void setBankType(String aBankType)
	{
            BankType = aBankType;
	}
	public String getUpBankCode()
	{
		return UpBankCode;
	}
	public void setUpBankCode(String aUpBankCode)
	{
            UpBankCode = aUpBankCode;
	}
	public String getUpBankShotName()
	{
		return UpBankShotName;
	}
	public void setUpBankShotName(String aUpBankShotName)
	{
            UpBankShotName = aUpBankShotName;
	}
	public String getMakeDate()
	{
		if( MakeDate != null )
			return fDate.getString(MakeDate);
		else
			return null;
	}
	public void setMakeDate(Date aMakeDate)
	{
            MakeDate = aMakeDate;
	}
	public void setMakeDate(String aMakeDate)
	{
		if (aMakeDate != null && !aMakeDate.equals("") )
		{
			MakeDate = fDate.getDate( aMakeDate );
		}
		else
			MakeDate = null;
	}

	public String getMakeTime()
	{
		return MakeTime;
	}
	public void setMakeTime(String aMakeTime)
	{
            MakeTime = aMakeTime;
	}
	public String getModifyDate()
	{
		if( ModifyDate != null )
			return fDate.getString(ModifyDate);
		else
			return null;
	}
	public void setModifyDate(Date aModifyDate)
	{
            ModifyDate = aModifyDate;
	}
	public void setModifyDate(String aModifyDate)
	{
		if (aModifyDate != null && !aModifyDate.equals("") )
		{
			ModifyDate = fDate.getDate( aModifyDate );
		}
		else
			ModifyDate = null;
	}

	public String getModifyTime()
	{
		return ModifyTime;
	}
	public void setModifyTime(String aModifyTime)
	{
            ModifyTime = aModifyTime;
	}
	public String getOperator()
	{
		return Operator;
	}
	public void setOperator(String aOperator)
	{
            Operator = aOperator;
	}

	/**
	* ʹ������һ�� HxbankInfoSchema ����� Schema ��ֵ
	* @param: aHxbankInfoSchema HxbankInfoSchema
	**/
	public void setSchema(HxbankInfoSchema aHxbankInfoSchema)
	{
		this.TranCom = aHxbankInfoSchema.getTranCom();
		this.BankCode = aHxbankInfoSchema.getBankCode();
		this.BankShortName = aHxbankInfoSchema.getBankShortName();
		this.BankFullName = aHxbankInfoSchema.getBankFullName();
		this.BankType = aHxbankInfoSchema.getBankType();
		this.UpBankCode = aHxbankInfoSchema.getUpBankCode();
		this.UpBankShotName = aHxbankInfoSchema.getUpBankShotName();
		this.MakeDate = fDate.getDate( aHxbankInfoSchema.getMakeDate());
		this.MakeTime = aHxbankInfoSchema.getMakeTime();
		this.ModifyDate = fDate.getDate( aHxbankInfoSchema.getModifyDate());
		this.ModifyTime = aHxbankInfoSchema.getModifyTime();
		this.Operator = aHxbankInfoSchema.getOperator();
	}

	/**
	* ʹ�� ResultSet �еĵ� i �и� Schema ��ֵ
	* @param: rs ResultSet
	* @param: i int
	* @return: boolean
	**/
	public boolean setSchema(ResultSet rs,int i)
	{
		try
		{
			//rs.absolute(i);		// �ǹ����α�
	this.TranCom = rs.getInt(1);
	if( rs.getString(2) == null )
		this.BankCode = null;
	else
		this.BankCode = rs.getString(2).trim();

	if( rs.getString(3) == null )
		this.BankShortName = null;
	else
		this.BankShortName = rs.getString(3).trim();

	if( rs.getString(4) == null )
		this.BankFullName = null;
	else
		this.BankFullName = rs.getString(4).trim();

	if( rs.getString(5) == null )
		this.BankType = null;
	else
		this.BankType = rs.getString(5).trim();

	if( rs.getString(6) == null )
		this.UpBankCode = null;
	else
		this.UpBankCode = rs.getString(6).trim();

	if( rs.getString(7) == null )
		this.UpBankShotName = null;
	else
		this.UpBankShotName = rs.getString(7).trim();

	this.MakeDate = rs.getDate(8);
	if( rs.getString(9) == null )
		this.MakeTime = null;
	else
		this.MakeTime = rs.getString(9).trim();

	this.ModifyDate = rs.getDate(10);
	if( rs.getString(11) == null )
		this.ModifyTime = null;
	else
		this.ModifyTime = rs.getString(11).trim();

	if( rs.getString(12) == null )
		this.Operator = null;
	else
		this.Operator = rs.getString(12).trim();

		}
		catch(SQLException sqle)
		{
			System.out.println("���ݿ��б�HxbankInfo�ֶθ�����Schema�е��ֶθ�����һ�£���ִ��db.executeQuery��ѯʱδʹ��select * from tables");
			// @@������
			CError tError = new CError();
			tError.moduleName = "HxbankInfoSchema";
			tError.functionName = "setSchema";
			tError.errorMessage = sqle.toString();
			this.mErrors .addOneError(tError);
			return false;
		}
		return true;
	}

	public HxbankInfoSchema getSchema()
	{
		HxbankInfoSchema aHxbankInfoSchema = new HxbankInfoSchema();
		aHxbankInfoSchema.setSchema(this);
		return aHxbankInfoSchema;
	}

	public HxbankInfoDB getDB()
	{
		HxbankInfoDB aDBOper = new HxbankInfoDB();
		aDBOper.setSchema(this);
		return aDBOper;
	}


	/**
	* ���ݴ������ XML ��ʽ�����˳��μ�<A href ={@docRoot}/dataStructure/tb.html#PrpHxbankInfo����/A>���ֶ�
	* @return: String ���ش�����ַ���
	**/
	public String encode()
	{
		StringBuffer strReturn = new StringBuffer(256);
strReturn.append( ChgData.chgData(TranCom));strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(BankCode)); strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(BankShortName)); strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(BankFullName)); strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(BankType)); strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(UpBankCode)); strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(UpBankShotName)); strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(fDate.getString( MakeDate ))); strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(MakeTime)); strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(fDate.getString( ModifyDate ))); strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(ModifyTime)); strReturn.append(SysConst.PACKAGESPILTER);
strReturn.append(StrTool.cTrim(Operator));
		return strReturn.toString();
	}

	/**
	* ���ݽ�������˳��μ�<A href ={@docRoot}/dataStructure/tb.html#PrpHxbankInfo>��ʷ����ƾ֤������Ϣ</A>���ֶ�
	* @param: strMessage String ����һ����¼���ݵ��ַ���
	* @return: boolean
	**/
	public boolean decode(String strMessage)
	{
		try
		{
			TranCom= new Integer(ChgData.chgNumericStr(StrTool.getStr(strMessage,1,SysConst.PACKAGESPILTER))).intValue();
			BankCode = StrTool.getStr(StrTool.GBKToUnicode(strMessage), 2, SysConst.PACKAGESPILTER );
			BankShortName = StrTool.getStr(StrTool.GBKToUnicode(strMessage), 3, SysConst.PACKAGESPILTER );
			BankFullName = StrTool.getStr(StrTool.GBKToUnicode(strMessage), 4, SysConst.PACKAGESPILTER );
			BankType = StrTool.getStr(StrTool.GBKToUnicode(strMessage), 5, SysConst.PACKAGESPILTER );
			UpBankCode = StrTool.getStr(StrTool.GBKToUnicode(strMessage), 6, SysConst.PACKAGESPILTER );
			UpBankShotName = StrTool.getStr(StrTool.GBKToUnicode(strMessage), 7, SysConst.PACKAGESPILTER );
			MakeDate = fDate.getDate(StrTool.getStr(StrTool.GBKToUnicode(strMessage), 8,SysConst.PACKAGESPILTER));
			MakeTime = StrTool.getStr(StrTool.GBKToUnicode(strMessage), 9, SysConst.PACKAGESPILTER );
			ModifyDate = fDate.getDate(StrTool.getStr(StrTool.GBKToUnicode(strMessage), 10,SysConst.PACKAGESPILTER));
			ModifyTime = StrTool.getStr(StrTool.GBKToUnicode(strMessage), 11, SysConst.PACKAGESPILTER );
			Operator = StrTool.getStr(StrTool.GBKToUnicode(strMessage), 12, SysConst.PACKAGESPILTER );
		}
		catch(NumberFormatException ex)
		{
			// @@������
			CError tError = new CError();
			tError.moduleName = "HxbankInfoSchema";
			tError.functionName = "decode";
			tError.errorMessage = ex.toString();
			this.mErrors .addOneError(tError);

			return false;
		}
		return true;
	}

	/**
	* ȡ�ö�Ӧ���������String��ʽ���ֶ�ֵ
	* @param: FCode String ϣ��ȡ�õ��ֶ���
	* @return: String
	* ���û�ж�Ӧ���ֶΣ�����""
	* ����ֶ�ֵΪ�գ�����"null"
	**/
	public String getV(String FCode)
	{
		String strReturn = "";
		if (FCode.equals("TranCom"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf(TranCom));
		}
		if (FCode.equals("BankCode"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf(BankCode));
		}
		if (FCode.equals("BankShortName"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf(BankShortName));
		}
		if (FCode.equals("BankFullName"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf(BankFullName));
		}
		if (FCode.equals("BankType"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf(BankType));
		}
		if (FCode.equals("UpBankCode"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf(UpBankCode));
		}
		if (FCode.equals("UpBankShotName"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf(UpBankShotName));
		}
		if (FCode.equals("MakeDate"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf( this.getMakeDate()));
		}
		if (FCode.equals("MakeTime"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf(MakeTime));
		}
		if (FCode.equals("ModifyDate"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf( this.getModifyDate()));
		}
		if (FCode.equals("ModifyTime"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf(ModifyTime));
		}
		if (FCode.equals("Operator"))
		{
			strReturn = StrTool.GBKToUnicode(String.valueOf(Operator));
		}
		if (strReturn.equals(""))
		{
			strReturn = "null";
		}

		return strReturn;
	}


	/**
	* ȡ��Schema��ָ������ֵ����Ӧ���ֶ�ֵ
	* @param: nFieldIndex int ָ�����ֶ�����ֵ
	* @return: String
	* ���û�ж�Ӧ���ֶΣ�����""
	* ����ֶ�ֵΪ�գ�����"null"
	**/
	public String getV(int nFieldIndex)
	{
		String strFieldValue = "";
		switch(nFieldIndex) {
			case 0:
				strFieldValue = String.valueOf(TranCom);
				break;
			case 1:
				strFieldValue = StrTool.GBKToUnicode(BankCode);
				break;
			case 2:
				strFieldValue = StrTool.GBKToUnicode(BankShortName);
				break;
			case 3:
				strFieldValue = StrTool.GBKToUnicode(BankFullName);
				break;
			case 4:
				strFieldValue = StrTool.GBKToUnicode(BankType);
				break;
			case 5:
				strFieldValue = StrTool.GBKToUnicode(UpBankCode);
				break;
			case 6:
				strFieldValue = StrTool.GBKToUnicode(UpBankShotName);
				break;
			case 7:
				strFieldValue = StrTool.GBKToUnicode(String.valueOf( this.getMakeDate()));
				break;
			case 8:
				strFieldValue = StrTool.GBKToUnicode(MakeTime);
				break;
			case 9:
				strFieldValue = StrTool.GBKToUnicode(String.valueOf( this.getModifyDate()));
				break;
			case 10:
				strFieldValue = StrTool.GBKToUnicode(ModifyTime);
				break;
			case 11:
				strFieldValue = StrTool.GBKToUnicode(Operator);
				break;
			default:
				strFieldValue = "";
		};
		if( strFieldValue.equals("") ) {
			strFieldValue = "null";
		}
		return strFieldValue;
	}

	/**
	* ���ö�Ӧ���������String��ʽ���ֶ�ֵ
	* @param: FCode String ��Ҫ��ֵ�Ķ���
	* @param: FValue String Ҫ����ֵ
	* @return: boolean
	**/
	public boolean setV(String FCode ,String FValue)
	{
		if( StrTool.cTrim( FCode ).equals( "" ))
			return false;

		if (FCode.equalsIgnoreCase("TranCom"))
		{
			if( FValue != null && !FValue.equals(""))
			{
				Integer tInteger = new Integer( FValue );
				int i = tInteger.intValue();
				TranCom = i;
			}
		}
		if (FCode.equalsIgnoreCase("BankCode"))
		{
			if( FValue != null && !FValue.equals(""))
			{
				BankCode = FValue.trim();
			}
			else
				BankCode = null;
		}
		if (FCode.equalsIgnoreCase("BankShortName"))
		{
			if( FValue != null && !FValue.equals(""))
			{
				BankShortName = FValue.trim();
			}
			else
				BankShortName = null;
		}
		if (FCode.equalsIgnoreCase("BankFullName"))
		{
			if( FValue != null && !FValue.equals(""))
			{
				BankFullName = FValue.trim();
			}
			else
				BankFullName = null;
		}
		if (FCode.equalsIgnoreCase("BankType"))
		{
			if( FValue != null && !FValue.equals(""))
			{
				BankType = FValue.trim();
			}
			else
				BankType = null;
		}
		if (FCode.equalsIgnoreCase("UpBankCode"))
		{
			if( FValue != null && !FValue.equals(""))
			{
				UpBankCode = FValue.trim();
			}
			else
				UpBankCode = null;
		}
		if (FCode.equalsIgnoreCase("UpBankShotName"))
		{
			if( FValue != null && !FValue.equals(""))
			{
				UpBankShotName = FValue.trim();
			}
			else
				UpBankShotName = null;
		}
		if (FCode.equalsIgnoreCase("MakeDate"))
		{
			if( FValue != null && !FValue.equals("") )
			{
				MakeDate = fDate.getDate( FValue );
			}
			else
				MakeDate = null;
		}
		if (FCode.equalsIgnoreCase("MakeTime"))
		{
			if( FValue != null && !FValue.equals(""))
			{
				MakeTime = FValue.trim();
			}
			else
				MakeTime = null;
		}
		if (FCode.equalsIgnoreCase("ModifyDate"))
		{
			if( FValue != null && !FValue.equals("") )
			{
				ModifyDate = fDate.getDate( FValue );
			}
			else
				ModifyDate = null;
		}
		if (FCode.equalsIgnoreCase("ModifyTime"))
		{
			if( FValue != null && !FValue.equals(""))
			{
				ModifyTime = FValue.trim();
			}
			else
				ModifyTime = null;
		}
		if (FCode.equalsIgnoreCase("Operator"))
		{
			if( FValue != null && !FValue.equals(""))
			{
				Operator = FValue.trim();
			}
			else
				Operator = null;
		}
		return true;
	}

	public boolean equals(Object otherObject)
	{
		if (this == otherObject) return true;
		if (otherObject == null) return false;
		if (getClass() != otherObject.getClass()) return false;
		HxbankInfoSchema other = (HxbankInfoSchema)otherObject;
		return
			TranCom == other.getTranCom()
			&& BankCode.equals(other.getBankCode())
			&& BankShortName.equals(other.getBankShortName())
			&& BankFullName.equals(other.getBankFullName())
			&& BankType.equals(other.getBankType())
			&& UpBankCode.equals(other.getUpBankCode())
			&& UpBankShotName.equals(other.getUpBankShotName())
			&& fDate.getString(MakeDate).equals(other.getMakeDate())
			&& MakeTime.equals(other.getMakeTime())
			&& fDate.getString(ModifyDate).equals(other.getModifyDate())
			&& ModifyTime.equals(other.getModifyTime())
			&& Operator.equals(other.getOperator());
	}

	/**
	* ȡ��Schemaӵ���ֶε�����
       * @return: int
	**/
	public int getFieldCount()
	{
 		return FIELDNUM;
	}

	/**
	* ȡ��Schema��ָ���ֶ�������Ӧ������ֵ
	* ���û�ж�Ӧ���ֶΣ�����-1
       * @param: strFieldName String
       * @return: int
	**/
	public int getFieldIndex(String strFieldName)
	{
		if( strFieldName.equals("TranCom") ) {
			return 0;
		}
		if( strFieldName.equals("BankCode") ) {
			return 1;
		}
		if( strFieldName.equals("BankShortName") ) {
			return 2;
		}
		if( strFieldName.equals("BankFullName") ) {
			return 3;
		}
		if( strFieldName.equals("BankType") ) {
			return 4;
		}
		if( strFieldName.equals("UpBankCode") ) {
			return 5;
		}
		if( strFieldName.equals("UpBankShotName") ) {
			return 6;
		}
		if( strFieldName.equals("MakeDate") ) {
			return 7;
		}
		if( strFieldName.equals("MakeTime") ) {
			return 8;
		}
		if( strFieldName.equals("ModifyDate") ) {
			return 9;
		}
		if( strFieldName.equals("ModifyTime") ) {
			return 10;
		}
		if( strFieldName.equals("Operator") ) {
			return 11;
		}
		return -1;
	}

	/**
	* ȡ��Schema��ָ������ֵ����Ӧ���ֶ���
	* ���û�ж�Ӧ���ֶΣ�����""
       * @param: nFieldIndex int
       * @return: String
	**/
	public String getFieldName(int nFieldIndex)
	{
		String strFieldName = "";
		switch(nFieldIndex) {
			case 0:
				strFieldName = "TranCom";
				break;
			case 1:
				strFieldName = "BankCode";
				break;
			case 2:
				strFieldName = "BankShortName";
				break;
			case 3:
				strFieldName = "BankFullName";
				break;
			case 4:
				strFieldName = "BankType";
				break;
			case 5:
				strFieldName = "UpBankCode";
				break;
			case 6:
				strFieldName = "UpBankShotName";
				break;
			case 7:
				strFieldName = "MakeDate";
				break;
			case 8:
				strFieldName = "MakeTime";
				break;
			case 9:
				strFieldName = "ModifyDate";
				break;
			case 10:
				strFieldName = "ModifyTime";
				break;
			case 11:
				strFieldName = "Operator";
				break;
			default:
				strFieldName = "";
		};
		return strFieldName;
	}

	/**
	* ȡ��Schema��ָ���ֶ�������Ӧ���ֶ�����
	* ���û�ж�Ӧ���ֶΣ�����Schema.TYPE_NOFOUND
       * @param: strFieldName String
       * @return: int
	**/
	public int getFieldType(String strFieldName)
	{
		if( strFieldName.equals("TranCom") ) {
			return Schema.TYPE_INT;
		}
		if( strFieldName.equals("BankCode") ) {
			return Schema.TYPE_STRING;
		}
		if( strFieldName.equals("BankShortName") ) {
			return Schema.TYPE_STRING;
		}
		if( strFieldName.equals("BankFullName") ) {
			return Schema.TYPE_STRING;
		}
		if( strFieldName.equals("BankType") ) {
			return Schema.TYPE_STRING;
		}
		if( strFieldName.equals("UpBankCode") ) {
			return Schema.TYPE_STRING;
		}
		if( strFieldName.equals("UpBankShotName") ) {
			return Schema.TYPE_STRING;
		}
		if( strFieldName.equals("MakeDate") ) {
			return Schema.TYPE_DATE;
		}
		if( strFieldName.equals("MakeTime") ) {
			return Schema.TYPE_STRING;
		}
		if( strFieldName.equals("ModifyDate") ) {
			return Schema.TYPE_DATE;
		}
		if( strFieldName.equals("ModifyTime") ) {
			return Schema.TYPE_STRING;
		}
		if( strFieldName.equals("Operator") ) {
			return Schema.TYPE_STRING;
		}
		return Schema.TYPE_NOFOUND;
	}

	/**
	* ȡ��Schema��ָ������ֵ����Ӧ���ֶ�����
	* ���û�ж�Ӧ���ֶΣ�����Schema.TYPE_NOFOUND
       * @param: nFieldIndex int
       * @return: int
	**/
	public int getFieldType(int nFieldIndex)
	{
		int nFieldType = Schema.TYPE_NOFOUND;
		switch(nFieldIndex) {
			case 0:
				nFieldType = Schema.TYPE_INT;
				break;
			case 1:
				nFieldType = Schema.TYPE_STRING;
				break;
			case 2:
				nFieldType = Schema.TYPE_STRING;
				break;
			case 3:
				nFieldType = Schema.TYPE_STRING;
				break;
			case 4:
				nFieldType = Schema.TYPE_STRING;
				break;
			case 5:
				nFieldType = Schema.TYPE_STRING;
				break;
			case 6:
				nFieldType = Schema.TYPE_STRING;
				break;
			case 7:
				nFieldType = Schema.TYPE_DATE;
				break;
			case 8:
				nFieldType = Schema.TYPE_STRING;
				break;
			case 9:
				nFieldType = Schema.TYPE_DATE;
				break;
			case 10:
				nFieldType = Schema.TYPE_STRING;
				break;
			case 11:
				nFieldType = Schema.TYPE_STRING;
				break;
			default:
				nFieldType = Schema.TYPE_NOFOUND;
		};
		return nFieldType;
	}
}
