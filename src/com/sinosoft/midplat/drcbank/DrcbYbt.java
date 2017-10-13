package com.sinosoft.midplat.drcbank;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class DrcbYbt extends Ybt4Socket{

	public DrcbYbt(Socket pSocket) throws Exception {
		super(pSocket, DrcbConf.newInstance());
	}
}
