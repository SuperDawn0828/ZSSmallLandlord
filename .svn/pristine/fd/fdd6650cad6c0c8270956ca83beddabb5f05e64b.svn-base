//
//  ZSSingleLineTextTableViewCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/15.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  首页--金融产品--资料收集--资料动态列表--单行文本

#import "ZSBaseTableViewCell.h"
#import "ZSInputOrSelectView.h"

@class ZSSingleLineTextTableViewCell;
@protocol ZSSingleLineTextTableViewCellDelegate <NSObject>
@optional
- (void)sendCurrentCellData:(NSString *)string withIndex:(NSUInteger)currentIndex;//传递输入框的值或者"请选择"按钮选择成功以后的值
@end

@interface ZSSingleLineTextTableViewCell : ZSBaseTableViewCell<ZSInputOrSelectViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)ZSInputOrSelectView                       *inputView;
@property(nonatomic,strong)ZSDynamicDataModel                        *model;
@property(nonatomic,assign)NSUInteger                                currentIndex; //当前cell所在的indexPath,用于操作后数据传值
@property(nonatomic,weak  )id<ZSSingleLineTextTableViewCellDelegate> delegate;
@property(nonatomic,assign)BOOL                                      isShowAdd;    //是否显示加号

@end
