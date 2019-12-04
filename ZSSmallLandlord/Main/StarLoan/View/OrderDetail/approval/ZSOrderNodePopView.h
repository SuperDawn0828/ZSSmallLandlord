//
//  ZSOrderNodePopView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/8/21.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  审批驳回至某个节点弹窗

#import "ZSBasePopView.h"
#import "ZSOrderNodeTableViewCell.h"

@class ZSOrderNodePopView;
@protocol ZSOrderNodePopViewDelegate <NSObject>
@optional
- (void)sendData:(ZSSLOrderRejectNodeModel *)model;
@end

@interface ZSOrderNodePopView : ZSBasePopView
@property (weak, nonatomic)id<ZSOrderNodePopViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withArray:(NSArray<ZSSLOrderRejectNodeModel *> *)rejectArray;
@end
