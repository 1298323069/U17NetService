//
//  LKDisk.m
//  AboutString
//
//  Created by liangkun on 16/11/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import "LKDisk.h"
#import "LKCompat.h"
#import "DirectorAndPathManager.h"
#import "ResultObject.h"
#import "U17StaticRequestObject.h"


@interface LKDisk()<NSFileManagerDelegate>


@property (nonatomic, strong) DirectorAndPathManager *lkpathManager;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSString *baseCashePath;

@property (nonatomic, strong) NSOperationQueue *ioQueue;

@end

@implementation LKDisk

- (instancetype)init
{
    self = [super init];
    
    if (self) {
       
        
    }
    return self;

}

- (instancetype)initWithNameSpace:(NSString *)nameSpace
{
    self = [super init];
    if (self) {
        
        //文件管理对象
        self.fileManager = [NSFileManager defaultManager];
        
        self.fileManager.delegate = self;
        
        self.lkpathManager = [[DirectorAndPathManager alloc]init];
        
        
        self.baseCashePath = [self.lkpathManager makeDiskCashePathWith:nameSpace];
        
        NSError *error;
        
        //在baseCashePath上创建一个路径
        [[[NSFileManager alloc]init] createDirectoryAtPath:self.baseCashePath withIntermediateDirectories:YES attributes:nil error:&error];
        
        _ioQueue = [[NSOperationQueue alloc]init];
        
        _ioQueue.maxConcurrentOperationCount = 1;
       
       

        
    }
    
    return self;

}

//某个key对应的存储路径
- (NSString*)defaultCashePathForKey:(NSString *)key
{
    
    
   
    NSString *keyPathStr = [_lkpathManager makeKeyPathWithBasePath:self.baseCashePath andKey:key];
    
    return keyPathStr;
}




- (BOOL)diskDataExistWithKey:(NSString *)key
{
    BOOL exit = NO;
    
    exit = [[NSFileManager defaultManager]fileExistsAtPath:[self defaultCashePathForKey:key]];
    
    if (!exit) {
        
        exit = [[NSFileManager defaultManager]fileExistsAtPath:[[self defaultCashePathForKey:key] stringByDeletingPathExtension]];
        
    }
    
    return exit;
}



- (id)dataFromDiskCasheForKey:(NSString *)key
{
    
    //得到路径解档相关的错误
    NSString *keyPath = [self defaultCashePathForKey:key];
    
    id data  = [NSKeyedUnarchiver unarchiveObjectWithFile:keyPath];

    
    if (data) {
        
        return data;
        
    }
    

    
    return nil;
    
}

- (void)clearObjectForKey:(NSString *)key and:(noParamterBlock)completed
{
    
    if (!key) {
        
        return;
    }
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        [_fileManager removeItemAtPath:[self defaultCashePathForKey:key] error:nil];
        
        if (completed) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completed();
                
            });
            
        }
    }];
    
    
    [_ioQueue addOperation:operation];
    
}

- (void)clearAllDiskCashe:(noParamterBlock)completed
{
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
       
        [_fileManager removeItemAtPath:self.baseCashePath error:nil];
        
        
        [_fileManager createDirectoryAtPath:self.baseCashePath withIntermediateDirectories:YES attributes:nil error:NULL];
        
        if (completed) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completed();
                
            });
        }
        
    }];
    
    [_ioQueue addOperation:operation];
    
}

- (void)getDiskCasheObjectCount:(void (^)(NSInteger))results
{
    __block NSUInteger count = 0;
    
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.baseCashePath];
        
        count =  [[fileEnumerator allObjects] count];
      
        if (results) {
            
            results(count);
        }

        
    }];
    
    [_ioQueue addOperation:operation];
    
}

- (void)calculateSizeWithCompletionBlock:(ParamterBlock)completed
{
    
    
    NSURL *diskCasheURL = [NSURL fileURLWithPath:self.baseCashePath isDirectory:YES];
    
    NSOperation *opeartion = [NSBlockOperation blockOperationWithBlock:^{
        
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumator = [_fileManager enumeratorAtURL:diskCasheURL includingPropertiesForKeys:@[NSFileSize] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
        
        
        for (NSURL *url in fileEnumator) {
            
            NSNumber *fileSize;
            
            [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:nil];
            
            totalSize += [fileSize unsignedIntegerValue];
            
            fileCount += 1;
            
        }
        
        if (completed) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ResultObject *object = [[ResultObject alloc]init];
                
                object.fileSize = totalSize;
                
                object.fileCount = fileCount;
                
                completed(object);
                
            });
        }

       
        
    }];
    
    [_ioQueue addOperation:opeartion];
}

- (void)saveObject:(id)object ToDiskPathWithKey:(NSString *)key
{
    
    
    U17StaticRequestObject *object1 = (U17StaticRequestObject*)object;
    
    
    if (key) {
        
        
       
        
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
//             NSData *data  = [NSKeyedArchiver archivedDataWithRootObject:object1];
            
            NSString *filepath = [self defaultCashePathForKey:key];

//            [data writeToFile:filepath atomically:YES];
            
            [NSKeyedArchiver archiveRootObject:object1 toFile:filepath];
            
           
        }];
        
        [_ioQueue addOperation:operation];
        
        return;
       
    }
    
    ParamError
    
    
}


- (NSData *)getDataWith:(id)object{
    

     if ([NSPropertyListSerialization propertyList:object isValidForFormat:NSPropertyListBinaryFormat_v1_0])
    {
        return [NSPropertyListSerialization dataWithPropertyList:object format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:nil];
        
    
    } else if ( [NSPropertyListSerialization propertyList:object isValidForFormat:NSPropertyListXMLFormat_v1_0] ) {
        
        return [NSPropertyListSerialization dataWithPropertyList:object format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:nil];
        
    }
    
    
    ParamError
    
    return nil;
    
}

@end
