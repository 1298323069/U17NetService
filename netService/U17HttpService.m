//
//  U17HttpService.m
//  testWeb
//
//  Created by liangkun on 16/1/5.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import "U17HttpService.h"
@interface U17HttpService()



@end

@implementation U17HttpService

- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
    
}
//一下的方法子类来重写
//请求的URL
- (NSString *)requestURL {
    
  return @"";
    
}
//baseURL;
- (NSString *)baseURL {
    
    return @"http://app.u17.com/v3/appV3_2/ios/phone";
    
}
//请求过期的时间
- (NSTimeInterval)requestTimeoutInterval {
    
    return 60;
}
//参数的列表
- (NSDictionary*)requestArgument {
    
    return nil;
    
}
- (NSDictionary*)lastModifiedTime{
    
    return nil;
    
}

//计算Cashe文件名的时候忽略一些指定的参数

- (id)casheFileNameFilterForRequestArgument:(id)requestArgument {
    
    return requestArgument;
    
}
//返回请求的方法
- (U17HTTPMethod)requestMethod {
    
    return U17HTTPGET;

}
/**
 *  但前使用的缓存策略
 *
 *  @return 只返回本地的缓存
 */
- (U17CashePolicy)cashePolicy {
    
    return OnlyLocalCash;
    
    
}
//需要在请求头中配置Base64加密的用户名和密码授权信息
- (NSArray*)requestAutoritationHeaderFielArray {
    
    return nil;
    
}
//请求头中需要自定义的参数
- (NSDictionary*)requestHeadFieldValueDictionary {
    
    return nil;
    
}
//自定义的一个请求
- (NSURLRequest*)buildCostomUrlRequest {
    
    return nil;
    
}

//请求头中需要配置的最后一次修改时间字段
- (NSString*)lastTimeModified {
    
    return nil;
    
}
//断点续传指定的地址
- (NSString*)resumableDownloadPath {
    
    return nil;
    
}
- (id)jsonValidator {
    
    return nil;
    
}
 
- (AFNConstructingBlock)constructingBodyBlock {
    
    return nil;
    
}

- (void)request {
    
    //开始网络请求获取数据
    [[U17NetworkAgent shareInstance] addRequest:self];
    
    
    
}
- (void)checkNet {
    
    //获取当前的网络状态
    [[U17NetworkAgent shareInstance] addNetStatus:self];
    
  
}



@end
