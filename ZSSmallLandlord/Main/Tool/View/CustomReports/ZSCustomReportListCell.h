//
//  ZSCustomReportListCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/27.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具--报表列表cell

#import "ZSBaseTableViewCell.h"
#import "ZSCustomReportListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSCustomReportListCell : ZSBaseTableViewCell
@property (nonatomic,strong) UILabel                 *explainLabel;     //报表说明
@property (nonatomic,strong) ZSCustomReportListModel *model;
@end

NS_ASSUME_NONNULL_END
