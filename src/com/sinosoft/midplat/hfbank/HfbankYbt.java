package com.sinosoft.midplat.hfbank;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

/**
 * @Title: com.sinosoft.midplat.hfbank.HfbankYbt.java
 * @Description: ∫„∑·“¯––
 * @Copyright: Copyright (c) 2016
 * @author:liying
 * 
 * @date 20160325
 * @version 1.0
 *
 */
public class HfbankYbt extends Ybt4Socket {

	public HfbankYbt(Socket pSocket) throws Exception {
		super(pSocket, HfbankConf.newInstance());
	}
}
