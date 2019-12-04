//
//  ZSBaseCreatOrderViewController.h
//  ZSSmallLandlord
//
//  Created by gengping on 2017/8/18.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  金融产品未提交订单详情base类

#import "ZSBaseViewController.h"
#import "ZSBaseCreatOrderHeaderView.h"

@interface ZSBaseCreatOrderViewController : ZSBaseViewController

@property (nonatomic,strong)ZSBaseCreatOrderHeaderView  *view_progress;   //图片进度view
@property (nonatomic,strong)UIView                      *view_top;        //顶部进度view
@property (nonatomic,copy  )NSString                    *orderState;      //订单状态

@end
