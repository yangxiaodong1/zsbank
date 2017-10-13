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
 * ftp工具类
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
	 *            端口
	 */
	public FtpUtil(String ip, String port) {
		this(ip, port, "", "");
	}

	/**
	 * 
	 * @param ip
	 *            ip
	 * @param port
	 *            端口
	 * @param user
	 *            用户名
	 * @param password
	 *            密码
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
	 *            端口
	 * @param user
	 *            用户名
	 * @param password
	 *            密码
	 * @param timeOut
	 *            超时时间，单位秒
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
		mFTPClient.setDefaultTimeout(ftpTimeOut * 1000); // 设置超时
		try {
			mFTPClient.connect(ftpIp);
			int tReplyCode = mFTPClient.getReplyCode();
			if (!FTPReply.isPositiveCompletion(tReplyCode)) {
				ccLogger.error("ftp连接失败！" + mFTPClient.getReplyString());
				throw new MidplatException("ftp连接失败！" + ftpIp + ": " + tReplyCode);
			}
			ccLogger.info("ftp连接成功！" + ftpIp);

			// 登录
			if (!mFTPClient.login(ftpUser, ftpPassword)) {
				ccLogger.error("ftp登录失败！" + mFTPClient.getReplyString());
				throw new MidplatException("ftp登录失败！" + ftpUser + ":" + ftpPassword);
			}
			ccLogger.info("ftp登录成功！");

			// 二进制传输
			if (mFTPClient.setFileType(FTP.BINARY_FILE_TYPE)) {
				ccLogger.info("采用二进制传输！");
			} else {
				ccLogger.warn("设置传输模式为二进制失败！" + mFTPClient.getReplyString());
			}
		} catch (Exception e) {
			throw new MidplatException(e);
		}
	}

	/**
	 * 
	 * 下载文件 默认本地文件名和银行服务器的文件名是一致， 若不一致， 调用downloadFile方法之前，先通过
	 * {@link #setFileName()}设置服务器的文件名
	 * 
	 * @param localPath
	 *            本地文件路径
	 * @param remotePath
	 *            ftp路径
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
				ccLogger.warn("未正确配置ftp文件本地备份目录，将停止备份操作，直接进行对账 ！", ex);
			}
			// if (null == tLocalFos) { // 未正确设置备份目录，直接使用ftp流进行对账
			// ByteArrayOutputStream ttBaos = new ByteArrayOutputStream();
			// if (mFTPClient.retrieveFile(fileName, ttBaos)) {
			// ccLogger.info("ftp下载数据成功！");
			// } else {
			// ccLogger.error("ftp下载数据失败！" + mFTPClient.getReplyString());
			// throw new MidplatException("ftp下载数据失败！" +
			// mFTPClient.getReplyString());
			// }
			// } else {
			while (i <= retryTimes) {
				try {

					if (mFTPClient.retrieveFile(fileName, tLocalFos)) {
						ccLogger.info("ftp下载数据成功！" + localPath);
						tLocalFos.close();
						mFTPClient.logout();
						ccLogger.info("ftp退出成功！");
						break;
					} else {
						ccLogger.info("ftp下载数据失败！" + mFTPClient.getReplyString());
						throw new MidplatException("ftp下载数据失败！" + mFTPClient.getReplyString());
					}

				} catch (MidplatException ex) {
					i++;
					if (i <= retryTimes) {
						ccLogger.info("ftp下载文件失败，重新下载！");
						continue;
					} else {
						throw new MidplatException("下载" + retryTimes + "次仍未成功，退出");
					}
				} catch (SocketTimeoutException ex) {
					i++;
					if (i <= retryTimes) {
						ccLogger.info("ftp服务器响应超时，尝试重新连接！");
						continue;
					} else {
						throw new MidplatException("重试" + retryTimes + "次连接，退出");
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
					ccLogger.info("ftp连接断开！");
				} catch (IOException ex) {
					ccLogger.warn("服务端连接已断开！", ex);
				}
			}
		}

	}

	/**
	 * 通过FTP上传文件到银行 默认本地文件名和银行服务器的文件名是一致， 若不一致， 调用方法之前，先通过
	 * {@link #setFileName()}设置服务器的文件名
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
						ccLogger.info("上传文件" + fileName + "成功");
						in.close();
						mFTPClient.logout();
						ccLogger.info("ftp退出成功！");
						break;
					} else {
						throw new MidplatException("");
					}

				} catch (MidplatException ex) {
					i++;
					if (i <= retryTimes) {
						ccLogger.info("ftp上传文件失败，重新上传！");
						continue;
					} else {
						throw new MidplatException("上传" + retryTimes + "次仍未成功，退出");
					}
				} catch (SocketTimeoutException ex) {
					if (i <= retryTimes) {
						ccLogger.info("ftp服务器响应超时，尝试重新连接！");
						i++;
						continue;
					} else {
						throw new MidplatException("重试" + retryTimes + "次连接，退出");
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
					ccLogger.info("ftp连接断开！");
				} catch (IOException ex) {
					ccLogger.warn("服务端连接已断开！", ex);
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
							ccLogger.error("切换ftp工作目录失败！" + remotePath + "; " + mFTPClient.getReplyString());
							throw new MidplatException("切换ftp工作目录失败！" + remotePath + "; " + mFTPClient.getReplyString());
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
	 * 获取上传文件的文件名，如果远程路径中包含文件名则将文件名设置为服务器中的文件名，如果不包含，则为待上传文件的文件名
	 * 
	 * @param localPath
	 * @param remotePath
	 */
	private void getUpLoadFileName(
									String localPath,
									String remotePath)
			throws MidplatException {

		if (!(remotePath.contains(".") || localPath.contains("."))) {
			throw new MidplatException("未设置文件名");
		}
		fileName = new File(localPath).getName();
		if (remotePath.contains(".")) {
			fileName = remotePath.substring(remotePath.lastIndexOf("/") + 1);
		}
	}

	/**
	 * 重试次数
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
	 * 设置服务器的文件名
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
		stringBu.append(",端口:" + this.ftpPort);
		stringBu.append(",用户名:" + this.ftpUser);
		stringBu.append(",密码:" + this.ftpPassword);
		stringBu.append(",超时时间:" + this.ftpTimeOut);
		stringBu.append(",连接重试次数:" + this.retryTimes);

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
