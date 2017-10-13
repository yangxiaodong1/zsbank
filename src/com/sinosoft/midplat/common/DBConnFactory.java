package com.sinosoft.midplat.common;

import java.sql.Connection;
import java.sql.DriverManager;

import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.jdom.Element;

import com.sinosoft.midplat.exception.UnsupportedException;

public class DBConnFactory implements XmlTag {
	private static final String oracle = "oracle";
	private static final String db2 = "db2";
	private static final String mysql = "mysql";
	private static final String sqlserver = "sqlserver";
	private static final String weblogic_ds = "weblogic_ds";
	private static final String commonsdbcp = "commonsdbcp";
	
	private final String cType;
	private final String cName;
	
	private final String cIP;
	private final String cPort;
	private final String cUserName;
	private final String cPassWord;
	
	public DBConnFactory(Element pDBConfEle) {
		this(pDBConfEle.getAttributeValue(type)
			, pDBConfEle.getAttributeValue(name)
			, pDBConfEle.getAttributeValue(ip)
			, pDBConfEle.getAttributeValue(port)
			, pDBConfEle.getAttributeValue(user)
			, pDBConfEle.getAttributeValue(password));
	}
	
	public DBConnFactory(
			String pType, String pName, String pIP, String pPort, String pUserName, String pPassWord) {
		cType = pType;
		cName = pName;
		
		cIP = pIP;
		cPort = pPort;
		cUserName = pUserName;
		cPassWord = pPassWord;
	}
	
	public Connection getConn() throws Exception {
		Connection mConn = null;
		
		if (oracle.equalsIgnoreCase(cType)) {
			Class.forName("oracle.jdbc.OracleDriver");
			mConn = DriverManager.getConnection(
					"jdbc:oracle:thin:@"+cIP+":"+cPort+":"+cName, cUserName, cPassWord);
		} else if (db2.equalsIgnoreCase(cType)) {
			Class.forName("com.ibm.db2.jcc.DB2Driver");
			mConn = DriverManager.getConnection(
					"jdbc:db2://"+cIP+":"+cPort+"/"+cName, cUserName, cPassWord);
		} else if (mysql.equalsIgnoreCase(cType)) {
			Class.forName("com.mysql.jdbc.Driver");
			mConn = DriverManager.getConnection(
					"jdbc:mysql://"+cIP+":"+cPort+"/"+cName+"?useUnicode=true&amp;characterEncoding=GBK", cUserName, cPassWord);
		} else if (sqlserver.equalsIgnoreCase(cType)) {
			mConn = null;
		} else if (weblogic_ds.equalsIgnoreCase(cType)) {
			DataSource tDataSource = (DataSource) new InitialContext().lookup(cName);
			mConn = tDataSource.getConnection();
		} else if (commonsdbcp.equalsIgnoreCase(cType)) {
			DataSource tDataSource = 
				(DataSource) new InitialContext().lookup("java:comp/env/"+cName);
			mConn = tDataSource.getConnection();
		} else {
			throw new UnsupportedException("暂不支持该种类型！"+cType);
		}
		
		return mConn;
	}
}
