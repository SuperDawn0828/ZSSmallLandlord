//
//  ZSMaterialCollectRecordCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/22.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  首页--订单列表--订单详情--资料收集--资料收集记录cell

#import "ZSBaseTableViewCell.h"
#import "ZSMaterialCollectRecordModel.h"
@interface ZSMaterialCollectRecordCell : ZSBaseTableViewCell
@property (nonatomic,strong) UIImageView *imgview_left;
@property (nonatomic,strong) UIView      *lineView;
@property (nonatomic,strong) UILabel     *timeLabel;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *contentLabel;
@property (nonatomic,strong) ZSMaterialCollectRecordModel *model;
@end
