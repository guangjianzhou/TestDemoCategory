//
//  LanguageManger.m
//  TestLocalLanguage
//
//  Created by jy on 15/5/28.
//  Copyright (c) 2015年 jy. All rights reserved.
//

#import "ISULanguageManger.h"

@implementation ISULanguageManger

+ (instancetype)shared {
    static ISULanguageManger * lanagerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lanagerManager = [[ISULanguageManger alloc] init];
    });
    return lanagerManager;
}

//创建静态变量bundle，以及获取方法bundle(此处不要使用getBundle)
static NSBundle *bundle = nil;
- ( NSBundle * )bundle
{
    return bundle;
}

//初始化方法：userLanguage储存在NSUserDefaults中，首次加载时要检测是否存在，如果不存在的话读AppleLanguages，并赋值给userLanguage。
-(void)initUserLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:@"userLanguage"];
    if(string.length == 0){
        //获取系统当前语言版本(中文zh-Hans,英文en)  //zh-Hans-US zh-Hans-CN   //en-US en-CN
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        NSString *current = [languages objectAtIndex:0];
        NSMutableArray *currentStr = [NSMutableArray arrayWithArray:[current componentsSeparatedByString:@"-"]];
        if (currentStr.count > 0)
        {
            [currentStr removeLastObject];
            current = [currentStr componentsJoinedByString:@"-"];
        }
        
        string = current;
        [def setValue:string forKey:@"userLanguage"];
        [def synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

-(NSString *)userLanguage
{
    NSString * language = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"];
    return language;
}

//设置当前语言
-(void)setUserlanguage:(NSString *)language
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    [def synchronize];
}

@end
