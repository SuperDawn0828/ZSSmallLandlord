//
//  ZSCustomReportListModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/28.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具--报表列表model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSCustomReportListModel : NSObject
@property (nonatomic,copy)NSString *tid;
@property (nonatomic,copy)NSString *prdType;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *timeFrame;
@property (nonatomic,copy)NSString *seqs;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,assign)NSInteger editingType;//是否是编辑模式 1不是 2是 (本地数据)
@end

NS_ASSUME_NONNULL_END
