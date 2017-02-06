//
//  U17NetworkPrivate.h
//  testWeb
//
//  Created by liangkun on 16/1/6.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
@interface U17NetworkPrivate : NSObject
//产看json数据是否正常可用；
//+ (BOOL)checkJson:(id)json withValidatorJson:(id)validatorJson;

//防止在此路径下的资源备份
+ (void)addNotBackUpAttribute:(NSString *)path;

/**
 *  传入字符获得MD5加密以后的字符
 *
 *  @param string 需要被MD5加密的字符串
 *
 *  @return 已经被加密的字符串
 */
+ (NSString*)MD5StringFromString:(NSString *)string;

/**
 *  获取当前程序版本号字符串
 *
 *  @return 获取当前程序版本号字符串
 */
+ (NSString*)appVersionString;

/**
 *  得到拼接完参数以后的字符串
 *
 *  @param originUrlString 请求的原始路径
 *  @param parameters      需要拼接的参数字典
 *
 *  @return 拼接完成以后的字符串
 */
+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters;
/**
 *  当前的设备号比如4S,5,5S,
 *
 *  @return 当前的设备号
 */
+ (NSString*)deviceName;
@end
