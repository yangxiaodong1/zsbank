package com.sinosoft.midplat.hljrcc;

import java.net.Socket;
import com.sinosoft.midplat.Ybt4Socket;


public class HljrccYbt extends Ybt4Socket{
	public HljrccYbt(Socket pSocket) throws Exception {
		super(pSocket, HljrccConf.newInstance());
	}
}
