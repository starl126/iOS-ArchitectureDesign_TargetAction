//
//  AESEncrypTools.h
//  TargetActionDemo
//
//  Created by 天边的星星 on 2018/10/20.
//  Copyright © 2018年 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptTools : NSObject

+ (instancetype)sharedEncryptionTools;

#pragma mark --- AES 加密解密
+ (NSString*)encryptAES128String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptAES128String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

+ (NSString*)encryptAES192String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptAES192String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

+ (NSString*)encryptAES256String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptAES256String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

#pragma mark --- DES 加密解密
+ (NSString*)encryptDESString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptDESString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

+ (NSString*)encrypt3DESString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decrypt3DESString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

#pragma mark --- CAST 加密解密
+ (NSString*)encryptMinCASTString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptMinCASTString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)encryptMaxCASTString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptMaxCASTString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

#pragma mark --- RC 加密解密
+ (NSString*)encryptMinRC4String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptMinRC4String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

+ (NSString*)encryptMaxRC4String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptMaxRC4String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

+ (NSString*)encryptMinRC2String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptMinRC2String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

+ (NSString*)encryptMaxRC2String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptMaxRC2String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

#pragma mark --- Blowfish 加密解密
+ (NSString*)encryptMinBlowfishString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptMinBlowfishString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

+ (NSString*)encryptMaxBlowfishString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString;
+ (NSString*)decryptMaxBlowfishString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString;

#pragma mark --- md5

/**
 计算MD5散列结果
 终端测试命令：
 @code
 md5 -s "string"
 @endcode

 <p>提示：随着 MD5 碰撞生成器的出现，MD5 算法不应被用于任何软件完整性检查或代码签名的用途。<p>
 @param source 明文
 @return 32个字符的MD5散列字符串
 */
+ (NSString*)md5String:(NSString*)source;

#pragma mark --- sha散列函数

/**
 *  计算SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha1
 *  @endcode
 *
 *  @return 40个字符的SHA1散列字符串
 */
+ (NSString*)sha1String:(NSString*)source;

/**
 *  计算SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha256
 *  @endcode
 *
 *  @return 64个字符的SHA256散列字符串
 */
+ (NSString*)sha256String:(NSString*)source;

/**
 *  计算SHA 512散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha512
 *  @endcode
 *
 *  @return 128个字符的SHA 512散列字符串
 */
+ (NSString*)sha512String:(NSString*)source;

/**
 *  计算SHA 224散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha224
 *  @endcode
 *
 *  @return 56个字符的SHA 224散列字符串
 */
+ (NSString*)sha224String:(NSString*)source;

/**
 *  计算SHA 384散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha384
 *  @endcode
 *
 *  @return 96个字符的SHA 384散列字符串
 */
+ (NSString*)sha384String:(NSString*)source;

#pragma mark --- HMAC散列函数

/**
 *  计算HMAC MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl dgst -md5 -hmac "key"
 *  @endcode
 *
 *  @return 32个字符的HMAC MD5散列字符串
 */
+ (NSString*)hmacMD5String:(NSString*)source key:(NSString*)key;

/**
 *  计算HMAC SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha1 -hmac "key"
 *  @endcode
 *
 *  @return 40个字符的HMAC SHA1散列字符串
 */
+ (NSString*)hmacSHA1String:(NSString*)source key:(NSString*)key;

/**
 *  计算HMAC SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha256 -hmac "key"
 *  @endcode
 *
 *  @return 64个字符的HMAC SHA256散列字符串
 */
+ (NSString*)hmacSHA256String:(NSString*)source key:(NSString*)key;

/**
 *  计算HMAC SHA512散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha512 -hmac "key"
 *  @endcode
 *
 *  @return 128个字符的HMAC SHA512散列字符串
 */
+ (NSString*)hmacSHA512String:(NSString*)source key:(NSString*)key;

/**
 *  计算HMAC SHA384散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha384 -hmac "key"
 *  @endcode
 *
 *  @return 96个字符的HMAC SHA384散列字符串
 */
+ (NSString*)hmacSHA384String:(NSString*)source key:(NSString*)key;

/**
 *  计算HMAC SHA224散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha224 -hmac "key"
 *  @endcode
 *
 *  @return 56个字符的HMAC SHA224散列字符串
 */
+ (NSString*)hmacSHA224String:(NSString*)source key:(NSString*)key;

#pragma mark --- 文件散列函数

/**
 *  计算文件的MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  md5 file.dat
 *  @endcode
 *
 *  @return 32个字符的MD5散列字符串
 */
+ (NSString*)fileMD5HashPath:(NSString*)path;

/**
 *  计算文件的SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha1 file.dat
 *  @endcode
 *
 *  @return 40个字符的SHA1散列字符串
 */
+ (NSString*)fileSHA1HashPath:(NSString*)path;

/**
 *  计算文件的SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha256 file.dat
 *  @endcode
 *
 *  @return 64个字符的SHA256散列字符串
 */
+ (NSString*)fileSHA256HashPath:(NSString*)path;

/**
 *  计算文件的SHA512散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha512 file.dat
 *  @endcode
 *
 *  @return 128个字符的SHA512散列字符串
 */
+ (NSString*)fileSHA512HashPath:(NSString*)path;

/**
 *  计算文件的SHA384散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha384 file.dat
 *  @endcode
 *
 *  @return 96个字符的SHA384散列字符串
 */
+ (NSString*)fileSHA384HashPath:(NSString*)path;

/**
 *  计算文件的SHA224散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha224 file.dat
 *  @endcode
 *
 *  @return 56个字符的SHA224散列字符串
 */
+ (NSString*)fileSHA224HashPath:(NSString*)path;

#pragma mark --- RSA非对称加密

/**
 @abstract 生成公钥私钥对

 @param keysize 秘钥长度，以bit为单位，只能从512、768、1024和2048中选择
 */
- (void)generateSecKeyPair:(NSUInteger)keysize;

/**
 rsa加密文本：公钥加密私钥解密

 @param secPadding 分组填充方式，分3种
        kSecPaddingNone：无任何填充,要加密的数据块大小 <= SecKeyGetBlockSize
        kSecPaddingPKCS1：随机变化,要加密的数据块大小 <= SecKeyGetBlockSize - 11
        kSecPaddingOAEP：要加密的数据块大小 <= SecKeyGetBlockSize - 42
 @param plaintext 明文
 @return 密文的二进制数据
 */
- (NSData*)rsaEncryptWithSecPadding:(SecPadding)secPadding plainText:(NSString*)plaintext;

/**
 rsa解密

 @param cipherData 密文二进制
 @return 解密后的明文
 */
- (NSString*)rsaDecryptWithCipherData:(NSData*)cipherData;

#pragma mark --- RSA签名和验证

/**
 rsa 签名 明文使用摘要算法后再使用秘钥签名，默认采用kSecPaddingPKCS1SHA256的填充方式

 @param text 明文
 @param secPadding 填充方式
 @return 签名后的二进制
 */
- (NSData*)rsaSignText:(NSString*)text secPadding:(SecPadding)secPadding;
- (BOOL)rsaVerifySuccessForSignedData:(NSData*)signedData plaintext:(NSString*)plaintext;

@end

