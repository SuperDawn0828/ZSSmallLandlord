//
//  ZSOrderDetailHeaderView.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/8/7.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSOrderDetailHeaderView.h"

@implementation ZSOrderDetailHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    self.backgroundColor = ZSColorRed;
    
    //图标
    self.headerImView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 20, 20)];
    [self addSubview:self.headerImView];

    //节点状态
    self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.headerImView.right+15, 8, 200, 20)];
    self.stateLabel.textColor = ZSColorWhite;
    self.stateLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.stateLabel];

    //订单创建人显示当前节点处理人, 其余显示订单创建人
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.headerImView.right+15, 30, ZSWIDTH-70, 20)];
    self.nameLabel.textColor = ZSColorWhite;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.nameLabel];
    
    //打电话按钮
    self.phoneCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneCallBtn.frame = CGRectMake(self.headerImView.right+15, 55, 85, 25);
//    [self.phoneCallBtn setTitle:@"联系操作人" forState:UIControlStateNormal];
    self.phoneCallBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.phoneCallBtn.layer.cornerRadius = 3;
    self.phoneCallBtn.layer.masksToBounds = YES;
    self.phoneCallBtn.layer.borderWidth = 0.5;
    self.phoneCallBtn.layer.borderColor = ZSColorWhite.CGColor;
    [self.phoneCallBtn addTarget:self action:@selector(phoneCallClick:) forControlEvents:UIControlEventTouchUpInside];
    self.phoneCallBtn.tag = 1;
    self.phoneCallBtn.hidden = YES;
    [self addSubview:self.phoneCallBtn];
    
    //催办按钮
    self.rushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rushBtn.frame = CGRectMake(self.phoneCallBtn.right+10, 55, 85, 25);
    [self.rushBtn setTitle:@"催办" forState:UIControlStateNormal];
    self.rushBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rushBtn.layer.cornerRadius = 3;
    self.rushBtn.layer.masksToBounds = YES;
    self.rushBtn.layer.borderWidth = 0.5;
    self.rushBtn.layer.borderColor = ZSColorWhite.CGColor;
    [self.rushBtn addTarget:self action:@selector(phoneCallClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rushBtn.tag = 2;
    self.rushBtn.hidden = YES;
    [self addSubview:self.rushBtn];
}

- (void)phoneCallClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(phoneCallBtnClick)]) {
            [_delegate phoneCallBtnClick];
        }
    }
    else {
        if (_delegate && [_delegate respondsToSelector:@selector(rushBtnClick)]) {
            [_delegate rushBtnClick];
        }
    }
}

@end
