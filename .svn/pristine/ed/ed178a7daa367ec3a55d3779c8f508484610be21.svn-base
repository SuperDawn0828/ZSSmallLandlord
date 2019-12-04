//
//  ZSHomeCarouselView.h
//
//  Created by lg on 16/7/4.
//  Copyright © 2016年 at. All rights reserved.
//  轮播图

#import <UIKit/UIKit.h>

@class ZSHomeCarouselView;
@protocol ZSHomeCarouselViewDelegate <NSObject>
@optional
/**
 *  点击图片的回调事件
 */
- (void)carouselView:(ZSHomeCarouselView *)carouselView indexOfClickedImageBtn:(NSUInteger)index;
@end

@interface ZSHomeCarouselView : UIView
//传入图片数组
@property (nonatomic, copy  ) NSArray *imagesArray;
//pageControl颜色设置
@property (nonatomic, strong) UIColor *currentPageColor;
@property (nonatomic, strong) UIColor *pageColor;
//是否竖向滚动
@property (nonatomic, assign, getter=isScrollDorectionPortrait) BOOL scrollDorectionPortrait;
//代理
@property (weak, nonatomic) id<ZSHomeCarouselViewDelegate> delegate;
@end
