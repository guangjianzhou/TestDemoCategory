//
//  IBDesignableUIImageView.m
//  TestDemo
//
//  Created by guangjianzhou on 16/5/17.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "IBDesignableUIImageView.h"

@implementation IBDesignableUIImageView

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

@end
