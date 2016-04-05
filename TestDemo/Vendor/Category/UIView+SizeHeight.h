//
//  UIView+SizeHeight.h
//  TestDemo
//
//  Created by guangjianzhou on 16/3/31.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SizeHeight)


#warning UITextView在上下左右分别有一个8px的padding

/**
 *  计算文本宽度
 *
 *  @param text     文本
 *  @param textFont 文字大小
 *  @param size     size
 *
 *  @return return value description
 */
+ (CGFloat)getTextSizeWidth:(NSString *)text font:(CGFloat)textFont withSize:(CGSize)size;

/**
 *  计算文本高度
 *  UITextView CGSizeMake(width -16.0, CGFLOAT_MAX)，return sizeToFit.height + 16.0
 *
 *  @param text     <#text description#>
 *  @param textFont textFont description
 *  @param size     size description
 *
 *  @return return value description
 */
+ (CGFloat)getTextSizeHeight:(NSString *)text font:(CGFloat)textFont withSize:(CGSize)size;


- (float) heightForString:(UIView *)view andWidth:(float)width;

@end
