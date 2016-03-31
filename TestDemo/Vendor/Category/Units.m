//
//  Units.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/29.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "Units.h"
#import "MBProgressHUD.h"


@implementation Units

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    
    return HUD;
}

@end
