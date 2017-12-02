//
//  HJCacheModule.m
//  hj
//
//  Created by jian huang on 2017/11/22.
//  Copyright © 2017年 hj. All rights reserved.
//

#import "HJCacheModule.h"

@implementation HJCacheModule

- (instancetype)initWithData:(id<NSCoding>)data timeOut:(NSTimeInterval)timeOut{
    self = [super init];
    if (self) {
        self.data = data;
        self.beginDate = [NSDate date];
        if (timeOut>=0) {
            self.expirationDate = [NSDate dateWithTimeInterval:timeOut sinceDate:self.beginDate];
        }
    }
    return self;
}

-(instancetype)initWithData:(id<NSCoding>)data{
    return [self initWithData:data timeOut:-1];
}

@end
