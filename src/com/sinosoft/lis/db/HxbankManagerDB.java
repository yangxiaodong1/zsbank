/**
 * Copyright (c) 2006 sinosoft Co. Ltd.
 * All right reserved.
 */

package com.sinosoft.lis.db;

import java.sql.*;
import com.sinosoft.lis.schema.HxbankManagerSchema;
import com.sinosoft.lis.vschema.HxbankManagerSet;
import com.sinosoft.lis.pubfun.PubFun;
import com.sinosoft.utility.*;

/**
 * <p>ClassName: HxbankManagerDB </p>
 * <p>Description: DB层数据库操作类文件 </p>
 * <p>Company: sinosoft </p>
 * @Database: PHYSICAL_DATA_MODEL_1
 * @author：Maker
 * @CreateDate：2014-04-23
 */
public class HxbankManagerDB extends HxbankManagerSchema
{
	// @Field
	private Connection con;
	private DBOper db;
	/**
	* flag = true: 传入Connection
	* flag = false: 不传入Connection
	**/
	private boolean mflag = false;


	/**
	 * 为批量操作而准备的语句和游标对象
	 */
	private ResultSet mResultSet = null;
	private Statement mStatement = null;
	// @Constructor
	public HxbankManagerDB( Connection tConnection )
	{
		con = tConnection;
		db = new DBOper( con, "HxbankManager" );
		mflag = true;
	}

	public HxbankManagerDB()
	{
		con = null;
		db = new DBOper( "HxbankManager" );
		mflag = false;
	}

	// @Method
	public boolean deleteSQL()
	{
		HxbankManagerSchema tSchema = this.getSchema();
		if (db.deleteSQL(tSchema))
		{
		     return true;
		}
		else
		{
			// @@错误处理
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankManagerDB";
			tError.functionName = "deleteSQL";
			tError.errorMessage = "操作失败!";
			this.mErrors .addOneError(tError);
			return false;
		}
	}

	public int getCount()
	{
		HxbankManagerSchema tSchema = this.getSchema();

		int tCount = db.getCount(tSchema);
		if (tCount < 0)
		{
			// @@错误处理
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankManagerDB";
			tError.functionName = "getCount";
			tError.errorMessage = "操作失败!";
			this.mErrors .addOneError(tError);

			return -1;
		}

		return tCount;
	}

