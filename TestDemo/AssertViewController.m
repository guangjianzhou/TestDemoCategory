//
//  AssertViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/7.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "AssertViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import <ZXingObjC.h>


@interface AssertViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZXCaptureDelegate,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession; //捕捉会话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;//预览层
@property (nonatomic, strong) UIView *boxView;//扫描识别框


@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) ZXCapture *capture;

@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UIButton *openTorchButton;


@property (nonatomic, strong) CMMotionManager * motionManager;
@property (nonatomic, strong) NSOperationQueue * operationQueue;
@property (nonatomic, assign) BOOL isShaking;

@end

static const double accelerationThreshold = 2.0f;

@implementation AssertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    {
        _operationQueue = [NSOperationQueue new];
        _motionManager = [CMMotionManager new];
        _motionManager.accelerometerUpdateInterval = 0.1;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    [self tapVC];
    self.scanView.hidden = YES;
    
    //监听
    [self startAccelerometer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [_motionManager stopAccelerometerUpdates];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [super viewDidDisappear:animated];
}



static int x = 0;

- (void)assertTest
{
    NSAssert(x < 0, @" x must be >0");//满足条件返回真值，程序继续运行，如果返回假值，则抛出异常
    NSLog(@"===x===%i==",x);
}

- (void)tapVC
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeX)];
    [self.view addGestureRecognizer:tap];
}

- (void)changeX
{
    x = (x>0)?-1:1;
    [self assertTest];
}

//=========QRCode=======
- (IBAction)deQRCodeFromCarmer:(UIButton *)sender
{
//    [self startScan];
//    return;
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    [self.view bringSubviewToFront:self.scanView];
    self.scanView.hidden = NO;
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
//    CGRect frame = CGRectMake((320 - 162) / 2, 198, 162, 162);
    self.capture.scanRect = self.scanView.frame;
    [self.capture start];
}

- (IBAction)deQRCodeFromPhoto:(UIButton *)sender
{
    [self selectPhotoFromAblum];
}


- (IBAction)createQRCode:(UIButton *)sender
{
    [self enCodeQRCode];
}

#pragma mark - ZXCaptureDelegate Methods
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
{
    NSString *text = result.text;
    NSLog(@"text ==============%@",text);
    UIImage   *image = [UIImage imageWithCGImage:capture.lastScannedImage];
    [self didScanWithResult:result.text];
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)didScanWithResult:(NSString *)result
{
    
}


#pragma mark  - 生成二维码
- (void)enCodeQRCode
{
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    NSString *str = [NSString stringWithFormat:@"A string to encode zgj ==%u",arc4random()];
    ZXBitMatrix* result = [writer encode:str
                                  format:kBarcodeFormatQRCode
                                   width:500
                                  height:500
                                   error:&error];
    if (result)
    {
        NSLog(@"生成成功photo====");
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:image], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
    else
    {
        NSString *errorMessage = [error localizedDescription];
        NSLog(@"生成失败====%@",errorMessage);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

#pragma mark  - 解析二维码 从相册
- (void)selectPhotoFromAblum
{
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.allowsEditing = YES;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    NSLog(@"选择成功==editingInfo = %@=====",editingInfo);
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"选择成功=======");
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self deCodeQRCode:image];
}


- (void)deCodeQRCode:(UIImage *)image
{   
    NSAssert(image != nil, @"image 不能为nil");
    CGImageRef imageToDecode ;  // Given a CGImage in which we are looking for barcodes
    imageToDecode = image.CGImage;
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result)
    {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        NSLog(@"====contents=%@========",contents);
        // The barcode format, such as a QR code or UPC-A
        ZXBarcodeFormat format = result.barcodeFormat;
    } else {
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
        NSLog(@"啥也没扫到======");
    }
}


#pragma mark  - 照相机扫描
- (void)startScan

