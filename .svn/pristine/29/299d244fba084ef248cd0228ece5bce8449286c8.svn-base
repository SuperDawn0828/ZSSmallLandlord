//
//  ZSBaseCreatOrderHeaderView.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/8/23.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBaseCreatOrderHeaderView.h"

@implementation ZSBaseCreatOrderHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, ZSWIDTH, viewTopHeight);
    self.lineView.backgroundColor = ZSViewBackgroundColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

//根据不同的产品和当前所在第几个页面展示不同的图片
- (void)setImgViewWithProduct:(NSString *)productName withIndex:(NSInteger)index
{
    //客户信息图片
    self.customerImgView.image   = ImageName(@"list_customer_n");
    //左边箭头
    self.leftArrowImgView.image  = ImageName(@"list_uuide_n");
    //右边箭头
    self.rightArrowImgView.image = ImageName(@"list_uuide_n");
    //贷款信息label
    self.loanLabel.text = @"贷款信息";
    //贷款信息图片
    self.loanImgView.image = [productName isEqualToString:kProduceTypeRedeemFloor] ? ImageName(@"list_makeadvances_n") : ImageName(@"list_loan_n");
    //房产信息label
    self.houseLabel.text = [productName isEqualToString:kProduceTypeCarHire] ? @"车位信息" : @"房产信息";
    //贷款信息图片
    self.houseImgView.image = [productName isEqualToString:kProduceTypeCarHire] ? ImageName(@"list_car_n_") : ImageName(@"list_house_n");
    
    
    
    //1.客户信息
    if (index == ZSCreatOrderStyleCustomer){
        self.customerImgView.image = ImageName(@"list_customer_n_1");
        self.customerLabel.textColor = ZSColorRed;
    }
    //2.贷款信息
    if (index == ZSCreatOrderStyleLoan) {
        self.loanImgView.image = [productName isEqualToString:kProduceTypeRedeemFloor] ? ImageName(@"list_makeadvances_n_1") : ImageName(@"list_loan_n_1");
        self.loanLabel.textColor    = ZSColorRed;
        self.leftArrowImgView.image = ImageName(@"list_uuide_n_1");
    }
    //3.房产信息
    if (index == ZSCreatOrderStyleHouse) {
        self.houseImgView.image = [productName isEqualToString:kProduceTypeCarHire] ? ImageName(@"list_car_n_1_") : ImageName(@"list_house_n_1");
        self.houseLabel.textColor    = ZSColorRed;
        self.leftArrowImgView.image  = ImageName(@"list_uuide_n_1");
        self.rightArrowImgView.image = ImageName(@"list_uuide_n_1");
    }
}

#pragma mark dismiss
- (void)dismiss
{
 [UIView animateWithDuration:0.1 animations:^{
   self.alpha = 0;
   } completion:^(BOOL finished) {
  [self removeFromSuperview];
 }];
}

#pragma mark show
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.alpha = 1;
    }];
}

@end
