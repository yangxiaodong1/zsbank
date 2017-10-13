package com.sinosoft.midplat.lnrcclife;

import java.net.Socket;
import com.sinosoft.midplat.Ybt4Socket;

public class LnrcclifeYbt  extends Ybt4Socket {
	public LnrcclifeYbt(Socket pSocket) throws Exception {
		super(pSocket, LnrcclifeConf.newInstance());
	}
}
