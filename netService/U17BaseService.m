//
//  U17BaseService.m
//  testWeb
//
//  Created by liangkun on 16/1/6.
//  Copyright © 2016年 liangkun. All rights reserved.
//
#define serverDataName  @"ServerCasheData"
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

#define isCDsave 0

#import "U17BaseService.h"
#import "U17NetworkPrivate.h"
#import "U17ComicCache.h"
#import "JSONKit.h"
#import "LKStoreManager.h"
#import "U17StaticRequestObject.h"


@interface U17BaseService()<NSFileManagerDelegate>


@property (nonatomic, assign) BOOL NetStatus;
@property (nonatomic, assign) BOOL WIFIStatus;
@property (nonatomic, assign) BOOL WWANStatus;

@property (nonatomic, assign) BOOL isCasheExit;

//最后一次修改的时间
@property (nonatomic, strong)NSString *lastModifiedTime;

//控制缓存的时间
@property (nonatomic, strong)NSString *CasheControl;

//更新的时间
@property (nonatomic, strong)NSDate *updateTime;

//文件管理的管理文件的对象
@property (nonatomic, strong)NSFileManager *fileManager;

//存储静态请求相关信息的存储管理
@property (nonatomic, strong)LKStoreManager *storeManager;

//网络缓存相关的数据对象
@property (nonatomic, strong) U17StaticRequestObject *reqStaticObject;

@property (nonatomic, strong) NSString *storeKey;

@property (nonatomic, strong) NSString *ClassName;

@property (nonatomic, assign) BOOL isDataPolluted;

@end

@implementation U17BaseService

- (instancetype)init {
    
    
    
    if (self = [super init]) {
        
        self.isCasheExit = NO;
        
        self.isDataPolluted = NO;
        
        self.storeManager = [LKStoreManager shareStoreManager];
        
        self.fileManager = [[NSFileManager alloc]init];
        
        self.ClassName = [NSString stringWithUTF8String:object_getClassName(self)];
        
        
    }
    return self;
    
    
}

- (NSString*)storeKey
{
    
    return [self storeRequestCasheKey];

}

//获取标记当前请求唯一的key
- (NSString*)storeRequestCasheKey
{
    NSString *keyString;
    
    NSString *request = [self requestURL];
    NSString *baseURL = [self baseURL];
    
    id argument = [self casheFileNameFilterForRequestArgument:[self requestArgument]];
    
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Host:%@URL:%@Argument:%@AppVersion:%@",(long)[self requestMethod],baseURL,request,argument,[U17NetworkPrivate appVersionString]];
    
    NSString *casheFileName = [U17NetworkPrivate MD5StringFromString:requestInfo];
    
    return casheFileName;

    return keyString;

}
/**
 *   在回调了缓存以后正在请求最新数据发生错误的时候是否回调
 *
 *  @return 返回YES表示回调，NO表示不回调
 */

- (BOOL)isErrorCallBackInSecongRequest {
    
    return NO;
    
}




/**
 *  清除指定路径下的内容
 *
 *  @param path 需要删除的文件对应的名字
 */
- (void)clearFileAt:(NSString *)path {
    
    NSFileManager *manager = [[NSFileManager alloc]init];
    manager.delegate = self;
    
    [manager removeItemAtPath:path error:NULL];
    
    if ([manager fileExistsAtPath:path]) {
        NSError *error = nil;
        int  a = 0;
        while (![manager removeItemAtPath:path error:&error]) {
            
            [manager removeItemAtPath:path error:&error];
            if (error) {
                
                NSLog(@"删除缓存数据错误 %@",error);
                
            }
            a ++;
            if (a == 10) {
                
                break;
            }
            
        }
        
    }
    
}

/**
 *  清空基本路径下的所有的缓存
 */
- (void)clearTheFile {
    
    
    [self.storeManager clearAllDiskCashe:^{
        
        NSLog(@"删除了磁盘中所有网络缓存的数据");
        
    }];
    
    //删除SDImage中的缓存
    [[SDImageCache sharedImageCache] clearDisk];
    
    //清除漫画相关的缓存
    [U17ComicCache removeAllCache];
    
    //清除封印图缓存
    [U17ComicCache removeSealImageCache:^(NSError *error) {
        
        
    }];
    
}


