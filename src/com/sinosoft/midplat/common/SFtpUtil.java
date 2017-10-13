/**
 * 
 */
package com.sinosoft.midplat.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

import org.apache.log4j.Level;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;
import com.sinosoft.midplat.exception.MidplatException;

/**
 * @author AB039365
 * 
 */
public class SFtpUtil implements IFtpUtil{
	private String ftpIp;
	private String ftpPort = "22";
	private String ftpUser;
	private String ftpPassword;
	private int ftpTimeOut = 5 * 60;
	private int retryTimes = 5;
	private ChannelSftp sftp = null;
	private String fileName = null;
	private Session session = null;
	private Channel channel = null;
	public org.apache.log4j.Logger ccLogger = org.apache.log4j.Logger
			.getLogger(getClass());

	/**
	 * ip
	 * 
	 * @param ip
	 */
	public SFtpUtil(String ip) {
		this(ip, "22");
	}

	/**
	 * 
	 * @param ip
	 *            ip
	 * @param port
	 *            �˿�
	 */
	public SFtpUtil(String ip, String port) {
		this(ip, port, "", "");
	}

	/**
	 * 
	 * @param ip
	 *            ip
	 * @param port
	 *            �˿�
	 * @param user
	 *            �û���
	 * @param password
	 *            ����
	 */
	public SFtpUtil(String ip, String port, String user, String password) {
		this(ip, port, user, password, 300);

	}

	public SFtpUtil(String ip, String port, String user, String password,
			int timeOut) {
		this(ip, port, user, password, timeOut, 5);
	}

	/**
	 * 
	 * @param ip
	 *            ip
	 * @param port
	 *            �˿�
	 * @param user
	 *            �û���
	 * @param password
	 *            ����
	 * @param timeOut
	 *            ��ʱʱ�䣬��λ��
	 */
	public SFtpUtil(String ip, String port, String user, String password,
			int timeOut, int retryTimes) {
		this.ftpIp = ip;
		if (port != null && !"".equals(port)) {
			this.ftpPort = port;
		}
		this.ftpUser = user;
		this.ftpPassword = password;
		this.ftpTimeOut = timeOut;
		this.retryTimes = retryTimes;
		ccLogger.setLevel(Level.INFO);
	}

	/**
	 * 
	 * @return
	 * @throws MidplatException
	 */
	public ChannelSftp connectFtp() throws MidplatException {

		try {
			JSch jsch = new JSch();
			session = jsch.getSession(ftpUser, ftpIp, Integer.parseInt(ftpPort));
			ccLogger.info("SFtp Session created.");
			session.isConnected();
			session.setPassword(ftpPassword);
			Properties sshConfig = new Properties();
			sshConfig.put("StrictHostKeyChecking", "no");
			session.setConfig(sshConfig);
			session.connect();
			ccLogger.info("SFtp Session connected.");
			ccLogger.info("SFtp Opening Channel.");
			channel = session.openChannel("sftp");
			channel.connect();
			sftp = (ChannelSftp) channel;
			ccLogger.info("SFtp Connected to " + ftpIp + ".");
		} catch (Exception e) {
			throw new MidplatException(e);
		}
		return sftp;
	}

	/**
	 * ͨ��SFTP�ϴ��ļ������� Ĭ�ϱ����ļ��������з��������ļ�����һ�£� ����һ�£� ���÷���֮ǰ����ͨ��
	 * {@link #setFileName()}���÷��������ļ���
	 * 
	 * @param localPath
	 * @param remotePath
	 *            path
	 * @throws MidplatException
	 */
	public void uploadFile(String localPath, String remotePath)
			throws MidplatException {
		localPath = checkPath(localPath);
		remotePath = checkPath(remotePath);
		File file = null;
		FileInputStream in = null;
		int i = 1;
		try {
			if (null == fileName) {
				getUpLoadFileName(localPath, remotePath);
			}
			ccLogger.info("fileName:" + fileName);
			connectFtp();

			try {
				if (null != remotePath && !"".equals(remotePath)) {
					if (remotePath.contains(".")) {
						remotePath = remotePath.substring(0, remotePath
								.lastIndexOf(("/"))+1);
					}
					sftp.cd(remotePath);
				}
			} catch (SftpException e1) {
				ccLogger.error("�л�sftp����Ŀ¼ʧ�ܣ�" + remotePath + "; ", e1);
				throw new MidplatException("�л�sftp����Ŀ¼ʧ�ܣ�" + remotePath + "; ");
			}

			file = new File(localPath);
			in = new FileInputStream(file);

			while (i <= retryTimes) {
				try {
					sftp.put(in, file.getName(), ChannelSftp.OVERWRITE);
					ccLogger.info("�ϴ��ļ�" + fileName + "�ɹ�");
					ccLogger.info("sftp�˳��ɹ���");
					break;
				} catch (SftpException e) {
					i++;
					if (i <= retryTimes) {
						ccLogger.error("sftp�ϴ��ļ�ʧ�ܣ������ϴ���", e);
						continue;
					} else {
						throw new MidplatException("�ϴ�" + retryTimes
								+ "����δ�ɹ����˳�", e);
					}
				}
			}

		} catch (Exception e) {
			ccLogger.error(e, e);
			throw new MidplatException(e);
		} finally {
			try {
			    if(in !=null){
			        in.close();
			    }
			} catch (IOException e) {
				throw new MidplatException(e);
			}
			sftp.quit();
			sftp.exit();
			sftp.disconnect();
			ccLogger.info("sftp���ӶϿ���");
			closeChannel();
		}

	}

