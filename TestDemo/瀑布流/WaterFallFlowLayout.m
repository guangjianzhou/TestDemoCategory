//
//  WaterFallFlowLayout.m
//  TestDemo
//
//  Created by ZGJ on 16/6/14.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "WaterFallFlowLayout.h"

//默认列数
static const CGFloat DefaultColumnCount = 3;
//每一列之间的间距
static const CGFloat DefaultColumnMargin = 10;
//每一行间距
static const CGFloat DefaultRowMargin = 10;
//边缘间距
static const UIEdgeInsets DefaultEdgeIntset = {10,10,10,10};





@interface WaterFallFlowLayout ()

//存放cell所有的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;

//存放所有列的最大y值（最大高度）maxY0/maxY1/maxY2/
@property (nonatomic, strong) NSMutableArray *columnHeights;


- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;

@end

/**
 *  自定义布局 实现以下四个部分
 */
@implementation WaterFallFlowLayout


#pragma mark - 常见数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return DefaultRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return DefaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return DefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return DefaultEdgeIntset;
    }
}

#pragma mark  - 懒加载
//创建一个数组（存放所有的布局属性）
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray)
    {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeights
{
    if (!_columnHeights)
    {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}


/**
 *  初始化,你可以在该方法里设置一些属性，调用一次
 */
- (void)prepareLayout
{
    
    NSLog(@"==%s==",__func__);
    //清空所有的布局属性
    [self.attrsArray removeAllObjects];
    //先清除以前所有的高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i< self.columnCount; i++)
    {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    

    //开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i<count; i++)
    {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        //创建布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexpath];
        [self.attrsArray addObject:attrs];
    }

    
    [super prepareLayout];
}


#pragma mark - 3
/**
 *  决定cell的排布
 *  重复调用，
 *
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"==%s==",__func__);
    //不会改变
    return  self.attrsArray;
}


#pragma mark - 2 返回indexpath位置cell的对应布局
/**
 *  返回indexpath位置cell的对应布局
 *  排布cell
 *
 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    //设置布局属性的frame
    CGFloat w = (collectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount-1)*DefaultColumnMargin)/self.columnCount;
    
    //高度应该由数据决定
//    CGFloat h = 50 + arc4random_uniform(100);
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    
    //x计算 找到哪一列
    //找出高度最短的那一列
//    __block  NSInteger destColumn = 0;
//    __block CGFloat minColumnHeight = MAXFLOAT;
    
//    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber*  _Nonnull columnHeightNum, NSUInteger idx, BOOL * _Nonnull stop) {
//       
//        CGFloat columnHeight = columnHeightNum.doubleValue;
//        if (columnHeight < minColumnHeight)
//        {
//            minColumnHeight = columnHeight;
//            destColumn = idx; //
//        }
//    }];

    //处在第几列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    
    //假设第0列最小,从第一列开始循环
    for (NSInteger i = 1; i<self.columnCount; i++)
    {
        //取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (columnHeight < minColumnHeight)
        {
            minColumnHeight = columnHeight;
            destColumn = i; //
        }

    }
    
    //
    CGFloat x = self.edgeInsets.left + destColumn * (w+self.columnMargin);
    CGFloat y = minColumnHeight;
    //第一行,y值DefaultEdgeIntset.top
    if (y != self.edgeInsets.top)
    {
        y = y + self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    
    
    //更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}


#pragma mark - 1返回contentsize的总大小
//拿出最长一列
- (CGSize)collectionViewContentSize
{
    NSLog(@"==%s==",__func__);
    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    //假设第0列就为最大高度
    for (NSInteger i = 1; i<self.columnCount; i++)
    {
        //取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (maxColumnHeight < columnHeight)
        {
            maxColumnHeight = columnHeight;
        }
    }
    return CGSizeMake(0, maxColumnHeight + self.edgeInsets.bottom);
}

@end

/**
 1、设计好我们的布局配置数据 prepareLayout方法中
 
 2、返回我们的配置数组 layoutAttributesForElementsInRect方法中
 
 */


