//
//  ZSBaseOrderListPageViewController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/6/11.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  订单列表page

#import "ZSBaseViewController.h"

@interface ZSBaseOrderListPageViewController : ZSBaseViewController<ZSSelectViewDelegate>
@property(strong, nonatomic) UILabel                  *titleLabel;
@property(strong, nonatomic) UIImageView              *titleImg;
@property(strong, nonatomic) NSArray                  *titleArray;
@property(strong, nonatomic) NSArray                  *titleArrayShow;
@property(strong, nonatomic) LTAdvancedManager        *managerView;
@property(strong, nonatomic) LTLayout                 *layout;

#pragma mark 列表数据权限
- (void)initTitleView:(CGFloat)titleWidth;

#pragma mark 初始化title(子类需要重写)
- (NSArray *)setupViewTitle;

#pragma mark 初始化的控制器(子类需要重写)
- (NSArray *)setupViewControllers;


@end
