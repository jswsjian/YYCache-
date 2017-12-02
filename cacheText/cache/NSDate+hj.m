//
//  NSDate+hj.m
//  hj
//
//  Created by jian huang on 2017/11/30.
//  Copyright © 2017年 hj. All rights reserved.
//

#import "NSDate+hj.h"

@implementation NSDate (hj)
-(BOOL)isEarlierDate:(NSDate *)otherDate{
    if ([self isEqualToDate:[self earlierDate:otherDate]]) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isLaterDate:(NSDate *)otherDate{
    if ([self isEqualToDate:[self laterDate:otherDate]]) {
        return YES;
    }else{
        return NO;
    }
}

@end