{
    
    //初始化设备(摄像头)
    
    NSError *error = nil;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (error)
        
    {
        
        NSLog(@"没有摄像头:%@", error.localizedDescription);
        
        return;
        
    }

    //创建输出流
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    
    
    //实例化捕捉会话并添加输入,输出流
    
    if (!_captureSession) {
        
        _captureSession = [[AVCaptureSession alloc] init];
        
    }
    
    
    
    //高质量采集率
    
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    
    
    [_captureSession addInput:input];
    
    [_captureSession addOutput:output];
    
    
    
    //设置输出的代理,在主线程里刷新
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];   //用串行队列新线程结果在UI上显示较慢
    
    
    
    //扫码类型
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,         //二维码
                                     
                                     AVMetadataObjectTypeCode39Code,     //条形码   韵达和申通
                                     
                                     AVMetadataObjectTypeCode128Code,    //CODE128条码  顺丰用的
                                     
                                     AVMetadataObjectTypeCode39Mod43Code,
                                     
                                     AVMetadataObjectTypeEAN13Code,
                                     
                                     AVMetadataObjectTypeEAN8Code,
                                     
                                     AVMetadataObjectTypeCode93Code,    //条形码,星号来表示起始符及终止符,如邮政EMS单上的条码
                                     
                                     AVMetadataObjectTypeUPCECode]];
    
    
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    
    
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    
    //添加预览图层
    
    _videoPreviewLayer.frame = self.view.bounds;
    
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    [self.view bringSubviewToFront:self.view.subviews[0]];
    
    
    
    
    
    //扫描框
    
    
    
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(60, 100, 200, 200)];
    
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    
    _boxView.layer.borderWidth = 1.0f;
    
    [self.view addSubview:_boxView];
    
    
    
    //扫描识别范围
    
    output.rectOfInterest = CGRectMake(100 / self.view.bounds.size.height,
                                       
                                       60  / self.view.bounds.size.width,
                                       
                                       200 / self.view.bounds.size.height,
                                       
                                       200 / self.view.bounds.size.width);
    
    
    
    //开始扫描
    
    [_captureSession startRunning];
    
}


- (void)stopScanner

{
    [self openLight:NO];

    [self.captureSession stopRunning];
    
    self.captureSession = nil;
    
}


#pragma mark - 扫描结果代理方法

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection

{
    
    [_captureSession stopRunning];
    
    //    [_videoPreviewLayer removeFromSuperlayer];
    
    
    
    if (metadataObjects.count > 0) {
        
        
        
//        [self playBeep];
        
        
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        
        
        [self showInfoWithMessage:obj.stringValue andTitle:@"扫描成功"];
        
        
        
        NSLog(@"扫码扫描结果obj.stringValue == %@", obj.stringValue);
        
        
        
    }
    
    
    
}





#pragma mark 照片处理



-(void)getInfoWithImage:(UIImage *)img{
    
    
    
    UIImage *loadImage= img;
    
    CGImageRef imageToDecode = loadImage.CGImage;
    
    
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    
    
    NSError *error = nil;
    
    
    
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    
    ZXResult *result = [reader decode:bitmap
                        
                                hints:hints
                        
                                error:&error];
    
    
    
    if (result) {
        
        
        
        NSString *contents = result.text;
        
        [self showInfoWithMessage:contents andTitle:@"解析成功"];
        
        
        
        NSLog(@"相册图片contents == %@",contents);
        
        
        
    } else {
        
        
        
        [self showInfoWithMessage:nil andTitle:@"解析失败"];
        
        
        
    }
    
}



- (void)showInfoWithMessage:(NSString *)message andTitle:(NSString *)title

{
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
    
    [alter show];
    
    
    
}



#pragma - mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_captureSession startRunning];
        
    });
    
}





#pragma - mark - UIImagePickerViewControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//
//{
//    
//    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    
//    
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//        
//        
//        [self getInfoWithImage:image];
//        
//    }];
//    
//}





- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    
    [_captureSession startRunning];
    
    
    
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    
    
}



//PS:info.plist文件已添加 Localizations 项,并选择语言为 Chinese (simplified),使相册的选择,打开,取消等按键为中文.

