//
//  UIViewController+help.m
//  ShareBicycle
//
//  Created by guangjianzhou on 15/12/21.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "UIViewController+help.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Toast+UIView.h"
#import <objc/runtime.h>

#define SetNavigationBarWithBlueColor(navigationController)            [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1 / 255.0f green:143 / 255.0f blue:219 / 255.0f alpha:1]]
#define SetNavigationBarTitleAttribute(navigationController)           [navigationController.navigationBar setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18.f] }]

#define SetNavigationBarWithImage(navigationController)                [navigationController.navigationBar setBackgroundImage: is_iOS_7 ? [UIImage imageNamed:@"bg_title_blue.png"] : [UIImage imageNamed:@"bg_title_blue_6.png"] forBarMetrics: UIBarMetricsDefault];


static const NSString * kSMSPresentVC  = @"SMSPresentVC";
static const NSString * kMailPresentVC  = @"MailPresentVC";

@implementation UIViewController (help)
- (void)sendToReceiver:(NSArray *)receiver msg:(NSString *)msg presentVC:(UIViewController *)vc
{
    if (![MFMessageComposeViewController canSendText])
    {
        //不能发送短信
        [UIView showToastWithText:@"此设备不支持发送短信"];
        return;
    }
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    
    picker.recipients = receiver;
    picker.messageComposeDelegate = self;
    picker.body = msg;
    
    SetNavigationBarWithImage(picker);
    SetNavigationBarTitleAttribute(picker);
    
    if (vc)
    {
        objc_setAssociatedObject(self, &kSMSPresentVC, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [vc?:self presentViewController:picker animated:YES completion:NULL];
}

- (void)sendToReceiver:(NSArray *)receiver msg:(NSString *)msg
{
    [self sendToReceiver:receiver msg:msg presentVC:nil];
}

- (void)sendToReceiver:(NSArray *)receiver msg:(NSString *)msg attachmentData:(NSData *)data type:(NSString *)type fileName:(NSString *)fileName
{
    if (![MFMessageComposeViewController canSendText])
    {
        //不能发送短信
        [UIView showToastWithText:@"此设备不支持发送短信"];
        return;
    }
    
    if (!is_iOS_7)
    {
        [UIView showToastWithText:@"此设备不支持发送彩信"];
    }
    else
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        
        picker.recipients = receiver;
        picker.messageComposeDelegate = self;
        picker.body = msg;
        
        [picker addAttachmentData:data typeIdentifier:type filename:fileName];
        
        SetNavigationBarWithImage(picker);
        SetNavigationBarTitleAttribute(picker);
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            [UIView showToastWithText:@"发送取消"];
            break;
            
        case MessageComposeResultFailed:
            [UIView showToastWithText:@"发送失败"];
            break;
            
        case MessageComposeResultSent:
            [UIView showToastWithText:@"发送成功"];
            break;
            
        default:
            break;
    }
    
    UIViewController *vc = (UIViewController *)objc_getAssociatedObject(self, &kSMSPresentVC);
    [vc?:self dismissViewControllerAnimated:YES completion:nil];
}


- (void)sendToMailReceiver:(NSArray *)toRecipients ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients mailBody:(NSString *)mailBody subject:(NSString *)subject
{
    [self sendToMailReceiver:toRecipients ccRecipients:ccRecipients bccRecipients:bccRecipients mailBody:mailBody subject:subject presentFromVC:nil];
}

- (void)sendToMailReceiver:(NSArray *)toRecipients ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients mailBody:(NSString *)mailBody subject:(NSString *)subject presentFromVC:(UIViewController *)vc
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    [mailPicker setToRecipients:toRecipients];
    [mailPicker setCcRecipients:ccRecipients];
    [mailPicker setBccRecipients:bccRecipients];
    [mailPicker setSubject:subject];
    [mailPicker setMessageBody:mailBody isHTML:NO];
    
    SetNavigationBarWithImage(mailPicker);
    SetNavigationBarTitleAttribute(mailPicker);
    if (vc)
    {
        objc_setAssociatedObject(self, &kMailPresentVC, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [vc?:self presentViewController:mailPicker animated:YES completion:nil];
}

- (void)sendToMailReceiver:(NSArray *)toRecipients ccRecipients:(NSArray *)bcRecipients bccRecipients:(NSArray *)bccRecipients mailBody:(NSString *)mailBody subject:(NSString *)subject attachmentData:(NSData *)attachment mimeType:(NSString *)mimeType fileName:(NSString *)filename
{
    [self sendToMailReceiver:toRecipients ccRecipients:bccRecipients bccRecipients:bccRecipients mailBody:mailBody subject:subject attachmentData:attachment mimeType:mimeType fileName:filename presentFromVC:nil];
}

- (void)sendToMailReceiver:(NSArray *)toRecipients ccRecipients:(NSArray *)bcRecipients bccRecipients:(NSArray *)bccRecipients mailBody:(NSString *)mailBody subject:(NSString *)subject attachmentData:(NSData *)attachment mimeType:(NSString *)mimeType fileName:(NSString *)filename presentFromVC:(UIViewController *)vc
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    [mailPicker setToRecipients:toRecipients];
    [mailPicker setCcRecipients:bcRecipients];
    [mailPicker setBccRecipients:bccRecipients];
    [mailPicker setSubject:subject];
    [mailPicker setMessageBody:mailBody isHTML:NO];
    [mailPicker addAttachmentData:attachment mimeType:mimeType fileName:filename];
    
    SetNavigationBarWithImage(mailPicker);
    SetNavigationBarTitleAttribute(mailPicker);
    if (vc)
    {
        objc_setAssociatedObject(self, &kMailPresentVC, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [vc?:self presentViewController:mailPicker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self toastWithTitle:nil msg:@"发送取消"];
            break;
            
        case MFMailComposeResultSaved:
            [self toastWithTitle:nil msg:@"保存成功"];
            break;
            
        case MFMailComposeResultSent:
            [self toastWithTitle:nil msg:@"发送成功"];
            break;
            
        case MFMailComposeResultFailed:
            [self toastWithTitle:nil msg:@"发送失败"];
            break;
            
        default:
            break;
    }
    
    UIViewController *vc = (UIViewController *)objc_getAssociatedObject(self, &kMailPresentVC);
    [vc?:self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toastWithTitle:(NSString *)_title_ msg:(NSString *)msg
{
    [UIView showToastWithText:msg];
}

- (void)launchMailAppOnDevice
{
    NSString *recipients = @"";
    NSString *body = @"";
    NSString *email = [NSString stringWithFormat:@"mailto:%@?body=%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)launchMailAppOnDeviceReceiver:(NSString *)recipients body:(NSString *)body
{
    NSString *email = [NSString stringWithFormat:@"mailto:%@?body=%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL isSuccess = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    if (!isSuccess)
    {
        [UIView showToastWithText:@"您尚未设置邮箱账户,请在'设置->邮箱、通讯录、日历->添加帐户'配置"];
    }
}



@end
