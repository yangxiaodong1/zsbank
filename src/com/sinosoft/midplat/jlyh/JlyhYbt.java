package com.sinosoft.midplat.jlyh;

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
public class JlyhYbt extends Ybt4Socket {

	public JlyhYbt(Socket pSocket) throws Exception {
		super(pSocket, JlyhConf.newInstance());
	}
}
