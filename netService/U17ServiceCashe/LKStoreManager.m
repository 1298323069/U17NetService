//
//  LKStoreManager.m
//  AboutString
//
//  Created by liangkun on 16/11/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import "LKStoreManager.h"
#import "LKCompat.h"
#import "LKCashe.h"
#import "LKDisk.h"

@interface LKStoreManager()

@property (nonatomic, strong) LKCashe *memeryCashe;

@property (nonatomic, strong) LKDisk *diskCashe;

@end

@implementation LKStoreManager

+(instancetype)shareStoreManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
       
        instance = [self new];
        
    });
    
    return instance;
    
}

- (instancetype)init
{
    self = [super init];
    
    
    if (self) {
        
        self.memeryCashe = [[LKCashe alloc]init];
        
        self.diskCashe = [[LKDisk alloc]initWithNameSpace:@"u17comicv3"];
         
    }
    return self;
    
}

//保存对象
- (void)saveObject:(id)object  WithKey:(NSString *)key
{
    
    [_memeryCashe casheObject:object key:key];
    
    [_diskCashe saveObject:object ToDiskPathWithKey:key];

}

- (id )getDataWithKey:(NSString *)key
{
   id object = [_memeryCashe cashedObjectForKey:key];
    
    if (object) {
        
        return object;
        
    } else
    {
        id object = [_diskCashe dataFromDiskCasheForKey:key];
        
        [_memeryCashe casheObject:object key:key];
        
        return object;
    }
}

- (BOOL)isObjectExitAtKey:(NSString *)key
{
    
    BOOL exit = [_diskCashe diskDataExistWithKey:key];
    
    return exit;
    
}

- (void)clearAllDiskCashe:(noParamterBlock)completed
{
    
    [self.diskCashe clearAllDiskCashe:completed];

}

@end
