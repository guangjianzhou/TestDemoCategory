

//
//  XibInSBView.m
//  TestDemo
//
//  Created by ZGJ on 16/9/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "XibInSBView.h"
#import <Masonry/Masonry.h>


/**
 *  在storyboard中使用自定义的view
 *
 *  1.在xib中进行创建，然后 File’s Owner：设置为自定义view
 *  2.在storyboard中创建，然后创建view与之相连
 */


//File’s Owner：
//xib对应的类，比如UIView的File’s Owner就是视图控制器UIViewController。
//View和ViewController之间的对应关系，需要一个桥梁来进行连接的（即，对于一个视图，他如何知道自己的界面的操作应该由谁来响应），这个桥梁就是File's Owner。


@interface XibInSBView ()<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end


@implementation XibInSBView

- (void)awakeFromNib
{
    [super awakeFromNib];
    //加载之前 _contentView 为nil
    [[NSBundle mainBundle] loadNibNamed:@"XibInSBView" owner:self options:nil];
    [self addSubview:self.contentView];
    
    //contentView和约束
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    //和约束相同
    self.contentView.frame = self.bounds;
}





#pragma  mark  - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"------------");
}


@end
