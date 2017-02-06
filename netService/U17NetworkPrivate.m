//
//  U17NetworkPrivate.m
//  testWeb
//
//  Created by liangkun on 16/1/6.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import "U17NetworkPrivate.h"
#import <sys/utsname.h>
#define CC_MD5_DIGEST_LENGTH 16

@implementation U17NetworkPrivate

//使用参数字典获取在URL中的参数字符
+ (NSString*)urlParametersStringFromParameters:(NSDictionary*)parameters {
    
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self urlEncode:value];
            [urlParametersString appendFormat:@"&%@=%@", key, value];
        }
    }
    return urlParametersString;


}

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    
    //原始的路径
    NSString *filteredUrl = originUrlString;
    //参数转换的路径
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    
    //如果字符不为空
    if (paraUrlString && paraUrlString.length > 0) {
        //原始路径中有表示拼接的字符？号
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            //原始路径中没有表示拼接的字符。
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    } else {
        
        return originUrlString;
    }
    
}

+ (NSString*)urlEncode:(NSString*)str {
    
    //different library use slightly different escaped and unescaped set.
    //below is copied from AFNetworking but still escaped [] as AF leave them for Rails array parameter which we don't use.
    //https://github.com/AFNetworking/AFNetworking/pull/555
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}
//添加不会备份的文件路径
+ (void)addNotBackUpAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    
    if (error) {
        
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }


}

