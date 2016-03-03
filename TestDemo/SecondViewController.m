//
//  SecondViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/17.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import <ViewPagerController.h>

@interface SecondViewController ()<ViewPagerDataSource,ViewPagerDelegate>


@end

@implementation SecondViewController

- (void)viewDidLoad
{
    self.delegate = self;
    self.dataSource = self;
//    self.automaticallyAdjustsScrollViewInsets=NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return 4;
}

- (UILabel *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            UILabel * titleLabel = [UILabel new];
            titleLabel.text = @"已发布";
            [titleLabel sizeToFit];
            return titleLabel;
        }
        case 1:
        {
            UILabel * titleLabel = [UILabel new];
            titleLabel.text = @"进行中";
                        [titleLabel sizeToFit];
            return titleLabel;
        }
        case 2:
        {
            UILabel * titleLabel = [UILabel new];
            titleLabel.text = @"已完成";
                        [titleLabel sizeToFit];
            return titleLabel;
        }
        case 3:
        {
            UILabel * titleLabel = [UILabel new];
            titleLabel.text = @"已取消";
                        [titleLabel sizeToFit];
            return titleLabel;
        }
        default:
            break;
    }
    return nil;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    ThirdViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdViewController"];
    
    cvc.view.backgroundColor = (index%2==0)?[UIColor yellowColor]:[UIColor orangeColor];
    return cvc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    
    switch (option)
    {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component)
    {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
        case ViewPagerTabsView:
            return [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
        case ViewPagerContent:
            return [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
        default:
            return color;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
