//
//  U17StaticRequestObject.h
//  U17_3.0
//
//  Created by liangkun on 17/2/3.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface U17StaticRequestObject : NSObject

@property (nonatomic, strong) NSString *CompleteUrlString;

@property (nonatomic, strong) NSString *lastModifiedTime;

@property (nonatomic, strong) NSString *CasheControl;

@property (nonatomic, strong) NSDate *updateTime;

@property (nonatomic, strong) NSDictionary* casheObject;

@end
