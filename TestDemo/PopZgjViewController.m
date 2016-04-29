//
//  PopZgjViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/27.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "PopZgjViewController.h"
#import "XHPopMenu.h"
#import "PopMenu.h"
#import "PopCustomView.h" //xib
#import "DCPaymentView.h"//纯代码

@interface PopZgjViewController ()
{
    PopCustomView *popView;
}

//弹出框
@property (strong, nonatomic) XHPopMenu *popMenu;
@property (strong, nonatomic) PopMenu *myPopMenu;




@end

@implementation PopZgjViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)popType1Action:(UIButton *)sender
{
    [self.popMenu showMenuOnView:self.view atPoint:CGPointZero];
}



- (IBAction)popType3Action:(UIButton *)sender
{
    [self showPopMenu];
    UIView *presentView=[[[UIApplication sharedApplication].keyWindow rootViewController] view];
    [_myPopMenu showMenuAtView:presentView startPoint:CGPointMake(0, -100) endPoint:CGPointMake(0, -100)];
}



- (IBAction)popType2Action:(UIButton *)sender
{
    if(!popView)
    {
        popView = [[PopCustomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    [popView showInContainView:self.view];
}

- (IBAction)popType4Action:(UIButton *)sender
{
    DCPaymentView *payAlert = [[DCPaymentView alloc]init];
    payAlert.title = @"请输入支付密码";
    payAlert.detail = @"提现";
    payAlert.amount= 10;
    [payAlert show];
    payAlert.completeHandle = ^(NSString *inputPwd) {
        NSLog(@"密码是%@",inputPwd);
    };
}

- (void)showPopMenu
{
    //初始化弹出菜单
    NSArray *menuItems = @[
                           [MenuItem itemWithTitle:@"项目" iconName:@"pop_Project" index:0],
                           [MenuItem itemWithTitle:@"任务" iconName:@"pop_Task" index:1],
                           [MenuItem itemWithTitle:@"冒泡" iconName:@"pop_Tweet" index:2],
                           [MenuItem itemWithTitle:@"添加好友" iconName:@"pop_User" index:3],
                           [MenuItem itemWithTitle:@"私信" iconName:@"pop_Message" index:4],
                           [MenuItem itemWithTitle:@"两步验证" iconName:@"pop_2FA" index:5],
                           ];
    if (!_myPopMenu)
    {
        _myPopMenu = [[PopMenu alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) items:menuItems];
        _myPopMenu.perRowItemCount = 3;
        _myPopMenu.menuAnimationType = kPopMenuAnimationTypeSina;
    }
    _myPopMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem){
        NSLog(@"----点击的-%@----",selectedItem.title);
    };
}

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 5; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"contacts_add_newmessage";
                    title = @"发起群聊";
                    break;
                }
                case 1: {
                    imageName = @"contacts_add_friend";
                    title = @"添加朋友";
                    break;
                }
                case 2: {
                    imageName = @"contacts_add_scan";
                    title = @"扫一扫";
                    break;
                }
                case 3: {
                    imageName = @"contacts_add_photo";
                    title = @"拍照分享";
                    break;
                }
                case 4: {
                    imageName = @"contacts_add_voip";
                    title = @"视频聊天";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            NSLog(@"点击了第%ld行----",(long)index);
        };
    }
    return _popMenu;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end