/**
 *
 *
 *  @return 缓存版本文件的内容（服务器端最后一次修改的时间）
 */
- (NSString*)casheVersionFileContent {
    
    
    if (_reqStaticObject) {
        
        return self.reqStaticObject.lastModifiedTime;
        
    } else
    {
        
        if ([self.storeManager isObjectExitAtKey:self.storeKey]) {
            
            _reqStaticObject = [self.storeManager getDataWithKey:self.storeKey];
            
            return _reqStaticObject.lastModifiedTime;

        } else
        {
        
            return nil;
            
        }
        
    }
    
}


/**
 *
 *
 *  @return 本次请求的完整的URL内容
 */
- (NSString*)completeUrlFileContent {
    
    
        return _CompleteUrlString;
    
}
/**
 *  获取某个路径中的值
 *
 *  @param thePath 路径
 *
 *  @return 路径中的值
 */
- (NSString*)getValueUnderThePath:(NSString*)thePath {
    
    NSString *path = thePath;
    
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    if ([filemanager fileExistsAtPath:path isDirectory:nil]) {
        //如果存在解裆这个数据返回
        NSString *lastTime;
        
        @try {
            
            lastTime  = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            
        } @catch (NSException *exception) {
            
            return nil;
            
        } @finally {
            
            
        }
        
        return lastTime;
        
    } else {
        
        return nil;
        
    }
    
}

