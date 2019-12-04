//
//  ZSAddRemarkPopView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/8/24.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSAddRemarkPopView.h"

@interface ZSAddRemarkPopView ()

@end

@implementation ZSAddRemarkPopView

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
    //新增备注
    self.titleLabel.text = @"新增备注";
    
    //输入框
    [self configureInputViewWithFrame:CGRectMake(0, self.titleLabel.bottom, ZSWIDTH, self.whiteBackgroundView.height) withString:@""];
    
    //提交按钮
    [self configureSubmitBtn:@"保存"];
}

#pragma mark /*-----------------------------------------------提交---------------------------------------------------*/
- (void)submitBtnAction
{
    if (self.inputTextView.text.length == 0) {
        [ZSTool showMessage:@"请输入备注内容" withDuration:DefaultDuration];
        return;
    }
    
    [self dismiss];

    if (_delegate && [_delegate respondsToSelector:@selector(sendData:)]){
        [_delegate sendData:self.inputTextView.text];
    }
}


@end
