//
//  AES128.h
//  SmartLock
//
//  Created by csis on 16/5/12.
//  Copyright © 2016年 csis. All rights reserved.
//

#ifndef AES128_h
#define AES128_h

#define RoundKeyLEN  300


void AES_Encrypt(char* pExpressText , char* pCipherText , char* pAeskey);
void AES_Decrypt(char* pExpressText , char* pCipherText , char* pAeskey);


#endif /* AES128_h */


/*加密解密算法调用格式
 
char expressText[1024];  //存放待加密的明文数据，具体缓存大小根据用户待加密数据长度自己任意修改
char cipherText[1024];//存放已加密的密文数据，具体缓存大小根据用户解密后的数据长度自己任意修改
char aesKey[16];//加解密的密钥，注意：此算法只适用于AES16位密钥加解密，不适用于32位密钥加解密

memcpy(aesKey , "1uweiIDAS7awOas8" , 16);  //AES加密密钥，16字节（128bit）

memset(expressText ,0 ,1024);
memset(cipherText , 0 ,1024);
strcpy(expressText , "Hello!!!Are you ready???");
AES_Encrypt(expressText  , cipherText , aesKey);	//use aesKey encrypt

memset(expressText ,0 ,1024);
AES_Decrypt(expressText , cipherText , aesKey);//use aesKey decrypt
 
 
*/




