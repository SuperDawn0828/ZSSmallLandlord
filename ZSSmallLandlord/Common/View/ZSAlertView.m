//
//  ZSAlertView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSAlertView.h"

@interface ZSAlertView ()
@property (nonatomic,strong)UIView *backgroundView_black;
@property (nonatomic,strong)UIView *backgroundView_white;
@end

@implementation ZSAlertView

#pragma mark 一个按钮
- (instancetype)initWithFrame:(CGRect)frame withNotice:(NSString *)notice btnTitle:(NSString *)btnTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureAlertView:notice btnTitle:btnTitle];
    }
    return self;
}

- (void)configureAlertView:(NSString *)notice btnTitle:(NSString *)btnTitle
{
    //黑底
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH,ZSHEIGHT_PopupWindow)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0;
    [self addSubview:self.backgroundView_black];
 
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
   
    //白底
    self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(53, (ZSHEIGHT_PopupWindow-200)/2, ZSWIDTH-53*2, 200)];
    self.backgroundView_white.backgroundColor = ZSColorWhite;
    self.backgroundView_white.layer.cornerRadius = 3;
    self.backgroundView_white.alpha = 0;
    [self addSubview:self.backgroundView_white];
   
    //label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15,0,self.backgroundView_white.width - 30,200-CellHeight)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = ZSColorListLeft;
    label.text = notice;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.backgroundView_white addSubview:label];
   
    //线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 200-CellHeight, self.backgroundView_white.width, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [self.backgroundView_white addSubview:lineView];
 
    //退出按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, lineView.bottom, self.backgroundView_white.width, CellHeight);
    [cancelBtn setTitle:btnTitle.length>0?btnTitle:@"确定" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ZSColorListLeft forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:cancelBtn];
}


#pragma mark 两个按钮,左侧确定,右侧取消
- (instancetype)initWithFrame:(CGRect)frame withNotice:(NSString *)notice sureTitle:(NSString *)sureTitle cancelTitle:(NSString *)cancelTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureAlertView:notice sureTitle:sureTitle cancelTitle:cancelTitle];
    }
    return self;
}

- (void)configureAlertView:(NSString *)notice sureTitle:(NSString *)sureTitle cancelTitle:(NSString *)cancelTitle
{
    //黑底
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0;
    [self addSubview:self.backgroundView_black];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    //白底
    self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(53, (ZSHEIGHT_PopupWindow-142)/2, ZSWIDTH-53*2, 142)];
    self.backgroundView_white.backgroundColor = ZSColorWhite;
    self.backgroundView_white.layer.cornerRadius = 3;
    self.backgroundView_white.alpha = 0;
    [self addSubview:self.backgroundView_white];
    //label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15,15,self.backgroundView_white.width - 30,98)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = ZSColorListLeft;
    label.text = notice;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.backgroundView_white addSubview:label];
    //字体高度坐标
    label.height = [ZSTool getStringHeight:notice withframe:CGSizeMake(label.width, MAXFLOAT) withSizeFont:[UIFont systemFontOfSize:15] winthLineSpacing:3];
    if (label.height < 98 - 15) {
        label.height = 98 - 15;
    }
    self.backgroundView_white.frame = CGRectMake(53, (ZSHEIGHT_PopupWindow-label.height - 120)/2, ZSWIDTH-53*2, label.height+80);
    //线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom + 15, self.backgroundView_white.width, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [self.backgroundView_white addSubview:lineView];
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, label.bottom + 15, self.backgroundView_white.width/2, CellHeight);
    [sureBtn setTitle:sureTitle.length>0 ? sureTitle : @"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:ZSPageItemColor forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:sureBtn];
    //线
    UIView *lineViews = [[UIView alloc]initWithFrame:CGRectMake(self.backgroundView_white.width/2, label.bottom + 17, 0.5, CellHeight)];
    lineViews.backgroundColor = ZSColorLine;
    [self.backgroundView_white addSubview:lineViews];

    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(self.backgroundView_white.width/2, label.bottom + 15, self.backgroundView_white.width/2, CellHeight);
    [cancelBtn setTitle:cancelTitle.length>0 ? cancelTitle : @"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ZSColorListLeft forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:cancelBtn];
}

#pragma mark 两个按钮,左侧取消,右侧确定
- (instancetype)initWithFrame:(CGRect)frame withNotice:(NSString *)notice cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureAlertView:notice cancelTitle:cancelTitle sureTitle:sureTitle];
    }
    return self;
}

