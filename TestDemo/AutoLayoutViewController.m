//
//  AutoLayoutViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/10.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "AutoLayoutViewController.h"
#import "UIView+Common.h"
#import "NetAPIClient.h"


@interface AutoLayoutViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@end

@implementation AutoLayoutViewController

/**
 *  当uiLabel在View中时，一般的字符长度 可以自动撑开，但是当字符过多时候，还是会省略
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view beginLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view endLoading];
            //数据加载后，无数据默认图片
            [self.view configBlankPage:EaseBlankPageTypeView hasData:NO hasError:YES reloadButtonBlock:^(id sender) {
                
            }];
        });
    });
    
    //1.隐藏灰色view
//    _bottomView.hidden = YES;
    
    //2.设置 灰色view的高度 不行
    _bottomViewHeightConstraint.constant = 0;
    //加上这句 可以了
    self.bottomView.clipsToBounds = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
