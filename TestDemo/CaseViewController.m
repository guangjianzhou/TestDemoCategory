


//
//  CaseViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/25.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CaseViewController.h"
#import "VIPhotoView/VIPhotoView.h"
#import "ShowCollectionViewCell.h"
#import "UIImageViewEx.h"
#import "ImageCropperView.h"
#import "DraggableView.h"
#import "Toast+UIView.h"
#import "Masonry.h"


#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height

@interface CaseViewController ()<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    CGPoint startPoint;
    CGPoint newPoint;
    
    CGFloat _lastTransX;
    CGFloat _lastTransY;
}


@property (weak, nonatomic) IBOutlet ImageCropperView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *smalImageView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UIView *panView;
@property (strong, nonatomic) DraggableView *drageView;



@end

@implementation CaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    [self imageGes];
}

- (void)imageGes
{
    [_backImageView setup];
    _backImageView.image = [UIImage imageNamed:@"test.jpg"];
    
    
    //collectionView
    
    {
        UICollectionViewFlowLayout *horizontalScrollLayout = [[UICollectionViewFlowLayout alloc] init];
        horizontalScrollLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        horizontalScrollLayout.minimumInteritemSpacing = 20;
        _collectionView.collectionViewLayout = horizontalScrollLayout;
        [_collectionView registerNib:[UINib nibWithNibName:@"ShowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShowCollectionViewCell"];
        
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveCell:)];
        longPressGes.minimumPressDuration = 0.5;
        longPressGes.delegate = self;
        [_collectionView addGestureRecognizer:longPressGes];
    }
    
    
}

- (void)setUp
{
//    _image = [UIImage imageNamed:@"test.jpg"];
//    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:    CGRectMake(0, 0, kScreenWidth, kScreenHeight -200) andImage:_image];
//    photoView.autoresizingMask = (1 << 6) -1;
//    [self.view addSubview:photoView];
    
    
    _smalImageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    [_smalImageView addGestureRecognizer:recognizer];
    
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}




#pragma mark  - 图片旋转

#pragma mark  - UIGestureRecognizerDelegate
- (void)pressSmallImageView:(UILongPressGestureRecognizer *)longPressGes
{
    CGPoint location = [longPressGes locationInView:self.view];
    static UIView       *snapshot = nil;
    switch (longPressGes.state) {
        case UIGestureRecognizerStateBegan: {
            snapshot = [self customSnapshoFromView:_smalImageView];
            __block CGPoint center = _smalImageView.center;
            snapshot.center = center;
            snapshot.alpha = 0.0;
            [self.view addSubview:snapshot];
            [UIView animateWithDuration:0.25 animations:^{
                
                // Offset for gesture location.
                center.y = location.y;
                snapshot.center = center;
                snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                snapshot.alpha = 0.98;
                
                // Fade out.
//                _smalImageView.alpha = 0.0;
            } completion:nil];
            
            break;
        }
        default: {
            // Clean up.
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = _smalImageView.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the fade-out effect we did.
                _smalImageView.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
//                [snapshot removeFromSuperview];
//                snapshot = nil;
                
            }];
            break;
        }

    }
}

#pragma mark - 处理手势操作
/**
 * 处理拖动手势
 *
 * @param recognizer 拖动手势识别器对象实例
 */
