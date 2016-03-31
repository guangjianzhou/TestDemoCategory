//
//  NSString+help.h
//  ShareBicycle
//
//  Created by guangjianzhou on 15/12/21.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+Emojize.h"

@interface NSString (help)

+ (NSString *)userAgentStr;

- (NSString *)URLEncoding;
- (NSString *)URLDecoding;


+ (NSString *)handelRef:(NSString *)ref path:(NSString *)path;

-(BOOL)containsEmoji;

- (NSString *)emotionMonkeyName;

- (NSString *)trimWhitespace;

- (BOOL)isEmptyOrListening;

- (NSRange)rangeByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
- (NSRange)rangeByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

#pragma mark - Util常用

//沙盒路径
+ (NSString *)documentPath;

//判读字符串是否为空
- (BOOL)isEmpty;

//转换拼音
- (NSString *)transformToPinyin;

//是否包含语音解析的图标
- (BOOL)hasListenChar;

//判断是否为整形
- (BOOL)isPureInt;
//判断是否为浮点形
- (BOOL)isPureFloat;

/**
 *  字节换算 B/kB/MB/GB
 *
 *  @param sizeOfByte 字节B
 *
 */
+ (NSString *)sizeDisplayWithByte:(CGFloat)sizeOfByte;

//计算字符长度
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

//判断号码是否为手机号(可以包含+86,+,86)
+ (BOOL)validateMobile:(NSString *)mobileNum;

#pragma mark - 读写plist文件
/**
 *  将字典写入文件
 *
 *  @param addDataDic
 *  @param filenamePlist  位于沙盒Document/
 */
+ (BOOL)writeToPlistWithDic:(NSDictionary *)addDataDic filename:(NSString *)filenamePlist;

/**
 *  读取plist 文件
 *
 *  @param filenamePlist   位于沙盒Document/
 *
 */
+ (NSMutableArray *)readPlistName:(NSString *)filenamePlist;

#pragma mark - AddressBook
//去掉标签格式
+ (NSString *)removeLabelFormat:(NSString *)label;

//是否手机号(可以发短信)
+ (BOOL)isLabelMobile:(NSString *)label;
//是否短号
+ (BOOL)isLabelShotMobile:(NSString *)label;


//去掉标签格式
- (NSString *)removeLabelFormat;

//是否手机号(可以发短信)
- (BOOL)isLabelMobile;
//是否短号
- (BOOL)isLabelShotMobile;


#pragma mark - 加密
- (NSString *)md5Str;
// sha1加密
- (NSString*) sha1Str;
- (NSString *)sha256;
- (NSString *)sha512;
- (NSString*) HMACWithSecret:(NSString*) secret;
- (NSString *)hexStringFromString;
//sha1  转十六进制
- (NSString *)sha1ForHex;

#pragma mark  - 判断
/**
 *  对链接URL进行判断
 *
 */
+ (BOOL)isURL:(NSString *)string;


@end

