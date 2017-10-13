package com.sinosoft.midplat.abc;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class AbcYbt extends Ybt4Socket {
	public AbcYbt(Socket pSocket) throws Exception {
		super(pSocket, AbcConf.newInstance());
	}
}