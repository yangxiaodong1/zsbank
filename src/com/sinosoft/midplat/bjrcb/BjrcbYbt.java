package com.sinosoft.midplat.bjrcb;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class BjrcbYbt extends Ybt4Socket {
	public BjrcbYbt(Socket pSocket) throws Exception {
		super(pSocket, BjrcbConf.newInstance());
	}
}
