//
//  ZSHomeTableCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  签约员首页/银行外勤首页--tableCell

#import "ZSBaseCardTableViewCell.h"

@class ZSHomeTableCell;
@protocol ZSHomeTableCellDelegate <NSObject>
@optional
- (void)sendData:(ZSAllListModel *)model withIndex:(NSUInteger)currentIndex withType:(BOOL)isAdd;//isAdd为YES则是添加
@end

@interface ZSHomeTableCell : ZSBaseCardTableViewCell
@property (nonatomic,strong) ZSAllListModel *model;
@property (nonatomic,assign) NSUInteger     currentIndex; //当前cell所在的indexPath,用于操作后数据传值
@property (nonatomic,weak  )id<ZSHomeTableCellDelegate> delegate;
@end
