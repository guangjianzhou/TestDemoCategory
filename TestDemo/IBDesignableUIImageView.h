//
//  IBDesignableUIImageView.h
//  TestDemo
//
//  Created by guangjianzhou on 16/5/17.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE 放在@interface或者@implement都可以，申明这个类在XCode直接看到渲染的效果。
//IBInspectable 修饰属性，使属性能在XCode中直接设置。


IB_DESIGNABLE
@interface IBDesignableUIImageView : UIImageView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end
