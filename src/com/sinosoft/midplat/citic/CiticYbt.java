package com.sinosoft.midplat.citic;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class CiticYbt extends Ybt4Socket {
	public CiticYbt(Socket pSocket) throws Exception {
		super(pSocket, CiticConf.newInstance());
	}
}