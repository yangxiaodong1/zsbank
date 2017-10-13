package com.sinosoft.midplat.bjbank;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class BjbankYbt extends Ybt4Socket {
	public BjbankYbt(Socket pSocket) throws Exception {
		super(pSocket, BjbankConf.newInstance());
	}
}
