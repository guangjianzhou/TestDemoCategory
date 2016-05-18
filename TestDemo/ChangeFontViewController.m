//
//  ChangeFontViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/5/16.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "ChangeFontViewController.h"

@interface ChangeFontViewController ()

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation ChangeFontViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (NSString *familyName in [UIFont familyNames])
    {
        NSLog(@"==font name = %@=====",familyName);
        
        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName])
        {
            NSLog(@"\t%@",fontName);         //*输出字体族科下字样名字
        }
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeFontAction:(UIButton *)sender
{
    //搜索出名字 HanWangKaiBold-Gb5
    _titleLabel.font = [UIFont fontWithName:@"HanWangKaiBold-Gb5" size:21];
    _titleBtn.titleLabel.font = [UIFont fontWithName:@"HanWangKaiBold-Gb5" size:21];
}

@end
