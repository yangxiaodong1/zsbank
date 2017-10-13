package com.sinosoft.midplat.citicHZ;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class CiticHZYbt extends Ybt4Socket {
	public CiticHZYbt(Socket pSocket) throws Exception {
		super(pSocket, CiticHZConf.newInstance());
	}
}