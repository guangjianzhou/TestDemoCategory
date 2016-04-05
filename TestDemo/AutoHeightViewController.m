//
//  AutoHeightViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/31.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "AutoHeightViewController.h"
#import "AutoHeightCell.h"
#import "AvatarView.h"

@interface AutoHeightViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong, nonatomic) UIActivityViewController *activityVC;

@end

@implementation AutoHeightViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //不能实现heightforRow  代理
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"====%@",self.dataArray);
    
    [_dataArray addObjectsFromArray:@[@"1手机端开发卡死的反馈",@"2d萨科技的南方开空间呢附近跨世纪的南方科技爱上即可是你的烦恼就看到附近空萨克的那份上单反教科文房间爱思考谁看见爱的你付款三代人卡萨丁南方科技三等分就看你撒快递费呢人家牛肉呢深刻的奶粉就看",@"3啥快递费就卡死鹅绒",@"4/n圣诞节南方萨科技的南方开就爱上人萨科技对方能快速结案而空间那个即可送达",@"5212e",@"sdmfs2016-03-31 15:38:44.094 TestDemo_Develop[9392:267994]  INFO: Reveal Server stopped.2016-03-31 15:38:44.094 TestDemo_Develop[9392:267994]  INFO: Reveal Server stopped.2016-03-31 15:38:44.094 TestDemo_Develop[9392:267994]  INFO: Reveal Server stopped.2016-03-31 15:38:44.094 TestDemo_Develop[9392:267994]  INFO: Reveal Server stopped."]];
    
    _nameArray = [NSMutableArray arrayWithObjects:@"周瑜",@"黄三等",@"123",@"我",@"中华人民共和国",@"😄",@"四遍", nil];
}

#pragma mark  - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AutoHeightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoHeightCell"];
    cell.contentLabel.text = _dataArray[indexPath.row];
    
    
    UIImage *image = [AvatarView defaultAvatarForVoipWithName:_nameArray[indexPath.row] phoneNum:@"15152883657"];
    cell.titleImageView.image = image;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = @"猫猫";
    UIImage *image = [UIImage imageNamed:@"loading_monkey"];
    self.activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[title,image] applicationActivities:nil];
    [self presentViewController:self.activityVC animated:YES
                     completion:^{
                        
                         
                     }];
    
    [self.activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
        
    }];
    
    [self.activityVC setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        NSLog(@"activityType=====%@",activityType);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
