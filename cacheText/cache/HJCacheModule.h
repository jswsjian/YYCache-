//
//  HJCacheModule.h
//  hj
//
//  Created by jian huang on 2017/11/22.
//  Copyright © 2017年 hj. All rights reserved.
//

#import "HJBasicModle.h"

@interface HJCacheModule : HJBasicModle
@property (nonatomic,strong) NSDate *beginDate;
//存储对象满足解档归档
@property (nonatomic,strong) id<NSCoding> data;

@property (nonatomic,strong) NSDate *expirationDate;

-(instancetype)initWithData:(id<NSCoding>)data timeOut:(NSTimeInterval)timeOut;

-(instancetype)initWithData:(id<NSCoding>)data;

@end
