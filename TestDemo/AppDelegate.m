//
//  AppDelegate.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/2.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "UIColor+help.h"
#import "UIImage+help.h"
#import <RongIMKit/RongIMKit.h>
#import "RongCloudManager.h"
#include <AudioToolbox/AudioToolbox.h>
#import "ISULanguageManger.h"
#import "TopWindowViewController.h"
#import "AFNetworking.h"
#import "JPEngine.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

// access_token openid refresh_token unionid
#define WXPatient_App_ID @"wx53bb98d092d08c4d"
#define WXPatient_App_Secret @"487bab8c673300349b6d30d914c834b7"

#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"
#define WX_UNION_ID @"unionid"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"

#define  kBackButtonFontSize 16
#define  kNavTitleFontSize 18
#define kColorTableSectionBg [UIColor colorWithHexString:@"0xeeeeee"]

NSString * const NotificationCategoryIdent  = @"ACTIONABLE";
NSString * const NotificationActionOneIdent = @"ACTION_ONE";
NSString * const NotificationActionTwoIdent = @"ACTION_TWO";

@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic, strong) UIWindow *topWindow;

@end

@implementation AppDelegate
/**
 *  LaunhScreen.storyboard files are static and cannot run codes, segues or other forms of animation.You should implement you UI inside Main.storyboard or another storyboard set as your main storyboard
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //白色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        exit(0);
    });
    
    NSInteger version = [UIDevice currentDevice].systemVersion.integerValue;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [application setValue:[UIColor redColor] forKeyPath:@"statusBarWindow.statusBar.foregroundColor"];
    
//    [self addCustomWindow:application];
 
#pragma mark  - 通知
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
       //必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    
                }];
            }else
            {
                NSLog(@"注册失败");
            }
        }];
    }
    else if ([[UIDevice currentDevice].systemVersion integerValue] > 7)
    {
        //1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"Action 1"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"Action 2"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types
                                                     categories:categories];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        /*
        //1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"Accept";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        //    action.authenticationRequired = YES;
        //    action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        [application registerUserNotificationSettings:notiSettings];
        */
    }
    else
    {
        [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
//    /**
//     * 推送处理1
//     */
//    if ([application
//         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        //注册推送, 用于iOS8以及iOS8之后的系统
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings
//                                                settingsForTypes:(UIUserNotificationTypeBadge |
//                                                                  UIUserNotificationTypeSound |
//                                                                  UIUserNotificationTypeAlert)
//                                                categories:nil];
//        [application registerUserNotificationSettings:settings];
//    } else {
//        //注册推送，用于iOS8之前的系统
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeAlert |
//        UIRemoteNotificationTypeSound;
//        [application registerForRemoteNotificationTypes:myTypes];
//    }
//    
    
    [self confing];
    /**
     * 统计推送打开率1
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    /**
     * 获取融云推送服务扩展字段1
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }

    
//    在launchOptions中有UIApplicationLaunchOptionsShortcutItemKey这样一个键，通过它，我们可以区别是否是从标签进入的app，如果是则处理结束逻辑后，返回NO，防止处理逻辑被反复回调。
    if (launchOptions[@"UIApplicationLaunchOptionsShortcutItemKey"] == nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    
    
}

- (void)addCustomWindow:(UIApplication *)application
{
    self.topWindow = [[UIWindow alloc] init];
    self.topWindow.frame = application.statusBarFrame;
    self.topWindow.hidden = NO;
    self.topWindow.windowLevel = UIWindowLevelAlert;
    self.topWindow.backgroundColor = [UIColor clearColor];
    self.topWindow.rootViewController = [[TopWindowViewController alloc] init];
}



#pragma mark - 配置
- (void)confing
{
    [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
    
    [self confing3DTouch];
    [self customizeInterface];
    [self configRongCloud];
    [self configLocalNotification];
    [self congfingJSPatch];
    
    [[ISULanguageManger shared] initUserLanguage];              //初始化多语种
    
    
    //向微信注册appid.
    //Description :  更新后的api 没有什么作用,只是给开发者一种解释作用.
    [WXApi registerApp:@"wx53bb98d092d08c4d" withDescription:@"微信支付"];
    //
    self.errorVC = [[NSErrorViewController alloc] initWithNibName:@"NSErrorViewController" bundle:nil];
}

- (void)congfingJSPatch
{
    [JPEngine startEngine];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    [JPEngine evaluateScript:script];
    
    
//    // 从网络拉回js脚本执行
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cnbang.net/test.js"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        [JPEngine evaluateScript:script];
//    }];
//    
//    // 执行本地js文件
//    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"js"];
//    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
//    [JPEngine evaluateScript:script];
}


- (void)configRongCloud
{
    [[RCIM sharedRCIM] initWithAppKey:kRongCloud_AppKey];
    [[RongCloudManager sharedClient] connectRongCloudWithToken:@"PTTJNs+2OZG2hKvtjBrw9E/vU2PbNVbN6a7wKvjww07IIhbLBBnkpewMkhXeLWns2lvXNkyZZQ8=" finishBlock:^(id obj) {
        
    } failBlock:^(id error) {
        
    }];
    
}


- (void)configLocalNotification
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:16];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //推送通知的触发时间(何时发出推送通知)
    
    notification.fireDate = date;
    notification.alertBody = @"hello,zgj";
    
    notification.alertAction = @"view List";
    notification.category = @"ACTIONABLE";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

- (void)customizeInterface {
    //设置Nav的背景色和title色
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
//    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                                     NSForegroundColorAttributeName: [UIColor redColor],
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
    
    
    
//    [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextField的光标颜色
//    [[UITextView appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextView的光标颜色
//    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorTableSectionBg] forBarPosition:0 barMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor orangeColor];
}

- (void)confing3DTouch
{
    //    UIApplicationShortcutItem
    //    UIMutableApplicationShortcutItem
    //    UIApplicationShortcutIcon
    
//    1、快捷标签最多可以创建四个，包括静态的和动态的。
//    2、每个标签的题目和icon最多两行，多出的会用...省略
    
    /** 创建shortcutItems */
    NSMutableArray *shortcutItems = [NSMutableArray array];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:@"测试1"];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"2" localizedTitle:@"测试2"];
    [shortcutItems addObject:item1];
    [shortcutItems addObject:item2];
    
    [[UIApplication sharedApplication] setShortcutItems:shortcutItems];
}

