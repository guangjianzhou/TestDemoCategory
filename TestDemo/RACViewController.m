//
//  RACViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/23.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "RACViewController.h"
#import "UIImage+help.h"

typedef void (^RWSignInResponse)(BOOL);

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds


@interface RACViewController ()

//RAC1
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

//RAC2
@property (weak, nonatomic) UITextField *searchTextField;




@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RACViewController

/**
 *  FRP:(function reactive programming) 函数响应式编程
 *
 *  RACSignal:发送事件流给它的subscriber
 *  filter 过滤
 *  map: 改变了事件的数据,map操作来把接收的数据转换成想要的类型，只要它是个对象
 *  RAC:宏允许直接把信号的输出应用到对象的属性上，RAC宏两个参数:(1:第一个需要设置属性值的对象  2:是属性名)
 *  combineLatest:reduce:  产生的最新的值聚合在一起，并生成一个新的信号
 *  createSignal: 创建信号
 *  flattenMap:信号中的信号
 *  doNext: 添加附加操作,并不改变事件本身
 */

- (void)viewDidLoad
{
    [super viewDidLoad];

    
//    //输出文本内容
//    [[self.userNameTextField.rac_textSignal filter:^BOOL(id value) {
//        NSString *text = value;
//        return text.length > 3;
//        //当YES时候才会继续向下执行
//    }] subscribeNext:^(id x) {
//        NSLog(@"===%@===",x);
//    }];
//    
//    //输出文本的长度
//    [[[self.userNameTextField.rac_textSignal map:^id(NSString *value) {
//        return @(value.length);
//    }] filter:^BOOL(NSNumber *length) {
//        return [length integerValue] > 3;
//    }]subscribeNext:^(id x) {
//        NSLog(@"=%@==",x);
//    }];
    
//    RACSignal *validUserNameSignal = [self.userNameTextField.rac_textSignal map:^id(NSString* value) {
//        return @([self isValidUsername:value]);
//    }];
//    
//    RACSignal *validUserPswSignal = [self.pswTextField.rac_textSignal map:^id(NSString *value) {
//        return @([self isValidPassword:value] );
//    }];
//    
//    [[validUserPswSignal map:^id(NSNumber *passwdValue) {
//        return [passwdValue boolValue] ?[UIColor clearColor]:[UIColor yellowColor];
//    }] subscribeNext:^(UIColor *color) {
//        self.pswTextField.backgroundColor = color;
//    }];
    
//    RAC(self.pswTextField,backgroundColor) = [validUserPswSignal
//                                              map:^id(NSNumber *passwordValid){
//                                                  return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
//                                              }];
    
    
//    聚合信号
//    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUserNameSignal,validUserPswSignal]
//                                                      //数组中信号对应的值
//                                                      reduce:^id(NSNumber *usernameValid,NSNumber *passwdValid){
//                        return @([usernameValid boolValue] && [passwdValid boolValue]);
//    }];
//
//    //必须两种条件满足后 点击按钮才有用
//    [signUpActiveSignal subscribeNext:^(NSNumber *valid) {
//        self.loginBtn.enabled = [valid boolValue];
//    }];

    //按钮
    //外部login按钮信号(包含内部信号)
//    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x){
//        self.loginBtn.enabled = NO;
//    }]
//       flattenMap:^id(id x){
//        return [self signSignal];
//    }] subscribeNext:^(NSNumber *signedIn){
//        BOOL success = [signedIn boolValue];
//        
//    }];
    
        /*****************第二部分******************************/
//    [[self.searchTextField.rac_textSignal map:^id(NSString *text){
//        return [self isValidUsername:text]?[UIColor whiteColor]:[UIColor yellowColor];
//    }] subscribeNext:^(UIColor *color){
//        self.searchTextField.backgroundColor = color;
//    }];
//    
//    RACSignal *backgroundColorSignal = [self.searchTextField.rac_textSignal map:^id(NSString *text){
//        return [self isValidUsername:text]?[UIColor whiteColor]:[UIColor yellowColor];
//    }];
//    
//    RACDisposable *subscription = [backgroundColorSignal subscribeNext:^(UIColor *color){
//        self.searchTextField.backgroundColor = color;
//    }];
//    
//    //某个时刻
//    [subscription dispose];
//    
//    
//    
//    
    
    
}

//把已有的异步API用信号的方式来表示
//- (RACSignal *)signSignal
//{
//    __weak typeof(self) weakSelf = self;
//    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [weakSelf signInWithUsername:weakSelf.userNameTextField.text password:self.pswTextField.text complete:^(BOOL success) {
//           //发出信号
//            [subscriber sendNext:@(success)];
//            [subscriber sendCompleted];
//        }];
//        return nil;
//    }];
//    return nil;
//}


- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock {
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        BOOL success = [username isEqualToString:@"user"] && [password isEqualToString:@"password"];
        completeBlock(success);
    });
}



- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

#pragma mark - Second
/**
 *  事件类型:error 和completed
 *  取消订阅一个signal:1.在一个completed 或者error 事件之后，订阅会自动移除 2.RACDisposable 手动移除订阅
 *  你创建了RACSignal管道，但是没有订阅它，这个管道就不会执行
 *  then方法会等待completed事件的发送，然后再订阅由then block返回的signal。这样就高效地把控制权从一个signal传递给下一个
 *  deliverOn:[RACScheduler mainThreadScheduler]]  subscribeNext:主线程
 *
 *  异步加载图片:
 *  节流    throttle:0.5 只有当，前一个next事件在指定的时间段内没有被接收到后，throttle操作才会发送next事件
 */


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //异步加载图片
    //1. 获取一个后台scheduler,来让signal不在主线程执行
//    RACScheduler *scheduler = [RACScheduler
//                               schedulerWithPriority:RACSchedulerPriorityBackground];
    //2. 创建一个signal
    
    //3.subscribeOn: 保证signal在指定的scheduler执行
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Btn
- (IBAction)fillBtnAction:(UIButton *)sender
{
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    UIImage *image = [UIImage imageNamed:@"3.png"];
    self.imageView.image = [image scaleToSize:CGSizeMake(400,172)];
}


- (IBAction)aspectFitAction:(UIButton *)sender
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)aspectFillAction:(UIButton *)sender
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
}

@end
