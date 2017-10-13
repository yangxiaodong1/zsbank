package com.sinosoft.midplat.cdrcb;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class CdrcbYbt extends Ybt4Socket {
	public CdrcbYbt(Socket pSocket) throws Exception {
		super(pSocket, CdrcbConf.newInstance());
	}
}