package com.sinosoft.midplat.bat;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.TimerTask;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.lis.db.TranLogDB;
import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DBConnFactory;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.exception.MidplatException;

public class NodeUpdate extends TimerTask implements XmlTag {
	private static final Logger cLogger = Logger.getLogger(NodeUpdate.class);
	
	private String cStartDate;
	private String cEndDate;
	
	private String cResultMsg;
	
	public void run() {
		long mStartMillis = System.currentTimeMillis();
		Thread.currentThread().setName(
				String.valueOf(NoFactory.nextTranLogNo()));
		cLogger.info("Into NodeUpdate.run()...");
		
		//清空上一次结果信息
		cResultMsg = null;
		
		TranLogDB mTranLogDB = null;
		
		Connection mOutConn = null;
		Statement mOutStmt = null;
		ResultSet mOutResultSet = null;
		Connection mLocalConn = null;
		try {
			mTranLogDB = insertTranLog();
			
			Element tMidplatRoot = MidplatConf.newInstance().getConf().getRootElement();
			mOutConn = new DBConnFactory(tMidplatRoot.getChild("saleSysDB")).getConn();
			
			mOutStmt = mOutConn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			mOutStmt.execute("alter session set nls_date_format='YYYYMMDD HH24:MI:SS'");
			mOutStmt.close();
			
			StringBuilder tSqlStrBld = new StringBuilder("select a.agentcom, a.name, b.agentcode, c.name, d.comcode, d.shortname, a.enddate, a.bankcode")
				.append(" from lacom a, lacomtoagent b, laagent c, ldcom d")
				.append(" where b.agentcode=c.agentcode and a.agentcom=b.agentcom and a.managecom=d.comcode and a.Branchtype='3' and b.relatype='1'");
			if (null != cStartDate) {	//增量同步
				if (null == cEndDate) {
					cEndDate =  cStartDate;
				}
				
				tSqlStrBld.append(" and (a.modifydate between '").append(cStartDate).append("' and '").append(cEndDate).append('\'')
					.append(" or b.modifydate between '").append(cStartDate).append("' and '").append(cEndDate).append('\'')
					.append(" or c.modifydate between '").append(cStartDate).append("' and '").append(cEndDate).append("')");
			}
			cLogger.info(tSqlStrBld);
			mOutStmt = mOutConn.createStatement();
			mOutResultSet = mOutStmt.executeQuery(tSqlStrBld.toString());
			
			mLocalConn = new DBConnFactory(tMidplatRoot.getChild(database)).getConn();
			mLocalConn.setAutoCommit(false);
			int tCurDate = DateUtil.getCur8Date();
			int tCurTime = DateUtil.getCur6Time();
			try {
				String ttSqlStr = null;
				Statement ttLocalStmt = null;
				
				//全量同步之前，先清空表数据
				if (null == cStartDate) {
					ttSqlStr = "delete from Agent";
					cLogger.info(ttSqlStr);
					ttLocalStmt = mLocalConn.createStatement();
					ttLocalStmt.executeUpdate(ttSqlStr);
					ttLocalStmt.close();
				}
				
				int tRecordNo = 0;
				while (mOutResultSet.next()) {
					if (null != cStartDate) {	//增量同步，逐个网点清理
						ttSqlStr = "delete from Agent where Type=0 and AgentCom='"+mOutResultSet.getString(1)+"'";
						cLogger.info(ttSqlStr);
						ttLocalStmt = mLocalConn.createStatement();
						ttLocalStmt.executeUpdate(ttSqlStr);
						ttLocalStmt.close();
					}
					
					ttSqlStr = new StringBuilder("insert into Agent values (").append(tRecordNo++)//NoFactory.nextAgentRecordNo())
						.append(", 0")
						.append(", '").append(mOutResultSet.getString(1)).append('\'')
						.append(", '").append(mOutResultSet.getString(2)).append('\'')
						.append(", '").append(mOutResultSet.getString(3)).append('\'')
						.append(", '").append(mOutResultSet.getString(4)).append('\'')
						.append(", '").append(mOutResultSet.getString(5)).append('\'')
						.append(", '").append(mOutResultSet.getString(6)).append('\'')
						.append(", ").append((null==mOutResultSet.getString(7)||"".equals(mOutResultSet.getString(6))) ? 0:1)
						.append(", '").append(mOutResultSet.getString(8)).append('\'')
						.append(", null")
						.append(", null")
						.append(", ").append(tCurDate)
						.append(", ").append(tCurTime)
						.append(", ").append(tCurDate)
						.append(", ").append(tCurTime)
						.append(", 'sys')").toString();
					cLogger.info(ttSqlStr);
					ttLocalStmt = mLocalConn.createStatement();
					if (1 != ttLocalStmt.executeUpdate(ttSqlStr)) {
						throw new MidplatException("插入失败！");
					}
					
//					PreparedStatement ttPreStmt = mLocalConn.prepareStatement("insert into Agent (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
//					ttPreStmt.setInt(1, NoFactory.nextAgentRecordNo());
//					ttPreStmt.setInt(2, 0);
//					ttPreStmt.setString(3, mOutResultSet.getString(0));
//					ttPreStmt.setString(4, mOutResultSet.getString(1));
//					ttPreStmt.setString(5, mOutResultSet.getString(2));
//					ttPreStmt.setString(6, mOutResultSet.getString(3));
//					ttPreStmt.setString(7, mOutResultSet.getString(4));
//					ttPreStmt.setString(8, mOutResultSet.getString(5));
//					ttPreStmt.setInt(9, (null==mOutResultSet.getString(6)||"".equals(mOutResultSet.getString(6))) ? 0:1);
//					ttPreStmt.setString(10, mOutResultSet.getString(7));
//					ttPreStmt.setNull(11, Types.VARCHAR);
//					ttPreStmt.setNull(12, Types.VARCHAR);
//					ttPreStmt.setInt(13, tCurDate);
//					ttPreStmt.setInt(14, tCurTime);
//					ttPreStmt.setInt(15, tCurDate);
//					ttPreStmt.setInt(16, tCurTime);
//					ttPreStmt.setString(17, "sys");
//					if (1 != ttPreStmt.executeUpdate()) {
//						
//					}
//					ttPreStmt.close();
					
					ttLocalStmt.close();
				}
				cLogger.info("本次同步记录数：" + tRecordNo);
				mLocalConn.commit();
			} catch (Exception ex) {
				mLocalConn.rollback();
				throw ex;
			}
			
			mTranLogDB.setRCode(0);	//-1-未返回；0-交易成功，返回；1-交易失败，返回
			cResultMsg = "销售网点同步完成！";
		} catch (Throwable ex) {
			cLogger.error("销售网点同步出错！", ex);
			if (ex instanceof MidplatException) {
				cResultMsg = ex.getMessage();
			} else {
				cResultMsg = ex.toString();
			}
			
			if (null != mTranLogDB) {	//插入日志失败时tTranLogDB=null
				mTranLogDB.setRCode(1);	//-1-未返回；0-交易成功，返回；1-交易失败，返回
			}
		} finally {
			if (null != mOutResultSet) {
				try {
					mOutResultSet.close();
				} catch (SQLException ex) {
					cLogger.error("关闭OutResultSet异常！", ex);
				}
			}
			if (null != mOutStmt) {
				try {
					mOutStmt.close();
				} catch (SQLException ex) {
					cLogger.error("关闭OutStatement异常！", ex);
				}
			}
			if (null != mOutConn) {
				try {
					mOutConn.close();
				} catch (SQLException ex) {
					cLogger.error("关闭OutConnection异常！", ex);
				}
			}
			if (null != mLocalConn) {
				try {
					mLocalConn.close();
				} catch (SQLException ex) {
					cLogger.error("关闭LocalConnection异常！", ex);
				}
			}
			
			if (null != mTranLogDB) {	//插入日志失败时tTranLogDB=null
				mTranLogDB.setRText(cResultMsg);
				long tCurMillis = System.currentTimeMillis();
				mTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
				mTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
				mTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
				if (!mTranLogDB.update()) {
					cLogger.error("更新日志信息失败！" + mTranLogDB.mErrors.getFirstError());
				}
			}
		}
		
		cStartDate = null;
		cEndDate = null;
		
		cLogger.info("Out NodeUpdate.run()!");
	}
	
