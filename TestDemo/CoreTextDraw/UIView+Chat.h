//
//  UIView+Chat.h
//  CoreTextTest
//
//  Created by lingyj on 12/22/14.
//  Copyright (c) 2014 lingyongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatViewDataSource <NSObject>
- (CGFloat)maxWidthForView;
@end

@interface UIView (Chat)

- (void)setChatViewDataSource:(id <ChatViewDataSource>)dataSource;
- (id <ChatViewDataSource>)chatViewDataSource;


- (void)loadWithMsg:(NSString *)msg  textcolor:textColorHex withMaxWidth:(CGFloat)maxWidth;
//- (void)drawCharAndPicture;
- (CGSize)calculateSizeWithMsg:(NSString *)msg withMaxWidth:(CGFloat)maxWidth;

@end
