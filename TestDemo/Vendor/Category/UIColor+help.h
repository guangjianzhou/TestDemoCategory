//
//  UIColor+help.h
//  ShareBicycle
//
//  Created by guangjianzhou on 15/12/18.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 颜色值在0-255之间 */
extern UIColor * UIColorMakeRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
extern UIColor * UIColorMakeRGB(CGFloat red, CGFloat green, CGFloat blue);

@interface UIColor (help)

/** 返回当前UIColor的颜色模式 */
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;

/** 返回当前UIColor的red值 */
@property (nonatomic, readonly) CGFloat red;

/** 返回当前UIColor的green值 */
@property (nonatomic, readonly) CGFloat green;

/** 返回当前UIColor的blue值 */
@property (nonatomic, readonly) CGFloat blue;

/** 返回当前UIColor的alpha值 */
@property (nonatomic, readonly) CGFloat alpha;

/** 返回当前UIColor的16进制值 */
@property (nonatomic, readonly) UInt32 rgbHex;


#pragma mark - Methods
/**
 *  @brief  创建UIColor从16进制值
 *
 *  @param  hexValue  16禁止颜色值（不包含alpha值）
 *
 *  @return             UIColor对象
 */
+ (UIColor *)colorWithHex:(unsigned int)hexValue;

/**
 *  @brief  创建UIColor从16进制值
 *
 *  @param  hexValue  16禁止颜色值（包含alpha值） 0x000000
 *
 *  @return             UIColor对象
 */
+ (UIColor *)colorWithHex:(unsigned int)hexValue alpha:(CGFloat)alpha;


/**
 *  字符串转换颜色
 *
 *  @param input {NSString} Hex string (ie: @"ff", @"#fff", @"ff0000", or @"ff00ffcc")
 *
 *  @return   UIColor对象
 */
+ (UIColor *)colorWithHexString:(id)input;


/**
 *  @brief  随机产生一个颜色值的UIColor
 *
 *  @return             UIColor对象
 */
+ (UIColor *)randomColor;


@end
