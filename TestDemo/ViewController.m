//
//  ViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/2.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "MJExtension.h"
#import "NSDate+DateHelp.h"
#import "CustomKeyboardView.h"
#import <Security/Security.h>
#import <AFNetworking.h>
#import "Status.h"
#import "NetAPIClient.h"
#import "FDRoot.h"
#import "XHPopMenu.h"
#import "PopMenu.h"
#import "WebViewCosntroller.h"
#import "RACViewController.h"
#import "CustomPopView.h"
#import "MyView.h"
#import "NSTimerViewController.h"
#import "MBProgressHUD.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds

@interface ViewController ()<NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//弹出框
@property (strong, nonatomic) XHPopMenu *popMenu;
@property (strong, nonatomic) PopMenu *myPopMenu;

//
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic)     CustomPopView *popView;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) UIView *subView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _subView = [[UIView alloc] initWithFrame:CGRectMake(20, 70, 50, 50)];
    _subView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_subView];
    
//    NSString *s1 = [NSString stringWithFormat:@"%@",1]; crash
//    NSLog(@"s1==%@==",s1);
    
    
    if([@"null" integerValue] == 1)
    {
        NSLog(@"=======等于1====");
    }
    else
    {
        NSLog(@"======不等于1========");
    }
    
    
    int i = 0;
    while (i<5)
    {
        i++;
        NSLog(@"%lu子view个数:i=%d",(unsigned long)[self.view subviews].count,i);
        [self.view addSubview:_subView];
        NSLog(@"==%lu子view个数:i=%d",(unsigned long)[self.view subviews].count,i);
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *name = dic[@"name"];
    
    NSLog(@"=name=%@======",name);
    
    
    //通知  此object 是用于过滤Notication的，只接收指定Sender所发的Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testNotifi:) name:@"TestNotification" object:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:self userInfo:@{@"name3":@"zgj3"}];
    });
    [self converJsonStrModel];
//    [self customNavigationBar];
    
    _searchBar.tintColor = [UIColor redColor];
    
    UIImageView *imgView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.jpg"]];
    imgView2.frame=CGRectMake(10,10 , 10, 10);
    _textField.rightView=imgView2;
    _textField.rightViewMode=UITextFieldViewModeAlways;
    
    NSString *testStr = @"撒手机看东方科技就看上对方即可123444test";
    for (int i = 0 ; i< testStr.length; i++)
    {
        NSLog(@"===%i==%c",i,[testStr characterAtIndex:i]);
        
    }
    
    _segmentControl.layer.cornerRadius = 20;
    _segmentControl.layer.masksToBounds = YES;
    
    _dataArray = [NSMutableArray arrayWithObjects:@"webview与交互",@"RAC学习",@"AVFoundataion", @"NSTimer",@"pop动画",@"FMDB和storyboard textView控制父控件",@"UIDynamic动力",@"Lock锁",@"CoreGraphics",@"头部视图",@"FFmpeg",@"Assert",nil];
    [self setUpNaivigationItem];
    [self effectVisualView];
    [self test1];
    [self gcdSerialQueue];
    [self gcdGlobalQueue];
//    [self gcdAfterQueue];
    {
        //键盘事件监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNote:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNote:) name:UIKeyboardWillHideNotification object:nil];
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CustomKeyboardView" owner:self options:nil];
        self.inputTextField.inputView = [views lastObject];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar"] forBarMetrics:UIBarMetricsDefault];
    
    
    
    
}

- (void)testNotifi:(NSNotification *)notifi
{
    NSLog(@"%@=推送======",notifi.userInfo);
}


- (void)backAction
{
    NSLog(@"======backAction======");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    _hud.labelText = @"拨打中,请稍等";
    
    [_hud hide:YES afterDelay:1];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_hud hide:YES];
//        
//        
//        _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        _hud.labelText = @"拨打中,请稍等222222";
//        NSLog(@"pushBtn frame ==%@=",NSStringFromCGRect(_pushBtn.frame));
//    });
}

/**
 *  测试NavigationBar  添加subview
 */
- (void)naviBackView
{
    UIView *navBarBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, 64)];
