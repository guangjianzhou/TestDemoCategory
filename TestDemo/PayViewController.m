//
//  PayViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/17.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "PayViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"

#import <PassKit/PassKit.h>
#import <PassKit/PKPaymentAuthorizationViewController.h>
#import <AddressBook/AddressBook.h>


@interface PayViewController ()<PKPaymentAuthorizationViewControllerDelegate>
{
    NSMutableArray *summaryItems;
    NSMutableArray *shippingMethods;
}

@property (nonatomic, strong) NSArray *supportedNetworks;

@end

@implementation PayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString * url = @"http://test02.icopm.com/haihui/buy?userId=684B5B4B-22AB-47E3-BA83-2AB5C8106972";
    if ([url rangeOfString:@"martin"].location == NSNotFound)
    {
        NSLog(@"YES============");
    }
    else
    {
        NSLog(@"NO============");
    }
    
    //设备ApplePay权限检测
    
}

#pragma mark  - 支付宝支付
- (void)aliPay
{
    /*
     partner、seller、privateKey 用户去申请
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    //商户ID:parnter.合作身份者ID,以 2088 开头由 16 位纯数字组成的字符串。如:2088501566833063
    NSString *partner = @"2088021795119191";//商户ID.
    //账户ID:seller.支付宝收款账号,手机号码或邮箱格式。如:chenglianshiye@yeah.net
    NSString *seller = @"3228823428@qq.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALpRFk7SDP7QuBrlLp1YD7AvHzwNk3G+dKBwav85XOWfzw93RVEtLf6bwvbLDE0yyPreVeTwAQrgj0pQQCaMzTbH5zjsCyfs7dvM0dL9hh8tyej5/Kyjim8M2yBDLFuT2M+nU+7Ns3DE8JIR5D3iggtJd/GC8E2b7/YpzC7+w7KtAgMBAAECgYEAktTUf8mJ9EcI0ClNUzLTKkX4l5sbV8iAoO/3YqwSSeRnigi02ASC+uRGAbiDOVOMkCgoCQQbzjaqtiYIaFkOX4UYbX+FoI8AvKCrT1yi3UqPdiWrkFoysJbWKT4B5TJnOySAio5oSQZVqH1VVZwVVZRzRAZp1KaQbQTo8+coyAECQQDkWPUjTii1TTpG3ovZ0eG7RZJgXlKGVugghX367fmAxJqCy/rAmYtDjsxK6NYYFKI7xijNFIPSBEDBuec9sD11AkEA0OEgdBprSdyHWGOniUi7KQQtGPnDFjUPSEvMsLbA+4rw4Z4+NSL62Hdtz+AHvnorn0GuurTz5fhM7xmcsMFhWQJAcgk++w+4YrqbpPLVEsWvHpAjBr90JSTXrg4cmSkpVjZZF4L4yiCkHOv+eFaJPONpFcLjc2+QWVzIXjcSFYujVQJAczebJS/lemqQparioRFjW66YCazLdZZzBZf6IofMT3RGhs041yqiX4ERK5cR7nmJUmFytj5WQsYB+emQytcAkQJAMUEj/lq1XQH4m39c3GEdwcRbNQ+4jcaw6a2ErgLVQ+quEkKOXZSr2q8Rm9t2r4s0yqJ7lr+iBn4oUCW1UvoYaQ==";
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        NSLog(@"缺少partner或者seller或者私钥。");
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"134123121231"; //订单ID（由商家自行制定）
    order.productName = @"蓝鸥iOS培训"; //商品标题
    order.productDescription = @"10万行代码,成就10万年薪"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f", 0.11]; //商品价格
    //跟公司的后台服务器进行回调的.支付完成后,告诉公司的后台, 是支付成功,还是支付失败.
    order.notifyURL =  @"http://app.cheguchina.com/wash/unionpay/mobilenotify"; //回调URL
    //以下信息 是支付的基本配置信息
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types（支付成功后可以 重新返回到app）
    NSString *appScheme = @"hugezuishuai";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //支付宝给我们的开发者的回调信息.
            //标示是成功还是失败.还是用户取消,网络中断等信息.
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

#pragma mark  - 微信支付

/**
 *  微信支付 在AppDelegate 进行设置，自己进行组装 签名,微信返回 onResp()
 *  商户服务器生成支付订单，先调用【统一下单API】生成预付单，获取到prepay_id后将参数再次签名传输给APP发起支付
 */
- (void)wxPay
{
    //微信支付按钮方法
    PayReq *request = [[PayReq alloc] init];
    //商家向财付通申请的商家id
    request.partnerId = @"1220277201";
    //预支付订单 : 里面包含了 商品的标题 . 描述, 价格等商品信息.
    request.prepayId= @"9201039000160109a802876d726d4458";
    ///** 商家根据财付通文档填写的数据和签名 */
    // 相当于一种标识
    request.package = @"Sign=WXPay";
    ///** 随机串，防重发 */
    request.nonceStr= @"DOagHs30hjYYeRSy";
    //时间戳.  防止重发.
    //从1970年之后的秒数.
    request.timeStamp= 1452325279;
    ///** 商家根据微信开放平台文档对数据做的签名 */
    //加密数据用的  sign生成字段名列表见调起支付API
    request.sign= @"7e3b26cf65196404b1bbed60ea8304a1b00038bd";
    //调用微信支付.
    [WXApi sendReq:request];
}

- (void)wxPay1
{
    time_t now;
    NSString   *timeStamp=[NSString stringWithFormat:@"%ld",time(&now)];
    
    PayReq *req = [[PayReq alloc]init];
    req.openID = APP_ID;
    req.partnerId = MCH_ID;
    ////预支付订单 : 里面包含了 商品的标题 . 描述, 价格等商品信息
    req.prepayId = @"";
    req.timeStamp = timeStamp.intValue;
    req.nonceStr = [WXUtil md5:timeStamp];
    req.package = @"Sign=WXPay";
    
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: APP_ID        forKey:@"appid"];
    [signParams setObject: [WXUtil md5:timeStamp]    forKey:@"noncestr"];
    [signParams setObject: @"Sign=WXPay"      forKey:@"package"];
    [signParams setObject: MCH_ID         forKey:@"partnerid"];
    [signParams setObject: timeStamp   forKey:@"timestamp"];
    [signParams setObject: @""     forKey:@"prepayid"];
    //生成签名
    payRequsestHandler *pRequsestHandler=[[payRequsestHandler alloc]init];
    
    NSString *sign  = [pRequsestHandler createMd5Sign:signParams];
    req.sign  = sign;
    [WXApi sendReq:req];
}


