package com.sinosoft.midplat.hrbcb;

import java.net.Socket;

import com.sinosoft.midplat.Ybt4Socket;

/**
 * @Title: com.sinosoft.midplat.jlyh.JlyhYbt.java
 * @Description: ��������
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
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
