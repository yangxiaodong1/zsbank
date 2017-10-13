/**
 * Copyright (c) 2006 sinosoft Co. Ltd.
 * All right reserved.
 */

package com.sinosoft.lis.vdb;

import java.sql.*;
import com.sinosoft.lis.schema.HxbankInfoSchema;
import com.sinosoft.lis.vschema.HxbankInfoSet;
import com.sinosoft.lis.pubfun.*;
import com.sinosoft.utility.*;

/**
 * <p>ClassName: HxbankInfoDBSet </p>
 * <p>Description: DB����¼���ݿ�������ļ� </p>
 * <p>Company: sinosoft </p>
 * @Database: PHYSICAL_DATA_MODEL_1
 * @author��Maker
 * @CreateDate��2014-04-23
 */
public class HxbankInfoDBSet extends HxbankInfoSet
{
	// @Field
	private Connection con;
	private DBOper db;
	/**
	* flag = true: ����Connection
	* flag = false: ������Connection
	**/
	private boolean mflag = false;


	// @Constructor
	public HxbankInfoDBSet(Connection tConnection)
	{
		con = tConnection;
		db = new DBOper(con,"HxbankInfo");
		mflag = true;
	}

	public HxbankInfoDBSet()
	{
		db = new DBOper( "HxbankInfo" );
	}
	// @Method
	public boolean deleteSQL()
	{
		if (db.deleteSQL(this))
		{
		        return true;
		}
		else
		{
			// @@������
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDBSet";
			tError.functionName = "deleteSQL";
			tError.errorMessage = "����ʧ��!";
			this.mErrors .addOneError(tError);
			return false;
		}
	}

    /**
     * ɾ������
     * ɾ������������
     * @return boolean
     */
	public boolean delete()
	{
		PreparedStatement pstmt = null;

		if( !mflag ) {
			con = DBConnPool.getConnection();
		}

		try
		{
			if (!mflag)
			{
				// ������ڲ����������ӣ���Ҫ����Commitģʽ
				con.setAutoCommit(false);
			}

            int tCount = this.size();
			pstmt = con.prepareStatement("DELETE FROM HxbankInfo WHERE  TranCom = ? AND BankCode = ?");
            for (int i = 1; i <= tCount; i++)
            {
			pstmt.setDouble(1, this.get(i).getTranCom());
			if(this.get(i).getBankCode() == null || this.get(i).getBankCode().equals("null")) {
				pstmt.setString(2,null);
			} else {
				pstmt.setString(2, this.get(i).getBankCode());
			}
                pstmt.addBatch();
            }
            pstmt.executeBatch();
			pstmt.close();

			if (!mflag)
			{
				// ������ڲ����������ӣ�ִ�гɹ�����Ҫִ��Commit
				con.commit();
				con.close();
			}
		} catch (Exception ex) {
			// @@������
ex.printStackTrace();
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDBSet";
			tError.functionName = "delete()";
			tError.errorMessage = ex.toString();
			this.mErrors .addOneError(tError);

			try {
				pstmt.close();
			} catch (Exception e){e.printStackTrace();}

			if( !mflag ) {
				//������ڲ����������ӣ��������Ҫִ��RollBack
				try {
					con.rollback();
					con.close();
				} catch (Exception e){e.printStackTrace();}
			}

			return false;
		}
       finally{
		if( !mflag ) {
			try {
				con.close();
			} catch (Exception e){e.printStackTrace();}
		}}

		return true;
	}

