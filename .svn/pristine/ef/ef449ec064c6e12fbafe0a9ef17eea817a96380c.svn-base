//
//  ZSCloseOrderPopView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/18.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSCloseOrderPopView.h"

@interface ZSCloseOrderPopView ()<ZSAlertViewDelegate>
@property (nonatomic,copy  )NSString     *reasonType;//关闭原因 11退单 12填错了 13其他
@end

@implementation ZSCloseOrderPopView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //UI
        [self configureViews];
        [self creatBaseUI];
    }
    return self;
}

#pragma mark /*------------------------------------------------黑底白底----------------------------------------------------*/
- (void)creatBaseUI
{
    //关闭订单
    self.titleLabel.text = @"关闭订单";

    //关闭原因
    UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, self.titleLabel.bottom, 100, CellHeight)];
    reasonLabel.font = [UIFont systemFontOfSize:14];
    reasonLabel.textColor = ZSColorBlack;
    reasonLabel.attributedText = [[NSString stringWithFormat:@"%@",@"关闭原因"] addStar];
    [self.whiteBackgroundView addSubview:reasonLabel];
    
    //关闭原因按钮
    NSArray *arrayName = @[@"退单",@"录错了",@"其他"];
    for (int i = 0 ; i < arrayName.count; i++)
    {
        UIButton *loanableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loanableBtn.frame = CGRectMake(GapWidth + (100+GapWidth)*i, reasonLabel.bottom, 100, 30);
        [loanableBtn setTitle:arrayName[i] forState:UIControlStateNormal];
        loanableBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [loanableBtn addTarget:self action:@selector(loanableBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [loanableBtn setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
        [loanableBtn setTitleColor:ZSColorWhite forState:UIControlStateSelected];
        [loanableBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorWhite] forState:UIControlStateNormal];
        [loanableBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forState:UIControlStateSelected];
        loanableBtn.layer.borderWidth = 0.5;
        loanableBtn.layer.borderColor = ZSColorAllNotice.CGColor;
        loanableBtn.layer.masksToBounds = YES;
        loanableBtn.layer.cornerRadius = 15;
        loanableBtn.tag = i+100;
        [self.whiteBackgroundView addSubview:loanableBtn];
        if (i == 0)
        {
            loanableBtn.selected = YES;
            loanableBtn.layer.borderColor = ZSColorRed.CGColor;
            self.reasonType = @"11";
        }
    }
    
    //输入框
    [self configureInputViewWithFrame:CGRectMake(0, reasonLabel.bottom+40, ZSWIDTH, self.whiteBackgroundView.height) withString:@"备注"];
    
    //提交按钮
    [self configureSubmitBtn:@"确认关闭"];
}

- (void)loanableBtnAction:(UIButton *)sender
{
    if (sender.tag == 100) {
        self.reasonType = @"11";
    }
    else if (sender.tag == 100 + 1) {
        self.reasonType = @"12";
    }
    else {
        self.reasonType = @"13";
    }
    
    if (sender.selected == YES) {
        return;
    }
    
    for (int i = 0 ; i < 3; i++)
    {
        if (sender.tag == i+100) {
            sender.selected = YES;
            sender.layer.borderColor = ZSColorRed.CGColor;
            continue;
        }
        UIButton *btn = (UIButton *)[self.whiteBackgroundView viewWithTag:i+100];
        btn.selected = NO;
        btn.layer.borderColor = ZSColorAllNotice.CGColor;
    }
}

#pragma mark /*-----------------------------------------------提交---------------------------------------------------*/
- (void)submitBtnAction
{
    ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"关闭订单后，该订单将不可进行任何操作，是否确认关闭订单？" sureTitle:@"确定" cancelTitle:@"取消"];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark ZSAlertViewDelegate
- (void)AlertView:(ZSAlertView *)alert
{
    //关闭订单
    [self dismiss];
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendReasonString:withRemark:)])
    {
        if (self.inputTextView.text.length)
        {
            [_delegate sendReasonString:self.reasonType withRemark:self.inputTextView.text];
        }
        else
        {
            [_delegate sendReasonString:self.reasonType withRemark:@""];
        }
    }
}

@end
