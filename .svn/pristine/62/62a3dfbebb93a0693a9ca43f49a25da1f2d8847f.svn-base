//
//  ZSTextWithPhotosTableViewCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/17.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  首页--金融产品--资料收集--资料动态列表--添加照片页面

#import "ZSBaseTableViewCell.h"

#define photoWidth (ZSWIDTH-50)/4

@class ZSTextWithPhotosTableViewCell;
@protocol ZSTextWithPhotosTableViewCellDelegate <NSObject>
@optional
//当前cell的高度
- (void)sendCurrentCellHeight:(CGFloat)collectionHeight withIndex:(NSUInteger)currentIndex;
//本地图片数组(已经选择完毕,但是未上传完)
- (void)sendImageArrayData:(NSArray *)imageDataArray WithIndex:(NSUInteger)currentIndex;
//已上传的照片
- (void)sendProcessOfPhototWithData:(NSString *)string WithIndex:(NSUInteger)currentIndex;//其他资料用
//图片有增删或修改,都需要请求网络
- (void)checkPhototCellChangeState:(BOOL)isChange;
//判断是否有图片上传失败
- (void)sendPictureUploadingFailureWithIndex:(BOOL)isFailure;
@end

@interface ZSTextWithPhotosTableViewCell : ZSBaseTableViewCell
@property(nonatomic,strong)ZSDynamicDataModel                        *model;
@property(nonatomic,assign)NSUInteger                                currentIndex;     //当前cell所在的indexPath,用于操作后数据传值
@property(nonatomic,weak  )id<ZSTextWithPhotosTableViewCellDelegate> delegate;
@property(nonatomic,assign)BOOL                                      isShowAdd;        //是否显示加号
@property(nonatomic,strong)NSArray                                   *imageDataArray;  //本地图片数组
@end
