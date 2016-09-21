//
//  CustomButton.h
//  TestDemo
//
//  Created by ZGJ on 16/9/7.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CusButtonType) {
    CusButtonTypeNormal = 1,
    CusButtonTypeImageRight = 2,
    CusButtonTypeImageTop = 3,
    CusButtonTypeImageBottom = 4
};

@interface CustomButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame
                        image:(NSString *)imageName
                    imageType:(CusButtonType)type;

@end
