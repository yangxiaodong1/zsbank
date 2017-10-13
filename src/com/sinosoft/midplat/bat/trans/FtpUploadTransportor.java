package com.sinosoft.midplat.bat.trans;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.common.FtpUtil;
import com.sinosoft.midplat.common.IFtpUtil;
import com.sinosoft.midplat.common.SFtpUtil;

public class FtpUploadTransportor implements FileTransportor {
    Logger logger = Logger.getLogger(FtpUploadTransportor.class);
    //bussess节点配置
    private Element busiConf;
    //远程目录
    private String remoteDir = null;
    //本地目录
    private String localDir = null;
    
    //ftp服务器ip
    private String ip = null;
    //ftp服务器端口
    private String port = null;
    //登陆用户名
    private String user = null;
    //登陆密码
    private String password = null;
    //超时时间
    private String timeOut = null;
    //ftp类型
    private String type = null;
    
    public FtpUploadTransportor(Element busiConf) {
        super();
        this.busiConf = busiConf;
        Element ftpElement = busiConf.getChild("ftp");
        
        logger.info("解析FTP参数信息...");
        ip = ftpElement.getAttributeValue("ip");
        port = ftpElement.getAttributeValue("port");
        user = ftpElement.getAttributeValue("user");
        password = ftpElement.getAttributeValue("password");
        timeOut = ftpElement.getAttributeValue("timeOut");
        type = ftpElement.getAttributeValue("type");
        remoteDir = ftpElement.getAttributeValue("path").replace('\\', '/');
        if (!remoteDir.endsWith("/")) {
            remoteDir += '/';
        }
        
        localDir = busiConf.getChildText("localDir");
        if (null != localDir && !"".equals(localDir)) {
            localDir.replace('\\', '/');
            if (!localDir.endsWith("/")) {
                localDir += '/';
            }
        }
    }


    public boolean transport(String remoteFileName) throws Exception {
       
        if(busiConf.getChild("ftp")==null){
            logger.debug("未配置ftp信息...");
            return true;
        }
        IFtpUtil ftp = null;

        // FTP模式
        if ("ftp".equals(type)) {
            // ftp模式
            if (null == timeOut || "".equals(timeOut)) {
                ftp = new FtpUtil(ip, port, user, password);
            } else {
                ftp = new FtpUtil(ip, port, user, password, Integer
                        .parseInt(timeOut));
            }
        } else if ("sftp".equals(type)) {
            // sftp模式
            if (null == timeOut || "".equals(timeOut)) {
                ftp = new SFtpUtil(ip, port, user, password);
            } else {
                ftp = new SFtpUtil(ip, port, user, password,
                        Integer.parseInt(timeOut));
            }
        }
        logger.info(ftp.toString());
        
        String sleepTime = busiConf.getChildText("sleep");
        if(sleepTime!=null && !"".equals(sleepTime.trim())){
            //配置了休眠时间
            try{
                int sleep = Integer.valueOf(sleepTime);
                logger.debug("等待"+sleep+"分钟后，发送数据...");
                Thread.currentThread().sleep(1000*60*sleep);
            }catch(Exception e){
                logger.error(e, e);
            }
        }else{
            //立即发送文件
            logger.debug("没有配置休眠时间，立即发送数据...");
        }

        ftp.uploadFile(localDir + remoteFileName, remoteDir
                + remoteFileName);
        
        return true;
    }

}
