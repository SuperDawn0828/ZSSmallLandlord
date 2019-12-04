//
//  ZSInputOrSelectView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  选择/输入/展示

#import <UIKit/UIKit.h>

@class ZSInputOrSelectView;
@protocol ZSInputOrSelectViewDelegate <NSObject>
@optional
- (void)clickBtnAction:(ZSInputOrSelectView *)view;//"请选择"按钮触发的方法
@end

@interface ZSInputOrSelectView : UIView<UITextFieldDelegate>
@property (nonatomic,strong) UILabel     *leftLabel;
@property (nonatomic,strong) UILabel     *rightLabel;
@property (nonatomic,strong) UIButton    *clickBtn;         //"请选择"的按钮
@property (nonatomic,strong) UIImageView *rightImgView;     //右侧箭头
@property (nonatomic,strong) UIView      *lineView;
@property (nonatomic,strong) UITextField *inputTextFeild;   //输入框
@property (nonatomic,strong) UITextView  *inputTextView;    //输入文本域
@property (nonatomic,strong) UILabel     *placeholderLabel;
@property (nonatomic,strong) UILabel     *elementLabel;     //拼接单位
@property (nonatomic,weak  )id<ZSInputOrSelectViewDelegate> delegate;

#pragma mark 选择
- (id)initWithFrame:(CGRect)frame withClickAction:(NSString *)leftTitle;
#pragma mark 输入(UITextField)
- (id)initWithFrame:(CGRect)frame withInputAction:(NSString *)leftTitle withRightTitle:(NSString *)rightTitle withKeyboardType:(UIKeyboardType)keyType;
#pragma mark 输入(UITextView)
- (id)initTextViewWithFrame:(CGRect)frame withInputAction:(NSString *)leftTitle withRightTitle:(NSString *)rightTitle withKeyboardType:(UIKeyboardType)keyType;
#pragma mark 纯展示
- (id)initWithFrame:(CGRect)frame withLeftTitle:(NSString *)leftTitle withRightTitle:(NSString *)rightTitle;
#pragma mark 输入(UITextField) (后面拼接单位的)
- (id)initWithFrame:(CGRect)frame withInputAction:(NSString *)leftTitle withRightTitle:(NSString *)rightTitle withKeyboardType:(UIKeyboardType)keyType withElement:(NSString *)title;
@end
