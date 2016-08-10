//
//  NetAPIClient.m
//  ZHCloudManager
//
//  Created by guangjianzhou on 15/12/11.
//  Copyright © 2015年 song song. All rights reserved.
//

#import "NetAPIClient.h"
#import <AFNetWorking/AFNetworking.h>
#import "NSDate+help.h"

NSString *const kAPIErrorDomain = @"kXPAPIErrorDomain";
NSString *const kAPIErrorDescription = @"请求失败，请稍后重试!";

const NSInteger kAPI_Timeout = 15;

@interface NetAPIClient ()
{
    AFHTTPRequestOperationManager *_manager;
}

@end

@implementation NetAPIClient


+ (instancetype)sharedClient
{
    static NetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetAPIClient alloc] init];
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

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager)
    {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html",@"text/plain",@"text/json",@"text/xml",@"application/json",@"application/xml",@"application/x-www-form-urlencoded"]];
//        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/json",@"application/json",@"application/x-www-form-urlencoded"]];
        manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.responseSerializer.acceptableStatusCodes = nil;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = kAPI_Timeout;
        _manager = manager;
    }
    return _manager;
}


#pragma mark - 数据请求
- (void)requestDataWithDic:(NSMutableDictionary *)dic
               requestType:(NetRequestType)requestType
               contentType:(NetRequestContentType)contentType
               finishBlock:(NetRequestFinishBlock)finishBlock
                 failBlock:(NetRequestFailBlock)failBlock
                errorBlock:(NetRequestErrorBlock)errorBlock
{
    NSMutableDictionary *params = [self changeDicParam:dic contentType:contentType];
    
    switch (requestType)
    {
        case NetRequestGet:
        {
            [self netGetRequestContentType:contentType params:params successBlock:finishBlock failBlock:failBlock errorBlock:errorBlock];
        }
            break;
        case NetRequestPost:
        {
            [self netPostRequestContentType:contentType params:params successBlock:finishBlock failBlock:failBlock errorBlock:errorBlock];
        }
            break;
        default:
            break;
    }
}

//参数重整
- (NSMutableDictionary *)changeDicParam:(NSMutableDictionary *)dic contentType:(NetRequestContentType)contentType
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    switch (contentType)
    {
        case NetRequestContent_RecordSet:
        {
          
        }
            break;
            
        case NetRequestContent_RecordLogSave:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    return params;
}

//url 修改
-(NSString *)httpNetRuquestUrl:(NetRequestContentType)contentType
{
    if (contentType == NetRequestContent_Test) {
        return  @"http://123.1.170:9000/apistore/appapi/registerUser";
    }
    
    NSString *httpUrl = @"http://apicloud.mob.com/cook/menu/query?key=d1bcf0d1bb38&id=00100010110000034063";
    return httpUrl;
}

#pragma mark Get
- (AFHTTPRequestOperation *)netGetRequestContentType:(NetRequestContentType)contentType
                          params:(NSDictionary *)params
                    successBlock:(NetRequestFinishBlock)successBlock
                       failBlock:(NetRequestFailBlock)failBlock
                      errorBlock:(NetRequestErrorBlock)errorBlock
{
    AFHTTPRequestOperationManager *manager = [self manager];
    NSString *httpURL = [self httpNetRuquestUrl:contentType];
    
    __weak typeof(self)weakSelf = self;
   return [manager GET:httpURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [weakSelf handleRequestSuccessDataWithTask:operation responseObject:responseObject hostType:NetHostTypeNone  failBlock:failBlock successBlock:successBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock (error);
    }];
}

#pragma mark Post
- (AFHTTPRequestOperation *)netPostRequestContentType:(NetRequestContentType)contentType
                           params:(NSDictionary *)params
                     successBlock:(NetRequestFinishBlock)successBlock
                        failBlock:(NetRequestFailBlock)failBlock
                       errorBlock:(NetRequestErrorBlock)errorBlock
{
    AFHTTPRequestOperationManager *manager = [self manager];
    NSString *httpURL = [self httpNetRuquestUrl:contentType];
    
    __weak typeof(self)weakSelf = self;
   return [manager POST:httpURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [weakSelf handleRequestSuccessDataWithTask:operation responseObject:responseObject hostType:NetHostTypeNone failBlock:failBlock successBlock:successBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock) errorBlock(error);
    }];
    
}

