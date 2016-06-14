//
//  WaterFallFlowLayout.h
//  TestDemo
//
//  Created by ZGJ on 16/6/14.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFallFlowLayout;

@protocol WaterflowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(WaterFallFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(WaterFallFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(WaterFallFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(WaterFallFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterFallFlowLayout *)waterflowLayout;
@end

@interface WaterFallFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WaterflowLayoutDelegate> delegate;

@end
