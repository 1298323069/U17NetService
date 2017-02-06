//
//  LKStoreManager.h
//  AboutString
//
//  Created by liangkun on 16/11/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCompat.h"


@interface LKStoreManager : NSObject

// 获取单利
+(instancetype)shareStoreManager;

//保存数据到对应的key上
- (void)saveObject:(id)object  WithKey:(NSString *)key;

//获取保存对应key上的对象
- (id )getDataWithKey:(NSString *)key;

//在key上是否保存有内容
- (BOOL)isObjectExitAtKey:(NSString *)key;

//删除磁盘中所有的缓存
- (void)clearAllDiskCashe:(noParamterBlock)completed;

@end
