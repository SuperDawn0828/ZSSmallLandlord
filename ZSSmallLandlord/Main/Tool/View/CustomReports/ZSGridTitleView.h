//
//  ZSGridTitleView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/30.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具--报表列表--报表详情--sectionTitleView

#import <UIKit/UIKit.h>
#import "ZSCustomReportSettingModel.h"

@class ZSGridTitleView;
@protocol ZSGridTitleViewDelegate <NSObject>
@optional
- (void)reOrderWithType:(NSString *)upOrDown withModel:(ZSCustomReportSettingModel *)model;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ZSGridTitleView : UIView

@property(nonatomic,strong)UILabel     *nameLabel;
@property(nonatomic,strong)UIImageView *rightImage;
@property(nonatomic,strong)ZSCustomReportSettingModel *model;
@property (weak, nonatomic)id<ZSGridTitleViewDelegate> delegate;

- (void)showRightImage:(BOOL)isShow withModel:(ZSCustomReportSettingModel *)model;

@end

NS_ASSUME_NONNULL_END
