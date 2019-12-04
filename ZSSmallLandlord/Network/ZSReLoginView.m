//
//  ZSReLoginView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/8/24.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSReLoginView.h"

@interface ZSReLoginView  ()
@property (nonatomic,strong)UIView *backgroundView_black;
@property (nonatomic,strong)UIView *backgroundView_white;
@end


@implementation ZSReLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //黑底
        self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        self.backgroundView_black.backgroundColor = ZSColorBlack;
        self.backgroundView_black.alpha = 0;
        [self addSubview:self.backgroundView_black];
        
        //白底
        self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(53, (ZSHEIGHT-186)/2, ZSWIDTH-53*2, 98+CellHeight*2)];
        self.backgroundView_white.backgroundColor = ZSColorWhite;
        self.backgroundView_white.layer.cornerRadius = 4;
        self.backgroundView_white.alpha = 0;
        [self addSubview:self.backgroundView_white];
        
        //title
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0,0,self.backgroundView_white.width,CellHeight)];
        title.font = [UIFont boldSystemFontOfSize:15];
        title.textColor = UIColorFromRGB(0x4F4F4F);
        title.text = @"登录提醒";
        title.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView_white addSubview:title];
        
        //line_top
        UIView *lineView_top = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight, self.backgroundView_white.width, 0.5)];
        lineView_top.backgroundColor = ZSColorLine;
        [self.backgroundView_white addSubview:lineView_top];
        
        //显示详情的label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15,lineView_top.bottom,self.backgroundView_white.width-30,98)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColorFromRGB(0x666666);
        label.text = @"您的账号已经禁用/删除/修改密码,请重新登录或联系管理员!";
        label.numberOfLines = 0;
        [self.backgroundView_white addSubview:label];
        
        //line_bottom
        UIView *lineView_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom, self.backgroundView_white.width, 0.5)];
        lineView_bottom.backgroundColor = ZSColorLine;
        [self.backgroundView_white addSubview:lineView_bottom];
        
        //按钮
        UIButton *knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        knowBtn.frame = CGRectMake(0, lineView_bottom.bottom, self.backgroundView_white.width, CellHeight);
        knowBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [knowBtn setTitle:@"好的" forState:UIControlStateNormal];
        [knowBtn setTitleColor:UIColorFromRGB(0x4F4F4F) forState:UIControlStateNormal];
        [knowBtn addTarget:self action:@selector(knowBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView_white addSubview:knowBtn];
        
    }
    return self;
}

#pragma mark 显示自己
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView_black.alpha = 0.5;
        self.backgroundView_white.alpha = 1;
    }];
}

#pragma mark 移除自己
- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)knowBtnAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(gotoRelogin)]){
        [self.delegate gotoRelogin];
    }
}

@end
