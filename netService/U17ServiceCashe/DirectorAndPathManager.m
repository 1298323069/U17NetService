//
//  DirectorAndPathManager.m
//  AboutString
//
//  Created by liangkun on 16/11/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import "DirectorAndPathManager.h"
#import "LKCompat.h"
#import "OtherInfoConvert.h"
#import "U17NetworkPrivate.h"


@interface DirectorAndPathManager()

@property (nonatomic, strong) OtherInfoConvert *convert;

@end


@implementation DirectorAndPathManager


- (instancetype)init{
    
    
    if (self = [super init]) {
     
        
        self.convert = [[OtherInfoConvert alloc]init];
        
        
    }
    
    return self;
}

//Document路径
- (NSString*)basePathForDocument
{
    
    return [self getBasePathWith:NSDocumentDirectory];
    
    
}

//Cashe路径
- (NSString*)basePathForCashes
{
    
    return [self getBasePathWith:NSCachesDirectory];
    
    
}

//临时的路径
- (NSString*)basePahtForTmp
{
    
    return NSTemporaryDirectory();
    
}

- (NSString *)getBasePathWith:(NSSearchPathDirectory)directory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    
    return paths[0];
}

- (NSString *)makeDiskCashePathWith:(NSString *)string;
{
    
    if (!string) {
        
        ParamError
        
    }

   NSString *path = [[self basePathForCashes] stringByAppendingPathComponent:[self.convert getCrossLauguageStringFromString:string]];
    
    [self creatBaseDirectoryAtPath:path];
    
    return path;
    
}

- (void)creatBaseDirectoryAtPath:(NSString *)path {
    
    NSError *error = nil;
    //创建一个路径
    
    if(![[[NSFileManager alloc]init] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error] ) {
        
        [[[NSFileManager alloc]init] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
    }
    
    
    if (error) {
        //发生错误输出错误的原因
        NSLog(@"create cache directory fail error = %@",error);
    } else {
        //成功标记不备份
        [U17NetworkPrivate addNotBackUpAttribute:path];
    }
    
}

- (NSString *)makeKeyPathWithBasePath:(NSString *)basePath andKey:(NSString *)key
{
    if (!basePath || !key) {
        
        ParamError
        
    }
    
    return [basePath stringByAppendingPathComponent:key];

}


@end
