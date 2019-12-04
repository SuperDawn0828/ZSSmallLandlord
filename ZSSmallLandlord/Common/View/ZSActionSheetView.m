//
//  ZSActionSheetView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSActionSheetView.h"

@interface ZSActionSheetView ()
@property (nonatomic,strong)UIView *backgroundView_black;
@property (nonatomic,strong)UIView *backgroundView_white;
@property (nonatomic,strong)UIButton *cancelBtn;
@end

@implementation ZSActionSheetView

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)titleArray{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureActionSheet:titleArray];
    }
    return self;
}

- (void)configureActionSheet:(NSArray *)titleArray
{
    //黑底
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0;
    [self addSubview:self.backgroundView_black];
  
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnAction)];
    [self addGestureRecognizer:tap];
 
    //取消按钮
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.backgroundColor = ZSColorWhite;
    self.cancelBtn.frame = CGRectMake(10, ZSHEIGHT, ZSWIDTH-20, 55);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:ZSColorRed forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
   
    //白底
    self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(10, ZSHEIGHT, ZSWIDTH-20, 55*titleArray.count)];
    self.backgroundView_white.backgroundColor = ZSColorWhite;
    self.backgroundView_white.layer.cornerRadius = 5;
    [self addSubview:self.backgroundView_white];
 
    //buttons
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 55*i, ZSWIDTH-20, 55);
        [btn setTitle:[NSString stringWithFormat:@"%@",titleArray[i]] forState:UIControlStateNormal];
        [btn setTitleColor:ZSColorListLeft forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = i;
        [btn addTarget:self action:@selector(actionSheetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView_white addSubview:btn];
        if (i != titleArray.count-1) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 55+55*i, ZSWIDTH-20, 0.5)];
            lineView.backgroundColor = ZSColorLine;
            [self.backgroundView_white addSubview:lineView];
        }
    }
}

#pragma mark 显示自己
- (void)show:(NSInteger)count
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView_black.alpha = 0.5;
        self.backgroundView_white.top = ZSHEIGHT-65-10-55*count;
        self.cancelBtn.top = ZSHEIGHT-65;
    }];
}

#pragma mark 按钮响应事件
- (void)cancelBtnAction
{
    [self removeFromSuperview];
}

- (void)actionSheetBtnAction:(UIButton *)btn
{
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(SheetView:btnClick:)]){
        [self.delegate SheetView:self btnClick:btn.tag];
    }
    //照片代理
    if (_delegate && [_delegate respondsToSelector:@selector(SheetView:btnClick:sheetStyle:)]){
        [self.delegate SheetView:self btnClick:btn.tag sheetStyle:self.sheetStyle];
    }
}

@end
