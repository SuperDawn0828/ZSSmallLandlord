//
//  ZSSLPersonDetailBigDataCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  星速贷--订单详情--人员列表--人员详情--大数据风控cell

#import "ZSBaseTableViewCell.h"

@interface ZSSLPersonDetailBigDataCell : ZSBaseTableViewCell
@property (nonatomic,strong) UILabel     *titleLabel;   //标题
@property (nonatomic,strong) UILabel     *contentLabel; //内容
@property (nonatomic,strong) UILabel     *label_result;  //结果
@property (nonatomic,strong) UIImageView *img_result;
@property (nonatomic,strong) BizCreditCustomers *detailModel;
+ (CGFloat)resetCellHeight:(BizCreditCustomers *)detailModel;
@end