#pragma mark 请求数据的方法
//顺序获取请求的数据
- (void)synchrousStarWith:(U17Success)responseObject andWithTask:(U17DataTask)goingTask andPrgress:(U17Progress)prgress andWithError:(U17Fail)error{
    
    //开启一个信号量
    //        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    WS(weakSelf);
    
    //有效时间
    NSInteger efficentTime = [self efficentTime];
    
    //过期时间
    NSInteger expireTime = [self expireTime];
    
    //新鲜的时间
    NSInteger freshTime = [self freshTime];
    
    //    NSLog(@"%ld",(long)efficentTime);
    //    NSLog(@"%ld",(long)expireTime);
    //    NSLog(@"%ld",(long)freshTime);re
    
    if (efficentTime > expireTime) {
        
        //有效期大于过期
        //加载新的数据
        [self request];
        
        
    }
    if (expireTime > efficentTime && efficentTime > freshTime ) {
        //  过期       > 有效期 > 新鲜期
        
        //下载新的数据
        [self request];
        
        
        @try {
            
            _casheObject = _reqStaticObject.casheObject;
            
        } @catch (NSException *exception) {
            
            
        } @finally {
            
            
        }
        
        
        
        
        if (_casheObject != nil) {
            
            if ([self cashePolicy] == ForceUpdate) {
                //如果当前的缓存策略是强制更新的话就什么都不做
            } else {
                
                //返回本地存储好的数据
                responseObject(_casheObject);
                self.isCasheExit = YES;
                
                
            }
            
            
        }
        
        
    }
    
    if (efficentTime < freshTime){
        
        //有效期 < 新鲜期
        @try {
            _casheObject = _reqStaticObject.casheObject;
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        
        if (_casheObject != nil) {
            
            //返回本地存储好的数据
            responseObject(_casheObject);
            self.isCasheExit = YES;
            
            
        } else {
            
            //            [super request];
            
        }
        
        weakSelf.dataTaskWithData = nil;
        
    }
    
    
    
    
    
    //如果进程的闭包被实现
    weakSelf.progres = ^(NSProgress * pro){
        
        if (prgress) {
            
            prgress(pro);
            
        }
        
    };
    
    self.dataTaskWithData = ^(NSURLSessionDataTask* task,id data){
        
        //如果进行任务的闭包被实现
        if (goingTask) {
            
            goingTask(task);
            
        }
        weakSelf.task = task;
        
        //得到最后修改时间字符串保存，
        NSURLResponse *response = task.response;
        NSURL *url  = response.URL;
        
        weakSelf.CompleteUrlString = url.absoluteString;
        
        NSHTTPURLResponse * response1 = (NSHTTPURLResponse *)response;
        
        
        
        
        //当数据需要更新的时候
        
        NSString *str = response1.allHeaderFields[@"Cache-Control"];
        //保存控制缓存
        if ([str rangeOfString:@"max-age"].location == NSNotFound ||[weakSelf cashePolicy] == ForceUpdate ) {
            
            responseObject(data);
            
        } else {
            
            if ([self cashePolicy] == CallBackTwice || [self lastTimeModified] == nil ) {
                
                //返回刷新以后的数据
                responseObject(data);
                
                
            }
            //保存当前刷新数据的时间
            weakSelf.updateTime = [NSDate date];
            
            
            //保存控制缓存的字符串
            weakSelf.CasheControl = response1.allHeaderFields[@"Cache-Control"];
            
            //保存刷新以后的数据覆盖之前的数据
            weakSelf.casheObject = data;
            
            if (response1.allHeaderFields[@"Last-Modified"] != nil) {
                
                weakSelf.lastModifiedTime = response1.allHeaderFields[@"Last-Modified"];
                
            }
            
        }
        
        
        
        
        
        
        
        
        weakSelf.dataTaskWithData = nil;
        
    };
    
    //请求失败的回调
    self.dataTaskWithDataFail = ^(NSURLSessionDataTask* task,NSError *err){
        
        //如果进行任务的闭包被实现
        if (goingTask) {
            
            goingTask(task);
            
        }
        weakSelf.task = task;
        
        //得到最后修改时间字符串保存，
        NSURLResponse *response = task.response;
        NSURL *url  = response.URL;
        
        weakSelf.CompleteUrlString = url.absoluteString;
        
        NSHTTPURLResponse * response1 = (NSHTTPURLResponse *)response;
        
        
        //如何错误信息的闭包被实现
        
        if (error) {
            
            
            
            if ( response1.statusCode != 304 ) {
                
                error(err);
                //执行信号通知的操作
                //                    dispatch_semaphore_signal(semaphore);
                
            }
            
            
            
        }
        
        weakSelf.dataTaskWithDataFail = nil;
        weakSelf.dataTaskWithData = nil;
        weakSelf.progres = nil;
        
    };
    
    
    
}



-(void)dealloc {
    
    //    [self.dataCt saveContext];
    
}


//得到请求数据的回调
- (void)startWith:(U17Success)responseObject andWithTask:(U17DataTask)gointTask andProgress:(U17Progress)progress andWithError:(U17Fail)error{
    
    
    WS(weakSelf);
    
    //静态网络缓存对象
    
    
    
    if (_isForceRefresh) {
        //切换到了强制更新的状态
        
        self.progres = ^(NSProgress * pro){
            
            if (progress) {
                
                progress(pro);
                
            }
            
            weakSelf.progres = nil;
            
        };
        
        self.dataTaskWithData = ^(NSURLSessionDataTask* task,id data){
            
            if (gointTask) {
                
                gointTask(task);
                
            }
            if (responseObject) {
                
                responseObject(data);

            }
        };
        self.dataTaskWithDataFail = ^(NSURLSessionDataTask* task,NSError *err){
            
            if (gointTask)
            {
                
                gointTask(task);
                
            }
            
            if (error)
            {
                error(err);
                
            }
        };
        
        weakSelf.dataTaskWithDataFail = nil;
        weakSelf.dataTaskWithData = nil;
        weakSelf.progres = nil;
    } else
    {

  
    
#pragma mark处理回传的数据
    
    self.progres = ^(NSProgress * pro){
        
        if (progress) {
            
            progress(pro);
            
        }
        
        weakSelf.progres = nil;
       
        
       
    };
    
    
    
    //成功以后的回传信息
    __block   NSHTTPURLResponse * response1;
    
    self.dataTaskWithData = ^(NSURLSessionDataTask* task,id data){
        
        if (gointTask) {
            
            gointTask(task);
            
        }
        weakSelf.task = task;
        
        
        //得到最后修改时间字符串保存，
        NSURLResponse *response = task.response;
        
        NSURL *url  = response.URL;
        
      
        weakSelf.reqStaticObject.CompleteUrlString = url.absoluteString;
        
        
        
        
        //        NSLog(@"%@",url);
        
        response1  = (NSHTTPURLResponse *)response;
        
               NSLog(@"%@",response1.allHeaderFields);
        //       NSLog(@"%@",response1.allHeaderFields[@"Cache-Control"]);
        
        NSString *str = response1.allHeaderFields[@"Cache-Control"];
        
        //保存控制缓存
        if ([str rangeOfString:@"max-age"].location == NSNotFound ||[weakSelf cashePolicy] == ForceUpdate) {
            
            //如果当前没有给控制缓存的信息
            responseObject(data);
            
            
        } else {
            
            //这里加入一次回调
            if([weakSelf.CompleteUrlString rangeOfString:@"comic/detail_static_new"].location!=NSNotFound){
                
                responseObject(data);
                
            }
            if (!weakSelf.reqStaticObject) {
                
                //如果当前的静态网络请求对象不存在
                
                weakSelf.reqStaticObject = [[U17StaticRequestObject alloc]init];
            }

            
            //如果当前需要回调两次。或者是第一次请求的。或者指定了是强制更新的话。
            
            if ([weakSelf cashePolicy] == CallBackTwice || [weakSelf lastTimeModified] == nil ) {
                
                //返回刷新以后的数据
                responseObject(data);
                
                
            }
            
            
            NSString *lastModifyTime;
            
            if (response1.allHeaderFields[@"Last-Modified"] != nil) {
                //                        NSLog(@"%@",response1.allHeaderFields[@"Last-Modified"]);
                
                lastModifyTime = response1.allHeaderFields[@"Last-Modified"];
            
                
               weakSelf.reqStaticObject.lastModifiedTime = response1.allHeaderFields[@"Last-Modified"];
                
                
            }
            
           weakSelf.reqStaticObject.CasheControl = response1.allHeaderFields[@"Cache-Control"];
            
            //                    NSLog(@"%@",[NSThread currentThread]);
            //保存当前刷新数据的时间
            
            weakSelf.reqStaticObject.updateTime = [NSDate date];
            
            //保存刷新以后的数据覆盖之前的数据
            weakSelf.reqStaticObject.casheObject = data;
            
            [weakSelf.storeManager saveObject:weakSelf.reqStaticObject WithKey:weakSelf.storeKey];//保存当前的对象
        }
        
       
        
        weakSelf.dataTaskWithData = nil;
        
    };
    
    //失败以后的回传信息
    
    self.dataTaskWithDataFail = ^(NSURLSessionDataTask* task,NSError *err){
        
        if (gointTask)
        {
            
            gointTask(task);
            
        }
        
        weakSelf.task = task;
        
        
        //得到最后修改时间字符串保存，
        NSURLResponse *response = task.response;
        
        NSURL *url  = response.URL;
        
        weakSelf.CompleteUrlString = url.absoluteString;
        
        //        NSLog(@"%@",url);
        
        NSHTTPURLResponse * response1 = (NSHTTPURLResponse *)response;
                NSLog(@"%@",response1.allHeaderFields);
                NSLog(@"%@",response1.allHeaderFields[@"Cache-Control"]);
                NSLog(@"%ld",(long)response1.statusCode);
        
        
        if (error)
        {
            
            if (response1.statusCode != 304 )
            {
                
                error(err);
                
            }
            
            
            
        }
        
        
        
        weakSelf.dataTaskWithDataFail = nil;
        weakSelf.dataTaskWithData = nil;
        weakSelf.progres = nil;

        
    };
#pragma mark 控制缓存策略的模块
    //有效时间
    NSInteger efficentTime = [self efficentTime];
    
    //过期时间
    NSInteger expireTime = [self expireTime];
    
    //新鲜的时间
    NSInteger freshTime = [self freshTime];
    //    NSLog(@"%@",[NSThread currentThread]);
    
    //             NSLog(@"%ld",(long)efficentTime);
    //             NSLog(@"%ld",(long)expireTime);
    //             NSLog(@"%ld",(long)freshTime);
    //
    
    
    if (self.ignoreCache || efficentTime > expireTime)
    {
        
        NSLog(@"这个路径 %@",self.requestURL);
        //有效期大于过期
        //加载新的数据
        self.isForceRefresh = YES;
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            
            
            [self request];
           
            
            NSLog(@"current net request service name === %@",self.ClassName);
            
        }];
        
        [queue addOperation:op];
        
        
        
    }
    else if (expireTime >= efficentTime && efficentTime >= freshTime )
    {
        //  过期 > 有效期 > 新鲜期
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            
            [self request];
            
            self.ClassName = [NSString stringWithUTF8String:object_getClassName(self)];
            
            NSLog(@"current net request service name === %@",self.ClassName);
            
        }];
        
        
        [queue addOperation:op];
    
        
        @try {
            _casheObject = _reqStaticObject.casheObject;
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        
        
        
        if (_casheObject != nil)
        {
            
            //返回本地存储好的数据
            if ([self cashePolicy] == ForceUpdate || self.ignoreCache)
            {
                //如果当发起这次请求是一个强制更新的请求就什么用不做
                
            } else
            {
                //给你回调数据的Block参数传值；
                responseObject(_casheObject);
                self.isCasheExit = YES;
                
            }
        } else
        {
            NSLog(@"接档数据错误");
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
                
                [self request];
                
                self.ClassName = [NSString stringWithUTF8String:object_getClassName(self)];
                
                NSLog(@"current net request service name === %@",self.ClassName);
                
            }];
            
            
            [queue addOperation:op];
            
        }
        
        
    }
    
    else if (efficentTime < freshTime && !self.ignoreCache)
    {
        
        //有效期 < 新鲜期
        @try {
            
            _casheObject = _reqStaticObject.casheObject;
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        if (_casheObject != nil)
        {
            
            //返回本地存储好的数据
            responseObject(_casheObject);
            self.isCasheExit = YES;
        }else
        {
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
                
                [self request];
                
            }];
            
            [queue addOperation:op];
            
            
        }
        
        
        
        weakSelf.dataTaskWithData = nil;
        
    }
    
}
}

