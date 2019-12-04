//
//  ZSOrderDetailPersonCell.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/3.
//  Copyright © 2018年 maven. All rights reserved.
//  首页--预授信报告--订单列表--列表--订单详情--人员cell

#import "ZSBaseTableViewCell.h"
#import "ZSPCOrderDetailModel.h"

static NSString *CellIdentifier = @"ZSOrderDetailPersonCell";

@interface ZSOrderDetailPersonCell : ZSBaseTableViewCell

@property(nonatomic,strong)CustomersModel *model;

@end
