//
//  ZSAlertView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSAlertView;
@protocol ZSAlertViewDelegate <NSObject>
@optional
- (void)AlertView:(ZSAlertView *)alert;//确认按钮响应的方法
- (void)AlertViewCanCleClick:(ZSAlertView *)alert;//取消按钮响应的方法
@end

@interface ZSAlertView : UIView

@property (weak, nonatomic)id<ZSAlertViewDelegate> delegate;

#pragma mark 一个按钮
- (instancetype)initWithFrame:(CGRect)frame withNotice:(NSString *)notice btnTitle:(NSString *)btnTitle;
#pragma mark 两个按钮,左侧确定,右侧取消
- (instancetype)initWithFrame:(CGRect)frame withNotice:(NSString *)notice sureTitle:(NSString *)sureTitle cancelTitle:(NSString *)cancelTitle;
#pragma mark 两个按钮,左侧取消,右侧确定
- (instancetype)initWithFrame:(CGRect)frame withNotice:(NSString *)notice cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle;
#pragma mark 两个按钮,左侧取消,右侧确定(两个按钮颜色一样)
- (instancetype)initWithFrame:(CGRect)frame withNotice:(NSString *)notice;
#pragma mark 视图展现
- (void)show;

@end
