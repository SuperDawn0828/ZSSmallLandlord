//
//  ZSNotificationDetailView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/8/21.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  通知详情弹窗

#import <UIKit/UIKit.h>

@class ZSNotificationDetailView;
@protocol ZSNotificationDetailViewDelegate <NSObject>
@optional
- (void)sureClick:(ZSNotificationDetailView *)noticeView;
@end

@interface ZSNotificationDetailView : UIView

@property (nonatomic,weak  )id <ZSNotificationDetailViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                    withTitle:(NSString *)titleSting
                  withContent:(NSString *)contentSting
             withLeftBtnTitle:(NSString *)leftBtnTitle
            withRightBtnTitle:(NSString *)rightBtnTitle;

- (void)show;

@end
