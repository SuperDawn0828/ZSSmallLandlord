//
//  ZSCloseOrderPopView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/18.
//  Copyright © 2018 黄曼文. All rights reserved.
//  关闭订单弹窗

#import "ZSBasePopView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZSCloseOrderPopView;
@protocol ZSCloseOrderPopViewDelegate <NSObject>
@optional
- (void)sendReasonString:(NSString *)reason withRemark:(NSString *)remark;
@end

@interface ZSCloseOrderPopView : ZSBasePopView
@property (weak, nonatomic)id<ZSCloseOrderPopViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
