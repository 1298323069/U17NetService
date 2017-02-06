//
//  ResultObject.h
//  AboutString
//
//  Created by liangkun on 16/11/8.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultObject : NSObject

@property (nonatomic, assign) BOOL isOperationSuccess;

@property (nonatomic, strong) id  anyObject;

@property (nonatomic, assign) NSUInteger fileSize;

@property (nonatomic, assign) NSUInteger fileCount;


@end
