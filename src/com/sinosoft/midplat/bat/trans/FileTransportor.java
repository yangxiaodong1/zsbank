package com.sinosoft.midplat.bat.trans;

public interface FileTransportor {
    
    /**
     * 传输文件
     * @param fileName  文件名
     * @return
     * @throws Exception 
     */
    public boolean transport(String fileName)throws Exception;

}
