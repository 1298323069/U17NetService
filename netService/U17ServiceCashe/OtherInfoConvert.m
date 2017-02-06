//
//  OtherInfoConvert.m
//  AboutString
//
//  Created by liangkun on 16/11/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import "OtherInfoConvert.h"
#import <CommonCrypto/CommonDigest.h>

@implementation OtherInfoConvert
- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}

- (NSString *)getCrossLauguageStringFromString:(NSString *)anyString
{

    return [self FileNameForKey:anyString];
    
}
-(NSString *)FileNameForKey:(NSString *)key
{
    
    const char *str = [key UTF8String]; //跨越不同语言系统
    if (str == NULL) {
        
        str = "";
        
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), r);
    
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];
    
    return filename;
    
}
@end