- (void)handlePan1:(UIPanGestureRecognizer *)recognizer
{
    //视图前置操作
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    
    CGPoint center = recognizer.view.center;
    CGFloat cornerRadius = recognizer.view.frame.size.width / 2;
    CGPoint translation = [recognizer translationInView:self.view];
    //NSLog(@"%@", NSStringFromCGPoint(translation));
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        //计算速度向量的长度，当他小于200时，滑行会很短
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866
        
        //基于速度和速度因素计算一个终点
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),
                                         center.y + (velocity.y * slideFactor));
        //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
        finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
                           self.view.bounds.size.width - cornerRadius);
        finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
                           self.view.bounds.size.height - cornerRadius);
        
        //使用 UIView 动画使 view 滑行到终点
        [UIView animateWithDuration:slideFactor*2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             recognizer.view.center = finalPoint;
                             if ([self judgeView:_smalImageView rangeView:_backImageView.imageView])
                             {
                                 [UIView showToastWithText:@"小在图内"];
                    
                                 [_backImageView.imageView addSubview:_smalImageView];
                                 [_backImageView.imageView bringSubviewToFront:_smalImageView];
                                 
                                 //坐标系转换
                                _smalImageView.frame =  [self.view convertRect:_smalImageView.frame toView:_backImageView.imageView];
                                 
                                 
                                 NSLog(@"=%@===frame====",NSStringFromCGRect(_smalImageView.frame));
                             }
                             else
                             {
                                 [UIView showToastWithText:@"小不在图内"];
                             }
                             
                         }
                         completion:nil];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        newPoint = [recognizer locationInView:self.view];
        CGFloat deltaX = newPoint.x - startPoint.x;
        CGFloat deltaY = newPoint.y - startPoint.y;
        startPoint = newPoint;
        recognizer.view.center = CGPointMake(recognizer.view.center.x + deltaX ,recognizer.view.center.y + deltaY);
        NSLog(@"=frame 111= %@=========",NSStringFromCGRect(recognizer.view.frame));
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan)
    {
         startPoint = [recognizer locationInView:self.view];
        NSLog(@"startPoint = %@",NSStringFromCGPoint(startPoint));
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    ShowCollectionViewCell *cell = (ShowCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];

 
    //视图前置操作
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    
    CGPoint center = recognizer.view.center;
    CGFloat cornerRadius = recognizer.view.frame.size.width / 2;
    CGPoint translation = [recognizer translationInView:self.view];
    //NSLog(@"%@", NSStringFromCGPoint(translation));
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        //计算速度向量的长度，当他小于200时，滑行会很短
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866
        
        //基于速度和速度因素计算一个终点
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),
                                         center.y + (velocity.y * slideFactor));
        //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
        finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
                           self.view.bounds.size.width - cornerRadius);
        finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
                           self.view.bounds.size.height - cornerRadius);
        
        //使用 UIView 动画使 view 滑行到终点
        [UIView animateWithDuration:slideFactor*2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _panView.center = finalPoint;
                         }
                         completion:nil];
    }
    else if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"==beigin============");
        _panView  = [self customSnapshoFromView:cell];
        if (_panView)
        {
            [self.view addSubview:_panView];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if (_panView)
        {
            [_panView removeFromSuperview];
             _panView = nil;
        }
    }
}

- (void)moveSnap:(UIPanGestureRecognizer *)panGes
{
    CGPoint translatedPoint = [panGes translationInView:_backImageView.imageView];
    
    if([panGes state] == UIGestureRecognizerStateBegan)
    {
        _lastTransX = 0.0;
        _lastTransY = 0.0;
    }
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(translatedPoint.x - _lastTransX, translatedPoint.y - _lastTransY);
    CGAffineTransform newTransform = CGAffineTransformConcat(panGes.view.transform, trans);
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;

    panGes.view.transform = newTransform;
    
    if ([panGes state] == UIGestureRecognizerStateEnded && panGes.view)
    {
        CGRect selfRect = [_backImageView.imageView convertRect:panGes.view.frame toView:_backImageView];
        BOOL isIn = CGRectIntersectsRect(_backImageView.imageView.frame,selfRect);
        if (isIn)
        {
            NSLog(@"=====包含====");
        }
        else
        {
            NSLog(@"====不=包含====");
            [panGes.view removeFromSuperview];
        }
        
    }

}


//复制图片
- (UIView *)customSnapshoFromView:(UIView *)inputView
{
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    //添加手势
    snapshot.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSnap:)];
    panGes.delegate = self;
    [snapshot addGestureRecognizer:panGes];

    return snapshot;
}


#pragma mark  - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 60;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShowCollectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"un_180"];
    
    //圆角
    //方法1
//    cell.imageView.layer.cornerRadius = 30;
//    cell.imageView.layer.masksToBounds = YES;
    [self drawRectWithRoundedImageView:cell.imageView CornerRadius:30 ];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld个",(long)indexPath.row];
    return cell;
}


