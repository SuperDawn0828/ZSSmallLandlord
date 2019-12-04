//
//  ZSBaseCreatOrderHeaderView.h
//  ZSSmallLandlord
//
//  Created by gengping on 2017/8/23.
//  Copyright © 2017年 黄曼文. All rights reserved.
//


typedef NS_ENUM(NSUInteger, ZSCreatOrderStyle) {
    ZSCreatOrderStyleCustomer = 0,//人员信息
    ZSCreatOrderStyleLoan,        //贷款信息
    ZSCreatOrderStyleHouse,       //房产信息
};
#import <UIKit/UIKit.h>

@interface ZSBaseCreatOrderHeaderView : UIView
//客户信息
@property (weak, nonatomic) IBOutlet UIImageView *customerImgView;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
//贷款信息
@property (weak, nonatomic) IBOutlet UIImageView *loanImgView;
@property (weak, nonatomic) IBOutlet UILabel *loanLabel;
//房产信息
@property (weak, nonatomic) IBOutlet UIImageView *houseImgView;
@property (weak, nonatomic) IBOutlet UILabel *
houseLabel;
//左边箭头
@property (weak, nonatomic) IBOutlet UIImageView *leftArrowImgView;
//右边箭头
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;//空格

//根据不同的产品和当前所在第几个页面展示不同的图片
- (void)setImgViewWithProduct:(NSString *)productName withIndex:(NSInteger )index;

#pragma mark dismiss
- (void)dismiss;

#pragma mark show
- (void)show;

@end
