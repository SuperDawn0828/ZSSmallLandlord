//
//  ZSAFOOrderListViewController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  首页--微信申请--订单列表--table

#import "ZSBaseViewController.h"

@interface ZSAFOOrderListViewController : ZSBaseViewController
@property (nonatomic,copy  )NSString *searchKeyWord;
@property (nonatomic,copy  )NSString *Orderstate;//订单状态 1未处理 2已处理
@end