#pragma mark 保持当前需要缓存的数据


#pragma mark 重写属性的Set方法

/**
 *  casheObject(返回的数据的)的Set方法
 *
 *  @param casheObject 返回的数据
 */
- (void)setCasheObject:(id)casheObject {
    _casheObject = casheObject;
    //保存
    [self saveJsonResponseToCasheFile:casheObject];
    
    
}



/**
 *  获取服务端返回的最后一次修改的时间
 *
 *  @return 最后一次修改时间字符串
 */
- (NSString*)lastTimeModified {
    
    if (self.isForceRefresh) {
        
        return nil;
    }
    if (self.isDataPolluted) {
        
        return nil;
    }
    
    if ([self cashePolicy] == ForceUpdate || self.ignoreCache) {
        
        //如果定义了当前必须强制的更新
        return nil;
        
    } else {
        
        NSString *lastTimeModify = [self casheVersionFileContent];
        
        if (!lastTimeModify) {
            
            return nil;
            
        } else
        {
            return lastTimeModify;
        }
        
    }
    
    
    
}

/**
 *  获取当前控制缓存的字符串
 *
 *  @return 响应头中控制缓存的字符串
 */
- (NSString*)casheControlstring {
    
    if (_reqStaticObject) {
        
        return self.reqStaticObject.CasheControl;
        
    } else
    {
        if ([self.storeManager isObjectExitAtKey:self.storeKey]) {
            
            _reqStaticObject = [self.storeManager getDataWithKey:self.storeKey];
            
            return _reqStaticObject.CasheControl;
            
        } else
        {
            return nil;
        
        }
       
        
    }
    
}

