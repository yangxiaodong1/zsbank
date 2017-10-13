/**
 * Copyright (c) 2006 sinosoft Co. Ltd.
 * All right reserved.
 */

package com.sinosoft.lis.db;

import java.sql.*;
import com.sinosoft.lis.schema.HxbankInfoSchema;
import com.sinosoft.lis.vschema.HxbankInfoSet;
import com.sinosoft.lis.pubfun.PubFun;
import com.sinosoft.utility.*;

/**
 * <p>ClassName: HxbankInfoDB </p>
 * <p>Description: DB�����ݿ�������ļ� </p>
 * <p>Company: sinosoft </p>
 * @Database: PHYSICAL_DATA_MODEL_1
 * @author��Maker
 * @CreateDate��2014-04-23
 */
public class HxbankInfoDB extends HxbankInfoSchema
{
	// @Field
	private Connection con;
	private DBOper db;
	/**
	* flag = true: ����Connection
	* flag = false: ������Connection
	**/
	private boolean mflag = false;


	/**
	 * Ϊ����������׼���������α����
	 */
	private ResultSet mResultSet = null;
	private Statement mStatement = null;
	// @Constructor
	public HxbankInfoDB( Connection tConnection )
	{
		con = tConnection;
		db = new DBOper( con, "HxbankInfo" );
		mflag = true;
	}

	public HxbankInfoDB()
	{
		con = null;
		db = new DBOper( "HxbankInfo" );
		mflag = false;
	}

	// @Method
	public boolean deleteSQL()
	{
		HxbankInfoSchema tSchema = this.getSchema();
		if (db.deleteSQL(tSchema))
		{
		     return true;
		}
		else
		{
			// @@������
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "deleteSQL";
			tError.errorMessage = "����ʧ��!";
			this.mErrors .addOneError(tError);
			return false;
		}
	}

