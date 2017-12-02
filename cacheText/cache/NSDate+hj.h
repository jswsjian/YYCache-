//
//  NSDate+hj.h
//  hj
//
//  Created by jian huang on 2017/11/30.
//  Copyright © 2017年 hj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (hj)
//是否比另一个时间早
-(BOOL)isEarlierDate:(NSDate *)otherDate;
//是否比另一个时间晚
-(BOOL)isLaterDate:(NSDate *)otherDate;


@end
