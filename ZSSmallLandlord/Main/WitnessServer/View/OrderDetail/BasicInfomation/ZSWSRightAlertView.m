//
//  ZSWSRightAlertView.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSRightAlertView.h"

@interface ZSWSRightAlertView ()
@property (nonatomic,strong)UIView       *blackBackgroundView;
@property (nonatomic,strong)UIView       *whiteBackgroundView;
@property (nonatomic,strong)UIImageView  *whiteBackgroundImage;
@end

@implementation ZSWSRightAlertView

- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)titlesArray
{
    if (self = [super initWithFrame:frame])
    {
        //UI
        [self configureViewsWithArray:titlesArray];
    }
    return self;
}

#pragma mark /*------------------------------------------------黑底白底----------------------------------------------------*/
- (void)configureViewsWithArray:(NSArray *)titlesArray
{
    //黑底
    self.blackBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    self.blackBackgroundView.backgroundColor = ZSColorBlack;
    self.blackBackgroundView.alpha = 0;
    [self addSubview:self.blackBackgroundView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.blackBackgroundView addGestureRecognizer:tap];
    
    //白色尖角图片
    self.whiteBackgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-18-22, kNavigationBarHeight+6, 18, 18)];
    self.whiteBackgroundImage.image = [UIImage imageNamed:@"list_moreshells_n"];
    self.whiteBackgroundImage.alpha = 0;
    [self addSubview:self.whiteBackgroundImage];
    
    //白底
    self.whiteBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(ZSWIDTH-120-10, self.whiteBackgroundImage.bottom, 120, CellHeight * titlesArray.count)];
    self.whiteBackgroundView.backgroundColor = ZSColorWhite;
    self.whiteBackgroundView.layer.cornerRadius = 3;
    self.whiteBackgroundView.alpha = 0;
    [self addSubview:self.whiteBackgroundView];
    
    //按钮
    for (int i = 0; i < titlesArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, CellHeight * i, 120, CellHeight);
        [button setTitle:titlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:ZSColorListLeft forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteBackgroundView addSubview:button];
        //设置按钮tag
        //征信重查
        if ([titlesArray[i] isEqual:KCreditBtnTitle])
        {
            button.tag = ZSCreditBtnTag;
        }
        //添加备注
        else if ([titlesArray[i] isEqual:KAddrRemarkBtnTitle])
        {
            button.tag = ZSAddrRemarkBtnTag;
        }
        //撤回订单
        else if ([titlesArray[i] isEqual:KWithdrawBtnTitle])
        {
            button.tag = ZSWithdrawBtnTag;
        }
        //关闭订单
        else if ([titlesArray[i] isEqual:KCloseBtnTitle])
        {
            button.tag = ZSCloseBtnTag;
        }
        //删除订单
        else if ([titlesArray[i] isEqual:KDeleteBtnTitle])
        {
            button.tag = ZSDeleteBtnTag;
        }
        //完成订单
        else if ([titlesArray[i] isEqual:KCompleteBtnTitle])
        {
            button.tag = ZSCompleteBtnTag;
        }
        //创建赎楼宝
        else if ([titlesArray[i] isEqualToString:KCreateRedeenFloorBtnTitle])
        {
            button.tag = ZSCreateRedeenFloorBtnTag;
        }
        //创建星速贷
        else if ([titlesArray[i] isEqualToString:KCreateStarLoanBtnTitle])
        {
            button.tag = ZSCreateStarLoanBtnTag;
        }
        //创建抵押贷
        else if ([titlesArray[i] isEqualToString:KCreateMortgageLoanTitle])
        {
            button.tag = ZSCreateMortgageLoanTag;
        }
        //相关订单
        else if ([titlesArray[i] isEqualToString:KRelatedOrderBtnTitle])
        {
            button.tag = ZSRelatedOrderBtnTag;
        }
    }
    
    //按钮之间的分割线
    for (int i = 1; i < titlesArray.count; i++)
    {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight * i, 120, 0.5)];
        lineView.backgroundColor = ZSColorLine;
        [self.whiteBackgroundView addSubview:lineView];
    }
    
}

- (void)selectBtnClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectBtnClick:)]){
        [_delegate didSelectBtnClick:sender.tag];
    }
    [self dismiss];
}

#pragma mark /*-------------------------------------------------显隐-----------------------------------------------------*/
#pragma mark 显示自己
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.blackBackgroundView.alpha = 0.5;
        self.whiteBackgroundView.alpha = 1;
        self.whiteBackgroundImage.alpha = 1;
    }];
}

#pragma mark 移除自己
- (void)dismiss
{
    [self removeFromSuperview];
}

@end
