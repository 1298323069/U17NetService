//
//  LKCompat.h
//  AboutString
//
//  Created by liangkun on 16/11/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//
#import <TargetConditionals.h>

#import <UIKit/UIKit.h>

#import "ResultObject.h"

extern NSString *const CasheErrorDomain;

extern NSString *const DiskErrorDomain;

extern NSString *const paramterErrorDomain;

typedef void(^noParamterBlock)();

typedef void(^ParamterBlock)(ResultObject *result);


#define ParamError NSLog(@"%@", paramterErrorDomain);

#define CasheError NSLog(@"%@", CasheErrorDomain);

#define DiskError NSLog(@"%@", DiskErrorDomain);

