package com.sinosoft.midplat.grcb;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

/**
 * @Title: com.sinosoft.midplat.grcb.GrcbYbt.java
 * @Description: ����ũ����
 * @Copyright: Copyright (c) 2015
 * @author:�����IT��
 * 
 * @date Feb. 3, 2015 10:00:09 AM
 * @version 1.0
 *
 */

public class GrcbYbt extends Ybt4Socket {

	public GrcbYbt(Socket pSocket) throws Exception {
		super(pSocket, GrcbConf.newInstance());
	}
}
