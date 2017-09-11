//
//  BLEViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/15.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "BLEViewController.h"
#import <GameKit/GameKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Son.h"



//#define NSNullObjects @[@"",@0,@{},@[]]
//
//@interface NSNull (InternalNullExtention)
//@end
//
//@implementation NSNull (InternalNullExtention)
//
//- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
//{
//    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
//    if (!signature) {
//        for (NSObject *object in NSNullObjects) {
//            signature = [object methodSignatureForSelector:selector];
//            if (signature) {
//                break;
//            }
//        }
//        
//    }
//    return signature;
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation
//{
//    SEL aSelector = [anInvocation selector];
//    
//    for (NSObject *object in NSNullObjects) {
//        if ([object respondsToSelector:aSelector]) {
//            [anInvocation invokeWithTarget:object];
//            return;
//        }
//    }
//    
//    [self doesNotRecognizeSelector:aSelector];
//}
//@end


@interface BLEViewController ()<CBPeripheralManagerDelegate,GKPeerPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) GKSession *session;//蓝牙连接会话

@property (nonatomic,strong) CBPeripheralManager *manager;


@end

@implementation BLEViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    Son *son = [[Son alloc] init];
    son.sonName = @"sun";
    NSLog(@"son.name ===%@",son.sonName);//son.name ===zgjhaha
    
    id obj  = [NSNull null];
    if (!obj)
    {
        NSLog(@"获取空值=========");
    }
    else
    {
        NSLog(@"获取非空值=========");
    }
    
    
    //crash bug 修复如上
     NSArray  *exitClientArray =[NSJSONSerialization JSONObjectWithData:[obj dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    
//    _dict = nil;
    NSInteger length = [[_dict objectForKey:@"nokeyforthis"] length];
    [_dict setObject:@"2" forKey:@"second"];
    NSLog(@"==_dict==%@========",_dict);
    
    NSString *value = [_dict objectForKey:@"nokeyforthis"];
    NSLog(@"没有key 能取值 为nil===%@",value);
}

//- (void)dict:(NSMutableDictionary *)dict
//{
//    NSLog(@"====重新设置Set方法=1=====%@===dict=%@====",_dict,dict);
////    _dict = [[NSMutableDictionary alloc] initWithDictionary:dict];
//    NSLog(@"====重新设置Set方法==2====%@===dict=%@====",_dict,dict);
//    _dict = dict;
//}



- (void)setDict:(NSMutableDictionary *)dict
{
    NSLog(@"重新设置==========");
    _dict = [[NSMutableDictionary alloc] initWithDictionary:dict];
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSString *alertViewTitle;
    switch (peripheral.state)
    {
        case CBPeripheralManagerStatePoweredOn:
        {
            
            alertViewTitle = @"蓝牙开启且可用";
            NSLog(@"蓝牙开启且可用");
        }
            break;
        default:
            NSLog(@"蓝牙不可用");
            alertViewTitle = @"蓝牙不可用";
            break;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:alertViewTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"====打印=====%@==",self.dict);
    });
    
}

- (IBAction)selectPhoto:(UIButton *)sender
{
    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
    imagePickerController.delegate=self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)sendClick:(UIBarButtonItem *)sender
{
    NSData *data=UIImagePNGRepresentation(self.imageView.image);
    NSError *error=nil;
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
    if (error) {
        NSLog(@"发送图片过程中发生错误，错误信息:%@",error.localizedDescription);
    }
}
- (IBAction)sendImage:(UIButton *)sender
{
    NSData *data=UIImagePNGRepresentation(self.imageView.image);
    NSError *error=nil;
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
    if (error) {
        NSLog(@"发送图片过程中发生错误，错误信息:%@",error.localizedDescription);
    }
}

#pragma mark - UIImagePickerController代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.imageView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 * GameKit  ios7 开始过期 (局限)
 * MultipeerConnectivity.frameWork 取代GameKit 
  仅仅支持iOS设备，传输内容仅限于沙盒或者照片库中用户选择的文件，并且第一个框架只能在同一个应用之间进行传输（一个iOS设备安装应用A，另一个iOS设备上安装应用B是无法传输的）。
 
 * CoreBluetooth 框架   蓝牙4.0
 
 
 */



/**
 *  GKPeerPickerController  蓝牙查找、连接用的视图控制器
 *  GKSession 连接会话主要用于发送和接受传输数据
 */
- (void)gameKit
{

}
- (IBAction)bleSearch:(UIButton *)sender
{
    GKPeerPickerController *peerPickerController = [[GKPeerPickerController alloc] init];
    peerPickerController.delegate = self;
    [peerPickerController show];
}

/**
 *  连接到某个设备
 *
 *  @param picker  蓝牙点对点连接控制器
 *  @param peerID  连接设备蓝牙传输ID
 *  @param session 连接会话
 */
//在此方法中可以获得连接的设备id（peerID）和连接会话（session）
-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    self.session=session;
    NSLog(@"已连接客户端设备:%@.",peerID);
    //设置数据接收处理句柄，相当于代理，一旦数据接收完成调用它的-receiveData:fromPeer:inSession:context:方法处理数据
    [self.session setDataReceiveHandler:self withContext:nil];
    
    [picker dismiss];//一旦连接成功关闭窗口
}


#pragma mark - 蓝牙数据接收方法
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
    UIImage *image=[UIImage imageWithData:data];
    self.imageView.image=image;
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    NSLog(@"数据发送成功！");
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
