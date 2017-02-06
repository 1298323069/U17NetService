//
//  DirectorAndPathManager.h
//  AboutString
//
//  Created by liangkun on 16/11/7.
//  Copyright © 2016年 liangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DirectorAndPathManager : NSObject


- (instancetype)init;

- (NSString *)basePathForCashes;

- (NSString *)basePathForDocument;

- (NSString *)basePahtForTmp;

- (NSString *)makeDiskCashePathWith:(NSString *)nameSpace;

- (NSString *)makeKeyPathWithBasePath:(NSString *)basePath andKey:(NSString *)key;


@end
