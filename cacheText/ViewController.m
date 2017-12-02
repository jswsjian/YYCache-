//
//  ViewController.m
//  cacheText
//
//  Created by jian huang on 2017/12/1.
//  Copyright © 2017年 hj. All rights reserved.
//

#import "ViewController.h"
#import "HJCacheManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    HJCacheManager *mananger = [[HJCacheManager alloc] initWithName:@"commom"];
//    [mananger saveMemeCacheData:@"内存存储" withKey:@"one"];
//    NSLog(@"----%@,%@,%@",[mananger cacheDataWithKey:@"one"],[mananger memeCacheDataWithKey:@"one"],[mananger fileCacheForKey:@"one"]);
////    [mananger removeAllFileCache];
////    [mananger removeAllMemeCache];
//    NSLog(@"----%@,%@,%@",[mananger cacheDataWithKey:@"one"],[mananger memeCacheDataWithKey:@"one"],[mananger fileCacheForKey:@"one"]);
//
//    [mananger saveFileCache:@"磁盘存储" forKey:@"one"];
//    NSLog(@"----%@,%@,%@",[mananger cacheDataWithKey:@"one"],[mananger memeCacheDataWithKey:@"one"],[mananger fileCacheForKey:@"one"]);
//    [mananger removeAllFileCache];
//    [mananger removeAllMemeCache];
//    [HJCacheManager cleanAllCache:^(BOOL sucess) {
//        NSLog(@"%@r",sucess?@"成功":@"失败");
//        NSLog(@"----%@,%@,%@",[mananger cacheDataWithKey:@"one"],[mananger memeCacheDataWithKey:@"one"],[mananger fileCacheForKey:@"one"]);
//        [mananger removeAllMemeCache];
//        NSLog(@"----------------------------");
//        HJCacheManager *NEWmananger = [[HJCacheManager alloc] initWithName:@"commom"];
//        [NEWmananger saveMemeCacheData:@"新磁盘存储" withKey:@"one"];
//        [NEWmananger saveFileCache:@"新磁盘存储" forKey:@"one" withBlock:^{
//            NSLog(@"----%@,%@,%@",[NEWmananger cacheDataWithKey:@"one"],[NEWmananger memeCacheDataWithKey:@"one"],[NEWmananger fileCacheForKey:@"one"]);
//        }];
//
//    }];
//    NSLog(@"%@",[HJCacheManager cachePath]);
    //    NSLog(@"----%@,%@,%@",[mananger cacheDataWithKey:@"one"],[mananger memeCacheDataWithKey:@"one"],[mananger fileCacheForKey:@"one"]);
    
    HJCacheManager *mananger = [[HJCacheManager alloc] initWithName:@"commom"];
    [mananger removeAllFileCache];
//    [mananger saveMemeCacheData:@"内存缓存5秒" withKey:@"two" timeOut:5];
    [mananger saveFileCache:@"磁盘缓存5秒" forKey:@"two" timeot:5];
    [self performSelector:@selector(click3) withObject:nil afterDelay:3];
    [self performSelector:@selector(click5) withObject:nil afterDelay:6];
}

-(void)click3{
    HJCacheManager *mananger = [[HJCacheManager alloc] initWithName:@"commom"];
    NSLog(@"三秒后---%@,%@,%@",[mananger cacheDataWithKey:@"two"],[mananger memeCacheDataWithKey:@"two"],[mananger fileCacheForKey:@"two"]);
}

-(void)click5{
    HJCacheManager *mananger = [[HJCacheManager alloc] initWithName:@"commom"];
    NSLog(@"五秒后--%@,%@,%@",[mananger cacheDataWithKey:@"two"],[mananger memeCacheDataWithKey:@"two"],[mananger fileCacheForKey:@"two"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
