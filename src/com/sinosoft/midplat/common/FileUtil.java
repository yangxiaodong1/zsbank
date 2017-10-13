package com.sinosoft.midplat.common;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;

import org.apache.log4j.Logger;

public class FileUtil {

	protected final Logger cLogger = Logger.getLogger(getClass());
	/**
     * 备份文件
     * @param files
     * 需要备份的文件
     * @return 新的文件路径
     */

    public  File[] backupFiles(File[] files, String oldDir, String newDir) throws IOException {

    	cLogger.info("开始备份文件，备份目录为：" + oldDir + File.separator + newDir);
            File mDirFile = new File(oldDir);

            if (!mDirFile.exists() || !mDirFile.isDirectory() ) {

                    cLogger.warn("本地文件目录不存在，不进行备份操作！" + mDirFile);

                    return new File[] {};

            }

            File[] newFiles = new File[files.length] ;

            // 新路径

            File newDirFile = new File(mDirFile,newDir);
            //如果新路径中有文件，先删再备份
//            if(newDirFile.exists()){
//            	cLogger.info("备份目录中文件已存在，先删除目录中的文件，删除目录为：：" + oldDir + File.separator + newDir);
//            	deleteDirectory(oldDir + File.separator + newDir);
//            }

            cLogger.info("备份文件到备份目录中目录为：" + oldDir + File.separator + newDir);
            for (int i = 0; i < files.length; i++) {

                    // 新文件的路径

                    newFiles[i] = new File(newDirFile, files[i].getName());


                    fileMove(files[i], newDirFile);


            }

            cLogger.info("备份文件结束！" + oldDir + File.separator + newDir);
            return newFiles;

    }
    
	public void fileMove(File pSrcFile, File pDestDir) throws IOException {
		pDestDir.mkdirs();
		if (!pDestDir.exists()) {	//目标目录不存在
			throw new IOException("目标目录不存在，试图创建失败！" + pDestDir);
		}
		File mDestFile = new File(pDestDir, pSrcFile.getName());
		if (mDestFile.exists()) {	//目标文件已存在
			//目录文件已存在，可先删再迁移
			cLogger.info("该文件已存，需要覆盖原文件，文件为：" + mDestFile.getName());
			mDestFile.delete();
		}
		
		if (!pSrcFile.renameTo(mDestFile)) {	//移动文件失败
			throw new IOException("移动文件失败！");
		}
	}
 
    
    public boolean deleteDirectory(String sPath) {  
    	
    	boolean flag = false;
        //如果sPath不以文件分隔符结尾，自动添加文件分隔符  
        if (!sPath.endsWith(File.separator)) {  
            sPath = sPath + File.separator;  
        }  
        File dirFile = new File(sPath);  
        //如果dir对应的文件不存在，或者不是一个目录，则退出  
        if (!dirFile.exists() || !dirFile.isDirectory()) {  
            return false;  
        }  
        flag = true;  
        //删除文件夹下的所有文件(包括子目录)  
        File[] files = dirFile.listFiles();  
        for (int i = 0; i < files.length; i++) {  
            //删除子文件  
            if (files[i].isFile()) {  
                flag = deleteFile(files[i].getAbsolutePath());  
                if (!flag) break;  
            } //删除子目录  
            else {  
                flag = deleteDirectory(files[i].getAbsolutePath());  
                if (!flag) break;  
            }  
        }  
        if (!flag) return false;  
        //删除当前目录  
        if (dirFile.delete()) {  
            return true;  
        } else {  
            return false;  
        }  
    } 

    /** 
     * 删除单个文件 
     * @param   sPath    被删除文件的文件名 
     * @return 单个文件删除成功返回true，否则返回false 
     */  
    public boolean deleteFile(String sPath) {  
        boolean flag = false;  
        File file = new File(sPath);  
        // 路径为文件且不为空则进行删除  
        if (file.isFile() && file.exists()) {  
            file.delete();  
            flag = true;  
        }  
        return flag;  
    } 
    

	 
//    int countFolders = 0;// 声明统计文件夹的变量

	/**
	 * 根据关键字，匹配文件
	 */
   public  File[] searchFile(File folder, final String keyWord) {// 递归查找包含关键字的文件
	   
	   cLogger.info("开始遍历并检索文件，检索日期为：" + keyWord);
       File[] subFolders = folder.listFiles(new FileFilter() {// 运用内部匿名类获得文件
                   public boolean accept(File pathname) {// 实现FileFilter类的accept方法
                	   int countFiles = 0;// 声明统计文件个数的变量
                       if (pathname.isFile())// 如果是文件
                           countFiles++;
//                       else
//                           // 如果是目录
//                           countFolders++;
                       if ((pathname.isFile() && pathname.getName()
                                       .toLowerCase()
                                       .contains(keyWord.toLowerCase())))// 目录或文件包含关键字
                           return true;
                       return false;
                   }
               });
       cLogger.info("遍历并检索文件结束！");
       return subFolders;
   }
   


	
}