/**
 *  服务器端将所要的参数返回
 */
+ (NSString *)jumpToBizPay {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}


#pragma mark  - ApplePay
/**
 *  1. 首先要申请MerchantID及对应证书。
 *  2. 设备ApplePay权限检测
 
 */
- (void)checkApplePayDevice
{
    if (![PKPaymentAuthorizationViewController class])
    {
        //PKPaymentAuthorizationViewController需iOS8.0以上支持
        NSLog(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
        return;
    }
    
    //检查设备是否可以用于支付
    if (![PKPaymentAuthorizationViewController canMakePayments])
    {
        //支付需iOS9.0以上支持
        NSLog(@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
        return;
    }
    
    //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
    _supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:_supportedNetworks])
    {
        NSLog(@"没有绑定支付卡");
        return;
    }
}

- (void)applePay
{
  
    //1.创建支付请求PKPaymentRequest
    //设置币种、国家码及merchant标识符等基本信息
    PKPaymentRequest *payRequest = [[PKPaymentRequest alloc]init];
    payRequest.countryCode = @"CN";     //国家代码
    payRequest.currencyCode = @"CNY";       //RMB的币种代码
    payRequest.merchantIdentifier = @"merchant.ApplePayDemoYasin";  //申请的merchantID
    payRequest.supportedNetworks = _supportedNetworks;   //用户可进行支付的银行卡
    payRequest.merchantCapabilities = PKMerchantCapability3DS|PKMerchantCapabilityEMV;      //设置支持的交易处理协议，3DS必须支持，EMV为可选，目前国内的话还是使用两者吧
    
    //2.设置发票配送信息和货物配送地址信息
//    用户设置后可以通过代理回调代理获取信息的更新
    
    //    payRequest.requiredBillingAddressFields = PKAddressFieldEmail;
    //如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
    //楼主感觉账单邮寄地址可以事先让用户选择是否需要，否则会增加客户的输入麻烦度，体验不好，
    payRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName;
    //送货地址信息，这里设置需要地址和联系方式和姓名，如果需要进行设置，默认PKAddressFieldNone(没有送货地址)
    
    

    //3.设置两种配送方式
    PKShippingMethod *freeShipping = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber zero]];
    freeShipping.identifier = @"freeshipping";
    freeShipping.detail = @"6-8 天 送达";
    
    PKShippingMethod *expressShipping = [PKShippingMethod summaryItemWithLabel:@"极速送达" amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]];
    expressShipping.identifier = @"expressshipping";
    expressShipping.detail = @"2-3 小时 送达";
    
    shippingMethods = [NSMutableArray arrayWithArray:@[freeShipping, expressShipping]];
    //shippingMethods为配送方式列表，类型是 NSMutableArray，这里设置成成员变量，在后续的代理回调中可以进行配送方式的调整。
    payRequest.shippingMethods = shippingMethods;
    
    
    
    
    //4.账单信息的设置
    NSDecimalNumber *subtotalAmount = [NSDecimalNumber decimalNumberWithMantissa:1275 exponent:-2 isNegative:NO];   //12.75
    PKPaymentSummaryItem *subtotal = [PKPaymentSummaryItem summaryItemWithLabel:@"商品价格" amount:subtotalAmount];
    
    NSDecimalNumber *discountAmount = [NSDecimalNumber decimalNumberWithString:@"-12.74"];      //-12.74
    PKPaymentSummaryItem *discount = [PKPaymentSummaryItem summaryItemWithLabel:@"优惠折扣" amount:discountAmount];
    
    NSDecimalNumber *methodsAmount = [NSDecimalNumber zero];
    PKPaymentSummaryItem *methods = [PKPaymentSummaryItem summaryItemWithLabel:@"包邮" amount:methodsAmount];
    
    NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
    totalAmount = [totalAmount decimalNumberByAdding:subtotalAmount];
    totalAmount = [totalAmount decimalNumberByAdding:discountAmount];
    totalAmount = [totalAmount decimalNumberByAdding:methodsAmount];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Yasin" amount:totalAmount];  //最后这个是支付给谁。哈哈，快支付给我
    
    summaryItems = [NSMutableArray arrayWithArray:@[subtotal, discount, methods, total]];
    //summaryItems为账单列表，类型是 NSMutableArray，这里设置成成员变量，在后续的代理回调中可以进行支付金额的调整。
    payRequest.paymentSummaryItems = summaryItems;
    
    
    //5.
    
    //ApplePay控件
    PKPaymentAuthorizationViewController *view = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:payRequest];
    view.delegate = self;
    [self presentViewController:view animated:YES completion:nil];
}





