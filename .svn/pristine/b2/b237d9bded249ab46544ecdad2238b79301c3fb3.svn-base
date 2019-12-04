//
//  ZSMoreLineTextTableViewCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/17.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  首页--金融产品--资料收集--资料动态列表--多行文本

#import "ZSBaseTableViewCell.h"

@class ZSMoreLineTextTableViewCell;
@protocol ZSMoreLineTextTableViewCellDelegate <NSObject>
@optional
- (void)sendCurrentCellData:(NSString *)string
                  withIndex:(NSUInteger)currentIndex
                 withHeight:(CGFloat)textHeight;//传递输入框的值或者和值得高度
@end

@interface ZSMoreLineTextTableViewCell : ZSBaseTableViewCell

@property(nonatomic,strong)ZSDynamicDataModel                        *model;
@property(nonatomic,assign)NSUInteger                                currentIndex; //当前cell所在的indexPath,用于操作后数据传值
@property(nonatomic,weak  )id<ZSMoreLineTextTableViewCellDelegate>   delegate;
@property(nonatomic,assign)BOOL                                      isShowAdd;    //是否显示加号

@end
