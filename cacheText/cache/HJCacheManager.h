//
//  HJCacheManager.h
//  hj
//
//  Created by jian huang on 2017/4/21.
//  Copyright © 2017年 hj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"

typedef enum{
    HJCacheTypeMeme,
    HJCacheTypeFileOrDB
}HJCacheType;

@interface HJCacheManager : NSObject

+(nonnull NSString *)cachePath;

+(void)cleanAllCache:(void(^)(BOOL sucess))backBlock;

+(NSInteger)cacheBit;



-(instancetype)initWithName:(NSString *_Nullable)name;

-(void)saveMemeCacheData:(nullable id<NSCoding>)data withKey:( NSString * _Nonnull)key;

-(void)saveMemeCacheData:(nullable id<NSCoding>)data withKey:(nonnull NSString *)key timeOut:(NSTimeInterval)timeOut;

-(nullable id<NSCoding>)memeCacheDataWithKey:(nonnull NSString *)key;

-(void)removeAllMemeCache;


-(void)saveData:(nullable id<NSCoding>)data cacheType:(HJCacheType)cacheType cacheKey:(nonnull NSString *)key timeout:(NSTimeInterval)interval;

-(void)saveData:(nullable id<NSCoding>)data cacheType:(HJCacheType)cacheType cacheKey:(nonnull NSString *)key;


-(void)saveAllCacheWithData:(nullable id<NSCoding>)data cacheKey:(nonnull NSString *)key timeout:(NSTimeInterval)interval;


-(void)saveAllCacheWithData:(nullable id<NSCoding>)data cacheKey:(nonnull NSString *)key;


-(nullable id<NSCoding>)cacheDataWithKey:(nonnull NSString *)key;



- (nullable id<NSCoding>)fileCacheForKey:(nonnull NSString *)key;

- (void)fileCacheForKey:(nonnull NSString *)key withBlock:(nullable void(^)( NSString *key, id<NSCoding> object))block;


- (void)saveFileCache:(nullable id<NSCoding>)object forKey:(nonnull NSString *)key;

-(void)saveFileCache:(nullable id<NSCoding>)object forKey:(nonnull NSString *)key timeot:(NSTimeInterval)interval;

- (void)saveFileCache:(nullable id<NSCoding>)object forKey:(nonnull NSString *)key withBlock:(nullable void(^)(void))block;

- (void)saveFileCache:(nullable id<NSCoding>)object forKey:(nonnull NSString *)key timeot:(NSTimeInterval)interval withBlock:(nullable void(^)(void))block;

- (void)removeFileCacheForKey:(nonnull NSString *)key;


- (void)removeFileCacheForKey:(nonnull NSString *)key withBlock:(nullable void(^)(NSString *key))block;


- (void)removeAllFileCache;


- (void)removeAllFileCacheWithBlock:(nullable void(^)(void))block;


- (void)removeAllFileCacheWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                                 endBlock:(nullable void(^)(BOOL error))end;

@end
