//
//  U17NetworkAgent.h
//  testWeb
//
//  Created by liangkun on 16/1/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "U17HttpService.h"
#import <AFNetworking/AFNetworking.h>
@class U17HttpService;

@interface U17NetworkAgent : NSObject

/**
 *  获取一个单利的对象
 *
 *  @return 网络工具类的代理
 */
+ (U17NetworkAgent*)shareInstance;

/**
 *  使用一个U17HttpService对象来造一个请求所需要的URL字符串
 *
 *  @param httpService 一个U17HttpService的类对象
 *
 *  @return 拼接完整的URL对象
 */
- (NSString*)buildRequestUrl:(U17HttpService*)httpService;

/**
 *   添加一个请求即发起一个请求
 *
 *  @param request 一个U17HttpSerce的类对象
 */
- (void)addRequest:(U17HttpService*)request;

/**
 *  添加一个网络状态的获取的请求
 *
 *  @param request 一个U17HttpService类对象
 */
- (void)addNetStatus:(U17HttpService*)request;

@end