- (IBAction)photoPickBtn:(UIButton *)sender {
    
    
    
    [_captureSession stopRunning];
    
    
    
    if (!_imagePickerController) {
        
        
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        
        _imagePickerController.delegate = self;
        
        _imagePickerController.allowsEditing = YES;
        
        _imagePickerController.SourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
    
    
}



//扫描震动

- (void)playBeep

{
    
    SystemSoundID soundID;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep"ofType:@"wav"]], &soundID);
    
    AudioServicesPlaySystemSound(soundID);
    
    
    
    // Vibrate
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}



//闪光灯

- (BOOL)isLightOpened

{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    
    if (![device hasTorch]) {
        
        return NO;
        
    }else{
        
        if ([device torchMode] == AVCaptureTorchModeOn) {
            
            return YES;
            
        } else {
            
            return NO;
            
        }
        
    }
    
}



- (void)openLight:(BOOL)open

{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];//[self.reader.readerView device];
    
    if (![device hasTorch]) {
        
    } else {
        
        if (open) {
            
            // 开启闪光灯
            
            if(device.torchMode != AVCaptureTorchModeOn ||
               
               device.flashMode != AVCaptureFlashModeOn){
                
                [device lockForConfiguration:nil];
                
                [device setTorchMode:AVCaptureTorchModeOn];
                
                [device setFlashMode:AVCaptureFlashModeOn];
                
                [device unlockForConfiguration];
                
            }
            
        } else {
            
            // 关闭闪光灯
            
            if(device.torchMode != AVCaptureTorchModeOff ||
               
               device.flashMode != AVCaptureFlashModeOff){
                
                [device lockForConfiguration:nil];
                
                [device setTorchMode:AVCaptureTorchModeOff];
                
                [device setFlashMode:AVCaptureFlashModeOff];
                
                [device unlockForConfiguration];
                
            }
            
        }
        
    }
    
}



- (IBAction)openTorchButtonTouched:(id)sender {
    
    
    
    UIButton *torchBtn = sender;
    
    BOOL isLightOpened = [self isLightOpened];
    
    
    
    if (isLightOpened)
    {
        //        [torchBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"scan_flash_closed" ofType:@"png"]] forState:UIControlStateNormal];
        [torchBtn setBackgroundColor:[UIColor clearColor]];
        [torchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.openTorchButton setTitle:@"开灯" forState:UIControlStateNormal];
    }
    else
    {
        //        [torchBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"scan_flash_opened" ofType:@"png"]] forState:UIControlStateNormal];
        [torchBtn setBackgroundColor:[UIColor whiteColor]];
        [torchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.openTorchButton setTitle:@"关灯" forState:UIControlStateNormal];
    }
    [self openLight:!isLightOpened];
    
}

#pragma mark  - 摇一摇1
//- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    NSLog(@"motionBegan===========");
//    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
//    AudioServicesPlaySystemSound (1007);//声音
//    
//}
//
//- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    NSLog(@"motionCancelled===========");
//}
//
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//     NSLog(@"motionEnded===========");
//}
//
//- (BOOL)canBecomeFirstResponder
//{
//    //默认是NO，所以得重写此方法，设成YES
//    return NO;
//}


#pragma mark - 另一种摇一摇
#pragma mark - 监听动作

-(void)startAccelerometer
{
    //以push的方式更新并在block中接收加速度
    
    [_motionManager startAccelerometerUpdatesToQueue:_operationQueue
                                         withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                             [self outputAccelertionData:accelerometerData.acceleration];
                                         }];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    double accelerameter = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2));
    
    if (accelerameter > accelerationThreshold) {
        [_motionManager stopAccelerometerUpdates];
        [_operationQueue cancelAllOperations];
        if (_isShaking) {return;}
        _isShaking = YES;
        
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound (1007);//声音
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self rotate:imageView];
            [self startAccelerometer];
            _isShaking = NO;
        });
    }
}

-(void)receiveNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]) {
        [_motionManager stopAccelerometerUpdates];
    } else {
        [self startAccelerometer];
    }
}

#pragma mark - 动画效果

- (void)rotate:(UIView *)view
{
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:M_PI / 3.0];
    rotate.duration = 0.18;
    rotate.repeatCount = 2;
    rotate.autoreverses = YES;
    
    [CATransaction begin];
    [self setAnchorPoint:CGPointMake(-0.2, 0.9) forView:view];
    [CATransaction setCompletionBlock:^{
//        [self getFetchProject]; 获取数据
    }];
    [view.layer addAnimation:rotate forKey:nil];
    [CATransaction commit];
}


// 参考 http://stackoverflow.com/questions/1968017/changing-my-calayers-anchorpoint-moves-the-view

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