    /**
     * 删除操作
     * 删除条件：主键
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
			pstmt = con.prepareStatement("DELETE FROM HxbankManager WHERE  TranCom = ? AND BankCode = ? AND ManagerCode = ?");
			pstmt.setDouble(1, this.getTranCom());
			if(this.getBankCode() == null || this.getBankCode().equals("null")) {
				pstmt.setNull(2, 12);
			} else {
				pstmt.setString(2, this.getBankCode());
			}
			if(this.getManagerCode() == null || this.getManagerCode().equals("null")) {
				pstmt.setNull(3, 12);
			} else {
				pstmt.setString(3, this.getManagerCode());
			}
			pstmt.executeUpdate();
			pstmt.close();
		} catch (Exception ex) {
                       ex.printStackTrace();
			// @@错误处理
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankManagerDB";
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
     * 更新操作
     * 更新条件：主键
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
			pstmt = con.prepareStatement("UPDATE HxbankManager SET  TranCom = ? , BankCode = ? , ManagerCode = ? , ManagerName = ? , ManagerCertifNo = ? , CertifEndDate = ? , MakeDate = ? , MakeTime = ? , ModifyDate = ? , ModifyTime = ? , Operator = ? WHERE  TranCom = ? AND BankCode = ? AND ManagerCode = ?");
			pstmt.setDouble(1, this.getTranCom());
			if(this.getBankCode() == null || this.getBankCode().equals("null")) {
				pstmt.setNull(2, 12);
			} else {
				pstmt.setString(2, this.getBankCode());
			}
			if(this.getManagerCode() == null || this.getManagerCode().equals("null")) {
				pstmt.setNull(3, 12);
			} else {
				pstmt.setString(3, this.getManagerCode());
			}
			if(this.getManagerName() == null || this.getManagerName().equals("null")) {
				pstmt.setNull(4, 12);
			} else {
				pstmt.setString(4, this.getManagerName());
			}
			if(this.getManagerCertifNo() == null || this.getManagerCertifNo().equals("null")) {
				pstmt.setNull(5, 12);
			} else {
				pstmt.setString(5, this.getManagerCertifNo());
			}
			if(this.getCertifEndDate() == null || this.getCertifEndDate().equals("null")) {
				pstmt.setNull(6, 12);
			} else {
				pstmt.setString(6, this.getCertifEndDate());
			}
			if(this.getMakeDate() == null || this.getMakeDate().equals("null")) {
				pstmt.setNull(7, 91);
			} else {
				pstmt.setDate(7, Date.valueOf(this.getMakeDate()));
			}
			if(this.getMakeTime() == null || this.getMakeTime().equals("null")) {
				pstmt.setNull(8, 12);
			} else {
				pstmt.setString(8, this.getMakeTime());
			}
			if(this.getModifyDate() == null || this.getModifyDate().equals("null")) {
				pstmt.setNull(9, 91);
			} else {
				pstmt.setDate(9, Date.valueOf(this.getModifyDate()));
			}
			if(this.getModifyTime() == null || this.getModifyTime().equals("null")) {
				pstmt.setNull(10, 12);
			} else {
				pstmt.setString(10, this.getModifyTime());
			}
			if(this.getOperator() == null || this.getOperator().equals("null")) {
				pstmt.setNull(11, 12);
			} else {
				pstmt.setString(11, this.getOperator());
			}
			// set where condition
			pstmt.setDouble(12, this.getTranCom());
			if(this.getBankCode() == null || this.getBankCode().equals("null")) {
				pstmt.setNull(13, 12);
			} else {
				pstmt.setString(13, this.getBankCode());
			}
			if(this.getManagerCode() == null || this.getManagerCode().equals("null")) {
				pstmt.setNull(14, 12);
			} else {
				pstmt.setString(14, this.getManagerCode());
			}
			pstmt.executeUpdate();
			pstmt.close();
		} catch (Exception ex) {
                       ex.printStackTrace();
			// @@错误处理
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankManagerDB";
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
     * 新增操作
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
			pstmt = con.prepareStatement("INSERT INTO HxbankManager VALUES( ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ?)");
			pstmt.setDouble(1, this.getTranCom());
			if(this.getBankCode() == null || this.getBankCode().equals("null")) {
				pstmt.setNull(2, 12);
			} else {
				pstmt.setString(2, this.getBankCode());
			}
			if(this.getManagerCode() == null || this.getManagerCode().equals("null")) {
				pstmt.setNull(3, 12);
			} else {
				pstmt.setString(3, this.getManagerCode());
			}
			if(this.getManagerName() == null || this.getManagerName().equals("null")) {
				pstmt.setNull(4, 12);
			} else {
				pstmt.setString(4, this.getManagerName());
			}
			if(this.getManagerCertifNo() == null || this.getManagerCertifNo().equals("null")) {
				pstmt.setNull(5, 12);
			} else {
				pstmt.setString(5, this.getManagerCertifNo());
			}
			if(this.getCertifEndDate() == null || this.getCertifEndDate().equals("null")) {
				pstmt.setNull(6, 12);
			} else {
				pstmt.setString(6, this.getCertifEndDate());
			}
			if(this.getMakeDate() == null || this.getMakeDate().equals("null")) {
				pstmt.setNull(7, 91);
			} else {
				pstmt.setDate(7, Date.valueOf(this.getMakeDate()));
			}
			if(this.getMakeTime() == null || this.getMakeTime().equals("null")) {
				pstmt.setNull(8, 12);
			} else {
				pstmt.setString(8, this.getMakeTime());
			}
			if(this.getModifyDate() == null || this.getModifyDate().equals("null")) {
				pstmt.setNull(9, 91);
			} else {
				pstmt.setDate(9, Date.valueOf(this.getModifyDate()));
			}
			if(this.getModifyTime() == null || this.getModifyTime().equals("null")) {
				pstmt.setNull(10, 12);
			} else {
				pstmt.setString(10, this.getModifyTime());
			}
			if(this.getOperator() == null || this.getOperator().equals("null")) {
				pstmt.setNull(11, 12);
			} else {
				pstmt.setString(11, this.getOperator());
			}
			// execute sql
			pstmt.executeUpdate();
			pstmt.close();
		} catch (Exception ex) {
                       ex.printStackTrace();
			// @@错误处理
			this.mErrors.copyAllErrors(db.mErrors);
			CError tError = new CError();
			tError.moduleName = "HxbankManagerDB";
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
     * 查询操作
     * 查询条件：主键
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
			pstmt = con.prepareStatement("SELECT * FROM HxbankManager WHERE  TranCom = ? AND BankCode = ? AND ManagerCode = ?", 
				ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_READ_ONLY);
			pstmt.setDouble(1, this.getTranCom());
			if(this.getBankCode() == null || this.getBankCode().equals("null")) {
				pstmt.setNull(2, 12);
			} else {
				pstmt.setString(2, this.getBankCode());
			}
			if(this.getManagerCode() == null || this.getManagerCode().equals("null")) {
				pstmt.setNull(3, 12);
			} else {
				pstmt.setString(3, this.getManagerCode());
			}
			rs = pstmt.executeQuery();
			int i = 0;
			while (rs.next())
			{
				i++;
				if (!this.setSchema(rs,i))
				{
					// @@错误处理
					CError tError = new CError();
					tError.moduleName = "HxbankManagerDB";
					tError.functionName = "getInfo";
					tError.errorMessage = "取数失败!";
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
			tError.moduleName = "HxbankManagerDB";
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
// 断开数据库连接
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
     * 查询操作
     * 查询条件：传入的schema中有值的字段
     * @return boolean
     */
	public HxbankManagerSet query()
	{
		Statement stmt = null;
		ResultSet rs = null;
		HxbankManagerSet aHxbankManagerSet = new HxbankManagerSet();

	  if( !mflag ) {
		  con = DBConnPool.getConnection();
		}

			SQLString sqlObj = new SQLString("HxbankManager");
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
			tError.moduleName = "HxbankManagerDB";
			tError.functionName = "query";
			tError.errorMessage = "查询返回结果过多!";
			this.mErrors .addOneError(tError);
                break;//结束当前循环             
 }     
				HxbankManagerSchema s1 = new HxbankManagerSchema();
				s1.setSchema(rs,i);
				aHxbankManagerSet.add(s1);
			}
			try{ rs.close(); } catch( Exception ex ) {ex.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex1 ) {ex1.printStackTrace();}
		}
		catch(Exception e)
	    {
            System.out.println("##### Error Sql in HxbankManagerDB at query(): " + sql);
			// @@错误处理
			CError tError = new CError();
			tError.moduleName = "HxbankManagerDB";
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

		return aHxbankManagerSet;
	}

	public HxbankManagerSet executeQuery(String sql)
	{
		Statement stmt = null;
		ResultSet rs = null;
		HxbankManagerSet aHxbankManagerSet = new HxbankManagerSet();

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
			tError.moduleName = "HxbankManagerDB";
			tError.functionName = "executeQuery";
			tError.errorMessage = "查询返回结果过多!";
			this.mErrors .addOneError(tError);
                break;//结束当前循环             
 }     
				HxbankManagerSchema s1 = new HxbankManagerSchema();
				if (!s1.setSchema(rs,i))
				{
					// @@错误处理
					CError tError = new CError();
					tError.moduleName = "HxbankManagerDB";
					tError.functionName = "executeQuery";
					tError.errorMessage = "sql语句有误，请查看表名及字段名信息!";
					this.mErrors .addOneError(tError);
				}
				aHxbankManagerSet.add(s1);
			}
			try{ rs.close(); } catch( Exception ex ) {ex.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex1 ) {ex1.printStackTrace();}
		}
		catch(Exception e)
	    {
            System.out.println("##### Error Sql in HxbankManagerDB at executeQuery(String sql): " + sql);
			// @@错误处理
			CError tError = new CError();
			tError.moduleName = "HxbankManagerDB";
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

		return aHxbankManagerSet;
	}

	public HxbankManagerSet query(int nStart, int nCount)
	{
		Statement stmt = null;
		ResultSet rs = null;
		HxbankManagerSet aHxbankManagerSet = new HxbankManagerSet();

	  if( !mflag ) {
		  con = DBConnPool.getConnection();
		}

			SQLString sqlObj = new SQLString("HxbankManager");
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

				HxbankManagerSchema s1 = new HxbankManagerSchema();
				s1.setSchema(rs,i);
				aHxbankManagerSet.add(s1);
			}
			try{ rs.close(); } catch( Exception ex ) {ex.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex1 ) {ex1.printStackTrace();}
		}
		catch(Exception e)
	    {
            System.out.println("##### Error Sql in HxbankManagerDB at query(int nStart, int nCount): " + sql);
			// @@错误处理
			CError tError = new CError();
			tError.moduleName = "HxbankManagerDB";
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

		return aHxbankManagerSet;
	}

	public HxbankManagerSet executeQuery(String sql, int nStart, int nCount)
	{
		Statement stmt = null;
		ResultSet rs = null;
		HxbankManagerSet aHxbankManagerSet = new HxbankManagerSet();

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

				HxbankManagerSchema s1 = new HxbankManagerSchema();
				if (!s1.setSchema(rs,i))
				{
					// @@错误处理
					CError tError = new CError();
					tError.moduleName = "HxbankManagerDB";
					tError.functionName = "executeQuery";
					tError.errorMessage = "sql语句有误，请查看表名及字段名信息!";
					this.mErrors .addOneError(tError);
				}
				aHxbankManagerSet.add(s1);
			}
			try{ rs.close(); } catch( Exception ex ) {ex.printStackTrace();}
			try{ stmt.close(); } catch( Exception ex1 ) {ex1.printStackTrace();}
		}
		catch(Exception e)
	    {
            System.out.println("##### Error Sql in HxbankManagerDB at executeQuery(String sql, int nStart, int nCount): " + sql);
			// @@错误处理
			CError tError = new CError();
			tError.moduleName = "HxbankManagerDB";
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

		return aHxbankManagerSet;
	}

	public boolean update(String strWherePart)
	{
		Statement stmt = null;

	  if( !mflag ) {
		  con = DBConnPool.getConnection();
		}

			SQLString sqlObj = new SQLString("HxbankManager");
			sqlObj.setSQL(2,this.getSchema());
			String sql = "update HxbankManager " + sqlObj.getUpdPart() + " where " + strWherePart;
		try
		{
			stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_READ_ONLY);

			int operCount = stmt.executeUpdate(sql);
			if( operCount == 0 )
			{
				// @@错误处理
				CError tError = new CError();
				tError.moduleName = "HxbankManagerDB";
				tError.functionName = "update";
				tError.errorMessage = "更新数据失败!";
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
            System.out.println("##### Error Sql in HxbankManagerDB at update(String strWherePart): " + sql);
			// @@错误处理
			CError tError = new CError();
			tError.moduleName = "HxbankManagerDB";
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
	    // 断开数据库连接
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
 * 准备数据查询条件
 * @param strSQL String
 * @return boolean
 */
public boolean prepareData(String strSQL)
{
    if (mResultSet != null)
    {
        // @@错误处理
        CError tError = new CError();
        tError.moduleName = "HxbankManagerDB";
        tError.functionName = "prepareData";
        tError.errorMessage = "数据集非空，程序在准备数据集之后，没有关闭！";
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
        // @@错误处理
        CError tError = new CError();
        tError.moduleName = "HxbankManagerDB";
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
 * 获取数据集
 * @return boolean
 */
public boolean hasMoreData()
{
    boolean flag = true;
    if (null == mResultSet)
    {
        CError tError = new CError();
        tError.moduleName = "HxbankManagerDB";
        tError.functionName = "hasMoreData";
        tError.errorMessage = "数据集为空，请先准备数据集！";
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
        tError.moduleName = "HxbankManagerDB";
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
 * 获取定量数据
 * @return HxbankManagerSet
 */
public HxbankManagerSet getData()
{
    int tCount = 0;
    HxbankManagerSet tHxbankManagerSet = new HxbankManagerSet();
    HxbankManagerSchema tHxbankManagerSchema = null;
    if (null == mResultSet)
    {
        CError tError = new CError();
        tError.moduleName = "HxbankManagerDB";
        tError.functionName = "getData";
        tError.errorMessage = "数据集为空，请先准备数据集！";
        this.mErrors.addOneError(tError);
        return null;
    }
    try
    {
        tCount = 1;
        tHxbankManagerSchema = new HxbankManagerSchema();
        tHxbankManagerSchema.setSchema(mResultSet, 1);
        tHxbankManagerSet.add(tHxbankManagerSchema);
        //注意mResultSet.next()的作用
        while (tCount++ < SysConst.FETCHCOUNT)
        {
            if (mResultSet.next())
            {
                tHxbankManagerSchema = new HxbankManagerSchema();
                tHxbankManagerSchema.setSchema(mResultSet, 1);
                tHxbankManagerSet.add(tHxbankManagerSchema);
            }
        }
    }
    catch (Exception ex)
    {
        CError tError = new CError();
        tError.moduleName = "HxbankManagerDB";
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
    return tHxbankManagerSet;
}
/**
 * 关闭数据集
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
            tError.moduleName = "HxbankManagerDB";
            tError.functionName = "closeData";
            tError.errorMessage = "数据集已经关闭了！";
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
        tError.moduleName = "HxbankManagerDB";
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
            tError.moduleName = "HxbankManagerDB";
            tError.functionName = "closeData";
            tError.errorMessage = "语句已经关闭了！";
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
        tError.moduleName = "HxbankManagerDB";
        tError.functionName = "closeData";
        tError.errorMessage = ex3.toString();
        this.mErrors.addOneError(tError);
        flag = false;
    }
    return flag;
}
}
