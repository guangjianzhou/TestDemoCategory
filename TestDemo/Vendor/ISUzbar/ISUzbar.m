////
////  ViewController.m
////  ISUzbar
////
////  Created by jy on 15/1/26.
////  Copyright (c) 2015年 jy. All rights reserved.
////
//
//#import "ISUzbar.h"
//#import "ZBarSDK.h"
//#import <AVFoundation/AVFoundation.h>
//#define BoundWidth [[UIScreen mainScreen] bounds].size.width
//#define BoundHeight [[UIScreen mainScreen] bounds].size.height
//@interface ISUzbar () <ZBarReaderViewDelegate, ZBarReaderDelegate,
//                       UINavigationControllerDelegate,
//                       UIImagePickerControllerDelegate> {
//  ZBarCameraSimulator *cameraSim;
//  BOOL isLightOpen;
//  UIImageView *lineView;
//  NSInteger num;
//  BOOL upOrdown;
//  NSTimer *timer;
//  BOOL isReaderStop;
//  UIButton *lampBtn;
//}
//@property(nonatomic, strong) IBOutlet ZBarReaderView *readerView;
//@property(nonatomic, strong) AVCaptureSession *AVSession;
//@end
//
//@implementation ISUzbar
//
//- (void)viewWillAppear:(BOOL)animated {
//  [super viewWillAppear:animated];
//  if (!isReaderStop) {
//    [_readerView start];
//  }
//    self.navigationController.navigationBarHidden = YES;
//    [[UIApplication sharedApplication] setStatusBarHidden:true];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [_readerView stop];
//    self.navigationController.navigationBarHidden = NO;
//    [[UIApplication sharedApplication] setStatusBarHidden:false];
//}
//
//- (void)viewDidLoad {
//  [super viewDidLoad];
//  if (_introduceText.length < 1) {
//    _introduceText = @"请将二维码置于框内";
//  }
//  _readerView = [ZBarReaderView new];
//  _readerView.frame = [[UIScreen mainScreen] bounds];
//  _readerView.backgroundColor = [UIColor clearColor];
//  [self.view addSubview:_readerView];
//  _readerView.tracksSymbols = NO; //绿色的追踪框
//  _readerView.readerDelegate = self;
//  [_readerView setAllowsPinchZoom:YES];
//  _readerView.torchMode = 0;
//  switch (_scanType) {
//  case ScanTypeDefault: {
//    [_readerView.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
//  } break;
//
//  case ScanTypeBarCode: {
//    [_readerView.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
//    [_readerView.scanner setSymbology:ZBAR_CODE128 config:ZBAR_CFG_ENABLE to:1];
//  } break;
//
//  case ScanTypeQRCode: {
//    [_readerView.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
//    [_readerView.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
//  } break;
//
//  default:
//    break;
//  }
//    
//    [self coverGrayView];
//
//  //显示的文字
//  UILabel *label =
//      [[UILabel alloc] initWithFrame:CGRectMake(60, 371, BoundWidth - 120, 46)];
//  label.text = _introduceText;
//  label.textAlignment = NSTextAlignmentCenter;
//  label.numberOfLines = 2;
//  label.font = [UIFont systemFontOfSize:13];
//  [self.view addSubview:label];
//
//  //灰色的半透明
//  if (TARGET_IPHONE_SIMULATOR) {
//    cameraSim = [[ZBarCameraSimulator alloc] initWithViewController:self];
//    cameraSim.readerView = _readerView;
//  }
//    NSLog(@"%@",cameraSim);
//  if (!_isNoLight) {
//    UIButton *lightBtn = [[UIButton alloc]
//        initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 60,
//                                 420, 50, 50)];
//    [lightBtn addTarget:self
//                  action:@selector(flashLight:)
//        forControlEvents:UIControlEventTouchUpInside];
//    [lightBtn setBackgroundImage:[UIImage imageNamed:@"lightNormansl.png"]
//                        forState:UIControlStateNormal];
//    [lightBtn setBackgroundImage:[UIImage imageNamed:@"lightSelected.png"]
//                        forState:UIControlStateSelected];
//    [self.view addSubview:lightBtn];
//  }
//  if (!_isNoPicture) {
//    UIButton *pictureBtn =
//        [[UIButton alloc] initWithFrame:CGRectMake(30, 420, 50, 50)];
//    [pictureBtn addTarget:self
//                   action:@selector(openPicture:)
//         forControlEvents:UIControlEventTouchUpInside];
//    [pictureBtn setBackgroundImage:[UIImage imageNamed:@"picture.png"]
//                          forState:UIControlStateNormal];
//    [self.view addSubview:pictureBtn];
//  }
//  if (!_isNoScanLine) {
//    [self scanLine];
//  }
////  if (_isPresent) {
//    UIButton *backBtn =
//        [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 36, 36)];
//    [backBtn setImage:[UIImage imageNamed:@"sweep_icon_back.png"]
//             forState:UIControlStateNormal];
//    [backBtn addTarget:self
//                  action:@selector(backAction:)
//        forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
//    lampBtn =
//    [[UIButton alloc] initWithFrame:CGRectMake(BoundWidth - 36 - 15, 15, 36, 36)];
//    [lampBtn setImage:[UIImage imageNamed:@"sweep_icon_lamp_open.png"]
//             forState:UIControlStateNormal];
//    [lampBtn addTarget:self
//                action:@selector(flashLight:)
//      forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:lampBtn];
////  }
//  [self scanBox];
//}
//
//- (void)coverGrayView {
//  //边缘覆盖的半透明灰色区域
////  [self otherCover:CGRectMake(0, 0, (BoundWidth - 230) / 2 + 8, BoundHeight)];
////  [self otherCover:CGRectMake(230 + (BoundWidth - 230)/2 - 8 , 0,
////                              (BoundWidth - 230) / 2+8, BoundHeight)];
////  [self otherCover:CGRectMake((BoundWidth - 230) / 2, 0, 238, 166)];
////  [self otherCover:CGRectMake((BoundWidth - 230) / 2, 352, 230,
////                              BoundHeight - 352)];
//    
//    
//    //扫描框 大小为 220 192 参考- (void)scanBox 方法
//    // 左边
//    int boxHeigtPosition = 163 ; // y坐标
//    int boxheight = 192 ;
//    int boxwidth = 220 ;
//    [self otherCover:CGRectMake(0, 0, (BoundWidth - boxwidth) / 2, BoundHeight)];
//    // 上边
//    [self otherCover:CGRectMake((BoundWidth - boxwidth) / 2 , 0,
//                          boxwidth , boxHeigtPosition)];
//         //右边
//    [self otherCover:CGRectMake((BoundWidth - boxwidth ) / 2 + boxwidth , 0, (BoundWidth - boxwidth ), BoundHeight)];
//    //下边
//    [self otherCover:CGRectMake((BoundWidth - boxwidth)/2  ,  boxHeigtPosition + boxheight , boxwidth, BoundHeight -boxHeigtPosition - boxheight )];
//}
//
//- (void)otherCover:(CGRect)Rect {
//  UIView *coverView = [[UIView alloc] initWithFrame:Rect];
////  coverView.backgroundColor = [UIColor colorWithRed:127/255.0f green:127/255.0f blue:127/255.0f alpha:0.5];
//    coverView.backgroundColor = [UIColor blackColor];
//    coverView.alpha = 0.5 ;
//  [self.view addSubview:coverView];
//}
//
////扫描框
//- (void)scanBox {
//  UIImageView *imageView = [[UIImageView alloc] init];
//  imageView.frame = CGRectMake((BoundWidth - 220) / 2, 163, 220, 192);
//  imageView.image = [UIImage imageNamed:@"code_kuang.png"];
//  [self.view addSubview:imageView];
//}
//
//- (void)scanLine {
//  lineView = [[UIImageView alloc]
//      initWithFrame:CGRectMake((BoundWidth - 220) / 2, 165, 220, 11)];
//  lineView.image = [UIImage imageNamed:@"code_line.png"];
//  upOrdown = NO;
//  num = 0;
//  [self.view addSubview:lineView];
//  [self scanLineAnimaton];
//  timer = [NSTimer scheduledTimerWithTimeInterval:.02
//                                           target:self
//                                         selector:@selector(scanLineAnimaton)
//                                         userInfo:nil
//                                          repeats:YES];
//}
//
//- (void)scanLineAnimaton {
//  if (upOrdown == NO) {
//    num++;
//    lineView.frame = CGRectMake(60, 165 + 2 * num, BoundWidth - 120, 2);
//    if (2 * num >= 184) {
//      upOrdown = YES;
//    }
//  } else {
//    num--;
//    lineView.frame = CGRectMake(60, 165 + 2 * num, BoundWidth - 120, 2);
//    if (num == 0) {
//      upOrdown = NO;
//    }
//  }
//}
//
//#pragma mark - 闪光灯
//- (void)flashLight:(id)sender {
//  UIButton *button = (UIButton *)sender;
//  button.selected = !button.selected;
//  if (button.selected) {
//    _readerView.torchMode = 1;
//      [lampBtn setImage:[UIImage imageNamed:@"sweep_icon_lamp.png"] forState:UIControlStateNormal];
//  } else {
//    _readerView.torchMode = 0;
//     [lampBtn setImage:[UIImage imageNamed:@"sweep_icon_lamp_open.png"] forState:UIControlStateNormal];
//  }
//}
//
//#pragma mark - 图库
//- (void)openPicture:(id)sender {
//  if ([UIImagePickerController
//          isSourceTypeAvailable:
//              UIImagePickerControllerSourceTypePhotoLibrary]) {
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES; //是否可以编辑
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:picker animated:YES completion:nil];
//  } else {
//    UIAlertView *alert =
//        [[UIAlertView alloc] initWithTitle:@"提示"
//                                   message:@"你没有摄像头"
//                                  delegate:nil
//                         cancelButtonTitle:@"确定"
//                         otherButtonTitles:nil];
//    [alert show];
//  }
//}
//
//#pragma mark - 二维码扫描
//- (void)readerView:(ZBarReaderView *)readerView
//    didReadSymbols:(ZBarSymbolSet *)symbols
//         fromImage:(UIImage *)image {
//    NSString *codeData = [[NSString alloc] init];
//    zbar_symbol_type_t codeType;
//    for (ZBarSymbol *sym in symbols) {
//        codeData = sym.data;
//        codeType = sym.type;
//    break;
//  }
//    [self turnScanResult:codeData type:codeType];
////  [_pushCodeInfoDelegate sendCodeInfo:codeData];
//  [_readerView stop];
//  if (timer) {
//    [timer invalidate];
//    timer = nil;
//  }
//  lineView.hidden = YES;
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker
//    didFinishPickingMediaWithInfo:(NSDictionary *)info {
//  UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//  id<NSFastEnumeration> results =
//      [info objectForKey:ZBarReaderControllerResults];
//  ZBarSymbol *symbol = nil;
//  for (symbol in results) {
//      
//    break;
//  }
//  NSString *scanInfo = [self scanForQR:image];
//  if (scanInfo.length < 1) {
//    scanInfo = @"无效的图片";
//  } else {
//    isReaderStop = YES;
//    [_readerView stop];
//    if (timer) {
//      [timer invalidate];
//      timer = nil;
//    }
//    lineView.hidden = YES;
//  }
//  [picker dismissViewControllerAnimated:YES completion:nil];
//  [self turnScanResult:scanInfo type:symbol.type];
////    [_pushCodeInfoDelegate sendCodeInfo:scanInfo];
//}
//
//- (NSString *)scanForQR:(UIImage *)image {
//  ZBarReaderController *imageReader = [ZBarReaderController new];
//  [imageReader.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
//  id<NSFastEnumeration> results = [imageReader scanImage:image.CGImage];
//  ZBarSymbol *sym = nil;
//  for (sym in results) {
//    break;
//  }
//  if (!sym) {
//    return nil;
//  }
//  return sym.data;
//}
//#pragma mark - 扫描结果
//- (void)turnScanResult:(NSString *)codeData type:(zbar_symbol_type_t)type
//{
//    
//}
//@end
