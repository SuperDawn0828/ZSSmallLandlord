//
//  ZSOrderDetailHeaderView.h
//  ZSSmallLandlord
//
//  Created by gengping on 2017/8/7.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  金融产品订单详情headerView

#import <UIKit/UIKit.h>

@protocol ZSOrderDetailHeaderViewDelegate <NSObject>

@optional
- (void)phoneCallBtnClick;//拨打电话
- (void)rushBtnClick;//催办
@end

@interface ZSOrderDetailHeaderView : UIView
@property (strong, nonatomic)  UIImageView *headerImView;
@property (strong, nonatomic)  UILabel     *stateLabel;
@property (strong, nonatomic)  UILabel     *nameLabel;
@property (strong, nonatomic)  UIButton    *phoneCallBtn;
@property (strong, nonatomic)  UIButton    *rushBtn;
@property (nonatomic,weak   )  id<ZSOrderDetailHeaderViewDelegate> delegate;
@end
