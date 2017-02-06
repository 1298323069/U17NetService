//
//  U17BaseService.h
//  testWeb
//
//  Created by liangkun on 16/1/6.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import "U17HttpService.h"




@interface U17BaseService : U17HttpService


//是否忽略缓存
@property (nonatomic)BOOL ignoreCache;
//缓存的返回数据
@property (nonatomic, strong)id casheObject;
//返回的任务对象
@property (nonatomic, strong)NSURLSessionTask * task;

//拼接完整的URL
@property (nonatomic, copy)NSString *CompleteUrlString;

//是否强壮在外围
@property (nonatomic, assign) BOOL isForceRefresh;

- (instancetype)init;


/**
 *   Undefine = 0, 与上一版的运行结果相同
 CallBackTwice,先回调内存中的数据。下载完成以后回调下载的数据
 OnlyLocalCash,只回调内存中的数据。新数据覆盖久数据。默认的返回结果
 ForceUpdate,只得到新鲜期以内的数据
 *
 *  @return 以上的枚举决定使用缓存的策略
 */
- (U17CashePolicy)cashePolicy;

/**
 *  在有缓存的情况下错误的信息是否回调返回YES回调为默认的情况。返回NO不回调；
 *
 *  @return BOOL决定错误的信息是否需要回调过来
 */
- (BOOL)isErrorCallBackInSecongRequest;


//手动将其它的的jsonResponseCashe中去
- (void)saveJsonResponseToCasheFile:(id)JsonResponse;

/**
 *   清空所有的缓存
 */
- (void)clearTheFile;

/**
 *  当前缓存的文件多少
 *
 *  @return 这个app缓存了多少文件
 */
- (double)cashfileCount;


//取消的操作
- (void)cancel;


//暂停的操作
- (void)suspend;


//恢复的操作
- (void)resume;

/**
 *  重复调用此方法。按掉用的先后顺序执行。在请求完成前不会发起下一次请求
 *
 *  @param responseObject 当前网络请求的数据
 *  @param goingTask      当前网络请求的任务对象
 *  @param prgress        当前网络请求的进程
 *  @param error          当前网络请求发生错误时返回的错误对象
 */
- (void)synchrousStarWith:(U17Success)responseObject andWithTask:(U17DataTask)goingTask andPrgress:(U17Progress)prgress andWithError:(U17Fail)error;

/**
 *  获取网络请求得到的数据所有的Block参数如不需要传入 nil
 *
 *  @param responseObject 当前网络请求的数据
 *  @param goingTask      当前网络请求的任务对象
 *  @param progress       当前网络请求的进程
 *  @param error          当前网络请求发生错误时返回的错误描述
 */
- (void)startWith:(U17Success)responseObject andWithTask:(U17DataTask)goingTask andProgress:(U17Progress)progress andWithError:(U17Fail)error;

/**
 *  获取当前请求完成的URL
 *
 *  @return 当前请求完整的URL
 */
- (NSString*)completeUrlFileContent;

/**
 *  获取当前的网络状态
 *
 *  @param netstatus 一个Block其中有当前网络状态的参数
 */
- (void)currentNetStatus:(U17NetStatus)netstatus;

@end
