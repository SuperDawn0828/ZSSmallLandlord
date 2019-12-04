//
//  ZSPCOrderDetailController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/7/16.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  首页--预授信报告--订单列表--列表--订单详情
//  首页--中介端跟进--订单列表--列表--订单详情
//  首页--派单--订单列表--列表--订单详情

#import "ZSBaseViewController.h"

#pragma mark 无数据---枚举
typedef NS_ENUM(NSUInteger, ZSLastViewCtrlType) {
    ZSPreliminaryCreditPageController = 0,   //预授信列表
    ZSTheMediationViewController,            //中介端跟进列表
    ZSSendOrderPageViewController,           //派单列表
};

@interface ZSPCOrderDetailController : ZSBaseViewController

@property(nonatomic,assign)ZSLastViewCtrlType lastVC;

@end
