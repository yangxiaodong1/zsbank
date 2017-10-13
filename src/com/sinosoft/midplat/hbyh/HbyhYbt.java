package com.sinosoft.midplat.hbyh;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

/**
 * @Title: com.sinosoft.midplat.hbyh.HbyhYbt.java
 * @Description: 河北银行
 * @Copyright: Copyright (c) 2015
 * @author:安邦保险IT部
 * 
 * @date Feb. 3, 2015 10:00:09 AM
 * @version 1.0
 *
 */
public class HbyhYbt extends Ybt4Socket {

	public HbyhYbt(Socket pSocket) throws Exception {
		super(pSocket, HbyhConf.newInstance());
	}
}
