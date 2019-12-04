//
//  ZSCustomReportSettingViewController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/28.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具--报表列表--设置报表字段

#import "ZSBaseViewController.h"
#import "ZSCustomReportListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSCustomReportSettingViewController : ZSBaseViewController
@property (nonatomic,strong) ZSCustomReportListModel *model;
@end

NS_ASSUME_NONNULL_END
