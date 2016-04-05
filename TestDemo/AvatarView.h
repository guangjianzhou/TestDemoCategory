//
//  AvatarView.h
//  TestDemo
//
//  Created by guangjianzhou on 16/4/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarView : UIView


#pragma mark - make image
+ (UIImage *)defaultAvatarForVoipWithName:(NSString *)name phoneNum:(NSString *)phoneNum;
+ (UIImage *)defaultAvatarForGroupDefaultWithName:(NSString *)name phoneNum:(NSString *)phoneNum;


@end
