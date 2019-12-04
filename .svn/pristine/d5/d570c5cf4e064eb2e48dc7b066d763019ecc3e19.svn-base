//
//  ZSCustomReportSettingCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/28.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具--报表列表--设置报表字段cell

#import "ZSBaseTableViewCell.h"
#import "ZSCustomReportSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ZSCustomReportSettingCell;
@protocol ZSCustomReportSettingCellDelegate <NSObject>
@optional
- (void)selectCell:(ZSCustomReportSettingModel *)model;//选中/删除
@end

@interface ZSCustomReportSettingCell : ZSBaseTableViewCell
@property (weak, nonatomic)id<ZSCustomReportSettingCellDelegate> delegate;
@property (nonatomic,strong)ZSCustomReportSettingModel *model;
@end

NS_ASSUME_NONNULL_END
