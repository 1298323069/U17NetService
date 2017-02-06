//
//  U17NetworkAgent.m
//  testWeb
///Users/liangkun/Desktop/U17_3.0/trunk/U17_3.0/U17_3.0/Tool/netService
//  Created by liangkun on 16/1/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import "U17NetworkAgent.h"
#import "U17NetworkPrivate.h"
#import "User.h"
#import "U17Manager.h"
#import "U17ComonTool.h"
#import "U17Contant.h"

@interface U17NetworkAgent()

@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong)AFNetworkReachabilityManager *netManager;

@end

@implementation U17NetworkAgent

+ (U17NetworkAgent*)shareInstance {

    static U17NetworkAgent *sharedInstance = nil;
    
    @synchronized(self) {
        if(sharedInstance == nil) {
            
            
            sharedInstance =  [[[self class] alloc] init];
        }
    }
    
    
    
    return sharedInstance;

}
- (instancetype)init {
    
    if (self = [super init]) {
        
        //得到会话管理者配置相关的属性
        AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
        
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //得到一个网络管理的对象
        self.netManager =  [AFNetworkReachabilityManager sharedManager];
        
        self.sessionManager = manager;
        
    }
    
    return self;
}
- (NSString*)buildRequestUrl:(U17HttpService *)httpService {
    //如果请求的URL是以HTTP开头
    NSString *detailUrl = [httpService requestURL];
    
    if ([detailUrl hasPrefix:@"http"]) {
        
        return detailUrl;
    }
    
    NSString *baseUrl = [httpService baseURL];
    //拼接得到请求的URL
    NSString *finaURL = [NSString stringWithFormat:@"%@%@",baseUrl,detailUrl];
    
    if (detailUrl == nil ) {
        
        return baseUrl;
        
    } else {
        
        return finaURL;
        
    }
}

