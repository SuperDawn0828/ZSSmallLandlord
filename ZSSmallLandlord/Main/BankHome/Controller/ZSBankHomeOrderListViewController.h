//
//  ZSBankHomeOrderListViewController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  银行后勤人员首页列表--table

#import "ZSBaseViewController.h"

@interface ZSBankHomeOrderListViewController : ZSBaseViewController
@property (nonatomic,copy  )NSString *searchKeyWord;
@property (nonatomic,copy  )NSString *Orderstate;//订单状态
@end
