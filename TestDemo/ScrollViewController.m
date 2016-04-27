//
//  ScrollViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/19.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "ScrollViewController.h"
#import "Toast+UIView.h"

@interface ScrollViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation ScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSLog(@"%@",path);
    
    NSMutableDictionary *dict = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:path];
    NSLog(@"%@",dict);
    
    NSString *str = [dict objectForKey:@"CFBundleIdentifier"];
    NSLog(@"%@",str);
    
    
    
    //更改完plist  之后重新写入
    [dict setObject:[str stringByAppendingString:@"_1"] forKey:@"CFBundleIdentifier"];
    
    BOOL isOK =  [dict writeToFile:path atomically:YES];
    NSLog(@"写入===%d",isOK);
    
    
    [UIView showToastWithText:str];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
