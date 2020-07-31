//
//  AESEncrypTools.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2018/10/20.
//  Copyright © 2018年 starxin. All rights reserved.
//

#import "EncryptTools.h"
#import <CommonCrypto/CommonCrypto.h>

@interface EncryptTools(){
    @private
    SecKeyRef _secPublicKeyRef;     // 公钥引用
    SecKeyRef _secPrivateKeyRef;    // 私钥引用
    NSMutableDictionary* randomStringM;  // 随机字符串
}

@property (nonatomic, readonly, copy) NSString* secPublicKeyTag;
@property (nonatomic, readonly, copy) NSString* secPrivateKeyTag;

@property (nonatomic, readonly, assign) SecPadding secPadding;
@property (nonatomic, readonly, assign) u_long rsaSections;

@property (nonatomic, readonly, assign) SecPadding signSecPadding; // 用于签名的填充方式

@end

@implementation EncryptTools

+ (instancetype)sharedEncryptionTools {
    static EncryptTools* instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}
- (instancetype)init {
    if (self = [super init]) {
        _secPublicKeyTag = [EncryptTools randomSecKeyTag];
        _secPrivateKeyTag = [EncryptTools randomSecKeyTag];
        randomStringM = [NSMutableDictionary dictionary];
    }
    return self;
}
+ (NSString*)encryptString:(NSString*)encryptStr keySize:(size_t)keySize keyString:(NSString*)keyString iv:(NSString*)ivString {
    
    // 加盐 keyString
    NSInteger keyStringLength = keyString.length;
    
    // 取出开始和结束字符
    unichar startChar = [keyString characterAtIndex:0];
    unichar endChar = [keyString characterAtIndex:keyStringLength-1];
    unichar middleChar = (abs(endChar - startChar))/2;
    
    
//    NSLog(@"%c",middleChar);
    char transformChars[keyStringLength];
    for (NSInteger i=0; i<keyStringLength; i++) {
        unichar character = [keyString characterAtIndex:i];
//        NSLog(@"character = %d",character);
        unichar ch1 = character + 2*i - middleChar;
        if (ch1 > 255) {
            ch1 -= 255 + middleChar;
        }
        transformChars[i] = ch1;
    }
    NSString *encodedKeyString = [[NSString alloc] initWithCString:transformChars encoding:NSUTF8StringEncoding];
    
    // 解析加密算法
    uint32_t algorithm;
    size_t blockSize;
    if (keySize == kCCKeySizeAES128 ||
        keySize == kCCKeySizeAES192 ||
        keySize == kCCKeySizeAES256) {
        algorithm = kCCAlgorithmAES;
        blockSize = kCCBlockSizeAES128;
    } else if (keySize == kCCKeySizeDES) {
        algorithm = kCCAlgorithmDES;
        blockSize = kCCBlockSizeDES;
    }else if (keySize == kCCKeySize3DES) {
        algorithm = kCCAlgorithm3DES;
        blockSize = kCCBlockSize3DES;
    }else if (keySize == kCCKeySizeMinRC2 ||
               keySize == kCCKeySizeMaxRC2) {
        algorithm = kCCAlgorithmRC2;
        blockSize = kCCBlockSizeRC2;
    } else if (keySize == kCCKeySizeMinRC4 ||
               keySize == kCCKeySizeMaxRC4) {
        algorithm = kCCAlgorithmRC4;
        blockSize = kCCBlockSizeRC2;
    } else if (keySize == kCCKeySizeMinCAST ||
               keySize == kCCKeySizeMaxCAST) {
        algorithm = kCCAlgorithmCAST;
        blockSize = kCCBlockSizeCAST;
    } else {
        algorithm = kCCAlgorithmBlowfish;
        blockSize = kCCBlockSizeBlowfish;
    }
    // 设置密钥
    NSData* keyData = [encodedKeyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[keySize];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:keySize];
    
    // 设置iv
    uint8_t cIv[blockSize];
    bzero(cIv, sizeof(cIv));
    int option = 0;
    
    /**
     kCCOptionPKCS7Padding                      CBC 的加密
     kCCOptionPKCS7Padding | kCCOptionECBMode   ECB 的加密
     */
    if (ivString) {
        NSData* iv = [ivString dataUsingEncoding:NSUTF8StringEncoding];
        [iv getBytes:cIv length:blockSize];
        option = kCCOptionPKCS7Padding;
    } else {
        option = kCCOptionECBMode | kCCOptionPKCS7Padding;
    }
    
    // 设置输出缓冲区
    NSData* data = [encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    size_t bufferSize = data.length + blockSize;
    void* buffer = malloc(bufferSize);
    
    // 开始加密
    size_t encryptedSize = 0;
    /**
     CCCrypt 对称加密算法的核心函数(加密/解密)
     
     参数
     1. kCCEncrypt 加密/ kCCDecrypt 解密
     2. 加密算法，默认使用的是 AES/DES
     3. 加密选项 ECB/CBC
     kCCOptionPKCS7Padding                      CBC 的加密
     kCCOptionPKCS7Padding | kCCOptionECBMode   ECB 的加密
     4. 加密密钥
     5. 密钥长度
     6. iv 初始向量，ECB 不需要指定
     7. 加密的数据
     8. 加密的数据长度
     9. 密文的内存地址
     10. 密文缓冲区大小
     11. 加密结果大小
     */
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          algorithm,
                                          option,
                                          cKey,
                                          keySize,
                                          cIv,
                                          data.bytes,
                                          data.length,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    NSData* result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytes:buffer length:encryptedSize];
    } else {
        free(buffer);
        NSLog(@"错误：加密失败|状态编码：%d", cryptStatus);
    }
    return [result base64EncodedStringWithOptions:0];
}
+ (NSString*)decryptString:(NSString*)string keySize:(size_t)keySize keyString:(NSString*)keyString iv:(NSString*)ivString {
    
    // 加盐 keyString
    NSInteger keyStringLength = keyString.length;
    
    // 取出开始和结束字符
    unichar startChar = [keyString characterAtIndex:0];
    unichar endChar = [keyString characterAtIndex:keyStringLength-1];
    unichar middleChar = (abs(endChar - startChar))/2;
    
    
//    NSLog(@"%c",middleChar);
    char transformChars[keyStringLength];
    for (NSInteger i=0; i<keyStringLength; i++) {
        unichar character = [keyString characterAtIndex:i];
//        NSLog(@"character = %d",character);
        unichar ch1 = character + 2*i - middleChar;
        if (ch1 > 255) {
            ch1 -= 255 + middleChar;
        }
        transformChars[i] = ch1;
    }
    NSString *encodedKeyString = [[NSString alloc] initWithCString:transformChars encoding:NSUTF8StringEncoding];
    
    // 解析加密算法
    uint32_t algorithm;
    size_t blockSize;
    if (keySize == kCCKeySizeAES128 ||
        keySize == kCCKeySizeAES192 ||
        keySize == kCCKeySizeAES256) {
        algorithm = kCCAlgorithmAES;
        blockSize = kCCBlockSizeAES128;
    } else if (keySize == kCCKeySizeDES) {
        algorithm = kCCAlgorithmDES;
        blockSize = kCCBlockSizeDES;
    }else if (keySize == kCCKeySize3DES) {
        algorithm = kCCAlgorithm3DES;
        blockSize = kCCBlockSize3DES;
    }else if (keySize == kCCKeySizeMinRC2 ||
              keySize == kCCKeySizeMaxRC2) {
        algorithm = kCCAlgorithmRC2;
        blockSize = kCCBlockSizeRC2;
    } else if (keySize == kCCKeySizeMinRC4 ||
               keySize == kCCKeySizeMaxRC4) {
        algorithm = kCCAlgorithmRC4;
        blockSize = kCCBlockSizeRC2;
    } else if (keySize == kCCKeySizeMinCAST ||
               keySize == kCCKeySizeMaxCAST) {
        algorithm = kCCAlgorithmCAST;
        blockSize = kCCBlockSizeCAST;
    } else {
        algorithm = kCCAlgorithmBlowfish;
        blockSize = kCCBlockSizeBlowfish;
    }
    // 设置秘钥
    NSData* keyData = [encodedKeyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[keySize];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:keySize];
    
    // 设置iv
    uint8_t cIv[blockSize];
    bzero(cIv, blockSize);
    NSData* iv = [ivString dataUsingEncoding:NSUTF8StringEncoding];
    [iv getBytes:cIv length:blockSize];
    
    /**
     kCCOptionPKCS7Padding                      CBC 的加密
     kCCOptionPKCS7Padding | kCCOptionECBMode   ECB 的加密
     */
    int option = 0;
    if (ivString) {
        option = kCCOptionPKCS7Padding;
    } else {
        option = kCCOptionECBMode | kCCOptionPKCS7Padding;
    }
    
    // 设置输出缓冲区
    NSData* data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    size_t bufferSize = data.length + blockSize;
    void* buffer = malloc(bufferSize);
    
    // 开始解密
    size_t decryptSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          algorithm,
                                          option,
                                          cKey,
                                          keySize,
                                          cIv,
                                          data.bytes,
                                          data.length,
                                          buffer,
                                          bufferSize,
                                          &decryptSize);
    NSData* result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptSize];
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    NSLog(@"错误：加密失败|状态编码：%d", cryptStatus);
    return nil;
}

