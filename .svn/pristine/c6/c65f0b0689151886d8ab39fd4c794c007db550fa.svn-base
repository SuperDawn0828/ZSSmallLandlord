//
//  ZSNotificationPageController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/8/21.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSNotificationPageController.h"
#import "ZSNotificationViewController.h"

@interface ZSNotificationPageController ()

@end

@implementation ZSNotificationPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark 初始化title(子类需要重写)
- (NSArray *)setupViewTitle
{
    return @[@"业务通知",@"其他通知"].copy;
}

#pragma mark 初始化的控制器(子类需要重写)
- (NSArray *)setupViewControllers
{
    NSMutableArray *testVCS = [NSMutableArray arrayWithCapacity:0];
    
    ZSNotificationViewController *listVC1 = [[ZSNotificationViewController alloc] init];
    listVC1.notificationType = @"1";
    [testVCS addObject:listVC1];
    
    ZSNotificationViewController *listVC2 = [[ZSNotificationViewController alloc] init];
    listVC2.notificationType = @"2";
    [testVCS addObject:listVC2];
    
    return testVCS.copy;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
