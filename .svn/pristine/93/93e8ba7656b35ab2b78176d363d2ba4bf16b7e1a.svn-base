//
//  ZSHomeHeaderView.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//  首页--headerView

#import <UIKit/UIKit.h>
#import "ZSHomeCarouselModel.h"

@class ZSHomeHeaderView;
@protocol ZSHomeHeaderViewDelegate <NSObject>
@optional
- (void)indexOfClickedImageBtn:(NSUInteger)index;//点击轮播图
- (void)indexOfClickedToolsBtn:(NSString *)prdTypeString;//点击小工具
@end

@interface ZSHomeHeaderView : UIView

@property (weak, nonatomic) id<ZSHomeHeaderViewDelegate> delegate;

#pragma mark 轮播图
- (void)fillInCarouselViewData:(NSArray *)array;

#pragma mark 提示label
- (void)configureNoticeLabel;

#pragma mark 设置自己的高度
- (void)resetSelfHeight;

@end