/**
 *  Called when the user activates your application by selecting a shortcut on the home screen,当我们点击标签进入应用程序时，也可以进行一些操作
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler NS_AVAILABLE_IOS(9_0) __TVOS_PROHIBITED
{
    /** 处理shortcutItem */
    switch (shortcutItem.type.integerValue)
    {
        case 1: { // 测试1
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoTestVc" object:self userInfo:@{@"type":@"1"}];
        }
        case 2: { // 测试2
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoTestVc" object:self userInfo:@{@"type":@"2"}];
        }   break;
        default:
            break;
    }
//    if([shortcutItem.type isEqualToString:@"com.test.static1"])
//    {
//        NSArray *arr = @[@"hello 3D Touch"];
//        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
//            //设置当前的VC 为rootVC
//            [self.window.rootViewController presentViewController:vc animated:YES completion:^{
//            }];
//    }
}

#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
    // 向微信请求授权后,得到响应结果
    //通过code+appId +appleSecret 去换取access_Token
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
            //拿到了code  state
            SendAuthResp *temp = (SendAuthResp *)resp;
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html",@"text/plain",@"text/json",@"text/xml",@"application/json",@"application/xml",@"application/x-www-form-urlencoded"]];
            NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WXPatient_App_ID, WXPatient_App_Secret, temp.code];
        
