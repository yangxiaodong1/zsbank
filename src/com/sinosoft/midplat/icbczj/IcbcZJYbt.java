package com.sinosoft.midplat.icbczj;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

public class IcbcZJYbt extends Ybt4Socket {
	public IcbcZJYbt(Socket pSocket) throws Exception {
		super(pSocket, IcbcZJConf.newInstance());
	}
}
