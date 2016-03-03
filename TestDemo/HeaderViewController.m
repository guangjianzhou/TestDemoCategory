

//
//  HeaderViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/2/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "HeaderViewController.h"
#import "UIDynamic1ViewController.h"
#import "UIViewController+OverRite.h"

@interface HeaderViewController ()

@end

@implementation HeaderViewController

/**
 *  在每个页面做统计  1.每个VC 手动添加   2.继承    3.category  4.MethodSwizzling
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIDynamic1ViewController *controller = [[UIDynamic1ViewController alloc] initWithNibName:nil bundle:nil];
        [weakSelf.navigationController pushViewController:controller animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
