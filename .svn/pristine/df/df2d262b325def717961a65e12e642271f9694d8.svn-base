//
//  ZSApprovalOpinionPopView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/8/21.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSApprovalOpinionPopView.h"
#import "ZSInputOrSelectView.h"
#import "ZSOrderNodePopView.h"

@interface ZSApprovalOpinionPopView  ()<UITextViewDelegate,ZSInputOrSelectViewDelegate,ZSOrderNodePopViewDelegate>
@property (nonatomic,strong)ZSInputOrSelectView                 *againstView;  //驳回至节点
@property (nonatomic,strong)NSArray<ZSSLOrderRejectNodeModel *> *rejectArray;  //驳回至节点的节点列表
@property (nonatomic,strong)NSString                            *rejectNodeID; //驳回至节点的节点ID
@end

@implementation ZSApprovalOpinionPopView

- (id)initWithFrame:(CGRect)frame withType:(BOOL)isAccept withArray:(NSArray<ZSSLOrderRejectNodeModel *> *)rejectArray;
{
    if (self = [super initWithFrame:frame])
    {
        //UI
        [self configureViews];
        [self creatBaseUI:isAccept];
        //显隐
        [self showLoanableView:isAccept];
        //Data
        self.rejectArray = rejectArray;
    }
    return self;
}

#pragma mark /*------------------------------------------------黑底白底----------------------------------------------------*/
- (void)creatBaseUI:(BOOL)isLoanable
{
    //审批
    self.titleLabel.text = @"审批";
    
    //贷款按钮
    NSArray *arrayName = @[@"通过",@"驳回"];
    for (int i = 0 ; i < arrayName.count; i++)
    {
        UIButton *opoinionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        opoinionBtn.frame = CGRectMake(GapWidth + (100+GapWidth)*i, self.titleLabel.bottom+10, 100, 30);
        [opoinionBtn setTitle:arrayName[i] forState:UIControlStateNormal];
        opoinionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [opoinionBtn addTarget:self action:@selector(opoinionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [opoinionBtn setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
        [opoinionBtn setTitleColor:ZSColorWhite forState:UIControlStateSelected];
        [opoinionBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorWhite] forState:UIControlStateNormal];
        [opoinionBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forState:UIControlStateSelected];
        opoinionBtn.layer.borderWidth = 0.5;
        opoinionBtn.layer.borderColor = ZSColorAllNotice.CGColor;
        opoinionBtn.layer.masksToBounds = YES;
        opoinionBtn.layer.cornerRadius = 15;
        opoinionBtn.tag = i+100;
        [self.whiteBackgroundView addSubview:opoinionBtn];
        if (isLoanable) {
            if (i == 0) {
                opoinionBtn.selected = YES;
                opoinionBtn.layer.borderColor = ZSColorRed.CGColor;
            }
        }
        else{
            if (i == 1) {
                opoinionBtn.selected = YES;
                opoinionBtn.layer.borderColor = ZSColorRed.CGColor;
            }
        }
    }
    
    //驳回至
    self.againstView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom + 50, ZSWIDTH, CellHeight) withClickAction:@"驳回至"];
    self.againstView.delegate = self;
    [self.whiteBackgroundView addSubview:self.againstView];
    
    //输入框
    [self configureInputViewWithFrame:CGRectMake(0, self.againstView.bottom, ZSWIDTH, self.whiteBackgroundView.height) withString:@"备注"];

    //提交按钮
    [self configureSubmitBtn:@"提交审批"];
}

- (void)opoinionBtnAction:(UIButton *)sender
{
    //页面
    if (sender.tag == 100) {
        [self showLoanableView:YES];
    }
    else{
        [self showLoanableView:NO];
    }
    
    //按钮
    if (sender.selected == YES) {
        return;
    }
    
    for (int i = 0 ; i < 2; i++)
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

#pragma mark ZSInputOrSelectViewDelegate 驳回的节点列表
- (void)clickBtnAction:(ZSInputOrSelectView *)view;
{
    if (self.rejectArray.count == 0) {
        [ZSTool showMessage:@"暂无可驳回的节点" withDuration:DefaultDuration];
        return;
    }
    ZSOrderNodePopView *approvalView = [[ZSOrderNodePopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:self.rejectArray];
    approvalView.delegate = self;
    [approvalView show];
}

#pragma mark ZSOrderNodePopViewDelegate 选中需要驳回的节点
- (void)sendData:(ZSSLOrderRejectNodeModel *)model;
{
    self.againstView.rightLabel.text = model.nodeName;
    self.againstView.rightLabel.textColor = ZSColorListRight;
    self.rejectNodeID = model.tid;
}

#pragma mark /*-----------------------------------------------提交---------------------------------------------------*/
- (void)submitBtnAction
{
    [self dismiss];

    //通过/驳回
    NSString *acceptState = self.againstView.hidden == YES ? @"1" : @"0";
    
    //驳回至节点
    NSString *rejectNodeID = self.rejectNodeID ? self.rejectNodeID : @"";
    
    //备注
    NSString *remarkString = self.inputTextView.text.length > 0 ? self.inputTextView.text : @"";
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendAcceptState:withNodeID:withRemarkString:)]){
        [_delegate sendAcceptState:acceptState withNodeID:rejectNodeID withRemarkString:remarkString];
    }
}

#pragma mark /*-------------------------------------------------显隐-----------------------------------------------------*/
#pragma mark 可贷view显隐
- (void)showLoanableView:(BOOL)isAccept
{
    if (isAccept)
    {
        self.againstView.hidden = YES;
        self.againstView.height = 0;
        self.inputBgScroll.top = self.againstView.bottom + 10;
    }
    else
    {
        self.againstView.hidden = NO;
        self.againstView.height = CellHeight;
        self.inputBgScroll.top = self.againstView.bottom + 10;
    }
}

@end
