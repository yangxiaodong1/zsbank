package com.sinosoft.midplat.bcomm;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

/**
 * @Title: com.sinosoft.midplat.bcomm.BcommYbt.java
 * @Description: 
 * Copyright: Copyright (c) 2014
 * Company:∞≤∞Ó±£œ’IT≤ø
 * 
 * @date Feb 7, 2014 9:15:57 AM
 * @version 
 *
 */
public class BcommYbt extends Ybt4Socket{

	public BcommYbt(Socket pSocket) throws Exception {
		super(pSocket, BcommConf.newInstance());
	}
}