//    navBarBackgroundView.backgroundColor = [UIColor colorWithRed:60.f/255.f green:198.f/255.f blue:253.f/255.f alpha:0.f];
    navBarBackgroundView.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:navBarBackgroundView];
    [self.navigationController.navigationBar addSubview:navBarBackgroundView];
}

- (void)setUpNaivigationItem
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [rightBtn addTarget:self action:@selector(pressRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"弹出框" forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)pressRightBtn:(UIButton *)btn
{



  _popView = [[CustomPopView alloc] initWithFrame:CGRectMake(0, 0,     [UIScreen mainScreen].bounds.size.width,     [UIScreen mainScreen].bounds.size.height)];
//    [[UIApplication sharedApplication].keyWindow addSubview:_popView];
//    [self.view addSubview:_popView];

    MyView *myView = [[MyView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    [[UIApplication sharedApplication].keyWindow addSubview:myView];
    
    return;
//    [self showPopMenu];
//    UIView *presentView=[[[UIApplication sharedApplication].keyWindow rootViewController] view];
//    [_myPopMenu showMenuAtView:presentView startPoint:CGPointMake(0, -100) endPoint:CGPointMake(0, -100)];
}


- (void)showPopMenu
{
    //初始化弹出菜单
    NSArray *menuItems = @[
                           [MenuItem itemWithTitle:@"项目" iconName:@"pop_Project" index:0],
                           [MenuItem itemWithTitle:@"任务" iconName:@"pop_Task" index:1],
                           [MenuItem itemWithTitle:@"冒泡" iconName:@"pop_Tweet" index:2],
                           [MenuItem itemWithTitle:@"添加好友" iconName:@"pop_User" index:3],
                           [MenuItem itemWithTitle:@"私信" iconName:@"pop_Message" index:4],
                           [MenuItem itemWithTitle:@"两步验证" iconName:@"pop_2FA" index:5],
                           ];
    if (!_myPopMenu)
    {
        _myPopMenu = [[PopMenu alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) items:menuItems];
        _myPopMenu.perRowItemCount = 3;
        _myPopMenu.menuAnimationType = kPopMenuAnimationTypeSina;
    }
    _myPopMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem){
        NSLog(@"----点击的-%@----",selectedItem.title);
    };
}

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 5; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"contacts_add_newmessage";
                    title = @"发起群聊";
                    break;
                }
                case 1: {
                    imageName = @"contacts_add_friend";
                    title = @"添加朋友";
                    break;
                }
                case 2: {
                    imageName = @"contacts_add_scan";
                    title = @"扫一扫";
                    break;
                }
                case 3: {
                    imageName = @"contacts_add_photo";
                    title = @"拍照分享";
                    break;
                }
                case 4: {
                    imageName = @"contacts_add_voip";
                    title = @"视频聊天";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            NSLog(@"点击了第%d行----",index);
        };
    }
    return _popMenu;
}

- (void)test
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    
}

- (void)converJsonStrModel
{
    // 1.Define a JSONString
    NSString *jsonString = @"{\"name\":\"Jack\", \"icon\":\"lufy.png\", \"age\":20}";
    
    {
        //json 转换dic
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"--%@----",dic);
    }
    
    // 2.JSONString -> User
    User *user = [User mj_objectWithKeyValues:jsonString];
    NSLog(@"--%@--",user);
    
    
    /*************************/
    NSDictionary *dict = @{
                           @"text" : @"Agree!Nice weather!",
                           @"user" : @{
                                   @"name" : @"Jack",
                                   @"icon" : @"lufy.png"
                                   },
                           @"retweetedStatus" : @{
                                   @"text" : @"Nice weather!",
                                   @"user" : @{
                                           @"name" : @"Rose",
                                           @"icon" : @"nami.png"
                                           }
                                   }
                           };
    
    {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"---/jsonStr-%@----",jsonStr);
    }
    
    Status *status = [Status mj_objectWithKeyValues:dict];
    NSLog(@"status=======%@",status);
}


/**
 *  图片压缩
 *  压:文件体积变小，但是像素数不变，长度尺寸不变，那么质量可能下降
 *  缩:文件的尺寸变小，也就是像素数减少，长宽尺寸变小，文件体积同样会减小
 */
- (void)imageCompress
{
//    UIImageJPEGRepresentation(image, 0.0)压功能
//    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)] ; 缩功能
}