#pragma mark --- AES 加密解密
+ (NSString*)encryptAES128String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeAES128 keyString:keyString iv:ivString];
}
+ (NSString*)decryptAES128String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeAES128 keyString:keyString iv:ivString];
}
+ (NSString*)encryptAES192String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeAES192 keyString:keyString iv:ivString];
}
+ (NSString*)decryptAES192String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeAES192 keyString:keyString iv:ivString];
}
+ (NSString*)encryptAES256String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeAES256 keyString:keyString iv:ivString];
}
+ (NSString*)decryptAES256String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeAES256 keyString:keyString iv:ivString];
}

#pragma mark --- DES 加密解密
+ (NSString*)encryptDESString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeDES keyString:keyString iv:ivString];
}
+ (NSString *)decryptDESString:(NSString *)string keyString:(NSString *)keyString iv:(NSString *)ivString {
    return [self decryptString:string keySize:kCCKeySizeDES keyString:keyString iv:ivString];
}
+ (NSString *)encrypt3DESString:(NSString *)encryptStr keyString:(NSString *)keyString iv:(NSString *)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySize3DES keyString:keyString iv:ivString];
}
+ (NSString*)decrypt3DESString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySize3DES keyString:keyString iv:ivString];
}

#pragma mark --- CAST 加密解密
+ (NSString*)encryptMinCASTString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeMinCAST keyString:keyString iv:ivString];
}
+ (NSString*)decryptMinCASTString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeMinCAST keyString:keyString iv:ivString];
}
+ (NSString*)encryptMaxCASTString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeMaxCAST keyString:keyString iv:ivString];
}
+ (NSString*)decryptMaxCASTString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeMaxCAST keyString:keyString iv:ivString];
}