    /**
     * ���²���
     * ��������������
     * @return boolean
     */
	public boolean update()
	{
		PreparedStatement pstmt = null;

		if( !mflag ) {
			con = DBConnPool.getConnection();
		}

		try
		{
			if (!mflag)
			{
				// ������ڲ����������ӣ���Ҫ����Commitģʽ
				con.setAutoCommit(false);
			}

            int tCount = this.size();
			pstmt = con.prepareStatement("UPDATE HxbankInfo SET  TranCom = ? , BankCode = ? , BankShortName = ? , BankFullName = ? , BankType = ? , UpBankCode = ? , UpBankShotName = ? , MakeDate = ? , MakeTime = ? , ModifyDate = ? , ModifyTime = ? , Operator = ? WHERE  TranCom = ? AND BankCode = ?");
            for (int i = 1; i <= tCount; i++)
            {
			pstmt.setDouble(1, this.get(i).getTranCom());
			if(this.get(i).getBankCode() == null || this.get(i).getBankCode().equals("null")) {
				pstmt.setString(2,null);
			} else {
				pstmt.setString(2, this.get(i).getBankCode());
			}
			if(this.get(i).getBankShortName() == null || this.get(i).getBankShortName().equals("null")) {
				pstmt.setString(3,null);
			} else {
				pstmt.setString(3, this.get(i).getBankShortName());
			}
			if(this.get(i).getBankFullName() == null || this.get(i).getBankFullName().equals("null")) {
				pstmt.setString(4,null);
			} else {
				pstmt.setString(4, this.get(i).getBankFullName());
			}
			if(this.get(i).getBankType() == null || this.get(i).getBankType().equals("null")) {
				pstmt.setString(5,null);
			} else {
				pstmt.setString(5, this.get(i).getBankType());
			}
			if(this.get(i).getUpBankCode() == null || this.get(i).getUpBankCode().equals("null")) {
				pstmt.setString(6,null);
			} else {
				pstmt.setString(6, this.get(i).getUpBankCode());
			}
			if(this.get(i).getUpBankShotName() == null || this.get(i).getUpBankShotName().equals("null")) {
				pstmt.setString(7,null);
			} else {
				pstmt.setString(7, this.get(i).getUpBankShotName());
			}
			if(this.get(i).getMakeDate() == null || this.get(i).getMakeDate().equals("null")) {
				pstmt.setDate(8,null);
			} else {
				pstmt.setDate(8, Date.valueOf(this.get(i).getMakeDate()));
			}
			if(this.get(i).getMakeTime() == null || this.get(i).getMakeTime().equals("null")) {
				pstmt.setString(9,null);
			} else {
				pstmt.setString(9, this.get(i).getMakeTime());
			}
			if(this.get(i).getModifyDate() == null || this.get(i).getModifyDate().equals("null")) {
				pstmt.setDate(10,null);
			} else {
				pstmt.setDate(10, Date.valueOf(this.get(i).getModifyDate()));
			}
			if(this.get(i).getModifyTime() == null || this.get(i).getModifyTime().equals("null")) {
				pstmt.setString(11,null);
			} else {
				pstmt.setString(11, this.get(i).getModifyTime());
			}
			if(this.get(i).getOperator() == null || this.get(i).getOperator().equals("null")) {
				pstmt.setString(12,null);
			} else {
				pstmt.setString(12, this.get(i).getOperator());
			}
			// set where condition
			pstmt.setDouble(13, this.get(i).getTranCom());
			if(this.get(i).getBankCode() == null || this.get(i).getBankCode().equals("null")) {
				pstmt.setString(14,null);
			} else {
				pstmt.setString(14, this.get(i).getBankCode());
			}
                pstmt.addBatch();
            }
            pstmt.executeBatch();
			pstmt.close();

			if (!mflag)
			{
				// ������ڲ����������ӣ�ִ�гɹ�����Ҫִ��Commit
				con.commit();
				con.close();
			}
		} catch (Exception ex) {
			// @@������
ex.printStackTrace();
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDBSet";
			tError.functionName = "update()";
			tError.errorMessage = ex.toString();
			this.mErrors .addOneError(tError);

			try {
				pstmt.close();
			} catch (Exception e){e.printStackTrace();}

			if( !mflag ) {
				//������ڲ����������ӣ��������Ҫִ��RollBack
				try {
					con.rollback();
					con.close();
				} catch (Exception e){e.printStackTrace();}
			}

			return false;
		}
       finally{
		if( !mflag ) {
			try {
				con.close();
			} catch (Exception e){e.printStackTrace();}
		}}

		return true;
	}

