//
//  SMVideoRecord.m
//  VideoRecord
//
//  Created by huangxinping on 1/2/14.
//  Copyright (c) 2014 sharemerge. All rights reserved.
//

#import "SMVideoRecord.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation SMVideoInfo
{
}

- (id)init {
	if ((self = [super init])) {
		_recordFileSize = 0;
		_recordFileTimeLength = 0;
		_outputFileSize = 0;
		_outputFileTimeLength = 0;
	}
	return self;
}

- (NSString*)description
{
    return [@{@"recordFileSize": @(self.recordFileSize),
              @"recordFileTimeLength" : @(self.recordFileTimeLength),
              @"outputFileSize" : @(self.outputFileSize),
              @"outputFileTimeLength" : @(self.outputFileTimeLength)
             } description];
}

@end

@interface SMVideoRecord () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSURL *videoURL;
@end

@implementation SMVideoRecord
{
	UIImagePickerController *pickerView;
	UIViewController *ownerViewController;
//    BOOL hasRecord
}

- (id)init {
	if ((self = [super init])) {
		if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/videooutput", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]]) {
			[[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/videooutput", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]] withIntermediateDirectories:YES attributes:nil error:nil];
		}
		_outputPath = [NSString stringWithFormat:@"%@/videooutput/output.mp4", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
		_shouldOptimizeForNetworkUse = YES;
		_smvi = [[SMVideoInfo alloc] init];
		_outputQuaityType = SMVideoQualityHigh;
		_recordQualityType = SMVideoQualityHigh;
		_videoMaximumDuration = 30.0f;
        
		pickerView = [[UIImagePickerController alloc] init];
	}
	return self;
}

- (void)presentWithViewController:(UIViewController *)viewcontroller animated:(BOOL)animated {
	pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
	NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	pickerView.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
	pickerView.videoMaximumDuration = self.videoMaximumDuration;
    pickerView.modalPresentationStyle = UIModalPresentationCurrentContext;
	switch (self.recordQualityType) {
		case SMVideoQualityLow:
			pickerView.videoQuality = UIImagePickerControllerQualityTypeLow;
			break;
            
		case SMVideoQualityMedium:
			pickerView.videoQuality = UIImagePickerControllerQualityTypeMedium;
			break;
            
		case SMVideoQualityHigh:
			pickerView.videoQuality = UIImagePickerControllerQualityTypeHigh;
			break;
            
		default:
			break;
	}
	pickerView.delegate = self;
	ownerViewController = viewcontroller;
	[ownerViewController presentViewController:pickerView animated:animated completion: ^{
	}];
    
	if (self.delegate &&
	    [self.delegate respondsToSelector:@selector(recordVideoStart:)]) {
		[self.delegate recordVideoStart:self];
	}
}

- (void)encodeVideo {
	NSString *mp4Quality = nil;
	switch (self.outputQuaityType) {
		case SMVideoQualityLow:
			mp4Quality = AVAssetExportPresetLowQuality;
			break;
            
		case SMVideoQualityMedium:
			mp4Quality = AVAssetExportPresetMediumQuality;
			break;
            
		case SMVideoQualityHigh:
			mp4Quality = AVAssetExportPresetHighestQuality;
			break;
            
		default:
			break;
	}
    
	AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
	NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
	if ([compatiblePresets containsObject:mp4Quality]) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(encodeVideoStart:)]) {
			[self.delegate encodeVideoStart:self];
		}
        
        __weak typeof(self) weakSelf = self;
		AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:mp4Quality];
		exportSession.outputURL = [NSURL fileURLWithPath:self.outputPath];
		exportSession.shouldOptimizeForNetworkUse = self.shouldOptimizeForNetworkUse;
		exportSession.outputFileType = AVFileTypeMPEG4;
		[exportSession exportAsynchronouslyWithCompletionHandler: ^{
		    switch ([exportSession status]) {
				case AVAssetExportSessionStatusFailed:
                {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(encodeVideoFailed:error:)]) {
                        [weakSelf.delegate encodeVideoFailed:weakSelf error:[exportSession error]];
                    }
                    break;
                }
                    
				case AVAssetExportSessionStatusCancelled:
					if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(encodeVideoFailed:error:)]) {
					    NSError *error = [NSError errorWithDomain:@"Error" code:500 userInfo:@{ @"errorinfo": @"导出取消" }];
					    [weakSelf.delegate encodeVideoFailed:weakSelf error:error];
					}
					break;
                    
				case AVAssetExportSessionStatusCompleted:
					if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(encodeVideoFinshed:videoInfo:)]) {
                        weakSelf.smvi.outputFileTimeLength = [weakSelf getVideoDuration:[NSURL fileURLWithPath:weakSelf.outputPath]];
                        weakSelf.smvi.outputFileSize = [weakSelf getFileSize:weakSelf.outputPath];
					    [weakSelf.delegate encodeVideoFinshed:weakSelf videoInfo:weakSelf.smvi];
					}
					break;
                    
				default:
					break;
			}
		}];
	}
	else {
		if (self.delegate && [self.delegate respondsToSelector:@selector(encodeVideoFailed:error:)]) {
			NSError *error = [NSError errorWithDomain:@"Error" code:0 userInfo:@{ @"errorinfo": @"设备不支持mp4输出" }];
			[self.delegate encodeVideoFailed:self error:error];
		}
	}
}

#pragma mark - private Method
- (NSInteger)getFileSize:(NSString *)path {
	NSFileManager *filemanager = [NSFileManager defaultManager];
	if ([filemanager fileExistsAtPath:path]) {
		NSDictionary *attributes = [filemanager attributesOfItemAtPath:path error:nil];
		NSNumber *theFileSize;
		if ((theFileSize = [attributes objectForKey:NSFileSize]))
			return [theFileSize intValue] / 1024;
		else
			return -1;
	}
	else {
		return -1;
	}
}

- (CGFloat)getVideoDuration:(NSURL *)URL {
	NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
	AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
	float second = 0;
	second = urlAsset.duration.value / urlAsset.duration.timescale;
	return second;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    _videoURL = info[UIImagePickerControllerMediaURL];
	self.smvi.recordFileSize = [self getFileSize:[[_videoURL absoluteString] substringFromIndex:16]];
	self.smvi.recordFileTimeLength = [self getVideoDuration:_videoURL];
    
	__weak typeof(self) weakSelf = self;
    
	[picker dismissViewControllerAnimated:YES completion: ^{
	    if (self.delegate &&
	        [self.delegate respondsToSelector:@selector(recordVideoFinished:videoInfo:)]) {
	        [self.delegate recordVideoFinished:self videoInfo:self.smvi];
		}
        
	    // 开始转码
//	    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
	        [weakSelf encodeVideo];
//		});
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion: ^{
	}];
	if (self.delegate &&
	    [self.delegate respondsToSelector:@selector(recordVideoCancel:)]) {
		[self.delegate recordVideoCancel:self];
	}
}

- (BOOL)hasVideoRecord{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.outputPath isDirectory:&isDir] && !isDir) {
        return YES;
    }
    return NO;
}

- (BOOL)clearCache{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.outputPath isDirectory:&isDir] && !isDir) {
        NSError * error = nil;
        if (![[NSFileManager defaultManager] removeItemAtPath:self.outputPath error:&error]) {
            //NSLog(@"Failed to delete video record. The error is %@", error);
            return NO;
        }
    }
    return YES;
}

@end
