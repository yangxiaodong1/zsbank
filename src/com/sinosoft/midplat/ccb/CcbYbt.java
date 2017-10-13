package com.sinosoft.midplat.ccb;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class CcbYbt extends Ybt4Socket {
	public CcbYbt(Socket pSocket) throws Exception {
		super(pSocket, CcbConf.newInstance());
	}
}