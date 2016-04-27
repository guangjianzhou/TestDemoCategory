//
//  RongCloudManager.h
//  TestDemo
//
//  Created by guangjianzhou on 16/4/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestFinishBlock)(id obj);
typedef void(^RequestFailBlock)(id error);


@interface RongCloudManager : NSObject

+ (instancetype)sharedClient;


/**
 * 在 App 整个生命周期，您只需要调用一次此方法与融云服务器建立连接。之后无论是网络出现异常或者 App 有前后台的切换等，SDK 都会负责自动重连
 *
 *  @param token     
 */

//{"code":200,"userId":"zgj","token":"AoQTzYnzDFgn/mjQkNcVo3N0yddEZlNTIEYvaFgPD2YT/2c4aXMq0IOVpI08DDgMCPdFLS3tKEQ="}



//{"code":200,"userId":"hxy","token":"PTTJNs+2OZG2hKvtjBrw9E/vU2PbNVbN6a7wKvjww07IIhbLBBnkpewMkhXeLWns2lvXNkyZZQ8="}

- (void)connectRongCloudWithToken:(NSString *)token
                      finishBlock:(RequestFinishBlock)successBlock
                        failBlock:(RequestFailBlock)failBlock;

@end
