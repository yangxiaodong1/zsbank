package com.sinosoft.midplat.cmb;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class CmbYbt extends Ybt4Socket {
	public CmbYbt(Socket pSocket) throws Exception {
		super(pSocket, CmbConf.newInstance());
	}
}