#pragma mark --- RC 加密解密
+ (NSString*)encryptMinRC4String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeMinRC4 keyString:keyString iv:ivString];
}
+ (NSString*)decryptMinRC4String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeMinRC4 keyString:keyString iv:ivString];
}

+ (NSString*)encryptMaxRC4String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeMaxRC4 keyString:keyString iv:ivString];
}
+ (NSString*)decryptMaxRC4String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeMaxRC4 keyString:keyString iv:ivString];
}

+ (NSString*)encryptMinRC2String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeMinRC2 keyString:keyString iv:ivString];
}
+ (NSString*)decryptMinRC2String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeMinRC2 keyString:keyString iv:ivString];
}

+ (NSString*)encryptMaxRC2String:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeMaxRC2 keyString:keyString iv:ivString];
}
+ (NSString*)decryptMaxRC2String:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeMaxRC2 keyString:keyString iv:ivString];
}

#pragma mark --- Blowfish 加密解密
+ (NSString*)encryptMinBlowfishString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeMinBlowfish keyString:keyString iv:ivString];
}
+ (NSString*)decryptMinBlowfishString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeMinBlowfish keyString:keyString iv:ivString];
}

+ (NSString*)encryptMaxBlowfishString:(NSString*)encryptStr keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self encryptString:encryptStr keySize:kCCKeySizeMaxBlowfish keyString:keyString iv:ivString];
}
+ (NSString*)decryptMaxBlowfishString:(NSString*)string keyString:(NSString*)keyString iv:(NSString*)ivString {
    return [self decryptString:string keySize:kCCKeySizeMaxBlowfish keyString:keyString iv:ivString];
}

#pragma mark --- md5
+ (NSString*)md5String:(NSString*)source {
    const char* str = source.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}
+ (NSString*)stringFromBytes:(uint8_t*)bytes length:(int)length {
    NSMutableString* strM = [NSMutableString string];
    for (int i=0; i<length; i++) {
        [strM appendFormat:@"%02x",bytes[i]];
    }
    return strM.copy;
}

#pragma mark --- sha散列函数
+ (NSString*)sha1String:(NSString*)source {
    const char* str = source.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}
+ (NSString*)sha256String:(NSString*)source {
    const char* str = source.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}
+ (NSString*)sha512String:(NSString*)source {
    const char* str = source.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(str, (CC_LONG)strlen(str), buffer);

    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}
+ (NSString*)sha224String:(NSString*)source {
    const char* str = source.UTF8String;
    uint8_t buffer[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA224_DIGEST_LENGTH];
}
+ (NSString*)sha384String:(NSString*)source {
    const char* str = source.UTF8String;
    uint8_t buffer[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA384_DIGEST_LENGTH];
}

#pragma mark --- HMAC散列函数
+ (NSString*)hmacMD5String:(NSString*)source key:(NSString*)key {
    
    const char* keyStr = key.UTF8String;
    const char* str = source.UTF8String;
    
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgMD5, keyStr, strlen(keyStr), str, strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}
+ (NSString*)hmacSHA1String:(NSString*)source key:(NSString*)key {
    
    const char* keyStr = key.UTF8String;
    const char* str = source.UTF8String;
    
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, keyStr, strlen(keyStr), str, strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}
+ (NSString*)hmacSHA256String:(NSString*)source key:(NSString*)key {
    
    const char *keyStr = key.UTF8String;
    const char *str = source.UTF8String;
    
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, keyStr, strlen(keyStr), str, strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}
+ (NSString*)hmacSHA512String:(NSString*)source key:(NSString*)key {
    
    const char *keyStr = key.UTF8String;
    const char *str = source.UTF8String;
    
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, keyStr, strlen(keyStr), str, strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}
+ (NSString*)hmacSHA384String:(NSString*)source key:(NSString*)key {
    
    const char *keyStr = key.UTF8String;
    const char *str = source.UTF8String;
    
    uint8_t buffer[CC_SHA384_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA384, keyStr, strlen(keyStr), str, strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_SHA384_DIGEST_LENGTH];
}
+ (NSString*)hmacSHA224String:(NSString*)source key:(NSString*)key {
    
    const char *keyStr = key.UTF8String;
    const char *str = source.UTF8String;
    
    uint8_t buffer[CC_SHA224_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA224, keyStr, strlen(keyStr), str, strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_SHA224_DIGEST_LENGTH];
}

