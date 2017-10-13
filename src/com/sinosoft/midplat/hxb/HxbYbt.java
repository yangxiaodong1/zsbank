package com.sinosoft.midplat.hxb;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

/**
 * @Title: com.sinosoft.midplat.hxb.HxbYbt.java
 * @Description: TODO
 * Copyright: Copyright (c) 2014
 * Company:∞≤∞Ó±£œ’IT≤ø
 * 
 * @date Apr 1, 2014 2:46:22 PM
 * @version 
 *
 */
public class HxbYbt extends Ybt4Socket{

	public HxbYbt(Socket socket) throws Exception {
		super(socket, HxbConf.newInstance());
	}

}
