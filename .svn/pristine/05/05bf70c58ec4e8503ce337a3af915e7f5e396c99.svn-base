//
//  ZSTextWithPhotosTableViewCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/17.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  首页--预授信报告--订单列表--列表--订单详情--照片cell

#import "ZSBaseTableViewCell.h"

static NSString *TextWithPhotosCellIdentifier = @"ZSTextWithPhotosTableViewCell";

#define photoWidth (ZSWIDTH-50)/4

@class ZSPCOrderDetailPhotoCell;
@protocol ZSTextWithPhotosTableViewCellDelegate <NSObject>
@optional
//当前cell的高度
- (void)sendCurrentCellHeight:(CGFloat)collectionHeight withIndex:(NSUInteger)currentIndex;
@end

@interface ZSPCOrderDetailPhotoCell : ZSBaseTableViewCell
@property(nonatomic,strong)ZSDynamicDataModel                        *model;
@property(nonatomic,assign)NSUInteger                                currentIndex;     //当前cell所在的indexPath,用于操作后数据传值
@property(nonatomic,weak  )id<ZSTextWithPhotosTableViewCellDelegate> delegate;
@property(nonatomic,assign)BOOL                                      isShowAdd;        //是否显示加号
@property(nonatomic,strong)NSArray                                   *imageDataArray;  //本地图片数组
@end
