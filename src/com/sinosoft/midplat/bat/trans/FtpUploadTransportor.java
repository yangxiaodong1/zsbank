package com.sinosoft.midplat.bat.trans;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.common.FtpUtil;
import com.sinosoft.midplat.common.IFtpUtil;
import com.sinosoft.midplat.common.SFtpUtil;

public class FtpUploadTransportor implements FileTransportor {
    Logger logger = Logger.getLogger(FtpUploadTransportor.class);
    //bussess�ڵ�����
    private Element busiConf;
    //Զ��Ŀ¼
    private String remoteDir = null;
    //����Ŀ¼
    private String localDir = null;
    
    //ftp������ip
    private String ip = null;
    //ftp�������˿�
    private String port = null;
    //��½�û���
    private String user = null;
    //��½����
    private String password = null;
    //��ʱʱ��
    private String timeOut = null;
    //ftp����
    private String type = null;
    
    public FtpUploadTransportor(Element busiConf) {
        super();
        this.busiConf = busiConf;
        Element ftpElement = busiConf.getChild("ftp");
        
        logger.info("����FTP������Ϣ...");
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
            logger.debug("δ����ftp��Ϣ...");
            return true;
        }
        IFtpUtil ftp = null;

        // FTPģʽ
        if ("ftp".equals(type)) {
            // ftpģʽ
            if (null == timeOut || "".equals(timeOut)) {
                ftp = new FtpUtil(ip, port, user, password);
            } else {
                ftp = new FtpUtil(ip, port, user, password, Integer
                        .parseInt(timeOut));
            }
        } else if ("sftp".equals(type)) {
            // sftpģʽ
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
            //����������ʱ��
            try{
                int sleep = Integer.valueOf(sleepTime);
                logger.debug("�ȴ�"+sleep+"���Ӻ󣬷�������...");
                Thread.currentThread().sleep(1000*60*sleep);
            }catch(Exception e){
                logger.error(e, e);
            }
        }else{
            //���������ļ�
            logger.debug("û����������ʱ�䣬������������...");
        }

        ftp.uploadFile(localDir + remoteFileName, remoteDir
                + remoteFileName);
        
        return true;
    }

}