- (void)effectVisualView
{
    //实现模糊效果
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = self.imageView.frame;
    visualEffectView.alpha = 1.0;
    [self.imageView addSubview:visualEffectView];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)test1
{
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[@"1450075148" doubleValue]];
    NSString *startTime = [NSDate stringFromDate:startdate withFormat:kDatabaseDateFormat];
    NSLog(@"---startTime = %@-----",startTime);
    
    NSDictionary *dict1 = @{@"key":@"valye1",@"key2":@"value2"};
    NSLog(@"--字典-----%@----",dict1);
    
    if ([dict1 isKindOfClass:[NSArray class]])
    {
        NSLog(@"dic1 是数组");
    }
    else
    {
        NSLog(@"dic1 是字典");
    }
    
    NSDictionary *dict2 = @[@{@"key":@"valye1",@"key2":@"value2"}];
    if ([dict2 isKindOfClass:[NSArray class]])
    {
        NSLog(@"dic2 是数组");
    }
    else
    {
        NSLog(@"dic2 是字典");
    }
    
}

#pragma mark  - 自定义UINavigationBar
- (void)customNavigationBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    view.backgroundColor = [UIColor redColor];
    
    [self.navigationController.navigationBar addSubview:view];
}


#pragma mark - Https
- (void)httpsRequest
{
    NSURL *httpURL = [NSURL URLWithString:@"https://www.baidu.com/index.php?tn=monline_3_dg"];
    NSURLRequest *request  = [NSURLRequest requestWithURL:httpURL];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    //1)获取trust object
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    SecTrustResultType result;
    
    //2.SecTrustEvalutate 对trust进行验证
    OSStatus status = SecTrustEvaluate(trust, &result);
    if (status == errSecSuccess && (result == kSecTrustResultProceed ||
                                    result == kSecTrustResultUnspecified))
    {
        
        //3)验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
        NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
        [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
    }
    else
    {
        //5)验证失败，取消这次验证流程
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
}

#pragma mark AFNetworkingHttps
- (void)afnRequest
{
    NSURL *url = [NSURL URLWithString:@""];
    AFHTTPRequestOperationManager *requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    dispatch_queue_t requestQueue = dispatch_queue_create("kRequestCompletionQueue", DISPATCH_QUEUE_SERIAL);
    requestOperationManager.completionQueue = requestQueue;
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //是否允许无效证书(也就是自建的证书)
    securityPolicy.allowInvalidCertificates = YES;
    
    //是否需要验证域名
    securityPolicy.validatesDomainName = YES;
    
    //是否验证整个证书链
    requestOperationManager.securityPolicy = securityPolicy;
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hgcang" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

- (void)stackViewStudy
{
    
}

#pragma mark - RunLoop
- (void)runLoop
{
    //scheduledTimerWithTimeInterval不需要加到runloop中
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(printMessage) userInfo:nil repeats:YES];
    
    //滚动scrollview,发现上面timer停止打印;在开启一个NSTimer实质上是在当前的runloop中注册了一个新的事件源，而当scrollView滚动时候，当前的mainRunloop处于UITrackingRunLoopModel模式下，这个模式下是不会处理NSDefaultRunLoopMode的消息，要想在scrollView滚动的同时也接受其它runloop的消息，我们需要改变两者之间的runloopmode.
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    /**
     *  5个model
     *
     *  1.KCFRunLoopDefaultModel:App的默认model。通常主线程是在这个mode下运行的
     *  2.UITrackingRunloopModel:界面追踪model，用于scrollView追踪触摸滑动，保证界面滑动时不受其他mode印象
     *  3.UIInitializationRunLoopModel:在刚启动App时进入的第一个mode,启动完成后就不再使用
     *  4.GSEventReceiveRunLoopModel:接受系统事件的内部Mode,通常用不到
     *  5.KCFRunLoopCommonModes:
     */
    
    
    
}

- (void)printMessage
{
    NSLog(@"打印message===");
}

#pragma mark - GCD
/**
 *  主队列/全局队列
 *
 */

- (void)gcdOneQueue
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //耗时操作
        
       //完成后刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}


//串行队列:执行完一个任务才会执行下一个任务
- (void)gcdSerialQueue
{
    dispatch_queue_t queue = dispatch_queue_create("SerialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"任务开始了哈哈哈哈");
//    任务1-->任务2--->任务3
    dispatch_async(queue, ^{
        NSLog(@"queue1 --------");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"queue2 --------");
        sleep(3);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"queue3 --------");
        sleep(2);
        
    });
    NSLog(@"任务结束了哈哈哈哈");
}


//并发队列
//输出: 任务2--》任务3--》任务1  ==》任务完成
- (void)gcdGlobalQueue
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"任务1======begin====");
    dispatch_group_async(group, queue, ^{
        sleep(5);
        NSLog(@"任务1=======");
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        dispatch_group_t group1 = dispatch_group_create();
        dispatch_group_async(group1, queue1, ^{
            sleep(4);
            NSLog(@"任务1后面的任务");
        });
        
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务2-------");
    });
    
    dispatch_group_async(group, queue, ^{
        sleep(1);
        NSLog(@"任务3-------");
    });
    //任务123 全部完成后调用
    NSLog(@"任务1======middle====");
    dispatch_group_notify(group, queue, ^{
        NSLog(@"任务完成-------");
    });
    NSLog(@"任务1======end====");
}

