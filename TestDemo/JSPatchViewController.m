


//
//  JSPatchViewController.m
//  TestDemo
//
//  Created by ZGJ on 2016/10/28.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "JSPatchViewController.h"
@interface JSPatchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JSPatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray array];
    [_dataArray addObjectsFromArray:@[@"1row",@"2row",@"3row",@"4row",@"5row",@"6row"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor yellowColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
    [self.view addSubview:_tableView];
    
    
    //
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSLog(@"--沙盒路径-");
    //将一张图片拷贝到app
    NSString *jpgpath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
    
    BOOL isSave = [[NSUserDefaults standardUserDefaults] valueForKey:@"save"];
    if (isSave) {
        [[NSUserDefaults standardUserDefaults] setBool:@"NO" forKey:@"save"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"已经存储过了");
    }
    else
    {
        NSError *error = nil;
        NSString *sourcePath = [path stringByAppendingPathComponent:@"1.jpg"];
        if (jpgpath) {
            [[NSFileManager defaultManager] removeItemAtPath:jpgpath error:&error];
            if (error) {
                NSLog(@"=====error%@",error);
            }
        }
        
        
        error = nil;
        BOOL flag = [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                                            toPath:jpgpath
                                                             error:&error];
        NSLog(@"error====%@",error);
        
        [[NSUserDefaults standardUserDefaults] setBool:@"YES" forKey:@"save"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.tableHeaderView = imageView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


//不走这里的方法了
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    cell.textLabel.text = _dataArray[indexPath.row];
    return  cell;
}

//不走这里了
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataArray removeLastObject];
    //肯定会超出数组范围导致 crash
    
    NSString *row = _dataArray[indexPath.row];
    NSLog(@"---%@",row);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
