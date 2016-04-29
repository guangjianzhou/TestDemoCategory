




//
//  ThemeConfig.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/29.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "ThemeConfig.h"

@implementation ThemeConfig

//夜间状态
+ (void)saveWhetherNightMode:(BOOL)isNight
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@(isNight) forKey:@"mode"];
    [userDefaults synchronize];
}
+ (BOOL)getMode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [[userDefaults objectForKey:@"mode"] boolValue];
}

@end