- (void)gcdAfterQueue
{
    NSLog(@"---begin----%@--",[NSThread currentThread]
          );
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //延迟1s执行
        NSLog(@"---after----%@--",[NSThread currentThread]);
    });
    for (int i = 0; i<1000; i++)
    {
        NSLog(@"-----%d,打印-------",i);
    }
}


- (void)operationQueue
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
}

#pragma mark - Keyboard
- (void)handleKeyboardWillShowNote:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
    }];
}


/**
 *  NSFileManager 使用
 */

- (void)fileManagerTest
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDiretory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc--Path:%@",documentDiretory);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.inputTextField resignFirstResponder];
}

#pragma mark - 设置
- (void)jumpSystemSetVC
{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
    return;
}

#pragma mark - Action
- (IBAction)requestBtnAction:(UIButton *)sender
{
    [[NetAPIClient sharedClient] requestDataWithDic:nil requestType:NetRequestGet contentType:NetRequestContent_RecordSet finishBlock:^(NSDictionary* responserObj) {
        FDRoot *tag = [[FDRoot alloc] initWithDictionary:responserObj];
        NSLog(@"tag === %@",tag);
        
    } failBlock:^(NSError *error) {
        
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = _dataArray[indexPath.row];
    if ([title isEqualToString:@"webview与交互"])
    {
        [self performSegueWithIdentifier:@"WebViewCosntrollerSegue" sender:nil];
    }
    else if ([title isEqualToString:@"RAC学习"])
    {
        [self performSegueWithIdentifier:@"RACViewControllerSegue" sender:nil];
    }
    else if ([title isEqualToString:@"AVFoundataion"])
    {
        [self performSegueWithIdentifier:@"AVFoundationViewControllerSegue" sender:nil];
    }
    else if ([title isEqualToString:@"NSTimer"])
    {
        [self performSegueWithIdentifier:@"NSTimerViewControllerSegue" sender:nil];
    }
    else if([title isEqualToString:@"FMDB和storyboard textView控制父控件"])
    {
        [self performSegueWithIdentifier:@"FMDBSegue" sender:nil];
    }
    else if ([title isEqualToString:@"UIDynamic动力"])
    {
        [self performSegueWithIdentifier:@"UIDynamicSegue" sender:nil];
    }
    else if ([title isEqualToString:@"Lock锁"])
    {
        [self performSegueWithIdentifier:@"LockSegue" sender:nil];
    }
    else if([title isEqualToString:@"CoreGraphics"])
    {
        [self performSegueWithIdentifier:@"CoreGraphicsSegue" sender:nil];
    }
    else if([title isEqualToString:@"头部视图"])
    {
        [self performSegueWithIdentifier:@"HeadSegue" sender:nil];
    }
    else if ([title isEqualToString:@"FFmpeg"])
    {
        [self performSegueWithIdentifier:@"FFmpegSegue" sender:nil];
    }
    else if ([title isEqualToString:@"Assert"])
    {
        [self performSegueWithIdentifier:@"AssertSegue" sender:nil];
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WebViewCosntrollerSegue"])
    {
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
