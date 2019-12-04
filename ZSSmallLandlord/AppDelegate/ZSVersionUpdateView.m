//
//  ZSVersionUpdateView.m
//  ZSYuegeche
//
//  Created by 武 on 2017/7/5.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSVersionUpdateView.h"

@interface ZSVersionUpdateView  ()
@property (nonatomic,strong)UIView *backgroundView_black;
@property (nonatomic,strong)UIView *backgroundView_white;
@property (nonatomic,assign)BOOL   isForced;
@end

@implementation ZSVersionUpdateView

#pragma mark 版本更新专用

- (instancetype)initWithFrame:(CGRect)frame withVersion:(NSString *)version withNotice:(NSString *)notice withNoticeHeight:(CGFloat)height withForced:(BOOL)isForced
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isForced = isForced;
        //黑底
        self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
        self.backgroundView_black.backgroundColor = ZSColorBlack;
        self.backgroundView_black.alpha = 0;
        [self addSubview:self.backgroundView_black];
        //添加手势
        if (!isForced) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
            [self.backgroundView_black addGestureRecognizer:tap];
        }
        //白底
        self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(53, (ZSHEIGHT_PopupWindow-height-50-CellHeight*2-20)/2, ZSWIDTH-53*2, height+50+CellHeight*2+20)];
        self.backgroundView_white.backgroundColor = ZSColorWhite;
        self.backgroundView_white.layer.cornerRadius = 4;
        self.backgroundView_white.alpha = 0;
        [self addSubview:self.backgroundView_white];
        //imageView
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, -52, self.backgroundView_white.width, 100)];
        imgview.image = [UIImage imageNamed:@"bombbox_upgrade_"];
        [self.backgroundView_white addSubview:imgview];
        //title
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0,imgview.bottom,self.backgroundView_white.width,CellHeight)];
        title.font = [UIFont boldSystemFontOfSize:16];
        title.textColor = UIColorFromRGB(0xFF3D3D);
        title.text = [NSString stringWithFormat:@"系统升级到%@啦!",version];
        title.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView_white addSubview:title];
        //label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15,title.bottom,self.backgroundView_white.width - 30,height)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = ZSColorListRight;
        label.text = notice;
        label.numberOfLines = 0;
        [self.backgroundView_white addSubview:label];
        //底色
        UIView *backgroundViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom+20, self.backgroundView_white.width, CellHeight+2)];
        [backgroundViewBottom addBackGroundLayerWithLeftColor:ZSColor(245, 107, 74) withRightColor:ZSColor(254, 63, 63)];
        [self.backgroundView_white addSubview:backgroundViewBottom];
        //设置指定角为圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backgroundViewBottom.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = backgroundViewBottom.bounds;
        maskLayer.path = maskPath.CGPath;
        backgroundViewBottom.layer.mask = maskLayer;
        //升级按钮
        if (isForced) {
            UIButton *btn_update = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_update.frame = backgroundViewBottom.bounds;
            btn_update.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn_update setTitle:@"立即升级" forState:UIControlStateNormal];
            [btn_update setTitleColor:ZSColorWhite forState:UIControlStateNormal];
            [btn_update addTarget:self action:@selector(btn_updateAction) forControlEvents:UIControlEventTouchUpInside];
            [backgroundViewBottom addSubview:btn_update];
        }
        else
        {
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame = CGRectMake(0, 0, backgroundViewBottom.width/2, backgroundViewBottom.height);
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            [backgroundViewBottom addSubview:cancelBtn];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(cancelBtn.width, 5, 0.5, cancelBtn.height-10)];
            lineView.backgroundColor = ZSColorWhite;
            [backgroundViewBottom addSubview:lineView];
            
            UIButton *btn_update = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_update.frame = CGRectMake(cancelBtn.width, 0, cancelBtn.width, cancelBtn.height);
            btn_update.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn_update setTitle:@"立即升级" forState:UIControlStateNormal];
            [btn_update setTitleColor:ZSColorWhite forState:UIControlStateNormal];
            [btn_update addTarget:self action:@selector(btn_updateAction) forControlEvents:UIControlEventTouchUpInside];
            [backgroundViewBottom addSubview:btn_update];
        }

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

#pragma mark 按钮响应事件
- (void)btn_updateAction
{
    if (!self.isForced) {
        [self removeFromSuperview];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(sureClick:)]){
        [self.delegate sureClick:self];
    }
}

@end
