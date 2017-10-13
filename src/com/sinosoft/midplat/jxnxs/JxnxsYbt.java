package com.sinosoft.midplat.jxnxs;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class JxnxsYbt extends Ybt4Socket {
	public JxnxsYbt(Socket pSocket) throws Exception {
		super(pSocket, JxnxsConf.newInstance());
	}
}
