//
//  U17HttpService.h
//  testWeb
//
//  Created by liangkun on 16/1/5.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>
#import "U17NetworkAgent.h"
//请求方法的枚举
typedef NS_ENUM(NSInteger,U17HTTPMethod){
    
U17HTTPGET = 0,
U17HTTPPOST,
    
};
/**
 *  使用缓存的策略
 */

typedef NS_ENUM(NSInteger,U17CashePolicy){
    
    
    Undefine = 0,
    /**
     *  数据展示后刷新服务器返回的数据
     */
    CallBackTwice = 1,
    /**
     *  数据展示后不刷新服务器返回的数据
     */
    OnlyLocalCash = 2,
    /**
     *  强制更新只使用服务器返回的最新数据
     */
    ForceUpdate = 3,
    
};

@class U17HttpService;
//操作的进度
typedef void (^U17Progress)(NSProgress * progress);

//操作成功的回传值
typedef void (^U17Success)(id responseJson);

//操作失败的回传值
typedef void (^U17Fail)(NSError *failerror);

//当前的网络状态
typedef void (^U17NetStatus)(BOOL isNetOK,BOOL isWifiOK,BOOL is3GOk);

//当前正在进行的网络任务
typedef void (^U17DataTask)(NSURLSessionDataTask * task);

//成功的回调
typedef void(^U17DataSuccess) (NSURLSessionDataTask *task, id Data);

//当前正在进行的网络任务失败的回调
typedef void (^U17DataTaskfail)(NSURLSessionDataTask * task);

//失败的回调
typedef void (^U17DataFial) (NSURLSessionDataTask *task, NSError *error);

//参数为上传的结构体
typedef void (^AFNConstructingBlock)(id<AFMultipartFormData>formData);
//参数为本自身
typedef void(^U17RequestCompletionBlock)(__kindof U17HttpService *request);

typedef void(^RequestSuccessBlock)(NSDictionary *dict, id reponseObject, NSError * error);

//请求的协议
@protocol U17RequestDelegate <NSObject>

@optional

- (void)getsuccess:(U17Success)success;


- (void)addRequest:(U17HttpService*)request;



@end

@interface U17HttpService : NSObject;

// 下载的进度
@property (nonatomic, strong) U17Progress progres;

//成功以后返回的数据
@property (nonatomic, strong) U17Success success;

//失败返回的错误原因
@property (nonatomic, strong) U17Fail failError;

//当前的网络状态
@property (nonatomic, strong) U17NetStatus U17Currentnetstatus;

//当前正在进行的网络任务
@property (nonatomic, strong) U17DataSuccess dataTaskWithData;

@property (nonatomic, strong) U17DataFial dataTaskWithDataFail;


//实现了相关方法的代理对象
@property (nonatomic, strong) id<U17RequestDelegate>delegate;

//标签
@property (nonatomic) NSInteger tag;

//用户的相关信息
@property (nonatomic,strong)NSDictionary *userInfo;









//返回的请求成功以后返回的id类型的返回对象
@property (nonatomic, strong,readonly) id responseObject;

//请求的响应头信息
@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;

//请求响应的状态吗
@property (nonatomic, assign) NSInteger responseStatusCode;
- (instancetype)init;

//请求的URL
- (NSString*)requestURL;

//请求的基础URL
- (NSString*)baseURL;
//最后一次修改的时间
- (NSString*)lastTimeModified;

//请求链接的超时时间
- (NSTimeInterval)requestTimeoutInterval;

//请求的参数列表
- (NSDictionary*)requestArgument;


- (id)casheFileNameFilterForRequestArgument:(id)requestArgument;

//请求的方法
- (U17HTTPMethod)requestMethod;

//请求的serializertype
//- (U17RequestSerializerType)requestSerializerType;

//在请求头中添加的自定义参数
- (NSDictionary*)requestHeadFieldValueDictionary;

//请求服务器的用户名和密码
- (NSArray*)requestAutoritationHeaderFielArray;


//自定义一个完全独立之外的请求
- (NSURLRequest*)buildCostomUrlRequest;

//用于检测JSON是否合法的对象
//- (id)jsonValidator;

// 检测Status Code是否正常
//- (BOOL)statusCodeValidator;

//返回返回请求体的构造函数
- (AFNConstructingBlock)constructingBodyBlock;


//断点续传的时候。使用的一个路径

- (NSString*)resumableDownloadPath;

//请求数据的方法
- (void)request;

//获取网络状态的方法
- (void)checkNet;





@end
