//
//  AppScoreViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/8/16.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "AppScoreViewController.h"
#import <StoreKit/StoreKit.h>

@interface AppScoreViewController ()<SKStoreProductViewControllerDelegate>

@end

@implementation AppScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor yellowColor];
    
    
//    self.edgesForExtendedLayout =UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = YES;
}

//应用内评分
- (IBAction)appAction:(UIButton *)sender {
    
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",1132497060]; //appID 解释如下 中南荟
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


//AppStore评分
- (IBAction)appStoreAction:(UIButton *)sender {
    
    [self evaluate];
    
}

- (void)evaluate{
    
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier : @"1132497060"} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
     }];
}

//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
