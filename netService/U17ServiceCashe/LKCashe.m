//
//  LKCashe.m
//  AboutString
//
//  Created by liangkun on 16/11/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import "LKCashe.h"

#import "LKCompat.h"
#import "OtherInfoConvert.h"



@interface LKCashe()

@property (nonatomic, strong) OtherInfoConvert *convert;

@property (nonatomic, strong) NSCache *lkStoreCache;

@end

@implementation LKCashe

- (instancetype)init{

    if (self = [super init]) {
      
    self.lkStoreCache = [[NSCache alloc]init];
        
    self.convert = [[OtherInfoConvert alloc]init];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    
    return self;
}


- (void)clearAllObjects
{
    [self.lkStoreCache removeAllObjects];
}

- (void)casheObject:(id)object key:(NSString *)key
{
    if (object && key) {
        
         [self.lkStoreCache setObject:object forKey:[self.convert getCrossLauguageStringFromString:key]];
        
    } else
    {
        
        ParamError
    }
    
}

- (id)cashedObjectForKey:(NSString *)key
{
    
    
    id  t = [self.lkStoreCache objectForKey:[self.convert getCrossLauguageStringFromString:key]];
    
    if (!t ) {
        
        CasheError
        
    }
    
    return t;
    
}
- (void)clearObjectForkey:(NSString *)key
{
    [self.lkStoreCache removeObjectForKey:[self.convert getCrossLauguageStringFromString:key]];
    
}

@end
