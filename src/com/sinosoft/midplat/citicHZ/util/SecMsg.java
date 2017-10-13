package com.sinosoft.midplat.citicHZ.util;

public class SecMsg {
	//报文明文
	byte[] secMsgClear;
	//报文签名
	byte[] secMsgSign;
	//会话秘钥
	byte[] sessionKey;
	//报文密文
	byte[] secMsgChper;

	public byte[] getSecMsgClear()
	{
		return secMsgClear;
	}
	public void setSecMsgClear(byte[] secMsgClear)
	{
		this.secMsgClear = secMsgClear;
	}
	public byte[] getSecMsgSign()
	{
		return secMsgSign;
	}
	public void setSecMsgSign(byte[] secMsgSign)
	{
		this.secMsgSign = secMsgSign;
	}
	public byte[] getSessionKey()
	{
		return sessionKey;
	}
	public void setSessionKey(byte[] sessionKey)
	{
		this.sessionKey = sessionKey;
	}
	public byte[] getSecMsgChper()
	{
		return secMsgChper;
	}
	public void setSecMsgChper(byte[] secMsgChper)
	{
		this.secMsgChper = secMsgChper;
	}


}
