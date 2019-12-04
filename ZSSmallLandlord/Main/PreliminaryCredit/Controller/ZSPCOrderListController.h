//
//  ZSPCOrderListController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/7/16.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  首页--预授信报告--订单列表--列表

#import "ZSBaseViewController.h"

@interface ZSPCOrderListController : ZSBaseViewController
@property (nonatomic,copy  )NSString *searchKeyWord;
@property (nonatomic,copy  )NSString *Orderstate;//订单状态 1未处理 2已处理
@end
