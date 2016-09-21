//
//  SMVideoRecord.h
//  VideoRecord
//
//  Created by huangxinping on 1/2/14.
//  Copyright (c) 2014 sharemerge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMVideoRecordDelegate.h"

typedef enum _VideoQuality{
    SMVideoQualityHigh = 0,
    SMVideoQualityMedium = 1,
    SMVideoQualityLow = 2,
}VideoQuality;

@interface SMVideoInfo : NSObject

/**
 *  录制的视频的大小（kb为单位）
 */
@property(nonatomic,assign)CGFloat recordFileSize;

/**
 *  录制的视频的时间长度（秒为单位）
 */
@property(nonatomic,assign)NSTimeInterval recordFileTimeLength;

/**
 *  输出的视频的大小（kb为单位）
 */
@property(nonatomic,assign)CGFloat outputFileSize;

/**
 *  输出的视频的时间长度（秒为单位）
 */
@property(nonatomic,assign)NSTimeInterval outputFileTimeLength;

@end




@interface SMVideoRecord : NSObject

/**
 *  视频录制最大时间（默认为30秒）
 */
@property(nonatomic,assign)NSTimeInterval videoMaximumDuration;

/**
 *  视频录制画质（默认为high）
 */
@property(nonatomic,assign)VideoQuality recordQualityType;

/**
 *  视频输出画质（默认为high）
 */
@property(nonatomic,assign)VideoQuality outputQuaityType;

/**
 *  是否显示网络菊花（默认为YES）
 */
@property(nonatomic,assign)BOOL shouldOptimizeForNetworkUse;

/**
 *  视频输出路径（默认为../Documents/videooutput/output.mp4）
 */
@property(nonatomic,strong)NSString *outputPath;

/**
 *  视频信息（包含录制和输出）
 */
@property(nonatomic,strong)SMVideoInfo *smvi;

/**
 *  委托
 */
@property(nonatomic,assign)id<SMVideoRecordDelegate> delegate;

/**
 *  弹出视频录制视图
 *
 *  @param viewcontroller 被寄生的视图控制器
 */
- (void)presentWithViewController:(UIViewController*)viewcontroller animated:(BOOL)animated;

/**
 *  是否有视频文件
 *
 *  @return 如果有则返回YES
 */
@property (nonatomic, readonly) BOOL    hasVideoRecord;

/**
 *  清除视频录制后的缓存 
 */
- (BOOL)clearCache;

@end
