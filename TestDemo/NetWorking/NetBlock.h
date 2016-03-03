//
//  NetBlock.h
//  ZHCloudManager
//
//  Created by guangjianzhou on 15/12/11.
//  Copyright © 2015年 song song. All rights reserved.
//

#ifndef NetBlock_h
#define NetBlock_h

typedef void(^NetRequestFinishBlock)(id responserObj);
typedef void(^NetRequestFailBlock)(NSError *error);
typedef void(^NetRequestErrorBlock)(NSError *error);


//下载
typedef void(^NetDownLoadCompletionBlock)(id object);
typedef void(^NetDownLodingBlock)(float percent);
typedef void(^NetDownLoadFailBlock)(NSError *error);

//上传
typedef void(^NetUpLoadCompletionBlock)(id object);
typedef void(^NetUpLodingBlock)(float percent);
typedef void(^NetUpLoadFailBlock)(NSError *error);

#define  kEntityModel  @"CallRecentEntity"

#endif /* NetBlock_h */
