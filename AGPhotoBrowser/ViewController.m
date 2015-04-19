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
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwo)];
    _photoImageView.userInteractionEnabled = YES;
    [_photoImageView addGestureRecognizer:tapTwo];
    [tapTwo release];
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
    
    // keyWindow的理解
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