#pragma mark - 图片圆角
//方法2
//https://github.com/liuzhiyi1992/ZYCornerRadius
//https://github.com/panghaijiao/HJCornerRadius
//为UIView 添加圆角
- (void)drawRectWithRoundedImageView:(UIImageView *)originImageView
                        CornerRadius: (CGFloat) radius
{
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(originImageView.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    CGContextAddPath(currnetContext, [UIBezierPath bezierPathWithRoundedRect:originImageView.bounds cornerRadius:radius].CGPath);
    CGContextClip(currnetContext);
    [originImageView.layer renderInContext:currnetContext];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    originImageView.image = image;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 76);
}


- (void)moveCell:(UILongPressGestureRecognizer *)ges
{
    UIGestureRecognizerState state = ges.state;
    CGPoint location = [ges locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    ShowCollectionViewCell *cell = (ShowCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath) {
                
                sourceIndexPath = indexPath;

                // Take a snapshot of the selected row using helper method.
                if (snapshot)
                {
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                }
                snapshot = [self customSnapshoFromView:cell];
                
                startPoint = [ges locationInView:self.collectionView];
                // Add the snapshot as subview, centered at cell's center...
                
                NSLog(@"======begin==111111==%@=====cell.frame =%@=====",NSStringFromCGRect(snapshot.frame),NSStringFromCGRect(cell.frame));
                
                
                CGRect snapFrame = [self.collectionView convertRect:cell.frame toView:self.view];
                snapshot.frame = snapFrame;
                snapshot.alpha = 1.0;
                
                NSLog(@"======begin==22222==%@========cell.frame =%@==========",NSStringFromCGRect(snapshot.frame),NSStringFromCGRect(cell.frame));
                
                [self.view addSubview:snapshot];
                [self.view bringSubviewToFront:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    // Fade out.
                    cell.alpha = 1.0;
                } completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            newPoint = [ges locationInView:self.collectionView];
            CGFloat deltaX = newPoint.x - startPoint.x;
            CGFloat deltaY = newPoint.y - startPoint.y;
            
            startPoint = newPoint;
            snapshot.center = CGPointMake(snapshot.center.x + deltaX ,snapshot.center.y + deltaY);
            NSLog(@"======changed======%@========",NSStringFromCGRect(snapshot.frame));
            break;
        }
        default: {
            NSLog(@"======default=11111==%@===========",NSStringFromCGRect(snapshot.frame));
            
            UIImageView *imageView = _backImageView.imageView;
            CGRect newFrame = [imageView convertRect:snapshot.frame toView:imageView];
            newFrame.origin.y -= 64;
            snapshot.frame = newFrame;
            
            [imageView addSubview:snapshot];
            NSLog(@"======default==2222=%@======new frame==%@===",NSStringFromCGRect(snapshot.frame),NSStringFromCGRect(snapshot.frame));
            return;
            
            // Clean up.
            NSLog(@"======default==============");
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 1.0;
                
                // Undo the fade-out effect we did.
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            break;
        }
    }

}

- (void)moveCell1:(UILongPressGestureRecognizer *)ges
{
    UIGestureRecognizerState state = ges.state;
    
    CGPoint location = [ges locationInView:self.collectionView];
    location = [self.collectionView convertPoint:location toView:self.view];
    
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath) {
                NSLog(@"======begin==============");
                sourceIndexPath = indexPath;
                
            
            
                
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 1.0;
                [self.view addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Fade out.
                    cell.alpha = 1.0;
                } completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            snapshot.center = location;
            NSLog(@"======changed==============");
            break;
        }
        default: {
            // Clean up.
            NSLog(@"======default==============");
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 1.0;
                
                // Undo the fade-out effect we did.
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            break;
        }
    }
    
}

#pragma mark - 点在frame内
//judgeView 小view   rangeView
- (BOOL)judgeView:(UIView *)compareView  rangeView:(UIView *)view
{
    BOOL isContain = CGRectContainsPoint(view.frame,compareView.center);
    NSLog(@"isContain========%d",isContain);
    return isContain;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
