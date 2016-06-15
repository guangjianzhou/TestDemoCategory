

//
//  CustomScrollViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/6/15.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CustomScrollViewController.h"

@interface CustomScrollViewController ()<UIScrollViewDelegate>


/**
 *  设置UIScrollview的contentSize属性,告诉UIScrollview所内容的尺寸----就是滚动的范围
 
    contentOffset:表示UIScrollView滚动的位置(就是内容左上角与scrollView左上角的间距!!)
    contentSize:表示UIScrollView内容的尺寸,滚动范围(能滚多远)
    contentInset:在UIScrollView的四周增加额外的滚动区域,一般用来避免scrollView的内容被其他控件挡住
 
    bounces:设置UIScrollView是否需要弹簧效果，NO看不到其他东西
    pageEnable：分页
    minimumZoomScale和maximumZoomScale 放大缩小 最小范围
 
 */


/**
 UIScrollView内部子控件添加约束的注意点：
 1.子控件的尺寸不能通过UIScrollView来计算，可以考虑通过以下方式计算
 * 可以设置固定值（width==100，height==300）
 * 可以相对于UIScrollView以外的其他控件来计算尺寸
 2.UIScrollView的frame应该通过子控件以外的其他控件来计算
 3.UIScrollView的contentSize通过子控件来计算
 * 根据子控件的尺寸以及子控件与UIScrollView之间的间距
 */


//sizeClass 必须采用AA的样式才会显示
//containVie的高度可以设置为uiview的height+1, containsize的高度大于scrollviewframe 才会滚动
@property (weak, nonatomic) IBOutlet UIScrollView *scroolView;
@property (strong, nonatomic) UIView *bar;


@end

@implementation CustomScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scroolView.delegate = self;
    
//    self.scroolView.bounces = NO;
    UIView *bar = [[UIView alloc] init];
    bar.frame = CGRectMake(0, 70, self.view.frame.size.width, 50);
    bar.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    [_scroolView addSubview:bar];
    self.bar = bar;
}


#pragma mark  - UIScrollViewDelegate
//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"----%s----",__func__);
}


//具体到某个位置
//1.设置bar的y值   2.或者改变frame的父view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"----%s----",__func__);
    NSLog(@"===%f==",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= 70)
    {
        //1.        self.bar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        //1.        [self.view addSubview:self.bar];
        self.bar.frame = CGRectMake(0, scrollView.contentOffset.y, self.view.frame.size.width, 50);
    }
    else
    {
        //1.        self.bar.frame = CGRectMake(0, 70, self.view.frame.size.width, 50);
        //1.        [scrollView addSubview:self.bar];
    }
    
    
    
//      头图片下拉放大
//    CGFloat scale = 1 - (offsetY / 70);
//    scale = (scale >= 1) ? scale : 1;
//    self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
}

//用户停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"----%s----",__func__);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
