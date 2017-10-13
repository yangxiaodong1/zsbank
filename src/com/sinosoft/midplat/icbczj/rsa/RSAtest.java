package com.sinosoft.midplat.icbczj.rsa;

import java.util.Map;

import com.sinosoft.midplat.icbczj.net.IcbcZJKeyCache;
      
    public class RSAtest {  
      
        static byte[] publicKey;  
        static byte[] privateKey;  
      
        static {  
            try {  
                Map<String, Object> keyMap = RSACoder.genKeyPair();  
//                publicKey = Base64Utils.decode(RSACoder.getPublicKey(keyMap));  
//                privateKey = Base64Utils.decode(RSACoder.getPrivateKey(keyMap));  
                publicKey= IcbcZJKeyCache.newInstance().getPubKey();
                privateKey=IcbcZJKeyCache.newInstance().getPriKey();  
                System.err.println("��Կ: \n\r" + Base64Utils.encode(publicKey));  
                System.err.println("˽Կ�� \n\r" + Base64Utils.encode(privateKey));  
            } catch (Exception e) {  
                e.printStackTrace();  
            }  
        }  
          
        public static void main(String[] args) throws Exception {  
            //test();  
            testSign();  
        }  
        
      
        static void testSign() throws Exception {  
//            System.err.println("˽Կ���ܡ�����Կ����");  
            String source = "����һ�в���RSA����ǩ��������������";  
//            System.out.println("ԭ���֣�\r\n" + source);  
            byte[] data = source.getBytes();  
            byte[] encodedData = RSACoder.encryptByPrivateKey(data, privateKey);  
//            System.out.println("���ܺ�\r\n" + new String(encodedData));  
//            byte[] decodedData = RSACoder.decryptByPublicKey(encodedData, publicKey);  
//            String target = new String(decodedData);  
//            System.out.println("���ܺ�: \r\n" + target);  
            System.err.println("˽Կǩ��������Կ��֤ǩ��");  
            String sign = RSACoder.sign(encodedData, privateKey);  
            System.err.println("ǩ��:\r" + sign);  
            boolean status = RSACoder.verify(encodedData, publicKey, sign);  
            System.err.println("��֤���:\r" + status);  
        }  
          
    } 