#pragma mark --- 文件散列函数
static const NSInteger fileHashDefaultChunkSizeForReadingData = 4096;
+ (NSString*)fileMD5HashPath:(NSString*)path {
    
    NSFileHandle* fp = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!fp) {
        return nil;
    }
    
    CC_MD5_CTX ctx;
    CC_MD5_Init(&ctx);
    
    while (YES) {
        @autoreleasepool {
            NSData* data = [fp readDataOfLength:fileHashDefaultChunkSizeForReadingData];
            if (data.length == 0) {
                break;
            }
            
            CC_MD5_Update(&ctx, data.bytes, (CC_LONG)data.length);
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &ctx);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}
+ (NSString*)fileSHA1HashPath:(NSString*)path {
    
    NSFileHandle* fp = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!fp) {
        return nil;
    }
    
    CC_SHA1_CTX ctx;
    CC_SHA1_Init(&ctx);
    
    while (YES) {
        @autoreleasepool {
            NSData* data = [fp readDataOfLength:fileHashDefaultChunkSizeForReadingData];
            if (data.length == 0) {
                break;
            }
            
            CC_SHA1_Update(&ctx, data.bytes, (CC_LONG)data.length);
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(buffer, &ctx);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}
+ (NSString*)fileSHA256HashPath:(NSString*)path {
    
    NSFileHandle* fp = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!fp) {
        return nil;
    }
    
    CC_SHA256_CTX ctx;
    CC_SHA256_Init(&ctx);
    
    while (YES) {
        @autoreleasepool {
            NSData* data = [fp readDataOfLength:fileHashDefaultChunkSizeForReadingData];
            if (data.length == 0) {
                break;
            }
            
            CC_SHA256_Update(&ctx, data.bytes, (CC_LONG)data.length);
        }
    }
    [fp closeFile];
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &ctx);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}
+ (NSString*)fileSHA512HashPath:(NSString*)path {
    
    NSFileHandle* fp = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!fp) {
        return nil;
    }
    
    CC_SHA512_CTX ctx;
    CC_SHA512_Init(&ctx);
    
    while (YES) {
        @autoreleasepool {
            NSData* data = [fp readDataOfLength:fileHashDefaultChunkSizeForReadingData];
            if (data.length == 0) {
                break;
            }
            
            CC_SHA512_Update(&ctx, data.bytes, (CC_LONG)data.length);
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(buffer, &ctx);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}
+ (NSString*)fileSHA384HashPath:(NSString*)path {
    
    NSFileHandle* fp = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!fp) {
        return nil;
    }
    
    CC_SHA512_CTX ctx;
    CC_SHA384_Init(&ctx);
    
    while (YES) {
        @autoreleasepool {
            NSData* data = [fp readDataOfLength:fileHashDefaultChunkSizeForReadingData];
            if (data.length == 0) {
                break;
            }
            
            CC_SHA384_Update(&ctx, data.bytes, (CC_LONG)data.length);
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384_Final(buffer, &ctx);
    
    return [self stringFromBytes:buffer length:CC_SHA384_DIGEST_LENGTH];
}
+ (NSString*)fileSHA224HashPath:(NSString*)path {
    
    NSFileHandle* fp = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!fp) {
        return nil;
    }
    
    CC_SHA256_CTX ctx;
    CC_SHA256_Init(&ctx);
    
    while (YES) {
        @autoreleasepool {
            NSData* data = [fp readDataOfLength:fileHashDefaultChunkSizeForReadingData];
            if (data.length == 0) {
                break;
            }
            
            CC_SHA224_Update(&ctx, data.bytes, (CC_LONG)data.length);
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224_Final(buffer, &ctx);
    
    return [self stringFromBytes:buffer length:CC_SHA224_DIGEST_LENGTH];
}

#pragma mark --- RSA加密解密以及签名
/*
 注意：
 RSA 加密或签名后的结果是不可读的二进制，使用时经常会转为 BASE64 码再传输。
 RSA 加密时，对要加密数据的大小有限制，最大不大于密钥长度。例如在使用 1024 bit 的密钥时（genrsa -out rsa_private_key.pem 1024），最大可以加密 1024/8=128 Bytes 的数据。数据大于 128 Bytes 时，需要对数据进行分组加密（如果数据超限，加解密时会失败，openssl 函数会返回 false），分组加密后的加密串拼接成一个字符串后发送给客户端。如果 Padding 填充方式使用默认的 OPENSSL_PKCS1_PADDING（需要占用 11 个字节用于填充），那么明文长度最多只能就是 128-11=117 Bytes。
 RSA 加密解密需要指定填充方式 Padding，在对超限数据进行分组时会按照这个 Padding 进行填充，一般默认使用 OPENSSL_PKCS1_PADDING。PHP 支持的 Padding 有 OPENSSL_PKCS1_PADDING、OPENSSL_SSLV23_PADDING、OPENSSL_PKCS1_OAEP_PADDING 和 OPENSSL_NO_PADDING。
 接收方解密时也需要分组。将加密后的原始二进制数据（对于经过 BASE64 的数据，需要解码），每 128 Bytes 分为一组，然后再进行解密。解密后的原文字符串拼接起来，就得到原始报文。
 
 原理：
 RSA 算法的可靠性基础：对极大整数做因数分解是很困难的。
 RSA 是非对称算法，加解密使用不同的密钥。
 两个密钥都可以用于加密，解密时需要使用另一个密钥。但是，通常用公钥加密私钥解密，因为公钥是近乎完全公开的，对于私钥加密的数据，有太多的人可以解密了。理论上 A 和 B 之间要通过 RSA 实现保密通信，需要 A 和 B 各自生成一组密钥，同时保管好自己的私钥；用对方的公钥加密要发送的消息，用自己的私钥解密对方发送过来的消息。
 在签名的场景下，用私钥签名，公钥验签。
 
 RSA 比 DES 等对称算法慢得多。一般在实际数据传输时，用 RSA 来加密比较短的对称密码，双方交换密码后再使用 DES 等对称算法传输数据。
 
 签名消息：
 RSA 也可以用来为一个消息签名。
 
 对消息字符串的散列值（Message digest，用 MD5、SHA256 等算法求得的长度较短且固定的字符串）使用 RSA 的私钥计算签名（实际上仍然是加密消息）后，得到一个签名字符串，将其附加在消息字符串的合适位置后，一并发送。接收方使用对应的公钥可以从签名字符串中解密出原来的散列值，同时对原始消息再计算一次散列值。二者相比较，假如两者相符的话，则认为发信人持有正确的私钥，并且这个消息在传播路径上没有被篡改过。

 密钥长度：
 用户应使用 1024 位密钥，证书认证机构应用 2048 位或以上。其他还有512、768位密钥
 
 特点：
 RSA 之所以叫非对称算法，是因为加密和解密的密钥不一样。任何一个密钥都可以用来加密。
 
 公钥和私钥
 通过私钥可以轻松计算出公钥，反之不行。
 
 加密和解密
 用公钥加密时，私钥可以解密。反之亦然，私钥加密后的信息用公钥可以解密。
 
 Linux 下通过 OpenSSL 生成 RSA 公钥和私钥
 需要提前在 Linux 上安装 OpenSSL，默认生成在当前用户家目录下：
 $ openssl
 OpenSSL> genrsa -out app_private_key.pem 1024    //生成1024位的私钥
 
 OpenSSL> rsa -in app_private_key.pem -pubout -out app_public_key.pem   //生成公钥
 //对于 PHP 可以直接使用上面生成的原始私钥。但是 Java 需要将私钥转换成 PKCS8 格式，SecKeyGeneratePair
 //然后将生成的 PKCS8 格式的私钥去除头尾、换行和空格，作为私钥字符串填入代码中：
 OpenSSL> pkcs8 -topk8 -inform PEM -in app_private_key.pem -outform PEM -nocrypt -out app_private_key_pkcs8.pem //私钥转成PKCS8格式
 
 Security框架提供的RSA在iOS上使用的一些小结
 支持的RSA 填充方式有三种：NOPadding,PKCS1,OAEP 三种方式 ，填充方式影响最大分组加密数据块的大小
 签名使用的填充方式PKCS1, 支持的签名算法有 sha1,sha256,sha224,sha384,sha512
 Nopadding填充最大数据块为 下面接口 SecKeyGetBlockSize 大小;
 PKCS1 填充方式最大数据为 SecKeyGetBlockSize大小 减去11
 OAEP 填充方式最大数据为 SecKeyGetBlockSize 大小减去 42
 RSA加密解密签名，适合小块的数据处理，大量数量需要处理分组逻辑；密码学中推荐使用对称加密进行数据加密，使用RSA来加密对称密钥
 
 ===================================================================================================
 数字签名算法
 特点：
 非对称加密算法+消息摘要算法的结合体
 抗否认性、认证数据来源、防止数据被篡改（具体意思与做法查看下边的过程与类比部分）
 私钥加密（签名）、公钥解密（验证）
 过程：
 
 1）消息发送者产生一个密钥对（私钥+公钥），然后将公钥发送给消息接收者
 
 2）消息发送者使用消息摘要算法对原文进行加密（加密后的密文称作摘要）
 
 3）消息发送者将上述的摘要使用私钥加密得到密文--这个过程就被称作签名处理，得到的密文就被称作签名（注意，这个签名是名词）
 
 4）消息发送者将原文与密文发给消息接收者
 
 5）消息接收者使用公钥对密文（即签名）进行解密，得到摘要值content1
 
 6）消息接收者使用与消息发送者相同的消息摘要算法对原文进行加密，得到摘要值content2
 
 7）比较content1是不是与content2相等，若相等，则说明消息没有被篡改（消息完整性），也说明消息却是来源于上述的消息发送方（因为其他人是无法伪造签名的，这就完成了“抗否认性”和“认证消息来源”）
 */


/**
 @abstract 产生10到20位的随机字符串

 @return 随机字符串
 */
+ (NSString*)randomSecKeyTag {
    uint8_t count[11] = {10,11,12,13,14,15,16,17,18,19,20};
    uint8_t randomCount = arc4random_uniform(11);
    uint8_t range = 127;

    NSMutableString* strM = [NSMutableString string];
    for (int i=0; i<count[randomCount]; i++) {
        char ch = arc4random_uniform(range);
        [strM appendFormat:@"%c", ch];
    }
    return strM.copy;
}

- (void)generateSecKeyPair:(NSUInteger)keysize {
    _secPublicKeyRef = NULL;
    _secPrivateKeyRef = NULL;
    
    NSAssert(keysize == 512 || keysize == 768 || keysize == 1024 || keysize == 2048, @"秘钥大小无效：%tu",keysize);
    
    // 删除已有的公钥私钥对
    [self p_deleteSecKeyPair];
    
    NSMutableDictionary* secKeyAttrs = [NSMutableDictionary dictionary];
    NSMutableDictionary* secPrivateKeyAttrs = [NSMutableDictionary dictionary];
    NSMutableDictionary* secPublicKeyAttrs  = [NSMutableDictionary dictionary];
    
    [secKeyAttrs setValue:(__bridge NSString*)kSecAttrKeyTypeRSA forKey:(__bridge NSString*)kSecAttrKeyType];
    [secKeyAttrs setValue:@(keysize) forKey:(__bridge NSString*)kSecAttrKeySizeInBits];
    
    [secPrivateKeyAttrs setValue:@YES forKey:(__bridge NSString*)kSecAttrIsPermanent];
    [secPrivateKeyAttrs setValue:self.secPrivateKeyTag forKey:(__bridge NSString*)kSecAttrApplicationTag];
    
    [secPublicKeyAttrs setValue:@YES forKey:(__bridge NSString*)kSecAttrIsPermanent];
    [secPublicKeyAttrs setValue:self.secPublicKeyTag forKey:(__bridge NSString*)kSecAttrApplicationTag];
    
    [secKeyAttrs setValue:secPublicKeyAttrs forKey:(__bridge NSString*)kSecPublicKeyAttrs];
    [secKeyAttrs setValue:secPrivateKeyAttrs forKey:(__bridge NSString*)kSecPrivateKeyAttrs];
    
    OSStatus status = SecKeyGeneratePair((__bridge CFDictionaryRef)secKeyAttrs.copy, &_secPublicKeyRef, &_secPrivateKeyRef);

    if (status == noErr) {
        NSLog(@"生成秘钥对成功");
    }
}
- (NSString *)getPublicKeyStr {
    
    if (!_secPublicKeyRef) {
        return nil;
    }
    OSStatus sanityCheck = noErr;
    NSData * publicKeyBits = nil;
    
    NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:_secPublicKeyTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Temporarily add key to the Keychain, return as data:
    NSMutableDictionary * attributes = [queryPublicKey mutableCopy];
    [attributes setObject:(__bridge id)_secPublicKeyRef forKey:(__bridge id)kSecValueRef];
    [attributes setObject:@YES forKey:(__bridge id)kSecReturnData];
    CFTypeRef result;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) attributes, &result);
    if (sanityCheck == errSecSuccess) {
        publicKeyBits = CFBridgingRelease(result);
        
        // Remove from Keychain again:
        (void)SecItemDelete((__bridge CFDictionaryRef) queryPublicKey);
    }
    if (!publicKeyBits) {
        return nil;
    }
    NSString * str  =[[NSString alloc] initWithData:publicKeyBits encoding:NSUTF8StringEncoding];
    
    return str;
}
- (NSData*)rsaEncryptWithSecPadding:(SecPadding)secPadding plainText:(NSString*)plaintext {
    
    NSAssert(_secPublicKeyRef, @"公钥为nil");
    NSAssert(plaintext && plaintext.length, @"明文为空");
    
    _secPadding = secPadding;
    NSData* dataIn = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
    
    // 判断被加密的数据的最大字节数
    size_t blockSize = SecKeyGetBlockSize(_secPublicKeyRef);
    size_t dataInLength = dataIn.length;
    size_t sectionMaxSize = blockSize;  // 分组加密的最大数据字节数
    
    if (kSecPaddingPKCS1 == secPadding) {
        sectionMaxSize -= 11;
    } else if (kSecPaddingOAEP == secPadding) {
        sectionMaxSize -= 42;
    }
    
    // 判断有多少分组
    _rsaSections = dataInLength/sectionMaxSize + ((dataInLength%sectionMaxSize) ? 1 : 0);
    
    NSMutableData* dataM = [NSMutableData data];
    u_long dataInStart = 0;
    u_long dataInSectionLength = sectionMaxSize;
    
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
    for (u_long i=0; i<_rsaSections; i++) {
        uint8_t* sectionCipherData = malloc(blockSize*sizeof(uint8_t));
        memset(sectionCipherData, 0x0, blockSize);
        
        dataInStart = sectionMaxSize*i;
        if (i == _rsaSections - 1 && dataInLength%sectionMaxSize > 1) {
            dataInSectionLength = dataInLength%sectionMaxSize;
        }
        NSData* sectionDataIn = [dataIn subdataWithRange:NSMakeRange(dataInStart, dataInSectionLength)];
 
        size_t cipherTextLen = blockSize;
        
        OSStatus status = SecKeyEncrypt(_secPublicKeyRef,
                                        secPadding,
                                        sectionDataIn.bytes,
                                        sectionDataIn.length,
                                        sectionCipherData,
                                        &cipherTextLen);
        if (status == noErr) {
            NSData* data = [NSData dataWithBytes:sectionCipherData length:cipherTextLen];
            [dataM appendData:data];
        } else {
            NSLog(@"section加密失败：%tu", i);
        }
        free(sectionCipherData);
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    NSLog(@"加密花费时间：%lf，keysize = %tu位", end - start, blockSize*8);
    return dataM.copy;
}
- (NSString*)rsaDecryptWithCipherData:(NSData*)cipherData {
    
    NSAssert(cipherData && cipherData.length, @"密文为空");
    size_t blockSize = SecKeyGetBlockSize(_secPrivateKeyRef);
    size_t dataInLength = cipherData.length;
    size_t sectionMaxSize = blockSize;
    
    if (_rsaSections < 1) {// 需要计算rsa分组
        _rsaSections = dataInLength/sectionMaxSize + ((dataInLength%sectionMaxSize) ? 1 : 0);
    }
    
    // 分组解密
    u_long dataInStart = 0;
    
    // 设置初始化分组数据
    u_long dataInSectionLength = blockSize;
    NSMutableString* strM = [NSMutableString string];
    
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
    
    for (u_long i=0; i<_rsaSections; i++) {
        dataInStart = sectionMaxSize*i;
        
        // 计算正确的分组数据，最后一个分组需要计算，否则解密错误
        dataInSectionLength = MIN(blockSize, cipherData.length - i*blockSize);
        
        NSData* sectionData = [cipherData subdataWithRange:NSMakeRange(dataInStart, dataInSectionLength)];
        uint8_t* plainBytes = malloc(blockSize*sizeof(uint8_t));
        memset(plainBytes, 0x0, blockSize);
        size_t sectionPlainTextLen = blockSize;
        
        OSStatus status = SecKeyDecrypt(_secPrivateKeyRef,
                                        _secPadding,
                                        sectionData.bytes,
                                        dataInSectionLength,
                                        plainBytes,
                                        &sectionPlainTextLen);
        
        if (status == noErr) {
            NSString* sectionStr = [[NSString alloc] initWithBytes:plainBytes length:sectionPlainTextLen encoding:NSUTF8StringEncoding];
            [strM appendString:sectionStr];
        } else if (_rsaSections == i + 1) {
            NSLog(@"section解密失败：%tu", i);
        } else {
            
        }
        free(plainBytes);
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    NSLog(@"加密花费时间：%lf，keysize = %tu位", end - start, blockSize*8);
    return strM.copy;
}
- (void)p_deleteSecKeyPair {
    
    NSMutableDictionary* queryPublicKey = [NSMutableDictionary dictionary];
    NSMutableDictionary* queryPrivateKey = [NSMutableDictionary dictionary];
    
    // 设置公钥查询字典
    [queryPublicKey setObject:(__bridge NSString*)kSecClassKey forKey:(__bridge NSString*)kSecClass];
    [queryPublicKey setObject:_secPublicKeyTag forKey:(__bridge NSString*)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge NSString*)kSecAttrKeyTypeRSA forKey:(__bridge NSString*)kSecAttrKeyType];
    
    // 设置私钥查询字典
    [queryPrivateKey setObject:(__bridge NSString*)kSecClassKey forKey:(__bridge NSString*)kSecClass];
    [queryPrivateKey setObject:_secPrivateKeyTag forKey:(__bridge NSString*)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(__bridge NSString*)kSecAttrKeyTypeRSA forKey:(__bridge NSString*)kSecAttrKeyType];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)queryPublicKey);
    
    status = SecItemDelete((__bridge CFDictionaryRef)queryPrivateKey);
    
    if (_secPublicKeyRef) {
        CFRelease(_secPublicKeyRef);
    }
    if (_secPrivateKeyRef) {
        CFRelease(_secPrivateKeyRef);
    }
}

