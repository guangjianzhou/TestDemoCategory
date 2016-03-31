//
//  UIView+help.h
//  TestDemo
//
//  Created by guangjianzhou on 16/3/31.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

//中心点
CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);


@interface UIView (help)

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

/** 起点 */
@property (nonatomic, assign) CGPoint origin;

/** 大小 */
@property (nonatomic, assign) CGSize size;

/** 左坐标 */
@property (nonatomic, assign) CGFloat left;

/** 右坐标 */
@property (nonatomic, assign) CGFloat right;

/** 上坐标 */
@property (nonatomic, assign) CGFloat top;

/** 下坐标 */
@property (nonatomic, assign) CGFloat bottom;

/** 横轴方向的中心点 */
@property (nonatomic, assign) CGFloat centerX;

/** 竖轴方向的中心点 */
@property (nonatomic, assign) CGFloat centerY;

/** 宽度 */
@property (nonatomic, assign) CGFloat width;

/** 高度 */
@property (nonatomic, assign) CGFloat height;




@end
