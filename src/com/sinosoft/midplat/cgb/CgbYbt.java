package com.sinosoft.midplat.cgb;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class CgbYbt extends Ybt4Socket {
	public CgbYbt(Socket pSocket) throws Exception {
		super(pSocket, CgbConf.newInstance());
	}
}