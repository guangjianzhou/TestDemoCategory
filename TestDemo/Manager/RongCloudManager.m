


//
//  RongCloudManager.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "RongCloudManager.h"
#import <RongIMKit/RongIMKit.h>

@interface RongCloudManager ()

@end

@implementation RongCloudManager

+ (instancetype)sharedClient
{
    static RongCloudManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RongCloudManager alloc] init];
    });
    return _sharedClient;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    
}

#pragma mark  - 连接融云服务器
- (void)connectRongCloudWithToken:(NSString *)token finishBlock:(RequestFinishBlock)successBlock failBlock:(RequestFailBlock)failBlock
{
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        if(successBlock)
        {
            successBlock(userId);
        }
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
        if (failBlock)
        {
            failBlock(@(status));
        }
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
        if (failBlock)
        {
            failBlock(@"token错误");
        }
    }];
}


@end
