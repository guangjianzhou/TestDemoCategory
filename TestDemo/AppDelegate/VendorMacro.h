//
//  VendorMacro.h
//  TestDemo
//
//  Created by guangjianzhou on 16/4/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//
#import <UIKit/UIKit.h>


#ifndef VendorMacro_h
#define VendorMacro_h


#endif /* VendorMacro_h */


#define kRongCloud_AppKey @"c9kqb3rdkg1lj"
#define kRongCloud_AppSecret @"8sJh10vT4u8k"

//切换语言 TestDemo动态根据strings修改
#define ISULocalizedString(key) [[[ISULanguageManger shared] bundle] localizedStringForKey:key value:nil table:@"TestDemo"]

#define kThemeDidChangeNotification     @"ThemeDidChangeNotification"    //更改主题的通知
#define kThemeName                      @"kThemeName"



UIKIT_EXTERN const CGFloat Color_Red;
UIKIT_EXTERN const CGFloat Color_Blue;
UIKIT_EXTERN const CGFloat Color_Green;