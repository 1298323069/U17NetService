//
//  LKDisk.h
//  AboutString
//
//  Created by liangkun on 16/11/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCompat.h"

@interface LKDisk : NSObject

- (instancetype)initWithNameSpace:(NSString *)nameSpace;

//主线程获取获取数据对象
- (NSData*)dataFromDiskCasheForKey:(NSString *)key;

//保存对象
- (void)saveObject:(id)object ToDiskPathWithKey:(NSString *)key;

//删除指定对象
- (void)clearObjectForKey:(NSString *)key and:(noParamterBlock)completed;

//删除所有对象
- (void)clearAllDiskCashe:(noParamterBlock)completed;

//获取缓存对象数量
- (void)getDiskCasheObjectCount:(void(^)(NSInteger cout))results;

//获取当前缓存的大小和缓存文件的数量
- (void)calculateSizeWithCompletionBlock:(ParamterBlock)completed;

//当前的路径上是否存在此key对应的存储
- (BOOL)diskDataExistWithKey:(NSString *)key;

@end