    /**
     * ��������
     * @return boolean
     */
	public boolean insert()
	{
		PreparedStatement pstmt = null;

		if( !mflag ) {
			con = DBConnPool.getConnection();
		}

		try
		{
			if (!mflag)
			{
				// ������ڲ����������ӣ���Ҫ����Commitģʽ
				con.setAutoCommit(false);
			}

            int tCount = this.size();
			pstmt = con.prepareStatement("INSERT INTO HxbankInfo VALUES( ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ?)");
            for (int i = 1; i <= tCount; i++)
            {
			pstmt.setDouble(1, this.get(i).getTranCom());
			if(this.get(i).getBankCode() == null || this.get(i).getBankCode().equals("null")) {
				pstmt.setString(2,null);
			} else {
				pstmt.setString(2, this.get(i).getBankCode());
			}
			if(this.get(i).getBankShortName() == null || this.get(i).getBankShortName().equals("null")) {
				pstmt.setString(3,null);
			} else {
				pstmt.setString(3, this.get(i).getBankShortName());
			}
			if(this.get(i).getBankFullName() == null || this.get(i).getBankFullName().equals("null")) {
				pstmt.setString(4,null);
			} else {
				pstmt.setString(4, this.get(i).getBankFullName());
			}
			if(this.get(i).getBankType() == null || this.get(i).getBankType().equals("null")) {
				pstmt.setString(5,null);
			} else {
				pstmt.setString(5, this.get(i).getBankType());
			}
			if(this.get(i).getUpBankCode() == null || this.get(i).getUpBankCode().equals("null")) {
				pstmt.setString(6,null);
			} else {
				pstmt.setString(6, this.get(i).getUpBankCode());
			}
			if(this.get(i).getUpBankShotName() == null || this.get(i).getUpBankShotName().equals("null")) {
				pstmt.setString(7,null);
			} else {
				pstmt.setString(7, this.get(i).getUpBankShotName());
			}
			if(this.get(i).getMakeDate() == null || this.get(i).getMakeDate().equals("null")) {
				pstmt.setDate(8,null);
			} else {
				pstmt.setDate(8, Date.valueOf(this.get(i).getMakeDate()));
			}
			if(this.get(i).getMakeTime() == null || this.get(i).getMakeTime().equals("null")) {
				pstmt.setString(9,null);
			} else {
				pstmt.setString(9, this.get(i).getMakeTime());
			}
			if(this.get(i).getModifyDate() == null || this.get(i).getModifyDate().equals("null")) {
				pstmt.setDate(10,null);
			} else {
				pstmt.setDate(10, Date.valueOf(this.get(i).getModifyDate()));
			}
			if(this.get(i).getModifyTime() == null || this.get(i).getModifyTime().equals("null")) {
				pstmt.setString(11,null);
			} else {
				pstmt.setString(11, this.get(i).getModifyTime());
			}
			if(this.get(i).getOperator() == null || this.get(i).getOperator().equals("null")) {
				pstmt.setString(12,null);
			} else {
				pstmt.setString(12, this.get(i).getOperator());
			}
                pstmt.addBatch();
            }
            pstmt.executeBatch();
			pstmt.close();

			if (!mflag)
			{
				// ������ڲ����������ӣ�ִ�гɹ�����Ҫִ��Commit
				con.commit();
				con.close();
			}
		} catch (Exception ex) {
			// @@������
ex.printStackTrace();
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDBSet";
			tError.functionName = "insert()";
			tError.errorMessage = ex.toString();
			this.mErrors .addOneError(tError);

			try {
				pstmt.close();
			} catch (Exception e){e.printStackTrace();}

			if( !mflag ) {
				//������ڲ����������ӣ��������Ҫִ��RollBack
				try {
					con.rollback();
					con.close();
				} catch (Exception e){e.printStackTrace();}
			}

			return false;
		}
       finally{
		if( !mflag ) {
			try {
				con.close();
			} catch (Exception e){e.printStackTrace();}
		}}

		return true;
	}

}
