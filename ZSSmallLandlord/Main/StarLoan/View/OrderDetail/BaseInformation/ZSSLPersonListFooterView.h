//
//  ZSSLPersonListFooterView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/8/7.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  星速贷--订单详情--人员列表--客户来源view

#import <UIKit/UIKit.h>

@protocol ZSSLPersonListFooterViewDelegate <NSObject>
@optional
- (void)goToChangeAgency;//如果是中介或线下客户可以进行修改
@end

@interface ZSSLPersonListFooterView : UIView

@property (weak, nonatomic)id<ZSSLPersonListFooterViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
             withMOrderSource:(NSString *)source        //客户来源 1中介 2线下 3微信 4官网 5中介APP
            withAgencyContact:(NSString *)contactName
       withAgencyContactPhone:(NSString *)contactPhone;

@end
