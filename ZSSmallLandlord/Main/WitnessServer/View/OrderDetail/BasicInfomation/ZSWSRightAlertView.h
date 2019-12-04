//
//  ZSWSRightAlertView.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark 按钮的tag值
typedef NS_ENUM(NSUInteger, ZSButtonTag)
{
    ZSCreditBtnTag = 101,     //征信重查
    ZSAddrRemarkBtnTag = 105, //添加备注
    ZSWithdrawBtnTag = 104,   //撤回订单
    ZSCloseBtnTag = 102,      //关闭订单
    ZSDeleteBtnTag = 106,     //删除订单
    ZSCompleteBtnTag = 103,   //完成订单
    ZSCreateRedeenFloorBtnTag = 110,   //创建赎楼宝
    ZSCreateStarLoanBtnTag = 111,   //创建星速贷
    ZSCreateMortgageLoanTag = 112,   //创建抵押贷
    ZSRelatedOrderBtnTag = 118,   //相关订单
};

#pragma mark 默认提示
static NSString *KCreditBtnTitle = @"征信重查";
static NSString *KAddrRemarkBtnTitle = @"添加备注";
static NSString *KWithdrawBtnTitle = @"撤回订单";
static NSString *KCloseBtnTitle = @"关闭订单";
static NSString *KDeleteBtnTitle = @"删除订单";
static NSString *KCompleteBtnTitle = @"完成订单";
static NSString *KCreateRedeenFloorBtnTitle = @"创建赎楼宝";
static NSString *KCreateStarLoanBtnTitle = @"创建星速贷";
static NSString *KCreateMortgageLoanTitle = @"创建抵押贷";
static NSString *KRelatedOrderBtnTitle = @"相关订单";

@protocol ZSWSRightAlertViewDelegate <NSObject>
- (void)didSelectBtnClick:(NSInteger)tag;//选中的方法
@end

@interface ZSWSRightAlertView : UIView
@property (nonatomic,weak) id <ZSWSRightAlertViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)titlesArray;
- (void)show;//视图展示
- (void)dismiss;//视图消失
@end
