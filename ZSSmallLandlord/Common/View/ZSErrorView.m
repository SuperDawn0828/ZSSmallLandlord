//
//  ZSErrorView.m
//  ZSMoneytocar
//
//  Created by 武 on 16/7/6.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSErrorView.h"

@implementation ZSErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    self.imagView = [[UIImageView alloc]initWithFrame:CGRectMake((self.width-120)/2, 100, 120, 120)];
    [self addSubview:self.imagView];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, self.imagView.bottom+10, ZSWIDTH-40, 22)];
    self.titleLab.textColor = ZSPageItemColor;;
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLab];
   
    //无数据时 轻扫手势通知接口请求
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sendNotification)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeGesture];
}

- (void)sendNotification
{
    if ([self.titleLab.text isEqualToString:@"暂无通知"])
    {
        [NOTI_CENTER postNotificationName:KSUpdateNotificationList object:nil];
    }
    else if ([self.titleLab.text isEqualToString:@"暂无小工具哦"])
    {
        [NOTI_CENTER postNotificationName:KSUpdateNotificationList object:nil];
    }
    else
    {
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
    }
}

@end
