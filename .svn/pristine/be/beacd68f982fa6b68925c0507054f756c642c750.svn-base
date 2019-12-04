//
//  ZSTabBarViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSTabBarViewController.h"
#import "ZSNavViewController.h"
#import "ZSHomeViewController.h"
#import "ZSNotificationPageController.h"
#import "ZSToolViewController.h"
#import "ZSBankHomeViewController.h"
#import "ZSPersonalViewController.h"

@interface ZSTabBarViewController ()

@end

@implementation ZSTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedIndex = 0;//默认选择第一页
    [self initTabBar];    
}

- (void)initTabBar
{
    //这种初始化可以去除tabbar顶部的细线
    [self.tabBar setBackgroundImage:[ZSTool createImageWithColor:UIColorFromRGB(0xFAFAFA)]];//将背景色设成图片,盖住细线
    [self.tabBar setShadowImage:[ZSTool createImageWithColor:UIColorFromRGB(0xFAFAFA)]];
    
    ZSHomeViewController            *homeVC         = [[ZSHomeViewController alloc]init];
    ZSBankHomeViewController        *bankHomeVC     = [[ZSBankHomeViewController alloc]init];
    ZSNotificationPageController    *notiVC         = [[ZSNotificationPageController alloc]init];
    ZSToolViewController            *toolVC         = [[ZSToolViewController alloc]init];
    ZSPersonalViewController        *personalVC     = [[ZSPersonalViewController alloc]init];

    [self setUpChildControllerWith:homeVC     title:@"首页" norImage:[UIImage imageNamed:@"bottom_home_n"] selImage:[UIImage imageNamed:@"bottom_home_s"]];
    [self setUpChildControllerWith:bankHomeVC title:@"审批" norImage:[UIImage imageNamed:@"bottom_subject_n"] selImage:[UIImage imageNamed:@"bottom_subject_s"]];
    [self setUpChildControllerWith:notiVC     title:@"通知" norImage:[UIImage imageNamed:@"bottom_notice_n"] selImage:[UIImage imageNamed:@"bottom_notice_s"]];
    [self setUpChildControllerWith:toolVC     title:@"工具" norImage:[UIImage imageNamed:@"bottom_tool_n"] selImage:[UIImage imageNamed:@"bottom_tool_s"]];
    [self setUpChildControllerWith:personalVC title:@"我"   norImage:[UIImage imageNamed:@"bottom_my_n"]   selImage:[UIImage imageNamed:@"bottom_my_s"]];
}

- (void)setUpChildControllerWith:(UIViewController *)childVc title:(NSString *)title norImage:(UIImage *)norImage selImage:(UIImage *)selImage
{
    ZSNavViewController *navVC = [[ZSNavViewController alloc] initWithRootViewController:childVc];
    //设置tabbar上的子控制器
    childVc.title = title;
    childVc.tabBarItem.image = [norImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    [self addChildViewController:navVC];

    //字体大小/颜色
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      UIColorFromRGB(0x4F4F4F), NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:10], NSFontAttributeName,nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      ZSColorRed, NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:10], NSFontAttributeName,nil]
                                             forState:UIControlStateSelected];
}

//点击tabbarItem自动调用
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
}

- (void)animationWithIndex:(NSInteger)index
{
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    //只图标做动画，文字不做动画
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            for (UIView *subView in tabBarButton.subviews) {
                if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                    [tabbarbuttonArray addObject:subView];
                }
            }
        }
    }
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.1;
    pulse.repeatCount = 1;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:1];
    pulse.toValue = [NSNumber numberWithFloat:1.2];
    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
}

#pragma mark 重设选中的index 用于推送
- (void)resetCurrentIndex:(NSInteger)index
{
    self.selectedIndex = index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
