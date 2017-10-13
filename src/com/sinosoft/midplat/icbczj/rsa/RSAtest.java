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
                System.err.println("公钥: \n\r" + Base64Utils.encode(publicKey));  
                System.err.println("私钥： \n\r" + Base64Utils.encode(privateKey));  
            } catch (Exception e) {  
                e.printStackTrace();  
            }  
        }  
          
        public static void main(String[] args) throws Exception {  
            //test();  
            testSign();  
        }  
        
      
        static void testSign() throws Exception {  
//            System.err.println("私钥加密——公钥解密");  
            String source = "这是一行测试RSA数字签名的无意义文字";  
//            System.out.println("原文字：\r\n" + source);  
            byte[] data = source.getBytes();  
            byte[] encodedData = RSACoder.encryptByPrivateKey(data, privateKey);  
//            System.out.println("加密后：\r\n" + new String(encodedData));  
//            byte[] decodedData = RSACoder.decryptByPublicKey(encodedData, publicKey);  
//            String target = new String(decodedData);  
//            System.out.println("解密后: \r\n" + target);  
            System.err.println("私钥签名——公钥验证签名");  
            String sign = RSACoder.sign(encodedData, privateKey);  
            System.err.println("签名:\r" + sign);  
            boolean status = RSACoder.verify(encodedData, publicKey, sign);  
            System.err.println("验证结果:\r" + status);  
        }  
          
    } 