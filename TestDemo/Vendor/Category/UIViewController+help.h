//
//  UIViewController+help.h
//  ShareBicycle
//
//  Created by guangjianzhou on 15/12/21.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (help)

#pragma mark - 短信邮件

/**
 *  @brief  发送短信
 *
 *  @param receiver     接受者手机号
 *
 */
- (void)sendToReceiver:(NSArray *)receiver msg:(NSString *)msg;

- (void)sendToReceiver:(NSArray *)receiver msg:(NSString *)msg presentVC:(UIViewController *)vc;

/**
 *  @brief  发送短信
 *
 *  @param receiver     接受者手机号
 *  @param msg          发送的文字信息
 *  @param data         附件
 *  @param type         附件类型
 *  @param fileName     附件名称
 *
 */
- (void)sendToReceiver:(NSArray *)receiver msg:(NSString *)msg attachmentData:(NSData *)data type:(NSString *)type fileName:(NSString *)fileName;

/**
 *  @brief  发送邮件
 *
 *  @param toRecipients     发送者
 *  @param bcRecipients     发送者
 *  @param bccRecipients    发送者
 *  @param mailBody         正文
 *  @param subject          主题
 *
 */
- (void)sendToMailReceiver:(NSArray *)toRecipients ccRecipients:(NSArray *)bcRecipients bccRecipients:(NSArray *)bccRecipients mailBody:(NSString *)mailBody subject:(NSString *)subject;
- (void)sendToMailReceiver:(NSArray *)toRecipients ccRecipients:(NSArray *)bcRecipients bccRecipients:(NSArray *)bccRecipients mailBody:(NSString *)mailBody subject:(NSString *)subject attachmentData:(NSData *)attachment mimeType:(NSString *)mimeType fileName:(NSString *)filename;

- (void)sendToMailReceiver:(NSArray *)toRecipients ccRecipients:(NSArray *)bcRecipients bccRecipients:(NSArray *)bccRecipients mailBody:(NSString *)mailBody subject:(NSString *)subject presentFromVC:(UIViewController *)vc;
- (void)sendToMailReceiver:(NSArray *)toRecipients ccRecipients:(NSArray *)bcRecipients bccRecipients:(NSArray *)bccRecipients mailBody:(NSString *)mailBody subject:(NSString *)subject attachmentData:(NSData *)attachment mimeType:(NSString *)mimeType fileName:(NSString *)filename presentFromVC:(UIViewController *)vc;


/**
 * @brief 发送邮件
 *
 * @param recipients 接收者
 * @param body 正文
 */
- (void)launchMailAppOnDeviceReceiver:(NSString *)recipients body:(NSString *)body;




@end
