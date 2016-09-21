//
//  CustomButton.m
//  TestDemo
//
//  Created by ZGJ on 16/9/7.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CustomButton.h"

@interface CustomButton ()

@property (nonatomic, assign) CusButtonType type;

@end

/**
 1.布局
 setTitleEdgeInsets和setImageEdgeInsets
 
 2.重写 layoutSubviews
 */

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame
                        image:(NSString *)imageName
                    imageType:(CusButtonType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor brownColor];
        self.type = type;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect titleRect = self.titleLabel.frame;
    CGRect imageRect = self.imageView.frame;
    CGRect frame = self.frame;
    //重新布局
    switch (self.type) {
        case CusButtonTypeNormal:
            break;
        case CusButtonTypeImageRight:
        {
            titleRect.origin.x = 0;
            self.titleLabel.frame = titleRect;
            imageRect.origin.x = titleRect.size.width;
            self.imageView.frame = imageRect;
        }
            break;
        case CusButtonTypeImageTop:
            //文字和图片相差10
            imageRect.origin.x = (frame.size.width - imageRect.size.width)* 0.5;
            imageRect.origin.y = frame.size.height * 0.5 - imageRect.size.height*0.5 - 10;
            self.imageView.frame = imageRect;
            
            titleRect.origin.x = (frame.size.width - titleRect.size.width) * 0.5;
            titleRect.origin.y = frame.size.height * 0.5;
            self.titleLabel.frame = titleRect;
            break;
        case CusButtonTypeImageBottom:
            
            titleRect.origin.x = (frame.size.width - titleRect.size.width)* 0.5;
            titleRect.origin.y = frame.size.height * 0.5 - titleRect.size.height*0.5 - 10;
            self.titleLabel.frame = titleRect;
            
            imageRect.origin.x = (frame.size.width - imageRect.size.width) * 0.5;
            imageRect.origin.y = frame.size.height * 0.5;
            self.imageView.frame = imageRect;
            break;
        default:
            break;
    }

}


@end
