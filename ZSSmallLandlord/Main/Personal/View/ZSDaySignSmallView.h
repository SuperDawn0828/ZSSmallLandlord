//
//  ZSDaySignSmallView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/2.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *normalString = @"欢迎查看我的今日幸运签";
static NSString *hilightString = @"释放查看日签";

NS_ASSUME_NONNULL_BEGIN

@interface ZSDaySignSmallView : UIView

@property(nonatomic,strong)UILabel *noticeLabel;//提示语

@end

NS_ASSUME_NONNULL_END
