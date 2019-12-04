//
//  ZSBaseSeationView.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBaseSectionView.h"

@implementation ZSBaseSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=ZSColorWhite;
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    //顶部线条
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.5)];
    view.backgroundColor=ZSColorLine;
    [self addSubview:view];
    
    //右边箭头
    self.rightArrowImgV=[[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-30, (self.frame.size.height-15)/2, 15, 15)];
    self.rightArrowImgV.image=[UIImage imageNamed:@"list_arrow_n"];
    self.rightArrowImgV.userInteractionEnabled = YES;
    [self.rightArrowImgV addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    [self addSubview:self.rightArrowImgV];
    
    //竖线
    self.verticalLineView = [[UIView alloc]initWithFrame:CGRectMake(0, (self.height-11)/2, 4, 11)];
    self.verticalLineView.backgroundColor = ZSColorRed;
    [self addSubview:self.verticalLineView];
    
    //左边label
    self.leftLab=[self LabelWithFrame:CGRectMake(self.verticalLineView.right + 10, 0, ZSWIDTH/2, self.frame.size.height) textAlignment:NSTextAlignmentLeft textColor:ZSColorListRight];
    self.leftLab.font = [UIFont boldSystemFontOfSize:15];
    
    //右边label
    self.rightLab=[self LabelWithFrame:CGRectMake(ZSWIDTH/2-30, 0, ZSWIDTH/2, self.frame.size.height) textAlignment:NSTextAlignmentRight textColor:ZSColorRed];
    self.rightLab.font = [UIFont systemFontOfSize:14];
    [self.rightLab addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    //解释Btn
    self.showDetailBtn=[UIButton new];
    [self.showDetailBtn setBackgroundImage:ImageName(@"establish_problem_n") forState:UIControlStateNormal];
    self.showDetailBtn.hidden=YES;
    [self.showDetailBtn addTarget:self action:@selector(showDetailClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.showDetailBtn];
    [self.showDetailBtn autoSetDimensionsToSize:CGSizeMake(20, 20)];
    [self.showDetailBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.showDetailBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:130 + 3];
    
    //刷新按钮
    self.view_refesh = [[UIView alloc]init];
    self.view_refesh.frame = CGRectMake(ZSWIDTH-58-15, (self.height-23)/2, 58, 23);
    self.view_refesh.backgroundColor = UIColorFromRGB(0xFFFBFA);
    self.view_refesh.layer.cornerRadius = 2;
    self.view_refesh.layer.masksToBounds = YES;
    self.view_refesh.layer.borderWidth = 0.5;
    self.view_refesh.layer.borderColor = ZSColorRed.CGColor;
    self.view_refesh.hidden = YES;
    [self addSubview:self.view_refesh];
    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(6, 5, 13, 13)];
    titleImg.image = [UIImage imageNamed:@"list_refresh_n"];
    [self.view_refesh addSubview:titleImg];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 58-20, 23)];
    titleLabel.text = @"刷新";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = ZSColorRed;
    [self.view_refesh addSubview:titleLabel];
    
    //底部的线
    self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(15, self.height - 0.5, ZSWIDTH - 15, 0.5)];
    self.bottomLine.backgroundColor = ZSColorLine;
    self.bottomLine.hidden = YES;
    [self addSubview:self.bottomLine];
    
    //点击Btn
    UIButton *tapBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, self.height)];
    [tapBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tapBtn];
}

- (void)showDetailClick
{
    if (_delegate&&[_delegate respondsToSelector:@selector(showExplain)]) {
        [_delegate showExplain];
    }
}

- (void)selectAction
{
    if (_delegate&&[_delegate respondsToSelector:@selector(tapSection:)]) {
        [_delegate tapSection:self.tag];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        if (![change[@"new"] isEqual:[NSNull null]]) {
            if ([change[@"new"] isEqualToString:@"通过"] || [change[@"new"] isEqualToString:@"已反馈-通过"]) {
                self.rightLab.textColor=ZSColorGreen;
            } else if([change[@"new"]isEqualToString:@"不通过"]||[change[@"new"]isEqualToString:@"需附加条件"] || [change[@"new"] isEqualToString:@"已反馈-不通过"]) {
                self.rightLab.textColor=ZSColorRed;
            }else{
                self.rightLab.textColor=ZSColorRed;
            }
        }
    } else {
        if ([change[@"new"] boolValue]) {
            self.rightLab.frame=CGRectMake(ZSWIDTH/2-15, 0, ZSWIDTH/2, self.frame.size.height);
        } else {
            self.rightLab.frame=CGRectMake(ZSWIDTH/2-30, 0, ZSWIDTH/2, self.frame.size.height);
        }
    }
}

- (void)dealloc
{
    [self.rightArrowImgV removeObserver:self forKeyPath:@"hidden"];
    [self.rightLab removeObserver:self forKeyPath:@"text"];
}

- (UILabel*)LabelWithFrame:(CGRect)frame textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)color
{
    UILabel *lab=[[UILabel alloc]initWithFrame:frame];
    lab.textAlignment=textAlignment;
    lab.textColor=color;
    lab.font=[UIFont systemFontOfSize:15.0f];
    [self addSubview:lab];
    return lab;
}

@end