- (void)configureAlertView:(NSString *)notice cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle
{
    //黑底
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0;
    [self addSubview:self.backgroundView_black];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    //白底
    self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(53, (ZSHEIGHT_PopupWindow-142)/2, ZSWIDTH-53*2, 142)];
    self.backgroundView_white.backgroundColor = ZSColorWhite;
    self.backgroundView_white.layer.cornerRadius = 3;
    self.backgroundView_white.alpha = 0;
    [self addSubview:self.backgroundView_white];
    //label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15,0,self.backgroundView_white.width - 30,98)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = ZSColorListLeft;
    label.text = notice;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.backgroundView_white addSubview:label];
    //线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 98, self.backgroundView_white.width, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [self.backgroundView_white addSubview:lineView];
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 98, self.backgroundView_white.width/2, CellHeight);
    [cancelBtn setTitle:cancelTitle.length>0 ? cancelTitle : @"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ZSPageItemColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:cancelBtn];
    //线
    UIView *lineViews = [[UIView alloc]initWithFrame:CGRectMake(self.backgroundView_white.width/2, 98, 0.5, CellHeight)];
    lineViews.backgroundColor = ZSColorLine;
    [self.backgroundView_white addSubview:lineViews];
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(self.backgroundView_white.width/2, 98, self.backgroundView_white.width/2, CellHeight);
    [sureBtn setTitle:sureTitle.length>0 ? sureTitle : @"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:ZSColorListLeft forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:sureBtn];
}

#pragma mark 两个按钮,左侧取消,右侧确定(两个按钮颜色一样)
- (instancetype)initWithFrame:(CGRect)frame withNotice:(NSString *)notice
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureAlertView:notice];
    }
    return self;
}

- (void)configureAlertView:(NSString *)notice
{
    //黑底
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0;
    [self addSubview:self.backgroundView_black];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    //白底
    self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(53, (ZSHEIGHT_PopupWindow-142)/2, ZSWIDTH-53*2, 142)];
    self.backgroundView_white.backgroundColor = ZSColorWhite;
    self.backgroundView_white.layer.cornerRadius = 3;
    self.backgroundView_white.alpha = 0;
    [self addSubview:self.backgroundView_white];
    //label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15,15,self.backgroundView_white.width - 30,98)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = ZSColorListLeft;
    label.text = notice;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.backgroundView_white addSubview:label];
    //字体高度坐标
    label.height = [ZSTool getStringHeight:notice withframe:CGSizeMake(label.width, MAXFLOAT) withSizeFont:[UIFont systemFontOfSize:15] winthLineSpacing:3];
    if (label.height < 98 - 15) {
        label.height = 98 - 15;
    }
    self.backgroundView_white.frame = CGRectMake(53, (ZSHEIGHT_PopupWindow-label.height - 120)/2, ZSWIDTH-53*2, label.height+80);
    //线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom + 15, self.backgroundView_white.width, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [self.backgroundView_white addSubview:lineView];
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, label.bottom + 15, self.backgroundView_white.width/2, CellHeight);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:ZSColorListLeft forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:sureBtn];
    //线
    UIView *lineViews = [[UIView alloc]initWithFrame:CGRectMake(self.backgroundView_white.width/2, label.bottom + 17, 0.5, CellHeight)];
    lineViews.backgroundColor = ZSColorLine;
    [self.backgroundView_white addSubview:lineViews];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(self.backgroundView_white.width/2, label.bottom + 15, self.backgroundView_white.width/2, CellHeight);
    [cancelBtn setTitle: @"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ZSColorListLeft forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:cancelBtn];
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

#pragma mark 按钮响应事件
- (void)cancelBtnAction:(UIButton *)btn
{
    if (btn.tag != 19920901) {
        [self removeFromSuperview];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(AlertViewCanCleClick:)]){
        [self.delegate AlertViewCanCleClick:self];
    }
}

- (void)sureBtnAction
{
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(AlertView:)]){
        [self.delegate AlertView:self];
    }
}


@end