/**
 *  客户端最近一次获取数据的时间
 *
 *
 */
- (NSDate*)CustomUpdateTime {
    
    if (_reqStaticObject) {
        
        return self.reqStaticObject.updateTime;
        
    } else
    {
        
        if ([self.storeManager isObjectExitAtKey:self.storeKey]) {
            
            _reqStaticObject = [self.storeManager getDataWithKey:self.storeKey];
            
            return _reqStaticObject.updateTime;

        } else
        {
            return nil;
        
        }
        
    }
    
    
}

/**
 *  有效期
 *
 *  @return 一个有效期
 */
- (NSInteger)efficentTime {
    
    
    
    NSDate *date = [NSDate date];
    
    NSTimeInterval interval = [date timeIntervalSinceDate:[self CustomUpdateTime]];
    
    NSInteger efficent =  (NSInteger)interval;
    if (efficent <= 0) {
        
        efficent = 1;
    }
    
    return efficent;
    
}
/**
 *  过期的时间
 *
 *  @return 过期
 */
- (NSInteger)expireTime {
    
    NSString *str = [self casheControlstring];
    //    NSLog(@"%@",str);
    NSInteger max_age = [self getNSIntergerWithOriginaString:str WithSeperate:@"," andInder:0 andFromWhere:8];
    NSInteger stale_revalidate =  [self getNSIntergerWithOriginaString:str WithSeperate:@"," andInder:1 andFromWhere:23];
    
    return max_age + stale_revalidate;
    
    
}
/**
 *
 *
 *  @return 服务器返回的新鲜器
 */
