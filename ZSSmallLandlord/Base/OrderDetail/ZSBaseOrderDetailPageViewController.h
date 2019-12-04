//
//  ZSBaseOrderDetailPageViewController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/30.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  金融产品已提交订单详情base类

#import "ZSBaseViewController.h"
#import "ZSOrderDetailHeaderView.h"

@interface ZSBaseOrderDetailPageViewController : ZSBaseViewController<ZSActionSheetViewDelegate,ZSWSRightAlertViewDelegate,ZSAlertViewDelegate,ZSOrderDetailHeaderViewDelegate>

@property(strong, nonatomic) LTAdvancedManager        *managerView;
@property(strong, nonatomic) ZSOrderDetailHeaderView  *myHeaderView;

#pragma mark 初始化的控制器(子类需要重写)
- (NSArray *)setupViewControllers;

#pragma mark rightAlertViewDelegate(子类需要重写)
- (void)didSelectBtnClick:(NSInteger)tag;

@end
