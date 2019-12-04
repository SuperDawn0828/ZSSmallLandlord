//
//  ZSsmallControl.m
//  ZSSmallLandlord
//
//  Created by cong on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSsmallControl.h"

@interface ZSsmallControl ()<UITextFieldDelegate>

@end

@implementation ZSsmallControl

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark 创建label
+(UILabel *)LFrame:(CGRect)frame LText:(NSString *)title LColor:(UIColor *)color LFont:(NSInteger)FontString{
    UILabel *label = [[UILabel alloc]init];
    label.frame =frame;
    label.text =title;
    label.textColor =color;
    label.font =[UIFont systemFontOfSize:FontString];
    return label;
}

#pragma mark 创建label右对齐
+(UILabel *)LRightFrame:(CGRect)frame LText:(NSString *)title LColor:(UIColor *)color LFont:(NSInteger)FontString{
    UILabel *label = [[UILabel alloc]init];
    label.frame =frame;
    label.text =title;
    label.textAlignment  =NSTextAlignmentRight;
    label.textColor =color;
    label.font =[UIFont systemFontOfSize:FontString];
    return label;
}

#pragma mark 创建label居中对齐
+(UILabel *)LCenterFrame:(CGRect)frame LText:(NSString *)title LColor:(UIColor *)color LFont:(NSInteger)FontString{
    UILabel *label = [[UILabel alloc]init];
    label.frame =frame;
    label.text =title;
    label.textAlignment  =NSTextAlignmentCenter;
    label.textColor =color;
    label.font =[UIFont systemFontOfSize:FontString];
    return label;
}

#pragma mark 字体最后一个字变色
+(UILabel *)LdiscolorationFrame:(CGRect)frame LText:(NSString *)title LColor:(UIColor *)color LFont:(NSInteger)FontString  LNSRange:(NSRange)labelNSRange valueColor:(UIColor *)ValueColor{
    UILabel *label = [[UILabel alloc]init];
    label.frame = frame;
    label.text = title;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:FontString];
    NSMutableAttributedString *discoloration = [[NSMutableAttributedString alloc] initWithString:title];
    [discoloration addAttribute:NSForegroundColorAttributeName value:ValueColor range:labelNSRange];
    label.attributedText = discoloration;
    return label;
}

#pragma mark 创建View
+(UIView *)ViewFrame:(CGRect)frame VBGColor:(UIColor *)BGColor{
    UIView *view =[[UIView alloc]init];
    view.frame = frame;
    view.backgroundColor = BGColor;
    return  view;
}

#pragma mark 创建图片
+(UIImageView *)ImgFrame:(CGRect)frame ImgS:(NSString *)images ImgBGColro:(UIColor *)BGColor{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = frame;
    imgView.image = [UIImage imageNamed:images];
    imgView.backgroundColor = BGColor;
    return  imgView;
}

#pragma mark 创建button
+(UIButton *)ButtonFrame:(CGRect )frame BtnTitle:(NSString *)title BGColor:(UIColor*)color titleColor:(UIColor*)Tcolor Target:(id)target action:(SEL)action{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:Tcolor forState:UIControlStateNormal];
    [button addTarget:(id)target action:(SEL)action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


#pragma mark 创建弧形button
+(UIButton *)ButtonCornerRadiusFrame:(CGRect )frame BtnTitle:(NSString *)title BGColor:(UIColor*)color titleColor:(UIColor*)Tcolor Target:(id)target action:(SEL)action{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:Tcolor forState:UIControlStateNormal];
    button.layer.cornerRadius = 4.0f;  //带弧形
    [button addTarget:(id)target action:(SEL)action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


#pragma mark 创建有边框button
+(UIButton *)ButtonBorderFrame:(CGRect )frame BtnTitle:(NSString *)title BGColor:(UIColor*)color titleColor:(UIColor*)Tcolor Target:(id)target action:(SEL)action{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:Tcolor forState:UIControlStateNormal];
    [button addTarget:(id)target action:(SEL)action forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = [ZSColor(222,222,222) CGColor];  //边框颜色
    button.layer.borderWidth = 0.5;    //带边框
    return button;
}

#pragma mark 创建ScrollView
+(UIScrollView *)ScrollViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)BGColor scrollViewcontentSize:(CGSize)contentSize{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = frame;
    scrollView.backgroundColor = BGColor;
    scrollView.contentSize = contentSize;
    scrollView.showsHorizontalScrollIndicator = NO;//是否显示水平滚动条
    scrollView.showsVerticalScrollIndicator = NO;//是否显示垂直滚动条
    scrollView.bounces = NO;     //设置是否开启在开始、末尾的弹性效果
    return scrollView;
}

#pragma mark 创建FextFrame
+(UITextField *)FextFrame:(CGRect )TextFieldFrame Text:(NSString *)FiedldText loat:(NSInteger)Float{
    UITextField *textField = [[UITextField alloc] init];
    textField.frame =TextFieldFrame;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font =[UIFont systemFontOfSize:Float];
    textField.textAlignment = NSTextAlignmentRight;
    textField.placeholder = FiedldText;
    textField.textColor = ZSColorListRight;
    textField.secureTextEntry = NO;
    [textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    textField.returnKeyType = UIReturnKeyDone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setValue:ZSColor(194,194,194) forKeyPath:@"_placeholderLabel.textColor"];
    //    textField.userInteractionEnabled = NO;//是否可以编辑
    return textField;
}


#pragma mark 创建CellButton
+(UIButton *)CellBtn:(CGRect)frame LText:(NSString *)title  ImgS:(NSString *)images Target:(id)target action:(SEL)action{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor =ZSColorWhite;
    [button addTarget:(id)target action:(SEL)action forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:[self ImgFrame:CGRectMake(15, 11.5, 21, 21) ImgS:images ImgBGColro:[UIColor clearColor]]];
    [button addSubview:[self ImgFrame:CGRectMake(ZSWIDTH-30, 15, 15, 15) ImgS:@"list_arrow_n" ImgBGColro:[UIColor clearColor]]];
    [button addSubview:[self LFrame:CGRectMake(46, 0, 100, 44) LText:title LColor:ZSColorBlack LFont:15]];
    [button addSubview:[self lineViewFrame:CGRectMake(15, 43.5, ZSWIDTH-15, 0.5)]];
    return button;
}

#pragma mark 自定义带图片带星号
+(UIButton *)BtnBorderOneFrame:(CGRect )frame  LTitle:(NSString *)title Target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button addTarget:(id)target action:(SEL)action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = ZSColorWhite;
    UIView *btnview = [self lineViewFrame:CGRectMake(10, 43.5, ZSWIDTH-10, 0.5)];
    [button addSubview:[self ImgFrame:CGRectMake(ZSWIDTH-30, 15, 15, 15) ImgS:@"list_arrow_n" ImgBGColro:[UIColor clearColor]]];
    [button addSubview:btnview];
    [button addSubview:[self LdiscolorationFrame:CGRectMake(15, 0, 200, 44) LText:title LColor:ZSColorListLeft LFont:15 LNSRange:NSMakeRange(title.length-1, 1) valueColor:ZSColorRed]];
    return button;
}

#pragma mark 设置分割线
+(UIView *)lineViewFrame:(CGRect)frame{
    UIView *view =[[UIView alloc]init];
    view.frame = frame;
    view.backgroundColor = ZSColorLine;
    return  view;
}
@end
