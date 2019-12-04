//
//  ZSAFOListCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBaseTableViewCell.h"
#import "ZSAOListModel.h"

@interface ZSAFOListCell : ZSBaseTableViewCell
@property (nonatomic,strong) UIImageView   *imgview_header;     //头像
@property (nonatomic,strong) UILabel       *nameLabel;          //姓名
@property (nonatomic,strong) UILabel       *label_area;         //地区
@property (nonatomic,strong) UILabel       *label_house;        //有无房产
@property (nonatomic,strong) UILabel       *orderStateLabel;    //订单状态
@property (nonatomic,strong) ZSAOListModel *model;
@end
