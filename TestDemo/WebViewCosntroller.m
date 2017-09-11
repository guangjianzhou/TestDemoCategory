

//
//  WebViewCosntroller.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/23.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "WebViewCosntroller.h"
#import "WebViewJavascriptBridge.h"

@interface WebViewCosntroller ()<UINavigationBarDelegate,UIImagePickerControllerDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) WebViewJavascriptBridge *bridge;
@property (assign, nonatomic) BOOL isFirstLoad;


@end


/**
 VC与html 交互
 
 uiwebview 用JavaScriptCore
 wkwebview 可以直接注册js
 */


/**
 *要注意的是：所有在应用内的资源文件都是在baseURL的根目录也就是此代码中的bundlePath的根目录，所以图片资源，不管在项目里面放在哪个目录结构下，在HTML内引用的时候，都是直接根目录的。
 //BaseURL file:///Users/liuqian/Library/Developer/CoreSimulator/Devices/77D7DB9D-A382-436A-B5D2-3CBD7B8B68AB/data/Containers/Bundle/Application/EF451A7E-B19E-4444-A9FC-B0E3CFEE7DE4/TestDemo_Develop.app/ + 资源文件
 */

@implementation WebViewCosntroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    //1.加载网页html
//    NSString *urlStr = @"http://lyds2011.139379.com:8027/login.aspx?zflx=aj&zf=安监执法稽查系统";
    NSString *urlStr = @"http://m.dianping.com/tuan/deal/12415397?utm_source=open";
    NSString* sURl = [self URLEncodeString:urlStr];
    NSURL *url = [NSURL URLWithString:sURl];
    
    
    //2.加载本地html
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index-h5" withExtension:@"html"];
//    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index-h5" ofType:@"html"];
//    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];    // 获取当前应用的根目录
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:path];
//    // 通过baseURL的方式加载的HTML
//    // 可以在HTML内通过相对目录的方式加载js,css,img等文件
//    [_webView loadHTMLString:htmlCont baseURL:baseURL]; //可以显示图片
//    
//
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    //属性
    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    _webView.delegate = self;
    
    [self setUpLeftNaviItem];
    
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                       NULL, /* allocator */
                                                                                       (__bridge CFStringRef)input,
                                                                                       NULL, /* charactersToLeaveUnescaped */
                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    return  outputStr;
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
/**
 *  动态修改网页内容
 *
 */



//UIWebViewNavigationTypeLinkClicked     用户触击了一个链接
//UIWebViewNavigationTypeFormSubmitted   用户提交了一个表单
//UIWebViewNavigationTypeBackForward     用户触击前进或返回按钮
//UIWebViewNavigationTypeReload          用户触击重新加载的按钮
//UIWebViewNavigationTypeFormResubmitted 用户重复提交表单
//UIWebViewNavigationTypeOther           发生其它行为
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"--shouldStartLoadWithRequest----%@------",request.URL);
    
    //拦截 点击相册
    NSString *str = request.URL.absoluteString;
    NSRange range = [str rangeOfString:@"xmg://"];
    if (range.location != NSNotFound)
    {
        NSString *method = [str substringFromIndex:range.location+range.length];
        
        NSLog(@"method===%@==",method);
//        SEL sel = NSSelectorFromString(method);
//        [self performSelector:sel];
        
    }
    
    
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
    
    if (!_isFirstLoad) {
        _isFirstLoad = true;
        NSString *lJs = @"document.documentElement.innerHTML";
        NSString *lHtml1 = [webView stringByEvaluatingJavaScriptFromString:lJs];
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [_webView loadHTMLString:lHtml1 baseURL:baseURL];
    }
    
//    获取所有html
    NSString *lJs = @"document.documentElement.innerHTML";
    
//    if (webView.isLoading) {
//        webView.userInteractionEnabled = NO;
//    }else{
//        webView.userInteractionEnabled = YES;
//    }
    
    //获取网页title
//    NSString *lJs2 = @"document.title";
    NSString *lHtml1 = [webView stringByEvaluatingJavaScriptFromString:lJs];
    NSLog(@"==lHtml1=%@========",lHtml1);
//　　 NSString *lHtml2 = [webView stringByEvaluatingJavaScriptFromString:lJs2];
//    NSLog(@"title========%@",lHtml2);

    
//    [_webView stringByEvaluatingJavaScriptFromString:@"function test(){ alert(123123123)}"];
//    [_webView stringByEvaluatingJavaScriptFromString:@"test();"];//调用
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"--didFailLoadWithError---%@-------",error);
}

- (NSString *)URLEncodeString:(NSString *)str
{
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedString = [str stringByAddingPercentEncodingWithAllowedCharacters:set];
    return encodedString;
}


#pragma mark  - 网页的增删改  ios中调用html(修改html中的数据)
- (void)addDeleteUpdateWebView:(UIWebView *)webView
{
    //删除p标签
    NSString *str1 = @"var word = document.getElementById('word')";
    NSString *str2 = @"word.remove()";
    
    [webView stringByEvaluatingJavaScriptFromString:str1];
    [webView stringByEvaluatingJavaScriptFromString:str2];
    
    
    //更改
    NSString *str3 = @"var change = document.getElementsByClassName('change')[0] ;change.innerHTML = '好你的哦';";
    [webView stringByEvaluatingJavaScriptFromString:str3];
    
    
    //插入
    NSString *str4 = @"var img = document.createElement('img');"
    "img.src = 'ico_appeal_03@3x.png';"
    "img.width = 80;"
    "img.height = 80;"
    "document.body.appendChild(img);";
    [webView stringByEvaluatingJavaScriptFromString:str4];
}

#pragma mark  - html 调用ios
- (void)iosInHtml:(UIWebView *)webView
{
    //改变标题
    NSString *str1 = @"var h1 = documentsByTagName('h1')[0] ;"
    "h1.innerHTML = '一起来';";
    [webView stringByEvaluatingJavaScriptFromString:str1];
    
    //删除
    
    
    //获取所有网页内容
    NSString *str3 = @"document.body.outHTML";
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:str3];
    NSLog(@"==%@==",html);
    
}

- (void)getImage
{
    UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
    imageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imageVC animated:YES completion:^{
        
    }];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
    
}




@end