	public int getCount()
	{
		HxbankInfoSchema tSchema = this.getSchema();

		int tCount = db.getCount(tSchema);
		if (tCount < 0)
		{
			// @@������
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "getCount";
			tError.errorMessage = "����ʧ��!";
			this.mErrors .addOneError(tError);

			return -1;
		}

		return tCount;
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
			pstmt = con.prepareStatement("DELETE FROM HxbankInfo WHERE  TranCom = ? AND BankCode = ?");
			pstmt.setDouble(1, this.getTranCom());
			if(this.getBankCode() == null || this.getBankCode().equals("null")) {
				pstmt.setNull(2, 12);
			} else {
				pstmt.setString(2, this.getBankCode());
			}
			pstmt.executeUpdate();
			pstmt.close();
		} catch (Exception ex) {
                       ex.printStackTrace();
			// @@������
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "delete()";
			tError.errorMessage = ex.toString();
			this.mErrors .addOneError(tError);

			try {
				pstmt.close();
			} catch (Exception e){e.printStackTrace();}

			if( !mflag ) {
				try {
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
			pstmt = con.prepareStatement("UPDATE HxbankInfo SET  TranCom = ? , BankCode = ? , BankShortName = ? , BankFullName = ? , BankType = ? , UpBankCode = ? , UpBankShotName = ? , MakeDate = ? , MakeTime = ? , ModifyDate = ? , ModifyTime = ? , Operator = ? WHERE  TranCom = ? AND BankCode = ?");
			pstmt.setDouble(1, this.getTranCom());
			if(this.getBankCode() == null || this.getBankCode().equals("null")) {
				pstmt.setNull(2, 12);
			} else {
				pstmt.setString(2, this.getBankCode());
			}
			if(this.getBankShortName() == null || this.getBankShortName().equals("null")) {
				pstmt.setNull(3, 12);
			} else {
				pstmt.setString(3, this.getBankShortName());
			}
			if(this.getBankFullName() == null || this.getBankFullName().equals("null")) {
				pstmt.setNull(4, 12);
			} else {
				pstmt.setString(4, this.getBankFullName());
			}
			if(this.getBankType() == null || this.getBankType().equals("null")) {
				pstmt.setNull(5, 12);
			} else {
				pstmt.setString(5, this.getBankType());
			}
			if(this.getUpBankCode() == null || this.getUpBankCode().equals("null")) {
				pstmt.setNull(6, 12);
			} else {
				pstmt.setString(6, this.getUpBankCode());
			}
			if(this.getUpBankShotName() == null || this.getUpBankShotName().equals("null")) {
				pstmt.setNull(7, 12);
			} else {
				pstmt.setString(7, this.getUpBankShotName());
			}
			if(this.getMakeDate() == null || this.getMakeDate().equals("null")) {
				pstmt.setNull(8, 91);
			} else {
				pstmt.setDate(8, Date.valueOf(this.getMakeDate()));
			}
			if(this.getMakeTime() == null || this.getMakeTime().equals("null")) {
				pstmt.setNull(9, 12);
			} else {
				pstmt.setString(9, this.getMakeTime());
			}
			if(this.getModifyDate() == null || this.getModifyDate().equals("null")) {
				pstmt.setNull(10, 91);
			} else {
				pstmt.setDate(10, Date.valueOf(this.getModifyDate()));
			}
			if(this.getModifyTime() == null || this.getModifyTime().equals("null")) {
				pstmt.setNull(11, 12);
			} else {
				pstmt.setString(11, this.getModifyTime());
			}
			if(this.getOperator() == null || this.getOperator().equals("null")) {
				pstmt.setNull(12, 12);
			} else {
				pstmt.setString(12, this.getOperator());
			}
			// set where condition
			pstmt.setDouble(13, this.getTranCom());
			if(this.getBankCode() == null || this.getBankCode().equals("null")) {
				pstmt.setNull(14, 12);
			} else {
				pstmt.setString(14, this.getBankCode());
			}
			pstmt.executeUpdate();
			pstmt.close();
		} catch (Exception ex) {
                       ex.printStackTrace();
			// @@������
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "update()";
			tError.errorMessage = ex.toString();
			this.mErrors .addOneError(tError);

			try {
				pstmt.close();
			} catch (Exception e){e.printStackTrace();}

			if( !mflag ) {
				try {
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
			pstmt = con.prepareStatement("INSERT INTO HxbankInfo VALUES( ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ?)");
			pstmt.setDouble(1, this.getTranCom());
			if(this.getBankCode() == null || this.getBankCode().equals("null")) {
				pstmt.setNull(2, 12);
			} else {
				pstmt.setString(2, this.getBankCode());
			}
			if(this.getBankShortName() == null || this.getBankShortName().equals("null")) {
				pstmt.setNull(3, 12);
			} else {
				pstmt.setString(3, this.getBankShortName());
			}
			if(this.getBankFullName() == null || this.getBankFullName().equals("null")) {
				pstmt.setNull(4, 12);
			} else {
				pstmt.setString(4, this.getBankFullName());
			}
			if(this.getBankType() == null || this.getBankType().equals("null")) {
				pstmt.setNull(5, 12);
			} else {
				pstmt.setString(5, this.getBankType());
			}
			if(this.getUpBankCode() == null || this.getUpBankCode().equals("null")) {
				pstmt.setNull(6, 12);
			} else {
				pstmt.setString(6, this.getUpBankCode());
			}
			if(this.getUpBankShotName() == null || this.getUpBankShotName().equals("null")) {
				pstmt.setNull(7, 12);
			} else {
				pstmt.setString(7, this.getUpBankShotName());
			}
			if(this.getMakeDate() == null || this.getMakeDate().equals("null")) {
				pstmt.setNull(8, 91);
			} else {
				pstmt.setDate(8, Date.valueOf(this.getMakeDate()));
			}
			if(this.getMakeTime() == null || this.getMakeTime().equals("null")) {
				pstmt.setNull(9, 12);
			} else {
				pstmt.setString(9, this.getMakeTime());
			}
			if(this.getModifyDate() == null || this.getModifyDate().equals("null")) {
				pstmt.setNull(10, 91);
			} else {
				pstmt.setDate(10, Date.valueOf(this.getModifyDate()));
			}
			if(this.getModifyTime() == null || this.getModifyTime().equals("null")) {
				pstmt.setNull(11, 12);
			} else {
				pstmt.setString(11, this.getModifyTime());
			}
			if(this.getOperator() == null || this.getOperator().equals("null")) {
				pstmt.setNull(12, 12);
			} else {
				pstmt.setString(12, this.getOperator());
			}
			// execute sql
			pstmt.executeUpdate();
			pstmt.close();
		} catch (Exception ex) {
                       ex.printStackTrace();
			// @@������
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "insert()";
			tError.errorMessage = ex.toString();
			this.mErrors .addOneError(tError);

			try {
				pstmt.close();
			} catch (Exception e){e.printStackTrace();}

			if( !mflag ) {
				try {
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
     * ��ѯ����
     * ��ѯ����������
     * @return boolean
     */
	public boolean getInfo()
	{
		PreparedStatement pstmt = null;
		ResultSet rs = null;

	  if( !mflag ) {
		  con = DBConnPool.getConnection();
		}

		try
		{
			pstmt = con.prepareStatement("SELECT * FROM HxbankInfo WHERE  TranCom = ? AND BankCode = ?", 
				ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_READ_ONLY);
			pstmt.setDouble(1, this.getTranCom());
			if(this.getBankCode() == null || this.getBankCode().equals("null")) {
				pstmt.setNull(2, 12);
			} else {
				pstmt.setString(2, this.getBankCode());
			}
			rs = pstmt.executeQuery();
			int i = 0;
			while (rs.next())
			{
				i++;
				if (!this.setSchema(rs,i))
				{
					// @@������
					CError tError = new CError();
					tError.moduleName = "HxbankInfoDB";
					tError.functionName = "getInfo";
					tError.errorMessage = "ȡ��ʧ��!";
					this.mErrors .addOneError(tError);

					try{ rs.close(); } catch( Exception e ) {e.printStackTrace();}
					try{ pstmt.close(); } catch( Exception e ) {e.printStackTrace();}

					if (!mflag)
					{
						try
						{
							con.close();
						}
						catch(Exception e){e.printStackTrace();}
					}
					return false;
				}
				break;
			}
			try{ rs.close(); } catch( Exception e ) {e.printStackTrace();}
			try{ pstmt.close(); } catch( Exception e ) {e.printStackTrace();}

			if( i == 0 )
			{
				if (!mflag)
				{
					try
					{
						con.close();
					}
					catch(Exception e){e.printStackTrace();}
				}
				return false;
			}
		}
		catch(Exception e)
	    {
                       e.printStackTrace();
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "getInfo";
			tError.errorMessage = e.toString();
			this.mErrors .addOneError(tError);

			try{ rs.close(); } catch( Exception ex ) {ex.printStackTrace();}
			try{ pstmt.close(); } catch( Exception ex1 ) {ex1.printStackTrace();}

			if (!mflag)
			{
				try
				{
					con.close();
				}
				catch(Exception et){et.printStackTrace();}
			}
			return false;
	    }
	    finally{
// �Ͽ����ݿ�����
		if (!mflag)
		{
			try
			{
				con.close();
			}
			catch(Exception e){e.printStackTrace();}
		}}

		return true;
	}

    /**
     * ��ѯ����
     * ��ѯ�����������schema����ֵ���ֶ�
     * @return boolean
     */
	public HxbankInfoSet query()
	{
		Statement stmt = null;
		ResultSet rs = null;
		HxbankInfoSet aHxbankInfoSet = new HxbankInfoSet();

	  if( !mflag ) {
		  con = DBConnPool.getConnection();
		}

			SQLString sqlObj = new SQLString("HxbankInfo");
			sqlObj.setSQL(5,this.getSchema());
			String sql = sqlObj.getSQL();
		try
		{
			stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_READ_ONLY);

			rs = stmt.executeQuery(sql);
			int i = 0;
			while (rs.next())
			{
				i++;
if(i>10000)      
           {     
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "query";
			tError.errorMessage = "��ѯ���ؽ������!";
			this.mErrors .addOneError(tError);
                break;//������ǰѭ��             
 }     
				HxbankInfoSchema s1 = new HxbankInfoSchema();
				s1.setSchema(rs,i);
				aHxbankInfoSet.add(s1);
			}
			try{ rs.close(); } catch( Exception ex ) {ex.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex1 ) {ex1.printStackTrace();}
		}
		catch(Exception e)
	    {
            System.out.println("##### Error Sql in HxbankInfoDB at query(): " + sql);
			// @@������
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "query";
			tError.errorMessage = e.toString();
			this.mErrors .addOneError(tError);

			try{ rs.close(); } catch( Exception ex2 ) {ex2.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex3 ) {ex3.printStackTrace();}

			if (!mflag)
			{
				try
				{
					con.close();
				}
				catch(Exception et){et.printStackTrace();}
			}
	    }
       finally{
		if (!mflag)
		{
			try
			{
				con.close();
			}
			catch(Exception e){e.printStackTrace();}
		}}

		return aHxbankInfoSet;
	}

	public HxbankInfoSet executeQuery(String sql)
	{
		Statement stmt = null;
		ResultSet rs = null;
		HxbankInfoSet aHxbankInfoSet = new HxbankInfoSet();

	  if( !mflag ) {
		  con = DBConnPool.getConnection();
		}

		try
		{
			stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_READ_ONLY);

			rs = stmt.executeQuery(StrTool.GBKToUnicode(sql));
			int i = 0;
			while (rs.next())
			{
				i++;
if(i>10000)      
           {     
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "executeQuery";
			tError.errorMessage = "��ѯ���ؽ������!";
			this.mErrors .addOneError(tError);
                break;//������ǰѭ��             
 }     
				HxbankInfoSchema s1 = new HxbankInfoSchema();
				if (!s1.setSchema(rs,i))
				{
					// @@������
					CError tError = new CError();
					tError.moduleName = "HxbankInfoDB";
					tError.functionName = "executeQuery";
					tError.errorMessage = "sql���������鿴�������ֶ�����Ϣ!";
					this.mErrors .addOneError(tError);
				}
				aHxbankInfoSet.add(s1);
			}
			try{ rs.close(); } catch( Exception ex ) {ex.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex1 ) {ex1.printStackTrace();}
		}
		catch(Exception e)
	    {
            System.out.println("##### Error Sql in HxbankInfoDB at executeQuery(String sql): " + sql);
			// @@������
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "executeQuery";
			tError.errorMessage = e.toString();
			this.mErrors .addOneError(tError);

			try{ rs.close(); } catch( Exception ex2 ) {ex2.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex3 ) {ex3.printStackTrace();}

			if (!mflag)
			{
				try
				{
					con.close();
				}
				catch(Exception et){et.printStackTrace();}
			}
	    }
       finally{
		if (!mflag)
		{
			try
			{
				con.close();
			}
			catch(Exception e){e.printStackTrace();}
		}}

		return aHxbankInfoSet;
	}

	public HxbankInfoSet query(int nStart, int nCount)
	{
		Statement stmt = null;
		ResultSet rs = null;
		HxbankInfoSet aHxbankInfoSet = new HxbankInfoSet();

	  if( !mflag ) {
		  con = DBConnPool.getConnection();
		}

			SQLString sqlObj = new SQLString("HxbankInfo");
			sqlObj.setSQL(5,this.getSchema());
			String sql = sqlObj.getSQL();
		try
		{
			stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_READ_ONLY);

			rs = stmt.executeQuery(sql);
			int i = 0;
			while (rs.next())
			{
				i++;

				if( i < nStart ) {
					continue;
				}

				if( i >= nStart + nCount ) {
					break;
				}

				HxbankInfoSchema s1 = new HxbankInfoSchema();
				s1.setSchema(rs,i);
				aHxbankInfoSet.add(s1);
			}
			try{ rs.close(); } catch( Exception ex ) {ex.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex1 ) {ex1.printStackTrace();}
		}
		catch(Exception e)
	    {
            System.out.println("##### Error Sql in HxbankInfoDB at query(int nStart, int nCount): " + sql);
			// @@������
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "query";
			tError.errorMessage = e.toString();
			this.mErrors .addOneError(tError);

			try{ rs.close(); } catch( Exception ex2 ) {ex2.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex3 ) {ex3.printStackTrace();}

			if (!mflag)
			{
				try
				{
					con.close();
				}
				catch(Exception et){et.printStackTrace();}
			}
	    }
       finally{
		if (!mflag)
		{
			try
			{
				con.close();
			}
			catch(Exception e){e.printStackTrace();}
		}}

		return aHxbankInfoSet;
	}

	public HxbankInfoSet executeQuery(String sql, int nStart, int nCount)
	{
		Statement stmt = null;
		ResultSet rs = null;
		HxbankInfoSet aHxbankInfoSet = new HxbankInfoSet();

	  if( !mflag ) {
		  con = DBConnPool.getConnection();
		}

		try
		{
			stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_READ_ONLY);

			rs = stmt.executeQuery(StrTool.GBKToUnicode(sql));
			int i = 0;
			while (rs.next())
			{
				i++;

				if( i < nStart ) {
					continue;
				}

				if( i >= nStart + nCount ) {
					break;
				}

				HxbankInfoSchema s1 = new HxbankInfoSchema();
				if (!s1.setSchema(rs,i))
				{
					// @@������
					CError tError = new CError();
					tError.moduleName = "HxbankInfoDB";
					tError.functionName = "executeQuery";
					tError.errorMessage = "sql���������鿴�������ֶ�����Ϣ!";
					this.mErrors .addOneError(tError);
				}
				aHxbankInfoSet.add(s1);
			}
			try{ rs.close(); } catch( Exception ex ) {ex.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex1 ) {ex1.printStackTrace();}
		}
		catch(Exception e)
	    {
            System.out.println("##### Error Sql in HxbankInfoDB at executeQuery(String sql, int nStart, int nCount): " + sql);
			// @@������
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "executeQuery";
			tError.errorMessage = e.toString();
			this.mErrors .addOneError(tError);

			try{ rs.close(); } catch( Exception ex2 ) {ex2.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex3 ) {ex3.printStackTrace();}

			if (!mflag)
			{
				try
				{
					con.close();
				}
				catch(Exception et){et.printStackTrace();}
			}
	    }
       finally{
		if (!mflag)
		{
			try
			{
				con.close();
			}
			catch(Exception e){e.printStackTrace();}
		}}

		return aHxbankInfoSet;
	}

	public boolean update(String strWherePart)
	{
		Statement stmt = null;

	  if( !mflag ) {
		  con = DBConnPool.getConnection();
		}

			SQLString sqlObj = new SQLString("HxbankInfo");
			sqlObj.setSQL(2,this.getSchema());
			String sql = "update HxbankInfo " + sqlObj.getUpdPart() + " where " + strWherePart;
		try
		{
			stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_READ_ONLY);

			int operCount = stmt.executeUpdate(sql);
			if( operCount == 0 )
			{
				// @@������
				CError tError = new CError();
				tError.moduleName = "HxbankInfoDB";
				tError.functionName = "update";
				tError.errorMessage = "��������ʧ��!";
				this.mErrors .addOneError(tError);

				if (!mflag)
				{
					try
					{
						con.close();
					}
					catch(Exception et){et.printStackTrace();}
				}
				return false;
			}
		}
		catch(Exception e)
	    {
            System.out.println("##### Error Sql in HxbankInfoDB at update(String strWherePart): " + sql);
			// @@������
			CError tError = new CError();
			tError.moduleName = "HxbankInfoDB";
			tError.functionName = "update";
			tError.errorMessage = e.toString();
			this.mErrors .addOneError(tError);

			try{ stmt.close(); } catch( Exception ex1 ) {ex1.printStackTrace();}

			if (!mflag)
			{
				try
				{
					con.close();
				}
				catch(Exception et){et.printStackTrace();}
			}
			return false;
	    }
	    finally{
	    // �Ͽ����ݿ�����
		if (!mflag)
		{
			try
			{
				con.close();
			}
			catch(Exception e){e.printStackTrace();}
		}}

		return true;
	}

/**
 * ׼�����ݲ�ѯ����
 * @param strSQL String
 * @return boolean
 */
public boolean prepareData(String strSQL)
{
    if (mResultSet != null)
    {
        // @@������
        CError tError = new CError();
        tError.moduleName = "HxbankInfoDB";
        tError.functionName = "prepareData";
        tError.errorMessage = "���ݼ��ǿգ�������׼�����ݼ�֮��û�йرգ�";
        this.mErrors.addOneError(tError);
        return false;
    }

    if (!mflag)
    {
        con = DBConnPool.getConnection();
    }
    try
    {
        mStatement = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
        mResultSet = mStatement.executeQuery(StrTool.GBKToUnicode(strSQL));
    }
    catch (Exception e)
    {
        // @@������
        CError tError = new CError();
        tError.moduleName = "HxbankInfoDB";
        tError.functionName = "prepareData";
        tError.errorMessage = e.toString();
        this.mErrors.addOneError(tError);
        try
        {
            mResultSet.close();
        }
        catch (Exception ex2)
        {ex2.printStackTrace();}
        try
        {
            mStatement.close();
        }
        catch (Exception ex3)
        {ex3.printStackTrace();}
        if (!mflag)
        {
            try
            {
                con.close();
            }
            catch (Exception et)
            {et.printStackTrace();}
        }
        return false;
    }
    finally{
    if (!mflag)
    {
        try
        {
            con.close();
        }
        catch (Exception e)
        {e.printStackTrace();}
    }}
    return true;
}

/**
 * ��ȡ���ݼ�
 * @return boolean
 */
public boolean hasMoreData()
{
    boolean flag = true;
    if (null == mResultSet)
    {
        CError tError = new CError();
        tError.moduleName = "HxbankInfoDB";
        tError.functionName = "hasMoreData";
        tError.errorMessage = "���ݼ�Ϊ�գ�����׼�����ݼ���";
        this.mErrors.addOneError(tError);
        return false;
    }
    try
    {
        flag = mResultSet.next();
    }
    catch (Exception ex)
    {
        CError tError = new CError();
        tError.moduleName = "HxbankInfoDB";
        tError.functionName = "hasMoreData";
        tError.errorMessage = ex.toString();
        this.mErrors.addOneError(tError);
        try
        {
            mResultSet.close();
            mResultSet = null;
        }
        catch (Exception ex2)
        {ex2.printStackTrace();}
        try
        {
            mStatement.close();
            mStatement = null;
        }
        catch (Exception ex3)
        {ex3.printStackTrace();}
        if (!mflag)
        {
            try
            {
                con.close();
            }
            catch (Exception et)
            {et.printStackTrace();}
        }
        return false;
    }
    return flag;
}
/**
 * ��ȡ��������
 * @return HxbankInfoSet
 */
public HxbankInfoSet getData()
{
    int tCount = 0;
    HxbankInfoSet tHxbankInfoSet = new HxbankInfoSet();
    HxbankInfoSchema tHxbankInfoSchema = null;
    if (null == mResultSet)
    {
        CError tError = new CError();
        tError.moduleName = "HxbankInfoDB";
        tError.functionName = "getData";
        tError.errorMessage = "���ݼ�Ϊ�գ�����׼�����ݼ���";
        this.mErrors.addOneError(tError);
        return null;
    }
    try
    {
        tCount = 1;
        tHxbankInfoSchema = new HxbankInfoSchema();
        tHxbankInfoSchema.setSchema(mResultSet, 1);
        tHxbankInfoSet.add(tHxbankInfoSchema);
        //ע��mResultSet.next()������
        while (tCount++ < SysConst.FETCHCOUNT)
        {
            if (mResultSet.next())
            {
                tHxbankInfoSchema = new HxbankInfoSchema();
                tHxbankInfoSchema.setSchema(mResultSet, 1);
                tHxbankInfoSet.add(tHxbankInfoSchema);
            }
        }
    }
    catch (Exception ex)
    {
        CError tError = new CError();
        tError.moduleName = "HxbankInfoDB";
        tError.functionName = "getData";
        tError.errorMessage = ex.toString();
        this.mErrors.addOneError(tError);
        try
        {
            mResultSet.close();
            mResultSet = null;
        }
        catch (Exception ex2)
        {ex2.printStackTrace();}
        try
        {
            mStatement.close();
            mStatement = null;
        }
        catch (Exception ex3)
        {ex3.printStackTrace();}
        if (!mflag)
        {
            try
            {
                con.close();
            }
            catch (Exception et)
            {et.printStackTrace();}
        }
        return null;
    }
    return tHxbankInfoSet;
}
/**
 * �ر����ݼ�
 * @return boolean
 */
public boolean closeData()
{
    boolean flag = true;
    try
    {
        if (null == mResultSet)
        {
            CError tError = new CError();
            tError.moduleName = "HxbankInfoDB";
            tError.functionName = "closeData";
            tError.errorMessage = "���ݼ��Ѿ��ر��ˣ�";
            this.mErrors.addOneError(tError);
            flag = false;
        }
        else
        {
            mResultSet.close();
            mResultSet = null;
        }
    }
    catch (Exception ex2)
    {
        CError tError = new CError();
        tError.moduleName = "HxbankInfoDB";
        tError.functionName = "closeData";
        tError.errorMessage = ex2.toString();
        this.mErrors.addOneError(tError);
        flag = false;
    }
    try
    {
        if (null == mStatement)
        {
            CError tError = new CError();
            tError.moduleName = "HxbankInfoDB";
            tError.functionName = "closeData";
            tError.errorMessage = "����Ѿ��ر��ˣ�";
            this.mErrors.addOneError(tError);
            flag = false;
        }
        else
        {
            mStatement.close();
            mStatement = null;
        }
    }
    catch (Exception ex3)
    {
        CError tError = new CError();
        tError.moduleName = "HxbankInfoDB";
        tError.functionName = "closeData";
        tError.errorMessage = ex3.toString();
        this.mErrors.addOneError(tError);
        flag = false;
    }
    return flag;
}
}
