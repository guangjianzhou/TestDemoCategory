

//
//  WebViewCosntroller.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/23.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "WebViewCosntroller.h"
#import "WebViewJavascriptBridge.h"

@interface WebViewCosntroller ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) WebViewJavascriptBridge *bridge;


@end



@implementation WebViewCosntroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://www.sina.com.cn/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    //属性
    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [self setUpLeftNaviItem];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"-----WebViewJavascriptBridge--------------");
    }];
    
}


- (void)setUpLeftNaviItem
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backPressAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}


//    [webView goBack];//返回
//    [webView goForward];//向前
//    [webView reload];//重新加载数据
//    [webView stopLoading];//停止加载数据
- (void)backPressAction:(UIButton *)btn
{
    if (_webView.canGoBack)
    {
        [_webView goBack];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate

//UIWebViewNavigationTypeLinkClicked     用户触击了一个链接
//UIWebViewNavigationTypeFormSubmitted   用户提交了一个表单
//UIWebViewNavigationTypeBackForward     用户触击前进或返回按钮
//UIWebViewNavigationTypeReload          用户触击重新加载的按钮
//UIWebViewNavigationTypeFormResubmitted 用户重复提交表单
//UIWebViewNavigationTypeOther           发生其它行为
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"--shouldStartLoadWithRequest----%@------",request.URL);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"--webViewDidStartLoad----------");
}

/**
 *  stringByEvaluatingJavaScriptFromString 必须在didFinishLoad中执行
 *
 *  @param webView
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"--webViewDidFinishLoad----------");
//    获取所有html
    NSString *lJs = @"document.documentElement.innerHTML";
    
    //获取网页title
    NSString *lJs2 = @"document.title";
    NSString *lHtml1 = [webView stringByEvaluatingJavaScriptFromString:lJs];
    NSLog(@"==lHtml1=%@========",lHtml1);
　　 NSString *lHtml2 = [webView stringByEvaluatingJavaScriptFromString:lJs2];
    NSLog(@"title========%@",lHtml2);
//    self.navigationController.
    
    //
    [_webView stringByEvaluatingJavaScriptFromString:@"function test(){ alert(123123123)}"];
    [_webView stringByEvaluatingJavaScriptFromString:@"test();"];//调用
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"--didFailLoadWithError---%@-------",error);
}

@end
