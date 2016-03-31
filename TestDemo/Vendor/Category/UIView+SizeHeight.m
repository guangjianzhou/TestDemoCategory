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



@end
