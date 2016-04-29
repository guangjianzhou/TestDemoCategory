//
//  LanguageManger.h
//  TestLocalLanguage
//
//  Created by jy on 15/5/28.
//  Copyright (c) 2015年 jy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISULanguageManger : NSObject

+(instancetype)shared;

-(NSBundle *)bundle;                                //获取当前资源文件
-(void)initUserLanguage;                            //初始化语言文件
-(NSString *)userLanguage;                          //获取应用当前语言
-(void)setUserlanguage:(NSString *)language;        //设置当前语言
///**
// *  将多语种Key转化为当前App语种对应的文字
// *
// *  @param key
// *
// *  @return 翻译后的文字
// */
//+(NSString *)translateWithKey:(NSString *)key;
@end
