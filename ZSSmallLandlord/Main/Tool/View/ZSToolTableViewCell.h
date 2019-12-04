//
//  ZSToolTableViewCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/23.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具cell

#import "ZSBaseTableViewCell.h"
#import "ZSToolModel.h"
#import "ZSToolButton.h"

static CGFloat const  KZZSToolTableViewCellHeight = 110;

NS_ASSUME_NONNULL_BEGIN

@protocol ZSToolTableViewCellDelegate <NSObject>
@optional
- (void)selectCurrentTool:(ToolDatamodel *)model;
@end

@interface ZSToolTableViewCell : ZSBaseTableViewCell
@property (weak, nonatomic)id<ZSToolTableViewCellDelegate> delegate;
@property (nonatomic,strong) ZSToolModel *model;
@end

NS_ASSUME_NONNULL_END
