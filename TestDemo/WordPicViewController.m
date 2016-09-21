//
//  WordPicViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/8/25.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "WordPicViewController.h"
#import <CoreText/CoreText.h>
#import "CustomPicView.h"

@interface WordPicViewController ()


@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) CustomPicView *picView;

@end

@implementation WordPicViewController

/**
 *  1.NSMutableAttributedString
    2.CoreText
    3.UIWebView
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"图文混排";
    

    _picView = [[CustomPicView alloc] initWithFrame:CGRectMake(0, 164, 300, 300)];
    _picView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_picView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableAttributedString *attstr1 = [[NSMutableAttributedString alloc] initWithString:@"你好牛逼"];
    [attstr1 addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(1, 2)];

    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.bounds = CGRectMake(0, -4,10, 10);
    attachment.image = [UIImage imageNamed:@"lxh_beicui"];
    NSMutableAttributedString *attstr = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    
    //图片大小设置为字体大小
    NSMutableAttributedString *attstr3 = [[NSMutableAttributedString alloc] init];
    [attstr3 appendAttributedString:attstr1];
    [attstr3 appendAttributedString:attstr];
    [attstr3 appendAttributedString:attstr1];
    [self.label setAttributedText:attstr3];
}



@end
