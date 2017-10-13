/**
 * 
 */
package com.sinosoft.midplat.common;

import com.sinosoft.midplat.exception.MidplatException;

/**
 * @author AB039365
 *
 */
public interface IFtpUtil {
	
	public void uploadFile(String localPath, String remotePath) throws MidplatException;
	public void downloadFile(String localPath, String remotePath) throws MidplatException;
	public void setRetryTimes(int retryTimes);
	public void setFileName(String fileName);
	public String toString();
}
