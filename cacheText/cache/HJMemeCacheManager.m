//
//  HJMemeCacheManager.m
//  hj
//
//  Created by jian huang on 2017/11/30.
//  Copyright © 2017年 hj. All rights reserved.
//

#import "HJMemeCacheManager.h"
#import "HJCacheModule.h"
#import "NSDate+hj.h"

@interface HJMemeCacheManager()<NSCacheDelegate>
@property (nonatomic,strong) NSCache *memeCache;
@end

@implementation HJMemeCacheManager

+(HJMemeCacheManager *)shareInstance{
    static dispatch_once_t once;
    static HJMemeCacheManager *instance =nil;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if (self = [super init]) {
        self.memeCache = [[NSCache alloc] init];
        self.memeCache.delegate = self;
    }
    return self;
}


-(void)saveMemeCacheData:(id<NSCoding>)data withKey:(NSString *)key{
    [self saveMemeCacheData:data withKey:key timeOut:-1];
}

-(void)saveMemeCacheData:(id<NSCoding>)data withKey:(NSString *)key timeOut:(NSTimeInterval)timeOut{
    HJCacheModule *module = [[HJCacheModule alloc] initWithData:data timeOut:timeOut];
    [self.memeCache setObject:module forKey:key];
}

-(id<NSCoding>)memeCacheDataWithKey:(NSString *)key{
    HJCacheModule *module = [self.memeCache objectForKey:key];
    if (module) {
        if (module.expirationDate && [module.expirationDate isEarlierDate:[NSDate date]]) {
            return nil;
        }else{
            return module.data;
        }
    }else{
        return nil;
    }
}

-(void)removeMemeCacheWithKey:(NSString *)key{
    [self.memeCache removeObjectForKey:key];
}

-(void)removeAllMemeCache{
    [self.memeCache removeAllObjects];
}


@end
