//
//  Macro.h
//  TestDemo
//
//  Created by guangjianzhou on 16/3/31.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#endif /* Macro_h */


//定义基本宏

#define kSCreen_Bounds [UIScreen mainScreen].bounds
#define kSCreenWidth [UIScreen mainScreen].bounds.size.width
#define kSCreenHeight [UIScreen mainScreen].bounds.size.height

//UIColorFromRGB(0x393836)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//版本号
#define kVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuild [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]


#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#define kKeyWindow [UIApplication sharedApplication].keyWindow

#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


//weak strong

/**
 * @code
 * ESWeak(imageView, weakImageView);
 * [self testBlock:^(UIImage *image) {
 *         ESStrong(weakImageView, strongImageView);
 *         strongImageView.image = image;
 * }];
 *
 * // `ESWeak_(imageView)` will create a var named `weak_imageView`
 * ESWeak_(imageView);
 * [self testBlock:^(UIImage *image) {
 *         ESStrong_(imageView);
 * 	_imageView.image = image;
 * }];
 *
 * // weak `self` and strong `self`
 * ESWeakSelf;
 * [self testBlock:^(UIImage *image) {
 *         ESStrongSelf;
 *         _self.image = image;
 * }];
 * @endcode
 */
#define ESWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define ESStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESStrong_(var) ESStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define ESWeakSelf      ESWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define ESStrongSelf    ESStrong(__weakSelf, _self);


