//
//  LKCashe.h
//  AboutString
//
//  Created by liangkun on 16/11/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKCashe : NSObject



@property (nonatomic, assign) NSInteger maxMemoryCost; //内存缓存的最大占用数

@property (nonatomic, assign) NSInteger maxMemoryObjectNum; //最大缓存对象数量

//保存需要缓存的对象
- (void)casheObject:(id)object key:(NSString*)key;

//获取当前缓存对象
- (id)cashedObjectForKey:(NSString *)key;

//删除对象
- (void)clearObjectForkey:(NSString *)key;



@end
