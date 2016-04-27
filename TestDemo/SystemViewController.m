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

@interface SystemViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
    
    
    
    
    _dataSourceArray = [NSMutableArray arrayWithObjects:@"系统相册",@"系统照片",nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
