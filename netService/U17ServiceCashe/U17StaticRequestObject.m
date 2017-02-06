//
//  U17StaticRequestObject.m
//  U17_3.0
//
//  Created by liangkun on 17/2/3.
//  Copyright © 2017年 wyl. All rights reserved.
/*
 @property (nonatomic, strong) NSString *CompleteUrlString;
 
 @property (nonatomic, strong) NSString *lastModifiedTime;
 
 @property (nonatomic, strong) NSString *CasheControl;
 
 @property (nonatomic, strong) NSDate *updateTime;
 
 @property (nonatomic, strong) NSDictionary* casheObject;

 */

#import "U17StaticRequestObject.h"

@implementation U17StaticRequestObject

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.CompleteUrlString forKey:@"CompleteUrlString"];
    [aCoder encodeObject:self.lastModifiedTime forKey:@"lastModifiedTime"];
    [aCoder encodeObject:self.CasheControl forKey:@"CasheControl"];
    [aCoder encodeObject:self.updateTime forKey:@"updateTime"];
    [aCoder encodeObject:self.casheObject forKey:@"casheObject"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        
        self.CompleteUrlString = [aDecoder decodeObjectForKey:@"CompleteUrlString"];
        self.lastModifiedTime = [aDecoder decodeObjectForKey:@"lastModifiedTime"];
        self.CasheControl = [aDecoder decodeObjectForKey:@"CasheControl"];
        self.updateTime = [aDecoder decodeObjectForKey:@"updateTime"];
        self.casheObject = [aDecoder decodeObjectForKey:@"casheObject"];
    }
    return self;
}
@end
