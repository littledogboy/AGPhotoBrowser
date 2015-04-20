//
//  ViewController.m
//  AGPhotoBrowser
//
//  Created by 吴书敏 on 15/4/18.
//  Copyright (c) 2015年 吴书敏. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()

@property (nonatomic,retain) UIImageView *smallImageView;
@property (nonatomic,retain) UIImageView *photoImageView;
@property (nonatomic,retain) UIView *backView;

@end

@implementation ViewController
- (void)dealloc
{
    [_smallImageView release];
    [_photoImageView release];
    [_backView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _smallImageView = [[UIImageView alloc] initWithFrame:(CGRectMake(50, 50,220,124.5))];
    // 1. clipsToBounds 超出边界剪裁 yes
    _smallImageView.clipsToBounds = YES;
    // 2. contentMode 等比缩放 超出剪裁  两个都设置了才会剪裁
    _smallImageView.contentMode = UIViewContentModeScaleAspectFill;
    NSURL *url = [NSURL URLWithString:@"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg"];
    // 1.使用方法1 url给imageView给图像
    [_smallImageView sd_setImageWithURL:url];
    _smallImageView.userInteractionEnabled  = YES; // 打开用户交互
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [_smallImageView addGestureRecognizer:tapGesture];
    
    
    [self.view addSubview:_smallImageView];
    
    // Do any additional setup after loading the view.
}

- (void)tapImage
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
    _backView = [[UIView alloc] init];
    _backView.frame = [UIScreen mainScreen].bounds;
    _backView.backgroundColor = [UIColor blackColor];
    // 自动调整子视图 保证与左 上  顶 下距离不变
    _backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //
//    UIImageView *photoImageView  = [[UIImageView alloc] initWithFrame:self.view.frame];
    
//    UIImageView *photoImageView = _smallImageView;
//    NSURL *url = [NSURL URLWithString:@"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg"];
    
    _photoImageView = [[UIImageView alloc] initWithFrame:self.smallImageView.frame];
    _photoImageView.image = _smallImageView.image;
#pragma mark- 给大图添加点击手势
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwo)];
    tapTwo.numberOfTapsRequired = 1;
    tapTwo.numberOfTouchesRequired = 1;
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPressGesture.numberOfTouchesRequired = 1;
      longPressGesture.minimumPressDuration = 0.5;
    _photoImageView.userInteractionEnabled = YES;
    [_photoImageView addGestureRecognizer:tapTwo];
    [_photoImageView addGestureRecognizer:longPressGesture];
    [tapTwo release];
    [longPressGesture release];
    
    [UIView animateWithDuration:0.2 animations:^{
        _photoImageView.frame = self.view.frame;
    } completion:^(BOOL finished) {
    }];
    
//    [photoImageView sd_setImageWithURL:url];
    _photoImageView.backgroundColor = [UIColor clearColor];
    _photoImageView.clipsToBounds = YES;
    _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _photoImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_backView addSubview:_photoImageView];
    
    // keyWindow的  _backView 被加到了 ViewController的 View上面
    // 如果想让旋转控制控制不一样 ，只有写两个 controller了
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backView];
    
    NSLog(@"图片放大");
}

- (void)tapTwo
{
    NSLog(@"第二次点击缩小");
//    CGRect smallImageFrame = self.smallImageView.frame;
//    CGRect photoImageFrame = self.photoImageView.frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.photoImageView.frame = self.smallImageView.frame;
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
    
}

#pragma mark- 长按触发保存图片到手机相册事件
- (void)longPress:(UILongPressGestureRecognizer *)longPG
{
    // 如果不加 state判断会触发多次，因为longPress手势不是单次执行手势
    if (longPG.state == UIGestureRecognizerStateBegan) {
        NSLog(@"longPress被触发");
        [self saveImagetoPhotos:self.photoImageView.image];
    }
}

- (void)saveImagetoPhotos:(UIImage *)saveImage
{
    NSLog(@"将要保存图片");
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil;
    if (error != nil) {
        msg = @"图片保存失败";
    }
    else
    {
        msg = @"图片保存成功";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存结果提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 屏幕旋转控制
/**
 想要实现的效果，底层原始小图不可以旋转，点击放大后的大图可以旋转
 只有自动旋转设置为yes   supportedInterfaceOrientations 才会有效
 
 三个函数来完成控制旋转。当shouldAutorotate返回YES的时候，第二个函数才会有效。如果返回NO，
 则无论你的项目如何设置，你的ViewController都只会使用
 preferredInterfaceOrientationForPresentation
 的返回值来初始化自己的方向，
 
 如果你没有重新定义preferredInterfaceOrientationForPresentation这个函数，那么它就返回父视图控制器的
 preferredInterfaceOrientationForPresentation的值。
 
 默认 就是yes
 */
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持的方向
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
