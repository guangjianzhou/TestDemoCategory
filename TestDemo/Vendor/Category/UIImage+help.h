//
//  UIImage+help.h
//  ShareBicycle
//
//  Created by guangjianzhou on 15/12/21.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (help)

/**
 *  生成纯色的image
 *
 *  @param aColor
 *
 */
+(UIImage *)imageWithColor:(UIColor *)aColor;

/**
 *  生成固定frame的image
 *  @param aColor
 *  @param aFrame
 *
 */
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

/**
 *  对图片尺寸进行压缩
 *
 *  @param targetSize 目标尺寸
 *
 */
-(UIImage*)scaledToSize:(CGSize)targetSize;

/**
 *  图片是否高质量
 *
 *  @param targetSize
 *  @param highQuality
 *
 */

-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;

/**
 *  图片进行放大
 *
 *  @param size
 *
 */
-(UIImage*)scaledToMaxSize:(CGSize )size;


/**
 *  控件截屏
 */
+ (UIImage *)imageWithCaputureView:(UIView *)view;


+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset;

+ (UIImage *)imageWithFileType:(NSString *)fileType;


- (UIImage *)getSubImage:(CGRect)rect;
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

//图片旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;



@end
