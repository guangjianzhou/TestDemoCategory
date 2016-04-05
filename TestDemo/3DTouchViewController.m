//
//  3DTouchViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/5.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "3DTouchViewController.h"
#import "TZTestOneViewController.h"
#import "TZTestTwoViewController.h"

@interface _DTouchViewController ()<UIViewControllerPreviewingDelegate>

@property (nonatomic, assign) CGRect sourceRect;       // 用户手势点 对应需要突出显示的rect
@property (nonatomic, strong) NSIndexPath *indexPath;  // 用户手势点 对应的indexPath

@end

@implementation _DTouchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 处理shortCutItem 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoTestVc:) name:@"gotoTestVc" object:nil];
#warning 注意
    //首先控制器该继承UIViewControllerPreviewingDelegate应该判断该控制器当前是否实现了3dtouch手势
    //如果实现的话最好禁用长按手势 （如果你的添加了该手势的话）
    
    
    //判断是否支持3dTouch
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        // 注册Peek和Pop方法
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
//        self.longPress.enable = NO;
        NSLog(@"3D Touch is available ! Hurra!");
    }
    else
    {
//        self.longPress.enable = YES;
        NSLog(@"3D Touch is not available on the device");
    }
    
    
}

//也可以在appdelegate 中写
- (void)setUpShortCut
{
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"iCon1"];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"iCon2"];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"iCon3"];
    
    // create several (dynamic) shortcut items
    UIMutableApplicationShortcutItem
    *item1 = [[UIMutableApplicationShortcutItem
               alloc]initWithType:@"com.test.dynamic" localizedTitle:@"DynamicShortcut" localizedSubtitle:@"available after first launch" icon:icon1
              userInfo:nil];
    
    UIMutableApplicationShortcutItem
    *item2 = [[UIMutableApplicationShortcutItem
               alloc]initWithType:@"com.test.deep1" localizedTitle:@"Deep Link 1"
              localizedSubtitle:@"Launch Nav Controller" icon:icon2 userInfo:nil];
    
    UIMutableApplicationShortcutItem
    *item3 = [[UIMutableApplicationShortcutItem
               alloc]initWithType:@"com.test.deep2" localizedTitle:@"Deep Link 2"
              localizedSubtitle:@"Launch 2nd Level" icon:icon3 userInfo:nil];
    
    // add all items to an array
    NSArray *items = @[item1, item2, item3];
    // add this array to the potentially existing static UIApplicationShortcutItems
    NSArray *existingItems = [UIApplication sharedApplication].shortcutItems;
    NSArray *updatedItems = [existingItems arrayByAddingObjectsFromArray:items];
    [UIApplication sharedApplication].shortcutItems = updatedItems;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


/**
 *  3DTouch三个模块
 *  1.HomeScreen Quick Action
     通过主屏幕的应用Icon，我们可以用3D Touch呼出一个菜单，进行快速定位应用功能模块相关功能的开发。
 *  2. peek and pop
       a1.提示用户这里有3D Touch的交互，会使交互控件周围模糊
       a2.继续深按，会出现预览视图
       a3.通过视图上的交互控件进行进一步交互
 *  3.Force Properties 力度 
    我们可以检测某一交互的力度值，来做相应的交互处理。例如，我们可以通过力度来控制快进的快慢，音量增加的快慢等。
 
 */


/**
 * 1. Info.plist 配置
 *  必填项（下面两个键值是必须设置的）：
 
 UIApplicationShortcutItemType 这个键值设置一个快捷通道类型的字符串
 
 UIApplicationShortcutItemTitle 这个键值设置标签的标题
 
 选填项（下面这些键值不是必须设置的）：
 
 UIApplicationShortcutItemSubtitle 设置标签的副标题
 
 UIApplicationShortcutItemIconType 设置标签Icon类型
 
 UIApplicationShortcutItemIconFile  设置标签的Icon文件

 ② 动态在 appdelegate 中实现
 
 动态标签是我们在程序中，通过代码添加的，与之相关的类，主要有三个：
 
 UIApplicationShortcutItem 创建3DTouch标签的类
 
 UIMutableApplicationShortcutItem 创建可变的3DTouch标签的类
 
 UIApplicationShortcutIcon 创建标签中图片Icon的类
 */

//#pragma mark  - UIViewControllerPreviewingDelegate
////点击进入预览模式： 实现该协议方法
//- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
//{
//    //进入预览模式
////    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Action 1"
////                                                          style:UIPreviewActionStyleDefault
////                                                        handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
////        
////        NSLog(@"Action 1 triggered");
////        
////    }];
//    
//    UIViewController *childVC = [[UIViewController alloc] init];
//    childVC.preferredContentSize = CGSizeMake(0.0f,300);
//    
//    CGRect rect = CGRectMake(10, location.y - 10, self.view.frame.size.width - 20,20);
//    previewingContext.sourceRect = rect;
//    return childVC;
//}

////继续按压进入：实现该协议
//- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0)
//{
//      [self showViewController:nil sender:self];
//}

#pragma mark peek && pop 代理方法
/** peek手势  点击进入预览模式*/
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    UIViewController *childVC = [[UIViewController alloc] init];
    
    // 获取用户手势点所在cell的下标。同时判断手势点是否超出tableView响应范围。
    if (![self getShouldShowRectAndIndexPathWithLocation:location]) return nil;
    
    previewingContext.sourceRect = self.sourceRect;
    
    // 加个白色背景
    UIView *bgView =[[UIView alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth - 40, - 20 - 64 * 2)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    [childVC.view addSubview:bgView];
    
    // 加个lable
    UILabel *lable = [[UILabel alloc] initWithFrame:bgView.bounds];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"有种再按重一点...";
    [bgView addSubview:lable];
    
    return childVC;
}

/** pop手势 继续按压进入 */
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    //调用点击cell方法--didSelectRowAtIndexPath
    
}

/** 获取用户手势点所在cell的下标。同时判断手势点是否超出tableView响应范围。*/
- (BOOL)getShouldShowRectAndIndexPathWithLocation:(CGPoint)location
{
    NSInteger row = (location.y - 20)/50;
    self.sourceRect = CGRectMake(0, row * 50 + 20,kScreenWidth, 50);
    self.indexPath = [NSIndexPath indexPathForItem:row inSection:0];
    // 如果row越界了，返回NO 不处理peek手势
//    return row >= self.items.count ? NO : YES;
    return YES;
}

#pragma mark 通知相关

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gotoTestVc:(NSNotification *)noti {
    NSString *type = noti.userInfo[@"type"];
    UIViewController *testVc;
    if ([type isEqualToString:@"1"]) {        // 测试1
        testVc = [[TZTestOneViewController alloc] initWithNibName:@"TZTestOneViewController" bundle:nil];
    } else if ([type isEqualToString:@"2"]) { // 测试2
        testVc = [[TZTestTwoViewController alloc] initWithNibName:@"TZTestTwoViewController" bundle:nil];
    }
    [self presentViewController:testVc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
