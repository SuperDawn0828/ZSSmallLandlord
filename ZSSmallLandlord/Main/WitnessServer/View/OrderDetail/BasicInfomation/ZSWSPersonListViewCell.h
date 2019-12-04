//
//  ZSViewPersonListCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  订单详情--人员列表--cell

#import "ZSBaseTableViewCell.h"

@interface ZSWSPersonListViewCell : ZSBaseTableViewCell
@property (nonatomic,strong) UILabel     *nameLabel;         //姓名
@property (nonatomic,strong) UILabel     *idCardLabel;       //身份证号
@property (nonatomic,strong) UILabel     *label_feedbackState;//反馈状态
@property (nonatomic,strong) UILabel     *timeLabel;         //反馈时间
@property (nonatomic,strong) CustInfo    *detailModel;
@end
