//
//  ProfileHeaderViewController.m
//  TestDemo
//
//  Created by ZGJ on 2016/10/19.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "ProfileHeaderViewController.h"
#import "UIImage+help.h"

#define headH 200
#define headMinH 64


//头部视图和选项卡视图不能拖动 //😆只要将图片的底部view的userinterface = false

/*
    tableView尺寸：tableView占据整个控制器的view，内容才能穿透导航条。否则内容滚动不上去。
 
     用户滚动多少，头部视图和选项卡移动多少,修改头部视图，选项卡视图就会跟着移动。
     计算用户滚动偏移差，记录一开始的偏移差，与当前的偏移差比较
 */

@interface ProfileHeaderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHCons; //头部视图的高度

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, assign) CGFloat lastOffsetY;

@end

@implementation ProfileHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _lastOffsetY = -(headH);
    self.tableView.contentInset = UIEdgeInsetsMake(headH, 0, 0, 0);

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideNavigationBar];
}

- (void)hideNavigationBar
{
    // 给导航条的背景图片传递一个空图片的UIImage对象
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 隐藏底部阴影条，传递一个空图片的UIImage对象
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark  - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID
                ];
        cell.backgroundColor = [UIColor redColor];
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}




//监听tableview的滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollview=====%@",NSStringFromCGPoint(scrollView.contentOffset));
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY - _lastOffsetY;
    
    //网上拖动，高度减少
    CGFloat height = headH - delta;
    if (height  < headMinH) {
        height = headMinH;
    }
    _headHCons.constant = height;
    
    //设置导航条的背景图片
    CGFloat alpha = delta / (headH - headMinH);
    // 当alpha大于1，导航条半透明，因此做处理，大于1，就直接=0.99
    if (alpha >= 1) {
        alpha = 0.99;
    }
    // 设置导航条的背景图片
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
   
}



@end
