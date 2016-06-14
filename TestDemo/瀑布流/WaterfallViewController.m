//
//  WaterfallViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/6/14.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "WaterfallViewController.h"
#import "WaterFallFlowLayout.h"
#import "PhotoCollectionViewCell.h"
#import "XMGShop.h"
#import "MJExtension.h"
#import "MJRefresh.h"



static NSString *const cellId = @"PhotoCollectionViewCell";

@interface WaterfallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterflowLayoutDelegate>


@property (strong, nonatomic) UICollectionView *collectionView;
@property (copy, nonatomic) NSMutableArray *dataSourceArray;


@end

@implementation WaterfallViewController



/**
 *  瀑布流实现方法
 
 1.3个tableview，每个代表一列，tableview 禁止滑动，方法不可取
 2.uiscrollview  排布的子view 循环利用，用nsmutableArray 进行缓存
 3.uicollectionView  布局和每个cell大小自己设定（挑最短的去排放新控件）
 */

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    WaterFallFlowLayout *flowLayout = [[WaterFallFlowLayout alloc] init];
    flowLayout.delegate = self;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_collectionView];
    
    _dataSourceArray = [NSMutableArray array];

    [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRefresh];
    
}

#pragma mark  - 刷新
- (void)setRefresh
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadShops)];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.footer.hidden = YES;
    
}

- (void)loadShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [XMGShop mj_objectArrayWithFilename:@"1.plist"];
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:shops];
        //刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_header endRefreshing];
    });
}

- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [XMGShop mj_objectArrayWithFilename:@"1.plist"];
        [self.dataSourceArray addObjectsFromArray:shops];
        //刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
    });
}




#pragma mark  - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    
    cell.shop = _dataSourceArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.mj_footer.hidden = self.dataSourceArray.count == 0;
    return self.dataSourceArray.count;
}

#pragma mark  - WaterflowLayoutDelegate
//index位置下 cell的高度
- (CGFloat)waterflowLayout:(WaterFallFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    XMGShop *shop = _dataSourceArray[index];
    
    return itemWidth*shop.h / shop.w;
}


- (CGFloat)rowMarginInWaterflowLayout:(WaterFallFlowLayout *)waterflowLayout
{
    return 20;
}

- (CGFloat)columnCountInWaterflowLayout:(WaterFallFlowLayout *)waterflowLayout
{
    if (self.dataSourceArray.count <= 50) return 2;
    return 3;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterFallFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(10, 20, 30, 100);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
