//
//  ZSVersionUpdateView.h
//  ZSYuegeche
//
//  Created by 武 on 2017/7/5.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSVersionUpdateView;
@protocol ZSVersionUpdateViewDelegate <NSObject>
@optional
- (void)sureClick:(ZSVersionUpdateView *)updateView;//确认按钮响应的方法
@end

@interface ZSVersionUpdateView : UIView
@property (weak, nonatomic)id<ZSVersionUpdateViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withVersion:(NSString *)version withNotice:(NSString *)notice withNoticeHeight:(CGFloat)height withForced:(BOOL)isForced;//非强制更新
- (void)show;//视图展现
@end
