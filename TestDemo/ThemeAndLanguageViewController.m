//
//  ThemeAndLanguageViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/28.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "ThemeAndLanguageViewController.h"
#import "ISULanguageManger.h"
#import "ThemeManager.h"

@interface ThemeAndLanguageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *themeBtn;
@property (weak, nonatomic) IBOutlet UIButton *languageBtn;

@end

@implementation ThemeAndLanguageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguageAction:) name:@"changeLanguage" object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_themeBtn setTitle:ISULocalizedString(@"ThemeTitle") forState:UIControlStateNormal];
    [_languageBtn setTitle:ISULocalizedString(@"LanguageTitle") forState:UIControlStateNormal];
}

/**
 *   主题切换
 *  方法1：[[NSNotificationCenter defaultCenter] postNotificationName:@"dawnAndNight" object:nil]; 
 *        发送通知，选择对应的一套颜色
 
 *  方法2: 换image颜色  skins 要用forder 不做编译，当做资源文件 
 group 一般只在你的工程中是文件夹的形式，但是在本地的目录中还是以散乱的形式放在一起的，除非你是从外部以group的形式引用进来的。
 
 folder 只能作为资源，整个引用进项目，不能编译代码，也就是说，以folder形式引用进来的文件，不能被放在complie sources列表里面。
 *
 */
- (IBAction)changeThemeAction:(UIButton *)sender
{
    //取出选中的主题名称
    NSString *themeName = @"默认";
    [ThemeManager shareInstance].themeName = themeName;
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:themeName];
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:kThemeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// 应用内部语言不跟随系统语言，由应用自己进行控制，通过配置多个语言文件，根据用户的选择动态获取不同文件夹下的语言文件，显示在界面上。
//最后把用户选择的语言持久化到本地，下次运行时读取。
- (IBAction)changeLanguage:(UIButton *)sender
{
    NSString *lan = [[ISULanguageManger shared] userLanguage];
    if(![lan isEqualToString:@"zh-Hans"])
    {
        [[ISULanguageManger shared] setUserlanguage:@"zh-Hans"];
    }
    else
    {
        [[ISULanguageManger shared] setUserlanguage:@"en"];
    }
    
    //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
    
}

-(void)clickCellIndex:(NSInteger)index
{
    NSString *lan = [[ISULanguageManger shared] userLanguage];
    switch (index) {
        case 0:
        {
            //判断当前的语言，进行改变
            if(![lan isEqualToString:@"zh-Hans"])
            {
                [[ISULanguageManger shared] setUserlanguage:@"zh-Hans"];
            }
            break;
        }
        case 1:
        {
            if(![lan isEqualToString:@"zh-Hant"])
            {
                [[ISULanguageManger shared]setUserlanguage:@"zh-Hant"];
            }
            break;
        }
        case 2:
        {
            if(![lan isEqualToString:@"en"])
            {
                [[ISULanguageManger shared] setUserlanguage:@"en"];
            }
            break;
        }
        default:
            break;
    }
}


- (void)changeLanguageAction:(NSNotification *)notifi
{
    [_themeBtn setTitle:ISULocalizedString(@"ThemeTitle") forState:UIControlStateNormal];
    [_languageBtn setTitle:ISULocalizedString(@"LanguageTitle") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
