//
//  RecordVideoViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/9/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "RecordVideoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>


@interface RecordVideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

 @property(nonatomic,strong) UIImagePickerController *imagePick;
 @property (strong ,nonatomic)AVPlayer *player;//播放器，用于录制完视频后播放视频
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation RecordVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 300, 200)];
    [self.view addSubview:_imageView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *avalibleMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([avalibleMediaTypes containsObject:(NSString *)kUTTypeMovie]) {
            //支持视频录制
            _imagePick = [UIImagePickerController new];
            _imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePick.mediaTypes = @[(NSString *) kUTTypeMovie];
            _imagePick.cameraDevice = UIImagePickerControllerCameraDeviceRear; //使用后置摄像头
            _imagePick.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
            _imagePick.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            _imagePick.allowsEditing = YES;
            _imagePick.delegate = self;
            [self presentViewController:_imagePick animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePickerController代理方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
        
    }
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error) {
        
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
        
    }else{
        
        NSLog(@"视频保存成功.");
        
        //录制完之后自动播放
        
        NSURL *url=[NSURL fileURLWithPath:videoPath];
        
        _player=[AVPlayer playerWithURL:url];
        
        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
        
        playerLayer.frame=self.imageView.frame;
        
        [self.imageView.layer addSublayer:playerLayer];
        
        [_player play];
    }
    
}



@end
