//
//  NavViewController.m
//
//
//  Created by 黄曼文 on 14-11-5.
//  Copyright (c) 2014年 黄曼文. All rights reserved.
//

#import "ZSNavViewController.h"
#import "ZSTabBarViewController.h"

@interface ZSNavViewController ()

@end

@implementation ZSNavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark 显示或隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //隐藏tabbar
    if (self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark 状态栏字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