	private TranLogDB insertTranLog() throws MidplatException {
		cLogger.info("Into NodeUpdate.insertTranLog()...");
		
		TranLogDB mTranLogDB = new TranLogDB();
		mTranLogDB.setLogNo(Thread.currentThread().getName());
		mTranLogDB.setTranCom(0);
		mTranLogDB.setNodeNo("-");
		mTranLogDB.setTranNo(Thread.currentThread().getName());
		mTranLogDB.setOperator("sys");
		mTranLogDB.setFuncFlag(0);
		Date mCurDate = new Date();
		mTranLogDB.setTranDate(DateUtil.get8Date(mCurDate));
		mTranLogDB.setTranTime(DateUtil.get6Time(mCurDate));
		mTranLogDB.setRCode(CodeDef.RCode_NULL);
		mTranLogDB.setUsedTime(-1);
		mTranLogDB.setMakeDate(DateUtil.get8Date(mCurDate));
		mTranLogDB.setMakeTime(DateUtil.get6Time(mCurDate));
		mTranLogDB.setModifyDate(mTranLogDB.getMakeDate());
		mTranLogDB.setModifyTime(mTranLogDB.getMakeTime());
		
		if (!mTranLogDB.insert()) {
			cLogger.error(mTranLogDB.mErrors.getFirstError());
			throw new MidplatException("插入日志失败！");
		}
		
		cLogger.info("Out NodeUpdate.insertTranLog()!");
		return mTranLogDB;
	}
	
	public void setStartDate(String p8Date) {
		cStartDate = p8Date;
	}
	
	public void setEndDate(String p8Date) {
		cEndDate = p8Date;
	}
	
	public String getResultMsg() {
		return cResultMsg;
	}
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger.getLogger("com.sinosoft.midplat.bat.NodeUpdate.main");
		mLogger.info("程序开始...");
		
		NodeUpdate mBatch = new NodeUpdate();
		
		//用于补对账，设置补对账日期
		if (0 != args.length) {
			mLogger.info(args[0] + " : " + args[1]);
			
			/**
			 * 严格日期校验的正则表达式：\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))。
			 * 4位年-2位月-2位日。
			 * 4位年：4位[0-9]的数字。
			 * 1或2位月：单数月为0加[0-9]的数字；双数月必须以1开头，尾数为0、1或2三个数之一。
			 * 1或2位日：以0、1或2开头加[0-9]的数字，或者以3开头加0或1。
			 * 
			 * 简单日期校验的正则表达式：\\d{4}\\d{2}\\d{2}。
			 */
			if (args[0].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				mBatch.setStartDate(args[0]);
			} else {
				throw new MidplatException("日期格式有误，应为yyyyMMdd！" + args[0]);
			}
			if (args[1].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				mBatch.setEndDate(args[1]);
			} else {
				throw new MidplatException("日期格式有误，应为yyyyMMdd！" + args[0]);
			}
		}
		
		mBatch.run();
		
		mLogger.info("成功结束！");
	}
}
