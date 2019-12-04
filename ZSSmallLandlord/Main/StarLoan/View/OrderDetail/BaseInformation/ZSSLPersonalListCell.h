//
//  ZSSLPersonalListCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  星速贷--订单详情--人员列表--人员详情cell

#import "ZSBaseTableViewCell.h"

static CGFloat const  KZSSLPersonalListCellHeight = 80;

@protocol ZSSLPersonalListCellDelegate <NSObject>
@optional
- (void)changeRole:(BizCustomers *)cutomerModel;
@end

@interface ZSSLPersonalListCell : ZSBaseTableViewCell
@property (weak, nonatomic)id<ZSSLPersonalListCellDelegate> delegate;
@property (nonatomic,strong) BizCustomers *detailModel;
@end
