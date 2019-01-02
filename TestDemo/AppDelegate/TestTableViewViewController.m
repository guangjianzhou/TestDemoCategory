

//
//  TestTableViewViewController.m
//  TestDemo
//
//  Created by ZGJ on 2017/9/24.
//  Copyright © 2017年 guangjianzhou. All rights reserved.
//

#import "TestTableViewViewController.h"
#import <Masonry/Masonry.h>
#import "TestTableTableViewCell.h"

@interface TestTableViewViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *bgScrollView;

@end

@implementation TestTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _bgScrollView = [[UIScrollView alloc] init];
    _bgScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1011.jpg"]];
    [self.view addSubview:_bgScrollView];
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _bgScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*5);
    
    
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [_tableView registerNib:[UINib nibWithNibName:@"TestTableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TestTableTableViewCell"];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestTableTableViewCell"];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableView.frame.size.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //
    NSLog(@"contentOffset===%@", NSStringFromCGPoint(scrollView.contentOffset));
    CGPoint offset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y*0.03);
    [self.bgScrollView setContentOffset:offset];
    
    
}




@end
