package com.sinosoft.midplat.bat.trans;

public interface FileTransportor {
    
    /**
     * �����ļ�
     * @param fileName  �ļ���
     * @return
     * @throws Exception 
     */
    public boolean transport(String fileName)throws Exception;

}
