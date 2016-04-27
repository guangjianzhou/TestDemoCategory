//
//  Units.h
//  TestDemo
//
//  Created by guangjianzhou on 16/3/29.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBProgressHUD;

@interface Units : NSObject


+ (MBProgressHUD *)createHUD;




/**
 NSString *content = @"文字加上表情[得意][酷][呲牙]";
 NSMutableAttributedString *attrStr = [Utility emotionStrWithString:content];
 _firstLabel.attributedText= attrStr;
 
 NSString *text = @"<微信>腾讯科技讯 微软提供免费升级的Windows 10，在全球获得普遍好评。但微软已经有一段时间没有公布最新升级数据。科技市场研究公司StatCounter发布了有关Windows升级的相关数据，显示出Windows 10的升级节奏开始放缓。<微信>另外，数据显示Windows 8用户是升级的主力军，Windows 7用户升级动力不太足。";
 NSMutableAttributedString *attrStr2 = [Utility exchangeString:@"<微信>" withText:text imageName:@"header_wechat"];
 _secondLabel.attributedText = attrStr2;
 
 */
//处理表情字符
+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text;

/**
 *  将带有表情符的文字转换为图文混排的文字
 *
 *  @param text      带表情符的文字
 *  @param plistName 表情符与表情对应的plist文件
 *  @param y         图片的y偏移值
 *
 *  @return 转换后的文字
 */
+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text plistName:(NSString *)plistName y:(CGFloat)y;
/**
 *  将个别文字转换为特殊的图片
 *
 *  @param string    原始文字段落
 *  @param text      特殊的文字
 *  @param imageName 要替换的图片
 *
 *  @return  NSMutableAttributedString
 */
+ (NSMutableAttributedString *)exchangeString:(NSString *)string withText:(NSString *)text imageName:(NSString *)imageName;


@end
