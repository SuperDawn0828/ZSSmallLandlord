//
//  ZSSendOrderPopView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/7/17.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  派单弹窗

#import "ZSBasePopView.h"
#import "ZSSendOrderPersonModel.h"

@class ZSSendOrderPopView;
@protocol ZSSendOrderPopViewDelegate <NSObject>
@optional
- (void)selectWithData:(ZSSendOrderPersonModel *)model;
@end

@interface ZSSendOrderPopView : ZSBasePopView
@property (weak, nonatomic)id<ZSSendOrderPopViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)array;
@end
