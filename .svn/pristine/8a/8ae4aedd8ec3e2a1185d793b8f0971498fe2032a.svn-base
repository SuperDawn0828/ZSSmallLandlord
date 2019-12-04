//
//  ZSApprovalOpinionPopView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/8/21.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  审批意见弹窗

#import "ZSBasePopView.h"
#import "ZSSLOrderRejectNodeModel.h"

@class ZSApprovalOpinionPopView;
@protocol ZSApprovalOpinionPopViewDelegate <NSObject>
@optional
- (void)sendAcceptState:(NSString *)isAccept withNodeID:(NSString *)nodeID withRemarkString:(NSString *)remark;
@end

@interface ZSApprovalOpinionPopView : ZSBasePopView
@property (weak, nonatomic)id<ZSApprovalOpinionPopViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withType:(BOOL)isAccept withArray:(NSArray<ZSSLOrderRejectNodeModel *> *)rejectArray;
@end