#pragma mark - PKPaymentAuthorizationViewControllerDelegate
//送货地址回调
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingContact:(PKContact *)contact
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //contact送货地址信息，PKContact类型
    NSPersonNameComponents *name = contact.name;                //联系人姓名
    CNPostalAddress *postalAddress = contact.postalAddress;     //联系人地址
    NSString *emailAddress = contact.emailAddress;              //联系人邮箱
    CNPhoneNumber *phoneNumber = contact.phoneNumber;           //联系人手机
    NSString *supplementarySubLocality = contact.supplementarySubLocality;  //补充信息,iOS9.2及以上才有
    
    //送货信息选择回调，如果需要根据送货地址调整送货方式，比如普通地区包邮+极速配送，偏远地区只有付费普通配送，进行支付金额重新计算，可以实现该代理，返回给系统：shippingMethods配送方式，summaryItems账单列表，如果不支持该送货信息返回想要的PKPaymentAuthorizationStatus
    completion(PKPaymentAuthorizationStatusSuccess, shippingMethods, summaryItems);
}

//送货方式回调
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //配送方式回调，如果需要根据不同的送货方式进行支付金额的调整，比如包邮和付费加速配送，可以实现该代理
    PKShippingMethod *oldShippingMethod = [summaryItems objectAtIndex:2];
    PKPaymentSummaryItem *total = [summaryItems lastObject];
    total.amount = [total.amount decimalNumberBySubtracting:oldShippingMethod.amount];
    total.amount = [total.amount decimalNumberByAdding:shippingMethod.amount];
    
    [summaryItems replaceObjectAtIndex:2 withObject:shippingMethod];
    [summaryItems replaceObjectAtIndex:3 withObject:total];
    
    completion(PKPaymentAuthorizationStatusSuccess, summaryItems);
}

//支付卡选择回调
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod completion:(void (^)(NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //支付银行卡回调，如果需要根据不同的银行调整付费金额，可以实现该代理
    completion(summaryItems);
}


-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingAddress:(ABRecordRef)address completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //送货地址回调，已弃用
}

//付款成功苹果服务器返回信息回调，做服务器验证
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    
    PKPaymentToken *payToken = payment.token;
    //支付凭据，发给服务端进行验证支付是否真实有效
    PKContact *billingContact = payment.billingContact;     //账单信息
    PKContact *shippingContact = payment.shippingContact;   //送货信息
    PKContact *shippingMethod = payment.shippingMethod;     //送货方式
    //等待服务器返回结果后再进行系统block调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //模拟服务器通信
        completion(PKPaymentAuthorizationStatusSuccess);
    });
    
    
}


//支付完成
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
