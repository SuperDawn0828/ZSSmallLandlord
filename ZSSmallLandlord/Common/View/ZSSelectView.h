//
//  ZSSelectView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/22.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  列表数据权限选择view

#import <UIKit/UIKit.h>

@class ZSSelectView;
@protocol ZSSelectViewDelegate <NSObject>
@optional
- (void)currentSelectIndex:(NSInteger)index currentSelectTitle:(NSString*)string withSecectView:(ZSSelectView *)alert;
- (void)changeImage;
@end

@interface ZSSelectView : UIView

@property (weak, nonatomic)id<ZSSelectViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)titleArray withCurrentIndex:(NSInteger)currentIndex;
- (void)show:(NSInteger)count;//视图展现

@end
