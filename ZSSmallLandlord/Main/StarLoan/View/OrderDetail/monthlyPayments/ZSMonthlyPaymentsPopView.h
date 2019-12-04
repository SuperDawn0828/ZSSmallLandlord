//
//  ZSMonthlyPaymentsPopView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/13.
//  Copyright © 2018 黄曼文. All rights reserved.
//  计算月供弹窗

#import "ZSBasePopView.h"
#import "ZSMonthlyPaymentsTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSMonthlyPaymentsPopView : ZSBasePopView
- (id)initWithFrame:(CGRect)frame withModel:(ZSMonthlyPaymentsModel *)model;
@end

NS_ASSUME_NONNULL_END
