//
//  UIView+SizeHeight.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/31.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "UIView+SizeHeight.h"

@implementation UIView (SizeHeight)

+ (CGFloat)getTextSizeWidth:(NSString *)text font:(CGFloat)textFont withSize:(CGSize)size
{
    
    CGSize textSize = [text boundingRectWithSize:size // 用于计算文本绘制时占据的矩形块
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFont]}        // 文字的属性
                                         context:nil].size;
    return textSize.width;
}


+ (CGFloat)getTextSizeHeight:(NSString *)text font:(CGFloat)textFont withSize:(CGSize)size
{
    
    CGSize textSize = [text boundingRectWithSize:size // 用于计算文本绘制时占据的矩形块
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:textFont]}        // 文字的属性
                                         context:nil].size;
    return textSize.height;
}

/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(UIView *)view andWidth:(float)width
{
    CGSize sizeToFit = [view sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}



@end
