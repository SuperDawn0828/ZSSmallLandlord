//
//  ZSViewPersonListCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  银行后勤人员首页列表--人员列表详情--cell
//  订单详情--人员列表--cell

#import "ZSBaseTableViewCell.h"

@interface ZSWSPersonListViewCell : ZSBaseTableViewCell
@property (nonatomic,strong) UILabel     *label_name;         //姓名
@property (nonatomic,strong) UILabel     *label_idCard;       //身份证号
@property (nonatomic,strong) UILabel     *label_feedbackState;//反馈状态
@property (nonatomic,strong) UILabel     *label_time;         //反馈时间
@property (nonatomic,strong) UILabel     *label_self_tag;     //本人标签
@property (nonatomic,strong) UILabel     *label_mate_tag;     //配偶标签
@property (nonatomic,strong) UILabel     *label_coowner_tag;  //共有人标签
@property (nonatomic,strong) UILabel     *label_bondsman_tag; //担保人标签
@property (nonatomic,strong) UILabel     *label_bondsmanMate_tag; //担保人配偶标签
@property (nonatomic,strong) CustInfo    *detailModel;
@end
