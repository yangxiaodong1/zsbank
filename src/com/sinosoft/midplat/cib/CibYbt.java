package com.sinosoft.midplat.cib;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class CibYbt extends Ybt4Socket {
	public CibYbt(Socket pSocket) throws Exception {
		super(pSocket, CibConf.newInstance());
	}
}
