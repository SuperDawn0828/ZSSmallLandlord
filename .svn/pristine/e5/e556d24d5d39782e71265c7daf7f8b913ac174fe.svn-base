//
//  ZSCreditReportsPopView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/7/17.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  预授信报告弹窗

#import "ZSBasePopView.h"
#import "ZSCreditReportModel.h"
#import "ZSSendOrderPersonModel.h"

@class ZSCreditReportsPopView;
@protocol ZSCreditReportsPopViewDelegate <NSObject>
@optional
- (void)sendData:(ZSCreditReportModel *)model;
@end

@interface ZSCreditReportsPopView : ZSBasePopView
@property (nonatomic,strong) NSArray<ZSSendOrderPersonModel *> *sendPersonArray;   //专属客户经理列表
@property (nonatomic,strong) NSArray<ZSBanklistModel *>        *bankDataArray;     //预授信贷款银行列表
@property (weak, nonatomic)id<ZSCreditReportsPopViewDelegate>  delegate;
- (id)initWithFrame:(CGRect)frame withType:(BOOL)isLoanable;
@end