#pragma mark --- RSA签名和验证
- (NSData*)rsaSignText:(NSString*)text secPadding:(SecPadding)secPadding {
    
    _signSecPadding = secPadding;
    // 随机字符串
    NSString* randomStr = [EncryptTools md5String:[EncryptTools randomSecKeyTag]];
    NSString* key = [EncryptTools md5String:@"hmacSHA256"];
    
    // 对消息进行消息摘要算法：hmacSHA256
    NSString* hmac256Str = [EncryptTools hmacSHA256String:text key:randomStr];
    [randomStringM setValue:randomStr forKey:key];
    
    // 对加密摘要k进行私钥签名完成私钥加密
    NSData* signData = [hmac256Str dataUsingEncoding:NSUTF8StringEncoding];
    size_t blockSize = SecKeyGetBlockSize(_secPrivateKeyRef);

    size_t sectionMaxSize = blockSize - 11 ;
    
    u_long sections = signData.length/sectionMaxSize + ((signData.length%sectionMaxSize) ? 1 : 0);
    
    NSMutableData* signedDataM = [NSMutableData data];
    
    for (u_long i=0; i<sections; i++) {
        NSUInteger signStart = i*sectionMaxSize;
        NSUInteger sectionSignLength = sectionMaxSize;
        if (i == sections - 1 && signData.length%sectionMaxSize > 1) {
            sectionSignLength = signData.length%sectionMaxSize;
        }
        
        NSData* sectionData = [signData subdataWithRange:NSMakeRange(signStart, sectionSignLength)];
    
        uint8_t* signedBytes = malloc(blockSize*sizeof(uint8_t));
        memset(signedBytes, 0x0, blockSize);
        size_t signedBytesLength = blockSize;
        
        OSStatus status = SecKeyRawSign(_secPrivateKeyRef,
                                        secPadding,
                                        sectionData.bytes,
                                        sectionData.length,
                                        signedBytes,
                                        &signedBytesLength);
        if (status == noErr) {
            [signedDataM appendBytes:signedBytes length:signedBytesLength];
        } else {
            NSLog(@"部分签名失败：%tu, blockSize bit=%tu位", i, 8*blockSize);
        }
        free(signedBytes);
    }
    return signedDataM.copy;
}
- (BOOL)rsaVerifySuccessForSignedData:(NSData*)signedData plaintext:(NSString*)plaintext {
    
    // 明文进行摘要算法
    // 随机字符串
    NSString* key = [EncryptTools md5String:@"hmacSHA256"];
    NSString* randomStr = [randomStringM objectForKey:key];
    
    // 对消息进行消息摘要算法：hmacSHA256
    NSString* hmac256Str = [EncryptTools hmacSHA256String:plaintext key:randomStr];
    NSData* hmac256Data = [hmac256Str dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t blockSize = SecKeyGetBlockSize(_secPublicKeyRef);
    size_t sectionMaxSize = blockSize ;
    
    u_long sections = signedData.length/sectionMaxSize + ((signedData.length%sectionMaxSize) ? 1 : 0);
    
    BOOL success = YES;
    
    for (u_long i=0; i<sections; i++) {
        NSInteger signedStart = i*sectionMaxSize;
        NSUInteger sectionSignLength = sectionMaxSize;
        if (i == sections - 1 && signedData.length%sectionMaxSize > 1) {
            sectionSignLength = signedData.length%sectionMaxSize;
        }
        NSData* sectionData = [signedData subdataWithRange:NSMakeRange(signedStart, sectionSignLength)];
        
        uint8_t* hashBytes = malloc(sectionSignLength*sizeof(uint8_t));
        memset(hashBytes, 0x0, sectionSignLength);
      
        OSStatus status = SecKeyRawVerify(_secPublicKeyRef,
                                          _signSecPadding,
                                          hmac256Data.bytes,
                                          hmac256Data.length,
                                          sectionData.bytes,
                                          sectionSignLength);
        if (status == noErr) {
            free(hashBytes);
        } else {
            free(hashBytes);
            NSLog(@"部分验签失败：%tu, blockSize bit=%tu位", i, 8*blockSize);
            success = NO;
            break;
        }
    }
    return success;
}
- (void)loadPublicKey:(NSString*)publicKeyPath {
    NSAssert(publicKeyPath.length, @"公钥路径为空");
    
    // 删除当前公钥
    if (_secPublicKeyRef) {
        CFRelease(_secPublicKeyRef);
    }
    
    // 从一个DER编码格式的证书创建一个证书对象
    NSData* certificateData = [NSData dataWithContentsOfFile:publicKeyPath];
    SecCertificateRef certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    NSAssert(certificateRef != NULL, @"公钥文件错误");
    
    // 返回一个默认的X509策略的z公钥对象
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    
    // 包含信任管理信息的结构体
    SecTrustRef trustRef;
    
    // 基于证书和策略创建一个信任管理对象
    OSStatus status = SecTrustCreateWithCertificates(certificateRef, policyRef, &trustRef);
    NSAssert(status == errSecSuccess, @"创建信任管理对象失败");
    
    // 信任结果
    SecTrustResultType trustResult;
    status = SecTrustEvaluate(trustRef, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 评估之后返回公钥子证书
    _secPublicKeyRef = SecTrustCopyPublicKey(trustRef);
    NSAssert(_secPublicKeyRef != NULL, @"公钥创建失败");
    
    if (certificateRef) {
        CFRelease(certificateRef);
    }
    if (policyRef) {
        CFRelease(policyRef);
    }
    if (trustRef) {
        CFRelease(trustRef);
    }
}
- (void)loadPrivateKey:(NSString*)privateKeyPath password:(NSString*)password {
    NSAssert(privateKeyPath.length, @"私钥路径为空");
    
    // 删除当前私钥
    if (_secPrivateKeyRef) {
        CFRelease(_secPrivateKeyRef);
    }
    NSData* PKCS12Data = [NSData dataWithContentsOfFile:privateKeyPath];
    CFDataRef PKCS12DataRef = (__bridge CFDataRef)PKCS12Data;
    CFStringRef passwordRef = (__bridge CFStringRef)password;
    
    // 从PKCS#12证书中提取标示和证书
    SecIdentityRef identityRef = nil;
    SecTrustRef trustRef = nil;
    const void* keys[] = {kSecImportExportPassphrase};
    const void* values[] = {passwordRef};
    CFDictionaryRef optionsDictRef = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, NULL, NULL);
    CFArrayRef itemsRef = CFArrayCreate(kCFAllocatorDefault, 0, 0, NULL);
    
    // 返回 PKCS#12 格式数据中的标示和证书
    OSStatus status = SecPKCS12Import(PKCS12DataRef, optionsDictRef, &itemsRef);
    
    if (status == errSecSuccess) {
        CFDictionaryRef identityAndTrustRef = CFArrayGetValueAtIndex(itemsRef, 0);
        identityRef = (SecIdentityRef)CFDictionaryGetValue(identityAndTrustRef, kSecImportItemIdentity);
        trustRef = (SecTrustRef)CFDictionaryGetValue(identityAndTrustRef, kSecImportItemTrust);
    }else {
        NSLog(@"loadPrivateKey fial");
    }
    
    if (optionsDictRef) {
        CFRelease(optionsDictRef);
    }
    if (itemsRef) {
        CFRelease(itemsRef);
    }
    NSAssert(status == errSecSuccess, @"获取身份和信任失败");
    
    SecTrustResultType trustResultType;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(trustRef, &trustResultType);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 提取私钥
    status = SecIdentityCopyPrivateKey(identityRef, &_secPrivateKeyRef);
    NSAssert(status == errSecSuccess, @"私钥创建失败");
}

/**
 获取私钥，根据标签

 @return 获取私钥
 */
- (SecKeyRef)p_getPrivateKeyRef {
    OSStatus sanityCheck = noErr;
    SecKeyRef privateKeyReference = NULL;
    
    if (_secPrivateKeyRef == NULL) {
        NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init];
        
        // 设置私钥查询字典
        [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
        [queryPrivateKey setObject:self.secPrivateKeyTag forKey:(__bridge id)kSecAttrApplicationTag];
        [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
        [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
        
        // 获得密钥
        sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKeyReference);
        
        if (sanityCheck != noErr) {
            privateKeyReference = NULL;
        }
    } else {
        privateKeyReference = _secPrivateKeyRef;
    }
    
    return privateKeyReference;
}

#pragma mark --- 常用终端命令
/**
 *  终端测试指令
 *
 *  DES(ECB)加密
 *  $ echo -n hello | openssl enc -des-ecb -K 616263 -nosalt | base64
 *
 * DES(CBC)加密
 *  $ echo -n hello | openssl enc -des-cbc -iv 0102030405060708 -K 616263 -nosalt | base64
 *
 *  AES(ECB)加密
 *  $ echo -n hello | openssl enc -aes-128-ecb -K 616263 -nosalt | base64
 *
 *  AES(CBC)加密
 *  $ echo -n hello | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt | base64
 *
 *  DES(ECB)解密
 *  $ echo -n HQr0Oij2kbo= | base64 -D | openssl enc -des-ecb -K 616263 -nosalt -d
 *
 *  DES(CBC)解密
 *  $ echo -n alvrvb3Gz88= | base64 -D | openssl enc -des-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 *  AES(ECB)解密
 *  $ echo -n d1QG4T2tivoi0Kiu3NEmZQ== | base64 -D | openssl enc -aes-128-ecb -K 616263 -nosalt -d
 *
 *  AES(CBC)解密
 *  $ echo -n u3W/N816uzFpcg6pZ+kbdg== | base64 -D | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 *  提示：
 *      1> 加密过程是先加密，再base64编码
 *      2> 解密过程是先base64解码，再解密
 */

@end