#pragma mark  处理成功返回
//success or fail
//对服务器
- (void)handleRequestSuccessDataWithTask:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject hostType:(NetHostType)hostType failBlock:(NetRequestFailBlock)failBlock successBlock:(NetRequestFinishBlock)successBlock
{
    switch (hostType) {
        case NetHostTypeNone:
        {
            if ([operation.response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSDictionary *headFields = [(NSHTTPURLResponse *)operation.response allHeaderFields];
                NSInteger statuscode = 0;
                for (NSString *key in headFields.allKeys)
                {
                    if ([key compare:@"statusCode" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                    {
                        statuscode = [headFields[key] integerValue];
                        break;
                    }
                }
                
                if (statuscode == 0)
                {
                    NSDictionary *response = (NSDictionary *)responseObject;
                    if ([response[@"errorCode"] integerValue] == 0)
                    {
                        //errorCode = 0 成功返回
                        if (successBlock)
                            successBlock(responseObject);
                    }else
                    {
                        //返回错误
                        if (failBlock)
                            failBlock(responseObject);
                    }
                }
                else
                {
                    if (failBlock)
                        failBlock(responseObject);
                }
            }
            else
            {
                if (failBlock)
                    failBlock(responseObject);
            }
            
            break;
        }
        default:
            break;
    }
}


#pragma mark - DownLoad
- (void)netDownLoadURL:(NSString *)url
          saveFilePath:(NSString *)filePath
      downLoadingBlock:(NetDownLodingBlock)downLodingBlock
  downLoadSuccessBlock:(NetDownLoadCompletionBlock)successBlock
     downLoadFailBlock:(NetDownLoadFailBlock)failBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *downURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:downURL];
    
    NSProgress *progress = nil;
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:&progress  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //非mainThread
        //指定下载路径
        NSURL *filePathURL = [NSURL fileURLWithPath:filePath];
        return [filePathURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //此处已经在主线程了MainThread
        if (!error)
        {
            successBlock(filePath.absoluteString);
        }
        else
        {
            failBlock(error);
        }
        
    }];
    [downLoadTask resume];
    
    //下载进度
    if (downLodingBlock)
    {
        [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            float downloadPercentage = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
            downLodingBlock(downloadPercentage);
        }];
    }
}

#pragma mark - Upload
//文件NSData
- (void)uploadDataTaskWithURL:(NSString *)url
               uploadFileData:(NSData *)fileData
               upLoadingBlock:(NetUpLodingBlock)upLodingBlock
           upLoadSuccessBlock:(NetUpLoadCompletionBlock)successBlock
              upLoadFailBlock:(NetUpLoadFailBlock)failBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *uploadURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    
    NSURLSessionUploadTask *uploadTaskData = [manager uploadTaskWithRequest:request fromData:fileData progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            failBlock(error);
        }
        else
        {
            successBlock(responseObject);
        }
    }];
    [uploadTaskData resume];
    
    if(upLodingBlock)
    {
        [manager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
            float uploadPercentage = (float)bytesSent/(float)totalBytesSent;
            upLodingBlock(uploadPercentage);
        }];
    }
}

#pragma mark - 头像

- (void)uploadImage:(UIImage *)image
                url:(NSString *)url
             params:(NSMutableDictionary *)params
     upLoadingBlock:(NetUpLodingBlock)upLodingBlock
 upLoadSuccessBlock:(NetUpLoadCompletionBlock)successBlock
    upLoadFailBlock:(NetUpLoadFailBlock)failBlock
{
    
    NSString *fileName = @"";
    NSString *name = @"";
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    AFHTTPRequestOperationManager *manager = [self manager];
    __weak typeof(self) weakSelf = self;
   AFHTTPRequestOperation *operation = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [weakSelf handleRequestSuccessDataWithTask:operation responseObject:responseObject hostType:NetHostTypeNone failBlock:failBlock successBlock:successBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock) failBlock(error);
    }];
    
    //这是上传进度
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progressValue = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
        if (upLodingBlock)
        {
            upLodingBlock(progressValue);
        }
    }];
    [operation start];
}


@end