//获得MD5加密以后的字符串
+ (NSString*)MD5StringFromString:(NSString *)string {
    
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    
    

}
//获得当前的版本号
+ (NSString*)appVersionString {
    
return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//+ (NSString*)deviceName {
//
//    @try {
//        
//        struct utsname systemInfo;
//        
//        uname(&systemInfo);
//        
//        NSString* code = [NSString stringWithCString:systemInfo.machine
//                                            encoding:NSUTF8StringEncoding];
//        
//         NSDictionary* deviceNamesByCode = nil;
//        
//        if (!deviceNamesByCode) {
//            
//            deviceNamesByCode = @{@"i386"      :@"Simulator",
//                                  @"x86_64"    :@"Simulator",
//                                  @"iPod1,1"   :@"iPod Touch",      // (Original)
//                                  @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
//                                  @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
//                                  @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
//                                  @"iPod7,1"   :@"iPod Touch",      // (6th Generation)
//                                  @"iPhone1,1" :@"iPhone",          // (Original)
//                                  @"iPhone1,2" :@"iPhone",          // (3G)
//                                  @"iPhone2,1" :@"iPhone",          // (3GS)
//                                  @"iPad1,1"   :@"iPad",            // (Original)
//                                  @"iPad2,1"   :@"iPad 2",          //
//                                  @"iPad3,1"   :@"iPad",            // (3rd Generation)
//                                  @"iPhone3,1" :@"iPhone 4",        // (GSM)
//                                  @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
//                                  @"iPhone4,1" :@"iPhone 4S",       //
//                                  @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
//                                  @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
//                                  @"iPad3,4"   :@"iPad",            // (4th Generation)
//                                  @"iPad2,5"   :@"iPad Mini",       // (Original)
//                                  @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
//                                  @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
//                                  @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
//                                  @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
//                                  @"iPhone7,1" :@"iPhone 6 Plus",   //
//                                  @"iPhone7,2" :@"iPhone 6",        //
//                                  @"iPhone8,1" :@"iPhone 6S",       //
//                                  @"iPhone8,2" :@"iPhone 6S Plus",  //
//                                  @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
//                                  @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
//                                  @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
//                                  @"iPad4,5"   :@"iPad Mini",       // (2nd Generation iPad Mini - Cellular)
//                                  @"iPad4,7"   :@"iPad Mini"        // (3rd Generation iPad Mini - Wifi (model A1599))
//                                  };
//        }
//        
//        NSString* deviceName;
//        
//        if ([code isKindOfClass:[NSString class]]) {
//            
//            if ([deviceNamesByCode[code] isKindOfClass:[NSString class]]) {
//                
//                 deviceName = deviceNamesByCode[code];
//                
//            } else {
//            
//            deviceName = @"Unknown";
//                
//            }
//           
//            
//            
//            
//        }
//        
//        if ([deviceName isKindOfClass:[NSString class]]) {
//            // Not found on database. At least guess main device type from string contents:
//            
//            if ([code rangeOfString:@"iPod"].location != NSNotFound) {
//                deviceName = @"iPod Touch";
//            }
//            else if([code rangeOfString:@"iPad"].location != NSNotFound) {
//                deviceName = @"iPad";
//            }
//            else if([code rangeOfString:@"iPhone"].location != NSNotFound){
//                deviceName = @"iPhone";
//            }
//            else {
//                deviceName = @"Unknown";
//            }
//        }
//        
//        return deviceName;
//
//    } @catch (NSException *exception) {
//        
//        return @"Unknown";
//        
//    } @finally {
//        
//    }
//    
//}


+ (NSString*) deviceName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    NSDictionary* deviceNamesByCode = nil;
    
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{
                              /*
                               *******模拟器**********
                               */
                              @"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              /*
                               *******iPod**********
                               */
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch",      // (6th Generation)
                              
                              /*
                               *******iPad**********
                               */
                          @"iPad1,1"   :@"iPad 1",            // (Original)
                             
                              @"iPad2,1"   :@"iPad 2",
                              @"iPad2,2"   :@"iPad 2",
                              @"iPad2,3"   :@"iPad 2",
                              @"iPad2,4"   :@"iPad 2",
                              
                              
                              @"iPad2,5"   :@"iPad Mini",
                              @"iPad2,6"   :@"iPad Mini",
                              @"iPad2,7"   :@"iPad Mini",
                              
                              @"iPad3,1"   :@"iPad 3",
                              @"iPad3,2"   :@"iPad 3",
                              @"iPad3,3"   :@"iPad 3",

                              @"iPad3,4"   :@"iPad 4",
                              @"iPad3,5"   :@"iPad 4",
                              @"iPad3,6"   :@"iPad 4",
                              
                              @"iPad4,1"   :@"iPad AIR",
                              @"iPad4,2"   :@"iPad AIR",
                              @"iPad4,3"   :@"iPad AIR",
                              
                              @"iPad4,4"   :@"iPad Mini 2",
                              @"iPad4,5"   :@"iPad Mini 2",
                              @"iPad4,6"   :@"iPad Mini 2",
                              
                              @"iPad4,7"   :@"iPad Mini 3",
                              @"iPad4,8"   :@"iPad Mini 3",
                              @"iPad4,9"   :@"iPad Mini 3",
                              
                              @"iPad5,1"   :@"iPad Mini 4",
                              @"iPad5,2"   :@"iPad Mini 4",

                              @"iPad5,3"   :@"iPad AIR 2",
                              @"iPad5,4"   :@"iPad AIR 2",
                             
                              @"iPad6,3"   :@"iPad PRO 12.9",
                              @"iPad6,4"   :@"iPad PRO 12.9",
                              @"iPad6,4"   :@"iPad PRO 12.9",
                              
                              @"iPad6,7"   :@"iPad PRO 9.7",
                              @"iPad6,8"   :@"iPad PRO 9.7",

                              
                              /*
                               *******iPhone**********
                               */
                            @"iPhone1,1" :@"iPhone",          // (Original)
                            @"iPhone1,2" :@"iPhone 3G",          // (3G)
                          @"iPhone2,1" :@"iPhone 3GS",          // (3GS)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6S",       //
                              @"iPhone8,2" :@"iPhone 6S Plus",  //
                               @"iPhone8,2" :@"iPhone 6S Plus",  //
                              @"iPhone8,4" :@"iPhone SE",
                              @"iPhone9,1" :@"iPhone 7 ",
                              @"iPhone9,3" :@"iPhone 7 ",
                              
                              @"iPhone9,2" :@"iPhone 7 Plus",
                              @"iPhone9,4" :@"iPhone 7 Plus"
                              
                              
                              };
    }

    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
    }
    
    return deviceName;
}
@end
