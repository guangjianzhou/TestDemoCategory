//
//  NetAPIClient.h
//  ZHCloudManager
//
//  Created by guangjianzhou on 15/12/11.
//  Copyright © 2015年 song song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetBlock.h"

/**
 网络请求类型
 */
//请求类型
typedef NS_ENUM (NSUInteger, NetRequestType){
    NetRequestGet = 0,//get 请求
    NetRequestPost = 1,//post 请求
};

//请求内容类型
typedef NS_ENUM (NSUInteger, NetRequestContentType) {
    NetRequestContent_RecordSet,             // 录音设置
    NetRequestContent_RecordLogSave,         // 保存通话日志
};


//服务器类型
typedef NS_ENUM (NSUInteger, NetHostType)
{
    NetHostTypeNone,
};


@interface NetAPIClient : NSObject

@property (nonatomic, assign) BOOL isShowLoadView;//是否显示加载图


+ (instancetype)sharedClient;



/**
 *  数据请求
 *  @param dic         请求参数
 *  @param requestType 请求类型
 *  @param contentType 接口类型
 *  @param finishBlock 请求成功回调
 *  @param failBlock   请求成功,但是失败信息
 *  @param errorBlock  请求失败
 */
- (void)requestDataWithDic:(NSMutableDictionary *)dic
               requestType:(NetRequestType)requestType
               contentType:(NetRequestContentType)contentType
               finishBlock:(NetRequestFinishBlock)finishBlock
                 failBlock:(NetRequestFailBlock)failBlock
                errorBlock:(NetRequestErrorBlock)errorBlock;


#pragma mark - Download
/**
 *  文件下载
 *
 *  @param url             下载url
 *  @param filePath        下载保存文件的文件夹路径
 *  @param downLodingBlock 下载中进度回调
 *  @param successBlock    下载完成回调
 *  @param failBlock       下载失败回调
 */
- (void)netDownLoadURL:(NSString *)url
          saveFilePath:(NSString *)filePath
      downLoadingBlock:(NetDownLodingBlock)downLodingBlock
  downLoadSuccessBlock:(NetDownLoadCompletionBlock)successBlock
     downLoadFailBlock:(NetDownLoadFailBlock)failBlock;



#pragma mark - Upload
/**
 *
 *
 *  @param url
 *  @param fileData
 *  @param upLodingBlock
 *  @param successBlock
 *  @param failBlock
 */
- (void)uploadDataTaskWithURL:(NSString *)url
                uploadFileData:(NSData *)fileData
                upLoadingBlock:(NetUpLodingBlock)upLodingBlock
            upLoadSuccessBlock:(NetUpLoadCompletionBlock)successBlock
              upLoadFailBlock:(NetUpLoadFailBlock)failBlock;

//头像上传
- (void)uploadImage:(UIImage *)image
                url:(NSString *)url
            params:(NSMutableDictionary *)params
     upLoadingBlock:(NetUpLodingBlock)upLodingBlock
 upLoadSuccessBlock:(NetUpLoadCompletionBlock)successBlock
    upLoadFailBlock:(NetUpLoadFailBlock)failBlock;


@end
