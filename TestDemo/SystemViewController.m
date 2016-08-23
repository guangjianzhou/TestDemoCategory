//
//  SystemViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/12.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "SystemViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "UIImage+help.h"
#import "UIColor+help.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTCellularData.h>
#import <AddressBook/AddressBook.h>
@import Photos;


@interface SystemViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *manager;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UIImageView *imageView;




@end

@implementation SystemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor= [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 80, 80)];
    [self.view addSubview:_imageView];
    
    
    //设置标题栏不能覆盖下面viewcontroller的内容
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    _dataSourceArray = [NSMutableArray arrayWithObjects:@"系统相册",@"系统照片",nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self judegeInteNet];
//    [self photoAuto];
//    [self cameraAuthor];
    [self location];

    
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.top.mas_equalTo(self.view.mas_top);
//        make.width.mas_equalTo(self.view.mas_width);
//        make.height.equalTo(@200);
//    }];
    
//    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_tableView.mas_left);
//        make.top.mas_equalTo(_tableView.mas_bottom);
//        make.width.equalTo(@80);
//        make.height.equalTo(@80);
//    }];
}

#pragma mark  - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _dataSourceArray[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *msg = _dataSourceArray[indexPath.row];
    if ([msg containsString:@"相册"])
    {
        [self imagePickerViewController];
    }
}

#pragma mark  - imagePickView
- (void)imagePickerViewController
{
    NSMutableArray *array = [NSMutableArray array];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"支持相机");
        [array addObject:@"相机"];
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSLog(@"支持图库");
        [array addObject:@"图库"];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        NSLog(@"支持相片库");
        [array addObject:@"相片库"];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self carmerVC];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self libaryVC];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相片库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self phoneVC];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:action];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    
    [self presentViewController:alertController animated:YES
                     completion:^{
                         
                     }];
}

- (UIImagePickerController *)imagePVCWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    //字体默认英文 国际化
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.view.backgroundColor = [UIColor orangeColor];
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    
    //设置图片选择 VC的导航栏
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"topbar"] forBarMetrics:UIBarMetricsDefault];

    
    return picker;
}

- (void)carmerVC
{
    UIImagePickerController *picker = [self imagePVCWithSourceType:UIImagePickerControllerSourceTypeCamera];
    
    //相机权限
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authStatus == AVAuthorizationStatusDenied)
        {
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设备的 '设置-隐私-相机' 中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alterView show];
            return;
        }
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)libaryVC
{
    UIImagePickerController *picker = [self imagePVCWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)phoneVC
{
    UIImagePickerController *picker = [self imagePVCWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark  - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    _imageView.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion: ^{
        
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
//    [viewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar"] forBarMetrics:UIBarMetricsDefault];
    
    //字体变黑
    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}



#pragma mark  - 权限设置
//联网权限
- (void)judegeInteNet{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    switch (state) {
        case kCTCellularDataRestricted:
            NSLog(@"Restricrted");
            break;
        case kCTCellularDataNotRestricted:
            NSLog(@"Not Restricted");
            break;
        case kCTCellularDataRestrictedStateUnknown:
            NSLog(@"Unknown");
            break;
        default:
            break;
    }
    [self jumpSet];
}

//相机权限
- (void)photoAuto
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        switch (status) {
            case ALAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
            case ALAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case ALAuthorizationStatusNotDetermined:
                NSLog(@"not Determined");
                break;
            case ALAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
                
            default:
                break;
        }
    }else{
        PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
        switch (photoAuthorStatus) {
            case PHAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
            case PHAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case PHAuthorizationStatusNotDetermined:
                NSLog(@"not Determined");
                break;
            case PHAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            default:
                break;
        }
        
        
        //    获取相册权限
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                NSLog(@"Authorized");
            }else{
                NSLog(@"Denied or Restricted");
            }
        }];
    }
}

- (void)cameraAuthor{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
//    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//麦克风权限
    
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            break;
        case AVAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case AVAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case AVAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    
    
    //第一次安装的时候，会弹出框提示你；当你第一次选完后，不会再提示，但代码执行 ====Authorized
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
        if (granted) {
            NSLog(@"====Authorized");
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
    
//    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {//麦克风权限
//        if (granted) {
//            NSLog(@"Authorized");
//        }else{
//            NSLog(@"Denied or Restricted");
//        }
//    }];
    
}

- (void)location{
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (!isLocation) {
        NSLog(@"not turn on the location");
    }
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    switch (CLstatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Always Authorized");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"AuthorizedWhenInUse");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    
     manager = [[CLLocationManager alloc] init];
//    manager.delegate = self;
    //infoPlist 设置 NSLocationWhenInUseUsageDescription
    
    
    [manager requestAlwaysAuthorization];//一直获取定位信息
    [manager requestWhenInUseAuthorization];//使用的时候获取定位信息
}

- (void)addressAuthor{
    ABAuthorizationStatus ABstatus = ABAddressBookGetAuthorizationStatus();
    switch (ABstatus) {
        case kABAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            break;
        case kABAuthorizationStatusDenied:
            NSLog(@"Denied'");
            break;
        case kABAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case kABAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            NSLog(@"Authorized");
            CFRelease(addressBook);
        }else{
            NSLog(@"Denied or Restricted");
        }
    });
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Always Authorized");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"AuthorizedWhenInUse");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    
}

//About — prefs:root=General&path=About
//Accessibility — prefs:root=General&path=ACCESSIBILITY
//AirplaneModeOn— prefs:root=AIRPLANE_MODE
//Auto-Lock — prefs:root=General&path=AUTOLOCK
//Brightness — prefs:root=Brightness
//Bluetooth — prefs:root=General&path=Bluetooth
//Date& Time — prefs:root=General&path=DATE_AND_TIME
//FaceTime — prefs:root=FACETIME
//General— prefs:root=General
//Keyboard — prefs:root=General&path=Keyboard
//iCloud — prefs:root=CASTLE iCloud
//Storage & Backup — prefs:root=CASTLE&path=STORAGE_AND_BACKUP
//International — prefs:root=General&path=INTERNATIONAL
//Location Services — prefs:root=LOCATION_SERVICES
//Music — prefs:root=MUSIC
//Music Equalizer — prefs:root=MUSIC&path=EQ
//Music VolumeLimit— prefs:root=MUSIC&path=VolumeLimit
//Network — prefs:root=General&path=Network
//Nike + iPod — prefs:root=NIKE_PLUS_IPOD
//Notes — prefs:root=NOTES
//Notification — prefs:root=NOTIFICATIONS_ID
//Phone — prefs:root=Phone
//Photos — prefs:root=Photos
//Profile — prefs:root=General&path=ManagedConfigurationList
//Reset — prefs:root=General&path=Reset
//Safari — prefs:root=Safari Siri — prefs:root=General&path=Assistant
//Sounds — prefs:root=Sounds
//SoftwareUpdate— prefs:root=General&path=SOFTWARE_UPDATE_LINK
//Store — prefs:root=STORE
//Twitter — prefs:root=TWITTER
//Usage — prefs:root=General&path=USAGE
//VPN — prefs:root=General&path=Network/VPN
//Wallpaper — prefs:root=Wallpaper
//Wi-Fi — prefs:root=WIFI
//Setting—prefs:root=INTERNET_TETHERING
- (void)jumpSet{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置网络" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //通用
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network/VPN"]];
        //进到app设置里面了
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
