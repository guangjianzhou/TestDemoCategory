//
//  WCAlertview.h
//  WCAlertView
//
//  Created by huangwenchen on 15/2/17.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WCALertviewDelegate<NSObject>
@optional
-(void)didClickButtonAtIndex:(NSUInteger)index;

@end

@interface WCAlertview : UIView
@property (weak,nonatomic) id<WCALertviewDelegate> delegate;
-(instancetype)initWithTitle:(NSString *) title Image:(UIImage *)image CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;
- (void)show;
@end
