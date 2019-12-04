//
//  ZSCustomReportEditViewController.h
//  ZSSmallLandlord
//
//  Created by 邵菡怡 on 2018/12/5.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  工具--报表列表--报表编辑

#import "ZSBaseViewController.h"

typedef void (^ReturnValueBlock) (NSArray *dataArray);

NS_ASSUME_NONNULL_BEGIN

@interface ZSCustomReportEditViewController : ZSBaseViewController

@property(nonatomic,strong)NSMutableArray   *arrayData;
@property(nonatomic, copy )ReturnValueBlock returnValueBlock;

@end

NS_ASSUME_NONNULL_END