	/**
	 * 
	 * �����ļ� Ĭ�ϱ����ļ��������з��������ļ�����һ�£� ����һ�£� ����downloadFile����֮ǰ����ͨ��
	 * {@link #setFileName()}���÷��������ļ���
	 * 
	 * @param localPath
	 *            �����ļ�·��
	 * @param remotePath
	 *            ftp·��
	 * @throws MidplatException
	 */
	public void downloadFile(String localPath, String remotePath)
			throws MidplatException {
		localPath = checkPath(localPath);
		remotePath = checkPath(remotePath);
		File file = null;
		FileOutputStream tLocalFos = null;
		int i = 1;
		try {
			if (null == fileName) {
				getUpLoadFileName(localPath, remotePath);
			}
			ccLogger.info("fileName:" + fileName);
			connectFtp();

			try {
				if (null != remotePath && !"".equals(remotePath)) {
					if (remotePath.contains(".")) {
						remotePath = remotePath.substring(0, remotePath
								.lastIndexOf(("/"))+1);
					}
					sftp.cd(remotePath);
				}
			} catch (SftpException e1) {
				ccLogger.error("�л�sftp����Ŀ¼ʧ�ܣ�" + remotePath + "; ", e1);
				throw new MidplatException("�л�sftp����Ŀ¼ʧ�ܣ�" + remotePath + "; ", e1);
			}

			if (!localPath.contains(".")) {

				if (((localPath.lastIndexOf("\\")) == (localPath.length() - 1))
						|| ((localPath.lastIndexOf("/")) == (localPath.length() - 1))) {
					localPath += fileName;
				} else {
					localPath += "/" + fileName;
				}
			}
			file = new File(localPath);
			tLocalFos = new FileOutputStream(file);

			while (i <= retryTimes) {
				try {
					sftp.get(fileName, tLocalFos);
					ccLogger.info("�����ļ�" + fileName + "�ɹ�");
					ccLogger.info("sftp�˳��ɹ���");
					break;
				} catch (SftpException e) {
					i++;
					if (i <= retryTimes) {
						ccLogger.error("sftp�����ļ�ʧ�ܣ��������أ�", e);
						continue;
					} else {
						throw new MidplatException("����" + retryTimes
								+ "����δ�ɹ����˳�", e);
					}
				}
			}

		} catch (FileNotFoundException e) {
			ccLogger.error(e);
			throw new MidplatException(e);
		} finally {
			try {
				tLocalFos.close();
			} catch (IOException e) {
				throw new MidplatException(e);
			}
			sftp.quit();
			sftp.exit();
			sftp.disconnect();
			ccLogger.info("sftp���ӶϿ���");
			closeChannel();
		}
	}



	public void closeChannel()   {
		if (channel != null) {
			channel.disconnect();
		}
		if (session != null) {
			session.disconnect();
		}
	}

	private String checkPath(String path) {

		if (path == null || path.length() < 1 || path.equals("")) {
			return "";
		}

		// String temp_path = path.substring(path.length() - 1);
		// if (!temp_path.equals("/") && !temp_path.equals("\\")) {
		// temp_path = path + File.separator;
		// } else {
		// temp_path = path;
		// }
		// return temp_path;
		ccLogger.info(path);
		return path;

	}

	/**
	 * ��ȡ�ϴ��ļ����ļ��������Զ��·���а����ļ������ļ�������Ϊ�������е��ļ������������������Ϊ���ϴ��ļ����ļ���
	 * 
	 * @param localPath
	 * @param remotePath
	 */
	private void getUpLoadFileName(String localPath, String remotePath)
			throws MidplatException {

		if (!(remotePath.contains(".") || localPath.contains("."))) {
			throw new MidplatException("δ�����ļ���");
		}
		fileName = new File(localPath).getName();
		if (remotePath.contains(".")) {
			fileName = remotePath.substring(remotePath.lastIndexOf("/") + 1);
		}
	}

	/**
	 * ���Դ���
	 * 
	 * @param retryTimes
	 */
	public void setRetryTimes(int retryTimes) {
		this.retryTimes = retryTimes;
	}

	public int getRetryTimes() {
		return retryTimes;
	}

	public String getFileName() {
		return fileName;
	}

	/**
	 * ���÷��������ļ���
	 * 
	 * @param fileName
	 */
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String toString() {
		StringBuilder stringBu = new StringBuilder();
		stringBu.append("ip:" + this.ftpIp);
		stringBu.append(",�˿�:" + this.ftpPort);
		stringBu.append(",�û���:" + this.ftpUser);
		stringBu.append(",����:" + this.ftpPassword);
		stringBu.append(",��ʱʱ��:" + this.ftpTimeOut);
		stringBu.append(",�������Դ���:" + this.retryTimes);

		return stringBu.toString();
	}

	public static void main(String[] args) throws Exception {
		String host = "10.10.232.60";
		String port = "22";
		String username = "ghr";
		String password = "ghr";
		SFtpUtil sf = new SFtpUtil(host, port, username, password);
		String directory = "/sss/p.xls";
		String localPath = "D:\\Temp\\test.xls";
		// String downloadFile = "upload2.txt";
		// String saveFile = "D:\\tmp\\download.txt";
		// String deleteFile = "delete.txt";
		// sftp = sf.connectSFtp();
		// sf.uploadFile(localPath, directory);
		sf.downloadFile("D:\\Temp/test666.xls", "sss/test.xls");
		
		
	}

}