- (NSInteger)freshTime {
    
    NSString *str = [self casheControlstring];
    
    NSLog(@"%@",str);
    
    NSInteger max_age = [self getNSIntergerWithOriginaString:str WithSeperate:@"," andInder:0 andFromWhere:8];
    if (max_age == 0) {
        
        return 0;
        
    } else {
        
        return max_age;
        
    }
    
    
}
/**
 *  得到casheControl中存储的max-age(新鲜期)和stale-while-revalidate两者用来计算过期时间这个时间段
 *
 *  @param original  原始的字符串
 *  @param seperator 分割的字符串
 *  @param index     第几个字段
 *  @param where     字段中的什么位置开始获取
 *
 *  @return
 */
- (NSInteger)getNSIntergerWithOriginaString:(NSString*)original WithSeperate:(NSString*)seperator andInder:(NSInteger)index andFromWhere:(NSInteger )where {
    
    NSArray *arr = [original componentsSeparatedByString:seperator];
    //    NSLog(@"%@",arr);
    if (index < arr.count) {
        
        NSString *maxAge = arr[index];
        
        //    NSLog(@"%@",maxAge);
        if (maxAge != nil) {
            
            if (where < maxAge.length) {
                NSString *intergerstring = [maxAge substringFromIndex:where];
                //    NSLog(@"%@",intergerstring);
                
                return [intergerstring integerValue];
                
            } else {
                
                return 0;
                
            }
            
            
        } else {
            
            return 0;
            
        }
    } else {
        
        return 0;
    }
    
    
    
    
}
//检测当前的网络

- (void)currentNetStatus:(U17NetStatus)netstatus {
    WS(weakSelf);
    self.U17Currentnetstatus = ^(BOOL isNetOK,BOOL isWifiOK,BOOL is3GOk ){
        if (netstatus) {
            
            netstatus(isNetOK,isWifiOK,is3GOk);
            
        }
        weakSelf.NetStatus = isNetOK;
        weakSelf.WIFIStatus = isWifiOK;
        weakSelf.WWANStatus = is3GOk;
        
    };
    
    [super checkNet];
    
    
}




//取消
- (void)cancel {
    
    [_task cancel];
    
}

//挂起
- (void)suspend {
    
    [_task suspend];
    
}

//恢复
- (void)resume {
    
    [_task resume];
    
}


@end
