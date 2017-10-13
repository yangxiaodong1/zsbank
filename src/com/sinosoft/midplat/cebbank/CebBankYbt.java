package com.sinosoft.midplat.cebbank;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class CebBankYbt extends Ybt4Socket {
	public CebBankYbt(Socket pSocket) throws Exception {
		super(pSocket, CebBankConf.newInstance());
	}
}
