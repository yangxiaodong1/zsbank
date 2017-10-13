package com.sinosoft.midplat.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.SocketTimeoutException;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.log4j.Level;

import com.sinosoft.midplat.exception.MidplatException;

/**
 * ftp������
 * 
 * @author ab024200
 * 
 */
public class FtpUtil implements IFtpUtil{
	private String ftpIp;
	private String ftpPort = "21";
	private String ftpUser;
	private String ftpPassword;
	private int ftpTimeOut = 5 * 60;
	private int retryTimes = 5;
	private FTPClient mFTPClient = new FTPClient();
	private String fileName = null;
	// private String localFileName;
	public org.apache.log4j.Logger ccLogger = org.apache.log4j.Logger.getLogger(getClass());

	/**
	 * ip
	 * 
	 * @param ip
	 */
	public FtpUtil(String ip) {
		this(ip, "21");
	}

	/**
	 * 
	 * @param ip
	 *            ip
	 * @param port
	 *            �˿�
	 */
	public FtpUtil(String ip, String port) {
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
	public FtpUtil(String ip, String port, String user, String password) {
		this(ip, port, user, password, 300);

	}

	public FtpUtil(String ip, String port, String user, String password, int timeOut) {
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
	public FtpUtil(String ip, String port, String user, String password, int timeOut, int retryTimes) {
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
	 * @throws MidplatException
	 */
	private void connectFtp()
			throws MidplatException {
		mFTPClient.setDefaultPort(Integer.parseInt(ftpPort));
		mFTPClient.setDefaultTimeout(ftpTimeOut * 1000); // ���ó�ʱ
		try {
			mFTPClient.connect(ftpIp);
			int tReplyCode = mFTPClient.getReplyCode();
			if (!FTPReply.isPositiveCompletion(tReplyCode)) {
				ccLogger.error("ftp����ʧ�ܣ�" + mFTPClient.getReplyString());
				throw new MidplatException("ftp����ʧ�ܣ�" + ftpIp + ": " + tReplyCode);
			}
			ccLogger.info("ftp���ӳɹ���" + ftpIp);

			// ��¼
			if (!mFTPClient.login(ftpUser, ftpPassword)) {
				ccLogger.error("ftp��¼ʧ�ܣ�" + mFTPClient.getReplyString());
				throw new MidplatException("ftp��¼ʧ�ܣ�" + ftpUser + ":" + ftpPassword);
			}
			ccLogger.info("ftp��¼�ɹ���");

			// �����ƴ���
			if (mFTPClient.setFileType(FTP.BINARY_FILE_TYPE)) {
				ccLogger.info("���ö����ƴ��䣡");
			} else {
				ccLogger.warn("���ô���ģʽΪ������ʧ�ܣ�" + mFTPClient.getReplyString());
			}
		} catch (Exception e) {
			throw new MidplatException(e);
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
	public void downloadFile(
								String localPath,
								String remotePath)
			throws MidplatException {

		localPath = checkPath(localPath);
		remotePath = checkPath(remotePath);

		connectFtp();
		int i = 1;

		try {

			changeWorkingDirectory(remotePath);
			if (null == fileName) {
				File remoteFile = new File(remotePath);
				fileName = remoteFile.getName();
			}
			ccLogger.info("fileName:" + fileName);
			FileOutputStream tLocalFos = null;
			try {
				if (!localPath.contains(".")) {
					localPath += fileName;
				}
				tLocalFos = new FileOutputStream(localPath);

			} catch (Exception ex) {
				ccLogger.warn("δ��ȷ����ftp�ļ����ر���Ŀ¼����ֹͣ���ݲ�����ֱ�ӽ��ж��� ��", ex);
			}
			// if (null == tLocalFos) { // δ��ȷ���ñ���Ŀ¼��ֱ��ʹ��ftp�����ж���
			// ByteArrayOutputStream ttBaos = new ByteArrayOutputStream();
			// if (mFTPClient.retrieveFile(fileName, ttBaos)) {
			// ccLogger.info("ftp�������ݳɹ���");
			// } else {
			// ccLogger.error("ftp��������ʧ�ܣ�" + mFTPClient.getReplyString());
			// throw new MidplatException("ftp��������ʧ�ܣ�" +
			// mFTPClient.getReplyString());
			// }
			// } else {
			while (i <= retryTimes) {
				try {

					if (mFTPClient.retrieveFile(fileName, tLocalFos)) {
						ccLogger.info("ftp�������ݳɹ���" + localPath);
						tLocalFos.close();
						mFTPClient.logout();
						ccLogger.info("ftp�˳��ɹ���");
						break;
					} else {
						ccLogger.info("ftp��������ʧ�ܣ�" + mFTPClient.getReplyString());
						throw new MidplatException("ftp��������ʧ�ܣ�" + mFTPClient.getReplyString());
					}

				} catch (MidplatException ex) {
					i++;
					if (i <= retryTimes) {
						ccLogger.info("ftp�����ļ�ʧ�ܣ��������أ�");
						continue;
					} else {
						throw new MidplatException("����" + retryTimes + "����δ�ɹ����˳�");
					}
				} catch (SocketTimeoutException ex) {
					i++;
					if (i <= retryTimes) {
						ccLogger.info("ftp��������Ӧ��ʱ�������������ӣ�");
						continue;
					} else {
						throw new MidplatException("����" + retryTimes + "�����ӣ��˳�");
					}
				}
			}
		} catch (Exception e) {
			ccLogger.info(e.getMessage());
			throw new MidplatException(e);
		} finally {
			if (mFTPClient.isConnected()) {
				try {
					mFTPClient.disconnect();
					ccLogger.info("ftp���ӶϿ���");
				} catch (IOException ex) {
					ccLogger.warn("����������ѶϿ���", ex);
				}
			}
		}

	}

	/**
	 * ͨ��FTP�ϴ��ļ������� Ĭ�ϱ����ļ��������з��������ļ�����һ�£� ����һ�£� ���÷���֮ǰ����ͨ��
	 * {@link #setFileName()}���÷��������ļ���
	 * 
	 * @param localPath
	 * @param remotePath
	 *            path
	 * @throws MidplatException
	 */
	public void uploadFile(
							String localPath,
							String remotePath)
			throws MidplatException {

		localPath = checkPath(localPath);
		remotePath = checkPath(remotePath);
		try {
			if (null == fileName) {
				getUpLoadFileName(localPath, remotePath);
			}
			ccLogger.info("fileName:" + fileName);
			connectFtp();
			int i = 1;

			changeWorkingDirectory(remotePath);
			File file = new File(localPath);

			FileInputStream in = new FileInputStream(file);
			while (i <= retryTimes) {
				try {
					if (mFTPClient.storeFile(fileName, in)) {
						ccLogger.info("�ϴ��ļ�" + fileName + "�ɹ�");
						in.close();
						mFTPClient.logout();
						ccLogger.info("ftp�˳��ɹ���");
						break;
					} else {
						throw new MidplatException("");
					}

				} catch (MidplatException ex) {
					i++;
					if (i <= retryTimes) {
						ccLogger.info("ftp�ϴ��ļ�ʧ�ܣ������ϴ���");
						continue;
					} else {
						throw new MidplatException("�ϴ�" + retryTimes + "����δ�ɹ����˳�");
					}
				} catch (SocketTimeoutException ex) {
					if (i <= retryTimes) {
						ccLogger.info("ftp��������Ӧ��ʱ�������������ӣ�");
						i++;
						continue;
					} else {
						throw new MidplatException("����" + retryTimes + "�����ӣ��˳�");
					}
				}
			}
		} catch (Exception e) {
			ccLogger.info(e.getMessage());
			throw new MidplatException(e);
		} finally {
			if (mFTPClient.isConnected()) {
				try {
					mFTPClient.disconnect();
					ccLogger.info("ftp���ӶϿ���");
				} catch (IOException ex) {
					ccLogger.warn("����������ѶϿ���", ex);
				}
			}
		}
		// break;
		// }

	}

	private void changeWorkingDirectory(
										String remotePath)
			throws MidplatException {
		try {
			if (null != remotePath && !"".equals(remotePath)) {
				if (remotePath.contains(".")) {
					remotePath = remotePath.substring(0, remotePath.lastIndexOf(("/")));
				}
				String[] dirArray = remotePath.split("/");
				for (String dr : dirArray) {
					if (!(dr == null || dr.equals(""))) {
						if (!mFTPClient.changeWorkingDirectory(dr)) {
							ccLogger.error("�л�ftp����Ŀ¼ʧ�ܣ�" + remotePath + "; " + mFTPClient.getReplyString());
							throw new MidplatException("�л�ftp����Ŀ¼ʧ�ܣ�" + remotePath + "; " + mFTPClient.getReplyString());
						}
					}
				}
			}
		} catch (Exception e) {
			throw new MidplatException(e);
		}
	}

	private String checkPath(
								String path) {

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
	private void getUpLoadFileName(
									String localPath,
									String remotePath)
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
	public void setRetryTimes(
								int retryTimes) {
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
	public void setFileName(
							String fileName) {
		this.fileName = fileName;
	}

	@Override
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

	public static void main(
							String[] args)
			throws MidplatException {
		FtpUtil fu = new FtpUtil("10.203.254.72", "21", "ftppost", "ftppost");
		fu.setFileName("YBTCX302920110615_RTN11");
		fu.uploadFile("D:/YBTCX302920110616_RTN1.1txt1", "abc");
		// fu.downloadFile("D:\\", "abc/in2.xml");
		// fu.downloadFile("D:\\test\\",
		// "abc/2011/201101/B3003052010080911");
		// FtpUtil f = null;
		// System.out.println(f.toString());
	}

}
