package com.sinosoft.midplat.cmbc;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class CmbcYbt extends Ybt4Socket{

	public CmbcYbt(Socket pSocket) throws Exception {
		super(pSocket, CmbcConf.newInstance());
	}
}
