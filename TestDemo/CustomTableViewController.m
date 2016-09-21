//
//  CustomTableViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/9/2.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CustomTableViewController.h"
#import "ItemModel.h"
#import "CustomTableViewCell.h"

#import "UITableView+FDTemplateLayoutCell.h"

/**
 *  Cell 布局表格
 *  1.普通计算
 *  2.自动计算 UITableViewAutomaticDimension
 *  3.UITableView+FDTemplateLayoutCell
 *
 *
 */




@interface CustomTableViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CustomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"表视图";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomTableViewCell"];
    _dataArray = [NSMutableArray array];
    [self caculateRowHeight2];
    
}

- (void)caculateRowHeight
{
    //contentLabel 的上下左右需要设置
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)caculateRowHeight2
{
    self.tableView.fd_debugLogEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ItemModel *model = [[ItemModel alloc] initWithTitle:@"测试1" content:@"2016-09-02 10:18:03.763 TestDemo_Develop[3261:47585] __global_last_connection_status : 11"];
    
    ItemModel *model1 = [[ItemModel alloc] initWithTitle:@"测试1" content:@"百度云是由百度公司出品的一款云服务产品,不仅为用户提供免费存储空间,还可以将视频、照片、文档、通讯录数据在移动设备和PC端之间跨平台同步、备份等,百度云还支持添加好友、创建群组,和伙伴们快乐分享, 目前已上线:Android、iPhone、iPad、百度云管家、网页端等. 2016-09-02 10:18:03.763 TestDemo_Develop[3261:47585] __global_last_connection_status : 11"];
    
    ItemModel *model2 = [[ItemModel alloc] initWithTitle:@"测试1" content:@"数据是重要的战略性资产。每时每刻客户和设备都在产生海量数据，只有获取数据并进行分析才能创造新价值，: 11"];
    
    ItemModel *model3 = [[ItemModel alloc] initWithTitle:@"测试1" content:@"数据是重要的战略性资产。每时每刻客户和设备都在产生海量数据，只有获取数据并进行分析才能创造新价值，带来新体验。天算是百度开放云提供的智能大数据平台，提供了完备的大数据托管服务、智能服务以及众多解决方案，帮助用户实现智能业务，引领未来。数据是重要的战略性资产。每时每刻客户和设备都在产生海量数据，只有获取数据并进行分析才能创造新价值，带来新体验。天算是百度开放云提供的智能大数据平台，提供了完备的大数据托管服务、智能服务以及众多解决方案，帮助用户实现智能业务，引领未来。2016-09-02 10:18:03.763 TestDemo_Develop[3261:47585] __global_last_connection_status : 11"];
    
    ItemModel *model4 = [[ItemModel alloc] initWithTitle:@"测试1" content:@"2016-09-02 10:18:03.763 TestDemo_Develop[3261:47585] __global_last_connection_status : 11"];
    
    ItemModel *model5 = [[ItemModel alloc] initWithTitle:@"测试1" content:@"2016-0"];
    
    ItemModel *model6 = [[ItemModel alloc] initWithTitle:@"测试1" content:@"数据是重要的战略性资产。每时每刻客户和设备都在产生海量数据，只有获取数据并进行分析才能创造新价值，带来新体验。天算是百度开放云提供的智能大数据平台，提供了完备的大数据托管服务、智能服务以及众多解决方案，帮助用户实现智能业务，引领未来。数据是重要的战略性资产。每时每刻客户和设备都在产生海量数据，只有获取数据并进行分析才能创造新价值，带来新体验。天算是百度开放云提供的智能大数据平台，提供了完备的大数据托管服务、智能服务以及众多解决方案，帮助用户实现智能业务，引领未来。数据是重要的战略性资产。每时每刻客户和设备都在产生海量数据，只有获取数据并进行分析才能创造新价值，带来新体验。天算是百度开放云提供的智能大数据平台，提供了完备的大数据托管服务、智能服务以及众多解决方案，帮助用户实现智能业务，引领未来。2016-09-02 10:18:03.763 TestDemo_Develop[3261:47585] __global_last_connection_status : 11"];

    [self.dataArray addObjectsFromArray:@[model1,model2,model3,model4,model5,model6,model]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell" forIndexPath:indexPath];
    ItemModel *itemModel = _dataArray[indexPath.row];
    [cell loadData:itemModel];
    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return  [tableView fd_heightForCellWithIdentifier:@"CustomTableViewCell" configuration:^(id cell) {
//        //重新计算
//        ItemModel *itemModel = _dataArray[indexPath.row];
//        [cell loadData:itemModel];
//    }];
//}


@end
