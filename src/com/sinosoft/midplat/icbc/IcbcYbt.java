package com.sinosoft.midplat.icbc;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class IcbcYbt extends Ybt4Socket {
	public IcbcYbt(Socket pSocket) throws Exception {
		super(pSocket, IcbcConf.newInstance());
	}
}