- (void)addRequest:(U17HttpService*)request {
    
    
    // 请求的方法
    U17HTTPMethod meth = [request requestMethod];
    
    //请求的URL
    NSString *url = [self buildRequestUrl:request];
    //请求的参数
    NSDictionary* param0 = [request requestArgument];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    User *user = [[U17Manager sharedInstance] loadUser];
    
    /**
     *  当前的版本号
     */
    NSString *version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    /**
     *  当前的设备号
     */
    //    NSString *device = [UIDevice currentDevice].model;
    
    /**
     *   当前的设备的具体的型号
     */
    NSString *deviceName = [U17NetworkPrivate deviceName];
    
    /**
     *  设备的唯一ID
     */
    //    NSString *deviceID =  [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSString *deviceID = [U17ComonTool getEquipmentUUID];
    
    
    /**
     *  当前的时间
     */
    
    NSDate *current = [NSDate date];
    NSString *timeMark = [NSString stringWithFormat:@"%ld",(long)[current timeIntervalSince1970]];
    
    int timemark = [timeMark intValue];
    
    /**
     *  得到一个公共的参数字典公共的参数有1用户唯一的Key值 2当前的版本号 3当前的设备号  4一个当前时间的时间戳
     */
//    NSDictionary *commentParam = [NSDictionary dictionary];
    
    NSDictionary *commentParam;
    
    
    if (user.key == nil) {
        
        if ([deviceName isKindOfClass:[NSString class]]) {
            commentParam = @{@"version":version,@"device_id":deviceID,@"time":@(timemark),@"model":deviceName};
        } else {
            
        commentParam = @{@"version":version,@"device_id":deviceID,@"time":@(timemark)};
        }
       
        
    } else {
        
        if ([deviceName isKindOfClass:[NSString class]]) {
            
            commentParam = @{@"key":user.key,@"version":version,@"device_id":deviceID,@"time":@(timemark),@"model":deviceName};
            
        } else {
            

            
              commentParam = @{@"key":user.key,@"version":version,@"device_id":deviceID,@"time":@(timemark)};
            
         
        
        }
        
        
        
    }
    
    
    
    [param addEntriesFromDictionary:param0];
    
    [param addEntriesFromDictionary:commentParam];
    
    
    
    
    
    //构造请求体的方法
    AFNConstructingBlock constructBlock =  [request constructingBodyBlock];
    
    //单次请求过期的时间
    @synchronized (self) {
      self.sessionManager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    }
    
    //得到请求头中相关的授权信息的用户名和密码
    NSArray *authorizationHeaderFieldArray = [request requestAutoritationHeaderFielArray];
    
    if (authorizationHeaderFieldArray != nil) {
        //如果不为空配置请求头中相关的授权信息
        [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString*)authorizationHeaderFieldArray.firstObject password:(NSString*)authorizationHeaderFieldArray.lastObject];
    }
    //一个配置请求头其它信息的可变字典
    NSMutableDictionary *headerFieldDictionary = [NSMutableDictionary dictionary];
    
    
    NSDictionary *headerField = [request requestHeadFieldValueDictionary];
    //请求需要拼接的最后修改时间参数
    NSString *lastmodify = [request lastTimeModified];
    
    NSDictionary *lastmodifydict;
    
    if (!lastmodify) {
        
        // 如果没有最后时间时，将时间置成最开始的时间
        lastmodify = @"Thu, 1 Jan 1970 00:00:00 GMT";
    }
    
    lastmodifydict = @{@"If-Modified-Since":lastmodify};
    
    [headerFieldDictionary addEntriesFromDictionary:lastmodifydict];
    
    [headerFieldDictionary addEntriesFromDictionary:headerField];
    
    //如果配置请求头的字典不为空
    
    if (headerFieldDictionary != nil) {
        
        for (id httpHeaderField in headerFieldDictionary.allKeys) {
                        
            id httpHeaderFieldValue = headerFieldDictionary[httpHeaderField];

            
            if ([httpHeaderField isKindOfClass:[NSString class]] && [httpHeaderFieldValue isKindOfClass:[NSString class]]) {
                
                //配置给请求头
                [self.sessionManager.requestSerializer setValue:(NSString*)httpHeaderFieldValue forHTTPHeaderField:(NSString*)httpHeaderField];
                
               
                
                
                
                NSLog(@"%@",headerFieldDictionary);
                
            } else {
                
                NSLog(@"Error class key/value in headerFieldDictionary must all NSString");
                
                
            }
        }
    }
    
    NSURLRequest *customURLRequest = [request buildCostomUrlRequest];
    if (customURLRequest) {
        //如果是自定义的URL
        
    } else {
        if (meth == U17HTTPGET ) {
            //如果是GET方法
            if ([request resumableDownloadPath]) {
                
                //指定了断点续传的地址
                
                
            } else {
                
                //没有指定断点续传的地址
                [self.sessionManager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                    if (request.progres) {
                        
                        request.progres(downloadProgress);
                        
                    }
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    
                    if (request.dataTaskWithData) {
                        
                        request.dataTaskWithData(task,responseObject);
                        
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    if (error) {
                        
                        //                        NSLog(@"%ld",(long)error.code);
                        NSLog(@"%@",error);
                        
                        //                        NSLog(@"123");
                    }
                    
                    
                    if (request.dataTaskWithDataFail) {
                        
                        request.dataTaskWithDataFail(task,error);
                        
                    }
                    
                 }];
                
                
            }
            
        } else if (meth == U17HTTPPOST) {
            //当前的请求是一个POST请求的时候
            if (constructBlock != nil) {
                //有构造请求体的时候
                [self.sessionManager POST:url parameters:param constructingBodyWithBlock:constructBlock
                                 progress:^(NSProgress * _Nonnull uploadProgress) {
                                     if (request.progres) {
                                         request.progres(uploadProgress);
                                         
                                     }
                                 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                     if (request.dataTaskWithData) {
                                         
                                         request.dataTaskWithData(task,responseObject);

                                         
                                     }
                                     
                                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     
                                     if (request.dataTaskWithDataFail) {
                                         
                                         request.dataTaskWithDataFail(task,error);

                                     }
                                     
                                     
                                     
                                 }];
                
            } else {
                
                //没有构造请求体的时候
                [self.sessionManager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    if (request.progres) {
                        
                        request.progres(uploadProgress);
                        
                    }
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (request.dataTaskWithData) {
                        
                        request.dataTaskWithData(task,responseObject);
                        
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    if (request.dataTaskWithDataFail) {
                        
                        request.dataTaskWithDataFail(task,error);
                        
                    }
                    
                }];
                
                
            }
            
        }
        
    }
    
    
}

//得到当前的网络状态的
- (void)addNetStatus:(U17HttpService *)request {
    
    //开启监控当前的网络状态
    [self.netManager startMonitoring];
    
    //使用AFN封装的方法获取当前的网络状态
    BOOL isNetOK = [self.netManager isReachable];
    
    BOOL isWifiOK = [self.netManager isReachableViaWiFi];
    
    BOOL is3GOK = [self.netManager isReachableViaWWAN];
    
    //如果Block被实现了
    if (request.U17Currentnetstatus) {
        
        //给方法的Block所需要的参数传值
        request.U17Currentnetstatus(isNetOK,isWifiOK,is3GOK);
        
    }
    
    
}

@end
