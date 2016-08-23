//
//  ThirdLoginViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/8/12.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "ThirdLoginViewController.h"
#import "WXApi.h"
#import "AFNetworking.h"

#define WX_ACCESS_TOKEN @"WX_Accss_token"
#define WX_OPEN_ID @"WX_OpenID"
#define WX_REFRESH_TOKEN @"WX_Refresh_Token"
#define  WX_BASE_URL @"https://api.weixin.qq.com/sns"

typedef enum{
    UIViewAnimationTransitionNone1,
    UIViewAnimationTransitionFlipFromLeft2,
    UIViewAnimationTransitionFlipFromRight3,
    UIViewAnimationTransitionCurlUp4,
    UIViewAnimationTransitionCurlDown5,
} UIViewAnimationTransitionType;

@interface ThirdLoginViewController ()

/** 通过block去执行AppDelegate中的wechatLoginByRequestForUserInfo方法 */
@property (nonatomic,copy) void (^requestForUserInfoBlock)();

@end

@implementation ThirdLoginViewController


/**
 *  1.infoPlist 配置/URLType 添加
    2.Appdelegate 中注册
    3.
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"第三方登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 60, 40)];
    [btn setTitle:@"微信登录" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor yellowColor]];
    [btn addTarget:self action:@selector(wechatLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}


#pragma mark - 微信登录
/*
 目前移动应用上德微信登录只提供原生的登录方式，需要用户安装微信客户端才能配合使用。
 对于iOS应用,考虑到iOS应用商店审核指南中的相关规定，建议开发者接入微信登录时，先检测用户手机是否已经安装
 微信客户端(使用sdk中的isWXAppInstall函数),对于未安装的用户隐藏微信 登录按钮，只提供其他登录方式。
 */
- (IBAction)wechatLoginClick:(id)sender {
    [self wechatLogin];
    return;
    
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && openID) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN];
        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_BASE_URL, WX_OPEN_ID, refreshToken];
        [manager GET:refreshUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求reAccess的response = %@", responseObject);
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *reAccessToken = [refreshDict objectForKey:WX_ACCESS_TOKEN];
            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
            if (reAccessToken) {
                // 更新access_token、refresh_token、open_id
                [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_OPEN_ID] forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_REFRESH_TOKEN] forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 当存在reAccessToken不为空时直接执行AppDelegate中的wechatLoginByRequestForUserInfo方法
                !self.requestForUserInfoBlock ? : self.requestForUserInfoBlock();
            }
            else {
                [self wechatLogin];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
        }];
    }
    else {
        [self wechatLogin];
    }
}
- (void)wechatLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"login";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}
- (void)setupAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请先安装微信客户端" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:alertAction];
    [self  presentViewController:alertController animated:YES completion:^{
        
    }];
}

//因为微信授权后access_token(2小时)之类的字段都是有效期的在有效期范围内


//1.首先获取到微信的openID，然后通过openID去后台数据库查询该微信的openID有没有绑定好的手机号.
//2.如果没有绑定,首相第一步就是将微信用户的头像、昵称等等基本信息添加到数据库；然后通过手机获取验证码;最后绑定手机号。然后就登录App.
//3.如果有，那么后台就返回一个手机号，然后通过手机登录App.


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)testType:(UIViewAnimationTransitionType) type{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
