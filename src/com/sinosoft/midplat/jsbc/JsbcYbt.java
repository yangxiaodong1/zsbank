package com.sinosoft.midplat.jsbc;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class JsbcYbt extends Ybt4Socket{

	public JsbcYbt(Socket pSocket) throws Exception {
		super(pSocket, JsbcConf.newInstance());
	}
}
