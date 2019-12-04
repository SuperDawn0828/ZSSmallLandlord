//
//  ZSNotificationDetailView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/8/21.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSNotificationDetailView.h"

@interface ZSNotificationDetailView ()
@property (nonatomic,strong)UIView *backgroundView_black;
@property (nonatomic,strong)UIView *backgroundView_white;
@end

@implementation ZSNotificationDetailView

- (instancetype)initWithFrame:(CGRect)frame
                    withTitle:(NSString *)titleSting
                  withContent:(NSString *)contentSting
             withLeftBtnTitle:(NSString *)leftBtnTitle
            withRightBtnTitle:(NSString *)rightBtnTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //label(高度最高为150)
        CGFloat textHeight = [self getLabelHeight:contentSting];
        CGFloat scrollHeight;
        if (textHeight < 100) {
            scrollHeight = 100;
        }
        else if (textHeight > 180) {
            scrollHeight = 180;
        }
        else
        {
            scrollHeight = textHeight;
        }

        //黑底
        self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
        self.backgroundView_black.backgroundColor = ZSColorBlack;
        self.backgroundView_black.alpha = 0;
        [self addSubview:self.backgroundView_black];
       
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self.backgroundView_black addGestureRecognizer:tap];
        
        //白底
        self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(53, (ZSHEIGHT_PopupWindow-CellHeight-scrollHeight-51)/2, ZSWIDTH-53*2, CellHeight+scrollHeight+51)];
        self.backgroundView_white.backgroundColor = ZSColorWhite;
        self.backgroundView_white.layer.cornerRadius = 4;
        self.backgroundView_white.alpha = 0;
        [self addSubview:self.backgroundView_white];
       
        //title
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0,0,self.backgroundView_white.width,CellHeight)];
        title.font = [UIFont boldSystemFontOfSize:15];
        title.textColor = UIColorFromRGB(0x4F4F4F);
        title.text = titleSting;
        title.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView_white addSubview:title];
       
        //line_top
        UIView *lineView_top = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight, self.backgroundView_white.width, 0.5)];
        lineView_top.backgroundColor = ZSColorLine;
        [self.backgroundView_white addSubview:lineView_top];
       
        //底部的scroll
        UIScrollView *scroll_bg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lineView_top.bottom, self.backgroundView_white.width, scrollHeight)];
        scroll_bg.contentSize = CGSizeMake(self.backgroundView_white.width, scrollHeight + 20);//根据高度设置scroll的滑动位置
        [self.backgroundView_white addSubview:scroll_bg];
      
        //显示详情的label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.backgroundView_white.width-30, textHeight)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColorFromRGB(0x666666);
        label.numberOfLines = 0;
        [scroll_bg addSubview:label];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 7;
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@0.0f};
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentSting attributes:dic];
        label.attributedText = attributeStr;
      
        //line_bottom
        UIView *lineView_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.backgroundView_white.height-50.5, self.backgroundView_white.width, 0.5)];
        lineView_bottom.backgroundColor = ZSColorLine;
        [self.backgroundView_white addSubview:lineView_bottom];
       
        //按钮
        if (leftBtnTitle && !rightBtnTitle)
        {
            UIButton *knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            knowBtn.frame = CGRectMake(0, lineView_bottom.bottom, self.backgroundView_white.width, 50);
            knowBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [knowBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
            [knowBtn setTitleColor:UIColorFromRGB(0x4F4F4F) forState:UIControlStateNormal];
            [knowBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.backgroundView_white addSubview:knowBtn];
        }
        else if (leftBtnTitle && rightBtnTitle)
        {
            //取消按钮
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame = CGRectMake(0, lineView_bottom.bottom, self.backgroundView_white.width/2, 50);
            [cancelBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
            [cancelBtn setTitleColor:ZSPageItemColor forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.backgroundView_white addSubview:cancelBtn];
          
            //分割线
            UIView *lineViews = [[UIView alloc]initWithFrame:CGRectMake(self.backgroundView_white.width/2, lineView_bottom.bottom, 0.5, 50)];
            lineViews.backgroundColor = ZSColorLine;
            [self.backgroundView_white addSubview:lineViews];
          
            //确定按钮
            UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sureBtn.frame = CGRectMake(self.backgroundView_white.width/2, lineView_bottom.bottom, self.backgroundView_white.width/2, 50);
            [sureBtn setTitle:rightBtnTitle forState:UIControlStateNormal];
            [sureBtn setTitleColor:ZSColorListLeft forState:UIControlStateNormal];
            sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self.backgroundView_white addSubview:sureBtn];
        }
    }
    return self;
}

#pragma mark 获取通知内容的高度,超过两行不显全,给弹窗
- (CGFloat)getLabelHeight:(NSString *)string
{
    CGSize size = CGSizeMake(ZSWIDTH-53*2-30,1000);
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 7;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
    CGSize labelsize = [string boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:dict
                                            context:nil].size;
    return labelsize.height;
}

#pragma mark 按钮响应事件
- (void)cancelBtnAction:(UIButton *)btn
{
    [self dismiss];
}

- (void)sureBtnAction
{
    [self dismiss];

    if (_delegate && [_delegate respondsToSelector:@selector(sureClick:)]){
        [self.delegate sureClick:self];
    }
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

@end
