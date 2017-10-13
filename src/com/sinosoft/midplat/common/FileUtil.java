package com.sinosoft.midplat.common;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;

import org.apache.log4j.Logger;

public class FileUtil {

	protected final Logger cLogger = Logger.getLogger(getClass());
	/**
     * �����ļ�
     * @param files
     * ��Ҫ���ݵ��ļ�
     * @return �µ��ļ�·��
     */

    public  File[] backupFiles(File[] files, String oldDir, String newDir) throws IOException {

    	cLogger.info("��ʼ�����ļ�������Ŀ¼Ϊ��" + oldDir + File.separator + newDir);
            File mDirFile = new File(oldDir);

            if (!mDirFile.exists() || !mDirFile.isDirectory() ) {

                    cLogger.warn("�����ļ�Ŀ¼�����ڣ������б��ݲ�����" + mDirFile);

                    return new File[] {};

            }

            File[] newFiles = new File[files.length] ;

            // ��·��

            File newDirFile = new File(mDirFile,newDir);
            //�����·�������ļ�����ɾ�ٱ���
//            if(newDirFile.exists()){
//            	cLogger.info("����Ŀ¼���ļ��Ѵ��ڣ���ɾ��Ŀ¼�е��ļ���ɾ��Ŀ¼Ϊ����" + oldDir + File.separator + newDir);
//            	deleteDirectory(oldDir + File.separator + newDir);
//            }

            cLogger.info("�����ļ�������Ŀ¼��Ŀ¼Ϊ��" + oldDir + File.separator + newDir);
            for (int i = 0; i < files.length; i++) {

                    // ���ļ���·��

                    newFiles[i] = new File(newDirFile, files[i].getName());


                    fileMove(files[i], newDirFile);


            }

            cLogger.info("�����ļ�������" + oldDir + File.separator + newDir);
            return newFiles;

    }
    
	public void fileMove(File pSrcFile, File pDestDir) throws IOException {
		pDestDir.mkdirs();
		if (!pDestDir.exists()) {	//Ŀ��Ŀ¼������
			throw new IOException("Ŀ��Ŀ¼�����ڣ���ͼ����ʧ�ܣ�" + pDestDir);
		}
		File mDestFile = new File(pDestDir, pSrcFile.getName());
		if (mDestFile.exists()) {	//Ŀ���ļ��Ѵ���
			//Ŀ¼�ļ��Ѵ��ڣ�����ɾ��Ǩ��
			cLogger.info("���ļ��Ѵ棬��Ҫ����ԭ�ļ����ļ�Ϊ��" + mDestFile.getName());
			mDestFile.delete();
		}
		
		if (!pSrcFile.renameTo(mDestFile)) {	//�ƶ��ļ�ʧ��
			throw new IOException("�ƶ��ļ�ʧ�ܣ�");
		}
	}
 
    
    public boolean deleteDirectory(String sPath) {  
    	
    	boolean flag = false;
        //���sPath�����ļ��ָ�����β���Զ�����ļ��ָ���  
        if (!sPath.endsWith(File.separator)) {  
            sPath = sPath + File.separator;  
        }  
        File dirFile = new File(sPath);  
        //���dir��Ӧ���ļ������ڣ����߲���һ��Ŀ¼�����˳�  
        if (!dirFile.exists() || !dirFile.isDirectory()) {  
            return false;  
        }  
        flag = true;  
        //ɾ���ļ����µ������ļ�(������Ŀ¼)  
        File[] files = dirFile.listFiles();  
        for (int i = 0; i < files.length; i++) {  
            //ɾ�����ļ�  
            if (files[i].isFile()) {  
                flag = deleteFile(files[i].getAbsolutePath());  
                if (!flag) break;  
            } //ɾ����Ŀ¼  
            else {  
                flag = deleteDirectory(files[i].getAbsolutePath());  
                if (!flag) break;  
            }  
        }  
        if (!flag) return false;  
        //ɾ����ǰĿ¼  
        if (dirFile.delete()) {  
            return true;  
        } else {  
            return false;  
        }  
    } 

    /** 
     * ɾ�������ļ� 
     * @param   sPath    ��ɾ���ļ����ļ��� 
     * @return �����ļ�ɾ���ɹ�����true�����򷵻�false 
     */  
    public boolean deleteFile(String sPath) {  
        boolean flag = false;  
        File file = new File(sPath);  
        // ·��Ϊ�ļ��Ҳ�Ϊ�������ɾ��  
        if (file.isFile() && file.exists()) {  
            file.delete();  
            flag = true;  
        }  
        return flag;  
    } 
    

	 
//    int countFolders = 0;// ����ͳ���ļ��еı���

	/**
	 * ���ݹؼ��֣�ƥ���ļ�
	 */
   public  File[] searchFile(File folder, final String keyWord) {// �ݹ���Ұ����ؼ��ֵ��ļ�
	   
	   cLogger.info("��ʼ�����������ļ�����������Ϊ��" + keyWord);
       File[] subFolders = folder.listFiles(new FileFilter() {// �����ڲ����������ļ�
                   public boolean accept(File pathname) {// ʵ��FileFilter���accept����
                	   int countFiles = 0;// ����ͳ���ļ������ı���
                       if (pathname.isFile())// ������ļ�
                           countFiles++;
//                       else
//                           // �����Ŀ¼
//                           countFolders++;
                       if ((pathname.isFile() && pathname.getName()
                                       .toLowerCase()
                                       .contains(keyWord.toLowerCase())))// Ŀ¼���ļ������ؼ���
                           return true;
                       return false;
                   }
               });
       cLogger.info("�����������ļ�������");
       return subFolders;
   }
   


	
}
