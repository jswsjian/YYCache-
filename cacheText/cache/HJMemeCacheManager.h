//
//  HJMemeCacheManager.h
//  hj
//
//  Created by jian huang on 2017/11/30.
//  Copyright © 2017年 hj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJMemeCacheManager : NSObject
+(HJMemeCacheManager *)shareInstance;

/**
 *  @Author 刘宝, 2015-10-14 13:10:25
 *
 *  永久缓存内存数据对象
 *
 *  @param data 数据
 *  @param key  关键字
 */
-(void)saveMemeCacheData:(nullable id<NSCoding>)data withKey:(nonnull NSString *)key;

-(void)saveMemeCacheData:(nullable id<NSCoding>)data withKey:(nonnull NSString *)key timeOut:(NSTimeInterval)timeOut;

/**
 *  @Author 刘宝, 2015-10-14 13:10:34
 *
 *  根据关键字获取内存缓存数据
 *
 *  @param key 关键字
 *
 *  @return 缓存数据
 */
-(nullable id<NSCoding>)memeCacheDataWithKey:(nonnull NSString *)key;

-(void)removeMemeCacheWithKey:(nonnull NSString *)key;

-(void)removeAllMemeCache;

@end
