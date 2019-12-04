//
//  ZSCustomReportListPopView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/27.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具--报表列表--新增/编辑报表弹窗

#import "ZSBasePopView.h"
#import "ZSCustomReportListCell.h"
#import "ZSCustomReportListModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ZSCustomReportListPopView;
@protocol ZSCustomReportListPopViewDelegate <NSObject>
@optional
- (void)addReportModel:(ZSCustomReportListModel *)model;
@end

@interface ZSCustomReportListPopView : ZSBasePopView
@property (nonatomic,strong) ZSCustomReportListModel *model;
@property (weak, nonatomic)id<ZSCustomReportListPopViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withType:(NSString *)type;
- (void)initData:(ZSCustomReportListModel *)model;//数据填充
@end

NS_ASSUME_NONNULL_END
