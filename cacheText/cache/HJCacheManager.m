//
//  HJCacheManager.m
//  hj
//
//  Created by jian huang on 2017/4/21.
//  Copyright © 2017年 hj. All rights reserved.
//

#import "HJCacheManager.h"
#import "HJCacheModule.h"
#import "NSDate+hj.h"
#import "HJMemeCacheManager.h"

@interface HJCacheManager()

@property (nonatomic,strong) YYCache *cache;

@property (nonatomic,strong) NSString *path;


@end

@implementation HJCacheManager

+(NSString *)cachePath{
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    NSString *cachePath = [libPath stringByAppendingPathComponent:@"objectCache"];
    return cachePath;
}


+(NSInteger)fileSizeAtPath:( NSString *)filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
    
}


+(NSInteger)cacheBit{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath:[self cachePath]]){
         return 0 ;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :[self cachePath]] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [[self cachePath] stringByAppendingPathComponent :fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    return folderSize;
}

+(void)cleanAllCache:(void (^)(BOOL))backBlock{
    NSError *error = nil;
    NSArray *subFilePaths = [[ NSFileManager defaultManager ] contentsOfDirectoryAtPath:[self cachePath] error:&error];
    if (error) {
        NSLog(@"error:cache子路径获取有误");
        backBlock(NO);
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *errorTWO = nil;
        for (NSString *subFilePath in subFilePaths) {
            [[ NSFileManager defaultManager ] removeItemAtPath:[[self cachePath] stringByAppendingPathComponent: subFilePath] error :&errorTWO];
            if (error) {
                NSLog(@"error:子路径%@删除有误",subFilePath);
                backBlock(NO);
                return;
            }
        }
        [YYCache removeAllCacheList];
        dispatch_async(dispatch_get_main_queue(), ^{
            backBlock(YES);
        });
    });
}

-(instancetype)initWithName:(NSString *)name{
    if (self = [super init]) {
        NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
        NSString *cachePath = [libPath stringByAppendingPathComponent:@"objectCache"];
        self.path = [cachePath stringByAppendingPathComponent:name];
//        HJLog(@"%@",self.path);
        self.cache = [[YYCache alloc] initWithPath:self.path];
    }
    return self;
}

//内存缓存
-(void)saveMemeCacheData:(nullable id<NSCoding>)data withKey:( NSString * _Nonnull)key{
    [[HJMemeCacheManager shareInstance] saveMemeCacheData:data withKey:key];
}

-(void)saveMemeCacheData:(nullable id<NSCoding>)data withKey:(nonnull NSString *)key timeOut:(NSTimeInterval)timeOut{
    [[HJMemeCacheManager shareInstance] saveMemeCacheData:data withKey:key timeOut:timeOut];
}

-(nullable id<NSCoding>)memeCacheDataWithKey:(nonnull NSString *)key{
    return [[HJMemeCacheManager shareInstance] memeCacheDataWithKey:key];
}

-(void)removeAllMemeCache{
    return[[HJMemeCacheManager shareInstance] removeAllMemeCache];
}


-(void)saveData:(id<NSCoding>)data cacheType:(HJCacheType)cacheType cacheKey:(NSString *)key{
    if (cacheType == HJCacheTypeMeme) {
        [self saveMemeCacheData:data withKey:key];
    }else if (cacheType == HJCacheTypeFileOrDB){
        [self saveFileCache:data forKey:key];
    }
}

-(void)saveData:(id<NSCoding>)data cacheType:(HJCacheType)cacheType cacheKey:(NSString *)key timeout:(NSTimeInterval)interval{
    if (cacheType == HJCacheTypeMeme) {
        [self saveMemeCacheData:data withKey:key timeOut:interval];
    }else if (cacheType == HJCacheTypeFileOrDB){
        [self saveFileCache:data forKey:key timeot:interval];
    }
}


-(void)saveAllCacheWithData:(nullable id<NSCoding>)data cacheKey:(nonnull NSString *)key timeout:(NSTimeInterval)interval{
    [self saveMemeCacheData:data withKey:key timeOut:interval];
    [self saveFileCache:data forKey:key timeot:interval];
}


-(void)saveAllCacheWithData:(nullable id<NSCoding>)data cacheKey:(nonnull NSString *)key{
    [self saveMemeCacheData:data withKey:key];
    [self saveFileCache:data forKey:key];
}

-(id<NSCoding>)cacheDataWithKey:(NSString *)key{
    id <NSCoding> object = [self memeCacheDataWithKey:key];
    if (object) {
        return object;
    }else{
        return [self fileCacheForKey:key];
    }
}


//文件缓存
- (id<NSCoding>)fileCacheForKey:(NSString *)key{
    HJCacheModule *module = [self.cache objectForKey:key];
    if (module) {
        if (module.expirationDate) {
            if ([module.expirationDate isLaterDate:[NSDate date]]) {
                return module.data;
            }else{
                [self.cache removeObjectForKey:key];
                return nil;
            }
        }else{
            return module.data;
        }
    }else{
        return nil;
    }
}


- (void)fileCacheForKey:(NSString *)key withBlock:(void (^)(NSString *, id<NSCoding>))block{
    __weak HJCacheManager *weakSekf = self;
    [self.cache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        HJCacheModule *module = (HJCacheModule *)object;
        if (module) {
            if (module.expirationDate) {
                if ([module.expirationDate isLaterDate:[NSDate date]]) {
                    block(key,module.data);
                }else{
                    [weakSekf.cache removeObjectForKey:key];
                    block(key,nil);
                }
            }else{
                block(key,module.data);
            }
        }else{
            block(key,nil);
        }
    }];
}


- (void)saveFileCache:(id<NSCoding>)object forKey:(NSString *)key{
    HJCacheModule *module = [[HJCacheModule alloc] initWithData:object];
    [self.cache setObject:module forKey:key];
}

-(void)saveFileCache:(id<NSCoding>)object forKey:(NSString *)key timeot:(NSTimeInterval)interval{
    HJCacheModule *module = [[HJCacheModule alloc] initWithData:object timeOut:interval];
    [self.cache setObject:module forKey:key];
}


- (void)saveFileCache:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void (^)(void))block{
    HJCacheModule *module = [[HJCacheModule alloc] initWithData:object];
    [self.cache setObject:module forKey:key withBlock:block];
}

-(void)saveFileCache:(id<NSCoding>)object forKey:(NSString *)key timeot:(NSTimeInterval)interval withBlock:(void (^)(void))block{
    HJCacheModule *module = [[HJCacheModule alloc] initWithData:object timeOut:interval];
    [self.cache setObject:module forKey:key withBlock:block];
}

- (void)removeFileCacheForKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}


- (void)removeFileCacheForKey:(NSString *)key withBlock:(void (^)(NSString *))block{
    [self.cache removeObjectForKey:key withBlock:block];
}


- (void)removeAllFileCache{
    [self.cache removeAllObjects];
}


- (void)removeAllFileCacheWithBlock:(void (^)(void))block{
    [self.cache removeAllObjectsWithBlock:block];
}


- (void)removeAllFileCacheWithProgressBlock:(void (^)(int, int))progress endBlock:(void (^)(BOOL))end{
    [self.cache removeAllObjectsWithProgressBlock:progress endBlock:end];
}

@end
