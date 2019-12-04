//
//  ZSGridView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/30.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具--报表列表--报表详情cell--view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSGridView : UIView

@property(nonatomic,strong)UILabel  *nameLabel;
@property(nonatomic,strong)NSString *showString;
@property(nonatomic,strong)NSIndexPath *indxPath;

@end

NS_ASSUME_NONNULL_END
