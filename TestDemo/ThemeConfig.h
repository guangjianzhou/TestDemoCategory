//
//  ThemeConfig.h
//  TestDemo
//
//  Created by guangjianzhou on 16/4/29.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeConfig : NSObject

+ (BOOL)getMode;
+ (void)saveWhetherNightMode:(BOOL)isNight;


@end
