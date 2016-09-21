//
//  SMVideoRecordDelegate.h
//  VideoRecord
//
//  Created by huangxinping on 1/6/14.
//  Copyright (c) 2014 sharemerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMVideoRecord;
@class SMVideoInfo;

@protocol SMVideoRecordDelegate <NSObject>

/**
 *  录制开始
 *
 *  @param videoRecord 录制视图控制器
 */
- (void)recordVideoStart:(SMVideoRecord *)videoRecord;

/**
 *  录制完成
 *
 *  @param videoRecord 录制视图控制器
 *  @param videoInfo   录制结果信息
 */
- (void)recordVideoFinished:(SMVideoRecord *)videoRecord videoInfo:(SMVideoInfo *)videoInfo;

/**
 *  录制取消
 *
 *  @param videoRecord 录制视图控制器
 */
- (void)recordVideoCancel:(SMVideoRecord *)videoRecord;


/**
 *  编码开始
 *
 *  @param videoRecord 录制视图控制器
 */
- (void)encodeVideoStart:(SMVideoRecord *)videoRecord;

/**
 *  编码完成
 *
 *  @param videoRecord 录制视图控制器
 *  @param videoInfo   录制并编码结果信息
 */
- (void)encodeVideoFinshed:(SMVideoRecord *)videoRecord videoInfo:(SMVideoInfo *)videoInfo;

/**
 *  编码失败
 *
 *  @param videoRecord 录制视图控制器
 *  @param error       错误信息
 */
- (void)encodeVideoFailed:(SMVideoRecord *)videoRecord error:(NSError *)error;

@end