//        "access_token" = "-hp4AI67y9MYGqy1GUoNzI9E2k07jArCQOEeW2Y7iUGkdhiquExemVf5-HIEhgXPi0Q3pz5kRGFvHi-qNXpo5sw-ENc_ADfjWTFaY2eAqkE";
//        "expires_in" = 7200;
//        openid = ovnnpwBFvMwQIWkDdHULsQEouQuc;
//        "refresh_token" = "_aK81jIBt1myeeqNhAPqm-XjRO18GMN8-zht2L56iyHEc8zipEQbatxTz0r_YXwGZ5TSGv-IC27G9-glUhdG7ceSdayCxF6aPagxjPrmZDA";
//        scope = "snsapi_userinfo";
//        unionid = "oR9fFv9rAt_b5x_Q608ehVK6Gg4U";
            [manager GET:accessUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"请求access的response = %@", responseObject);
                NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
                NSString *accessToken = [accessDict objectForKey:WX_ACCESS_TOKEN];
                NSString *openID = [accessDict objectForKey:WX_OPEN_ID];
                NSString *refreshToken = [accessDict objectForKey:WX_REFRESH_TOKEN];
                // 本地持久化，以便access_token的使用、刷新或者持续
                if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
                    [[NSUserDefaults standardUserDefaults] setObject:openID forKey:WX_OPEN_ID];
                    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
                    [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
                }
                [self wechatLoginByRequestForUserInfo];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"获取access_token时出错 = %@", error);
            }];
        }
}
// 获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfo {
//    请求用户信息的response = {
//        city = Xuzhou;
//        country = CN;
//        headimgurl = "http://wx.qlogo.cn/mmopen/PiajxSqBRaEIYcwxVhIxSpB9QBicaJySCxjSIg3qia2hlX6d1ia9IVrNDH3wic91NtKC4QySzKu36VM13xtzs0A1shw/0";
//        language = "zh_CN";
//        nickname = "\U6361\U4e0d\U8d77\U6765\U7684\U8282\U64cd";
//        openid = ovnnpwBFvMwQIWkDdHULsQEouQuc;
//        privilege =     (
//        );
//        province = Jiangsu;
//        sex = 1;
//        unionid = "oR9fFv9rAt_b5x_Q608ehVK6Gg4U";
//    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, accessToken, openID];
    // 请求用户数据
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html",@"text/plain",@"text/json",@"text/xml",@"application/json",@"application/xml",@"application/x-www-form-urlencoded"]];
    [manager GET:userUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求用户信息的response = %@", responseObject);
        // NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取用户信息时出错 = %@", error);
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}

#pragma mark  - Push
/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

/**
 * 推送处理4
 * userInfo内容请参考官网文档
 * iOS6及以下系统，收到通知
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}

//处理远程通知
//与上面方面相斥，两者都实现，执行上述方法
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"iOS7及以上系统，收到通知");
    completionHandler(UIBackgroundFetchResultNewData);
}


//本地通知回调函数，当应用程序在前台后台调用
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    NSLog(@"获得本地通知");
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    
    
    
}

//在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(nullable NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
   withResponseInfo:(NSDictionary *)responseInfo
  completionHandler:(void(^)())completionHandler
{
    NSLog(@"本地通知%s",__FUNCTION__);
}



#pragma mark  - iOS10通知
//app 处于前台
//UNPushNotificationTrigger 远程通知
//UNTimeIntervalNotificationTrigger 本地通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog(@"-----willPresentNotification--------");
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知");
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    //前台展示出来弹出框
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

//app 处于后台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSLog(@"-----didReceiveNotificationResponse--------");
}



#pragma mark  - lifeCycle
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillTerminate====");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationWillTerminate====");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate====");
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}



/**
 1.注册 通知
     if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
         //iOS10特有
         UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
         // 必须写代理，不然无法监听通知的接收与点击
         center.delegate = self;
         [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
         if (granted) {
         // 点击允许
         NSLog(@"注册成功");
         [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
         NSLog(@"%@", settings);
         }];
         } else {
         // 点击不允许
         NSLog(@"注册失败");
         }
         }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
         //iOS8 - iOS10
         [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
         
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
         //iOS8系统以下
         [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
 
 // 获得Device Token
 - (void)application:(UIApplication *)application
 didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
     NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
 }
 // 获得Device Token失败
 - (void)application:(UIApplication *)application
 didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
     NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
 }
 
 2.处理接收的通知
    a.前台通知
        - (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
    b.后台
        - (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
    c.app关闭
        - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 
 */

@end
