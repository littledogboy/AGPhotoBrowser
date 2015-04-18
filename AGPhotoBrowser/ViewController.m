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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *smallImageView = [[UIImageView alloc] initWithFrame:(CGRectMake(50, 50,220,124.5))];
    // 1. clipsToBounds 超出边界剪裁 yes
    smallImageView.clipsToBounds = YES;
    // 2. contentMode 等比缩放 超出剪裁  两个都设置了才会剪裁
    smallImageView.contentMode = UIViewContentModeScaleAspectFill;
    NSURL *url = [NSURL URLWithString:@"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg"];
    // 1.使用方法1 url给imageView给图像
    [smallImageView sd_setImageWithURL:url];
    smallImageView.userInteractionEnabled  = YES; // 打开用户交互
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [smallImageView addGestureRecognizer:tapGesture];
    
    
    [self.view addSubview:smallImageView];
    [smallImageView release];
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)tapImage
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
    UIView *backView = [[UIView alloc] init];
    backView.frame = [UIScreen mainScreen].bounds;
    backView.backgroundColor = [UIColor blackColor];
    // 自动调整子视图 保证与左 上  顶 下距离不变
    backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //
    UIImageView *photoImageView  = [[UIImageView alloc] initWithFrame:self.view.frame];
    NSURL *url = [NSURL URLWithString:@"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg"];
    [photoImageView sd_setImageWithURL:url];
    photoImageView.backgroundColor = [UIColor clearColor];
    photoImageView.clipsToBounds = YES;
    photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    photoImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [backView addSubview:photoImageView];
    [photoImageView release];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:backView];
    [backView release];
    
    NSLog(@"图片放大");
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
