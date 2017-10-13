package com.sinosoft.midplat.hrbcb;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

/**
 * @Title: com.sinosoft.midplat.jlyh.JlyhYbt.java
 * @Description: 吉林银行
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Jul 1, 2014 10:00:09 AM
 * @version 
 *
 */
public class HrbcbYbt extends Ybt4Socket {

	public HrbcbYbt(Socket pSocket) throws Exception {
		super(pSocket, HrbcbConf.newInstance());
	}
}
