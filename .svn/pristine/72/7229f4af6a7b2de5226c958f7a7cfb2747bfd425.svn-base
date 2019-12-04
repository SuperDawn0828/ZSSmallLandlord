//
//  ZSSingleLineTextTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/15.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSSingleLineTextTableViewCell.h"
#import "WSDatePickerView.h"
#import "ZSWSYearMonthDayPicker.h"

@interface ZSSingleLineTextTableViewCell ()<ZSPickerViewDelegate>

@end

@implementation ZSSingleLineTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.backgroundColor = ZSViewBackgroundColor;
    }
    return self;
}

- (void)setModel:(ZSDynamicDataModel *)model
{
    _model = model;
    //fieldType;     //展示类型  1文本 2多行文本 3图片 4数字 5日期 6日期+时间 7单选,
    
    //文本
    if (model.fieldType.intValue == 1)
    {
        if (model.isNecessary.intValue == 0) {
            self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:model.fieldMeaning withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
        }
        else {
            self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:[NSString stringWithFormat:@"%@ *",model.fieldMeaning] withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
        }
    }
    //数字
    else if (model.fieldType.intValue == 4)
    {
        if (model.isNecessary.intValue == 0) {
            if (model.fieldUnit.length > 0) {//带单位
                self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:model.fieldMeaning withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad withElement:model.fieldUnit];
                if ([model.fieldUnit isEqualToString:@"万元"]) {
                    self.inputView.inputTextFeild.width = ZSWIDTH-160-15-30;
                }
            }
            else{
                self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:model.fieldMeaning withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
            }
        }
        else {
            if (model.fieldUnit.length > 0) {
                self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:[NSString stringWithFormat:@"%@ *",model.fieldMeaning] withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad withElement:model.fieldUnit];
            }
            else{
                self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:[NSString stringWithFormat:@"%@ *",model.fieldMeaning] withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad];
            }
        }
    }
    //日期/日期+时间/单选
    else if (model.fieldType.intValue == 5 || model.fieldType.intValue == 6 || model.fieldType.intValue == 7)
    {
        //非必填
        if (model.isNecessary.intValue == 0) {
            self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withClickAction:model.fieldMeaning];
        }
        else {//必填
            self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withClickAction:[NSString stringWithFormat:@"%@ *",model.fieldMeaning]];
        }
    }
    
    //右边的数据
    if (model.rightData.length > 0) {
        if (self.inputView.inputTextFeild) {
            self.inputView.inputTextFeild.text = SafeStr(model.rightData);
            self.inputView.inputTextFeild.textColor = ZSColorListRight;
        }else{
            self.inputView.rightLabel.text = SafeStr(model.rightData);
            self.inputView.rightLabel.textColor = ZSColorListRight;
        }
    }
    self.inputView.delegate = self;
    self.inputView.inputTextFeild.delegate = self;
    [self addSubview:self.inputView];
    
    
    //已完成和已操作的单子不能操作
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:model.prdType] && self.isShowAdd)
    {
    }
    else
    {
        self.userInteractionEnabled = NO;
        self.inputView.leftLabel.text = [self.inputView.leftLabel.text stringByReplacingOccurrencesOfString:@"*" withString:@""];
        self.inputView.inputTextFeild.placeholder = @"";
        self.inputView.placeholderLabel.text = @"";
        self.inputView.rightImgView.hidden = YES;
        //如果没有数据才显示空的
        if (model.rightData.length == 0 || [model.rightData isKindOfClass:[NSNull class]]) {
            self.inputView.rightLabel.text = @"";
            self.inputView.inputTextFeild.text = @"";
            self.inputView.elementLabel.text = @"";
        }
    }
}

#pragma mark ZSInputOrSelectViewDelegate 弹出pickerView
- (void)clickBtnAction:(ZSInputOrSelectView *)view;
{
    //键盘回收
    [NOTI_CENTER postNotificationName:@"hideKeyboard" object:nil];
    
    //只选择日期
    if (self.model.fieldType.intValue == 5)
    {
        ZSWSYearMonthDayPicker *datePicker = [[ZSWSYearMonthDayPicker alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 250)];
        datePicker.datePickerBlock = ^(NSString *selectDate) {
            self.inputView.rightLabel.text = selectDate;
            self.inputView.rightLabel.textColor = ZSColorListRight;
            if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:)]){
                [self.delegate sendCurrentCellData:selectDate withIndex:(long)self.currentIndex];
            }
        };
        [self addSubview:datePicker];
    }
    //日期+时间
    else if (self.model.fieldType.intValue == 6)
    {
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            self.inputView.rightLabel.text = date;
            self.inputView.rightLabel.textColor = ZSColorListRight;
            if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:)]){
                [self.delegate sendCurrentCellData:date withIndex:(long)self.currentIndex];
            }
        }];
        datepicker.dateLabelColor = [UIColor orangeColor];//年-月-日-时-分 颜色
        datepicker.datePickerColor = ZSColorBlack;//滚轮日期颜色
        datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
        [datepicker show];
    }
    //其他的单选资料
    else if (self.model.fieldType.intValue == 7)
    {
        NSMutableArray *nameArray = [[NSMutableArray alloc]init];
        for (Options *model in self.model.options) {
            [nameArray addObject:model.optionText];
        }
        ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        pickerView.titleArray = nameArray;
        pickerView.delegate = self;
        [pickerView show];
    }
}

#pragma mark ZSPickerViewDelegate 单选类资料
- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index;
{
    NSMutableArray *valueArray = [[NSMutableArray alloc]init];
    for (Options *model in self.model.options) {
        [valueArray addObject:model.optionValue];
    }
    //选中的值
    NSString *selectString = valueArray[index];
    if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:)]){
        [self.delegate sendCurrentCellData:selectString withIndex:(long)self.currentIndex];
    }
}

#pragma mark UITextFieldDelegate
//当文本输入框已经停止编辑的时候会调用这个方法
//两种停止编辑的情况:1.放弃第一响应者  2.点击了其他的输入框
- (void)textFieldDidEndEditing:(UITextField *)textField
{    
    if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:)]){
        [self.delegate sendCurrentCellData:textField.text withIndex:(long)self.currentIndex];
    }
}

#pragma mark textField--限制输入的字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"]){ return YES;}
    //限制输入表情
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    //判断键盘是不是九宫格键盘
    if ([ZSTool isNineKeyBoard:string] ){
        return YES;
    }else{
        //限制输入表情
        if ([ZSTool stringContainsEmoji:string]) {
            return NO;
        }
    }
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    //姓名长度限制40
    if ([toBeString length] > 20) {
        textField.text = [toBeString substringToIndex:20];
        return NO;
    }
    return YES;
}

@end
