//
//  ZSCreditReportsPopView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/7/17.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSCreditReportsPopView.h"
#import "ZSInputOrSelectView.h"
#import "ZSSendOrderPopView.h"

@interface ZSCreditReportsPopView  ()<UITextFieldDelegate,UITextViewDelegate,ZSInputOrSelectViewDelegate,ZSPickerViewDelegate,ZSSendOrderPopViewDelegate>
@property (nonatomic,strong)UIScrollView        *backgroundScroll;
//可贷款的view
@property (nonatomic,strong)UIView              *loanableBackgroundView;
@property (nonatomic,strong)ZSInputOrSelectView *salesmanView;     //专属客户经理
@property (nonatomic,strong)ZSInputOrSelectView *loanAmountView;   //申请贷款金额
@property (nonatomic,strong)ZSInputOrSelectView *totalPriceView;   //房产评估总价
@property (nonatomic,strong)ZSInputOrSelectView *maxLoanAmountView;//最高可贷额度
@property (nonatomic,strong)ZSInputOrSelectView *loanBankView;     //贷款银行
@property (nonatomic,strong)ZSInputOrSelectView *loanRateView;     //贷款利率
//备注输入框
//@property (nonatomic,strong)UIView              *inputView;
//数据
@property (nonatomic,copy  )NSString            *canLoan;           //是否可贷 1可贷 2不可待
@property (nonatomic,copy  )NSString            *custQualification; //用户资质 1A 2B 3C
@property (nonatomic,copy  )NSString            *loanBankID;        //贷款银行id
@property (nonatomic,copy  )NSString            *salesmanID;        //专属客户经理id
@end

@implementation ZSCreditReportsPopView

- (id)initWithFrame:(CGRect)frame withType:(BOOL)isLoanable
{
    if (self = [super initWithFrame:frame])
    {
        //UI
        [self configureViews];
        [self creatBaseUI:isLoanable];
        [self configureloanableBackgroundView];
        [self configureInputView];
        
        //显隐
        [self showloanableBackgroundView:isLoanable];
        
        //Data
        [self initData];
    }
    return self;
}

#pragma mark 数据填充
- (void)initData
{
    //专属客户经理
    if (global.pcOrderDetailModel.order.customerManagerName) {
        self.salesmanView.rightLabel.textColor = ZSColorListRight;
        self.salesmanView.rightLabel.text = global.pcOrderDetailModel.order.customerManagerName;
        self.salesmanID = global.pcOrderDetailModel.order.customerManager;
    }
    
    //房产评估总价
    if (global.pcOrderDetailModel.agentPrecredit.evaluationAmount) {
        NSString *stringAmount = [NSString stringWithFormat:@"%@",[ZSTool yuanIntoTenThousandYuanWithCount:global.pcOrderDetailModel.agentPrecredit.evaluationAmount WithType:YES]];
        self.totalPriceView.inputTextFeild.text = stringAmount;
    }
    
    //最高可贷额度
    if (global.pcOrderDetailModel.agentPrecredit.maxCreditLimit) {
        NSString *stringAmount = [NSString stringWithFormat:@"%@",[ZSTool yuanIntoTenThousandYuanWithCount:global.pcOrderDetailModel.agentPrecredit.maxCreditLimit WithType:YES]];
        self.maxLoanAmountView.inputTextFeild.text = stringAmount;
    }
    
    //贷款银行
    if (global.pcOrderDetailModel.order.loanBank2) {
        self.loanBankView.rightLabel.textColor = ZSColorListRight;
        self.loanBankView.rightLabel.text = global.pcOrderDetailModel.order.loanBank2;
        self.loanBankID = global.pcOrderDetailModel.order.loanBankId2;
    }
    
    //贷款利率
    if (global.pcOrderDetailModel.order.loanRate) {
        self.loanRateView.inputTextFeild.text = global.pcOrderDetailModel.order.loanRate;
    }
    
    //备注
    if (global.pcOrderDetailModel.agentPrecredit.remark) {
        self.inputTextView.text = global.pcOrderDetailModel.agentPrecredit.remark;
        self.placeholderLabel.hidden = YES;
    }
}

#pragma mark /*------------------------------------------------黑底白底----------------------------------------------------*/
- (void)creatBaseUI:(BOOL)isLoanable
{
    //预授信报告
    self.titleLabel.text = @"预授信报告";
    
    //贷款按钮
    NSArray *arrayName = @[@"可贷款",@"不可贷款"];
    for (int i = 0 ; i < arrayName.count; i++)
    {
        UIButton *loanableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loanableBtn.frame = CGRectMake(GapWidth + (100+GapWidth)*i, self.titleLabel.bottom+10, 100, 30);
        [loanableBtn setTitle:arrayName[i] forState:UIControlStateNormal];
        loanableBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [loanableBtn addTarget:self action:@selector(loanableBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [loanableBtn setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
        [loanableBtn setTitleColor:ZSColorWhite forState:UIControlStateSelected];
        [loanableBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorWhite] forState:UIControlStateNormal];
        [loanableBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forState:UIControlStateSelected];
        loanableBtn.layer.borderWidth = 0.5;
        loanableBtn.layer.borderColor = ZSColorAllNotice.CGColor;
        loanableBtn.layer.masksToBounds = YES;
        loanableBtn.layer.cornerRadius = 15;
        loanableBtn.tag = i+100;
        [self.whiteBackgroundView addSubview:loanableBtn];
        if (isLoanable) {
            if (i == 0) {
                loanableBtn.selected = YES;
                loanableBtn.layer.borderColor = ZSColorRed.CGColor;
            }
        }
        else{
            if (i == 1) {
                loanableBtn.selected = YES;
                loanableBtn.layer.borderColor = ZSColorRed.CGColor;
            }
        }
    }
    
    //背景ScrollView
    self.backgroundScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom+50, ZSWIDTH, self.whiteBackgroundView.height-164-SafeAreaBottomHeight)];
    [self.whiteBackgroundView addSubview:self.backgroundScroll];

    //提交按钮
    [self configureSubmitBtn:@"提交"];
}

- (void)loanableBtnAction:(UIButton *)sender
{
    //页面
    if (sender.tag == 100) {
        [self showloanableBackgroundView:YES];
    }
    else{
        [self showloanableBackgroundView:NO];
    }
    
    //按钮
    if (sender.selected == YES) {
        return;
    }
    
    for (int i = 0 ; i < 2; i++)
    {
        if (sender.tag == i+100) {
            sender.selected = YES;
            sender.layer.borderColor = ZSColorRed.CGColor;
            continue;
        }
        UIButton *btn = (UIButton *)[self.whiteBackgroundView viewWithTag:i+100];
        btn.selected = NO;
        btn.layer.borderColor = ZSColorAllNotice.CGColor;
    }
}

#pragma mark /*-----------------------------------------------可贷款view---------------------------------------------------*/
- (void)configureloanableBackgroundView
{
    self.loanableBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 216+CellHeight)];
    [self.backgroundScroll addSubview:self.loanableBackgroundView];
    
//    //用户资质
//    UILabel *qualificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 0, 100, CellHeight)];
//    qualificationLabel.font = [UIFont systemFontOfSize:14];
//    qualificationLabel.textColor = ZSColorBlack;
//    qualificationLabel.text = @"用户资质";
//    [self.loanableBackgroundView addSubview:qualificationLabel];
//
//    //用户资质按钮
//    NSArray *arrayName = @[@"A类",@"B类",@"C类"];
//    for (int i = 0 ; i < arrayName.count; i++)
//    {
//        UIButton *qualificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        qualificationBtn.frame = CGRectMake(GapWidth + (100+GapWidth)*i, qualificationLabel.bottom, 100, 30);
//        [qualificationBtn setTitle:arrayName[i] forState:UIControlStateNormal];
//        qualificationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [qualificationBtn addTarget:self action:@selector(qualificationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [qualificationBtn setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
//        [qualificationBtn setTitleColor:ZSColorWhite forState:UIControlStateSelected];
//        [qualificationBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorWhite] forState:UIControlStateNormal];
//        [qualificationBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forState:UIControlStateSelected];
//        qualificationBtn.layer.borderWidth = 0.5;
//        qualificationBtn.layer.borderColor = ZSColorAllNotice.CGColor;
//        qualificationBtn.layer.masksToBounds = YES;
//        qualificationBtn.layer.cornerRadius = 15;
//        qualificationBtn.tag = i+1000;
//        [self.loanableBackgroundView addSubview:qualificationBtn];
//    }
    
    //专属客户经理(必填)
    self.salesmanView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withClickAction:@"专属客户经理 *"];
    self.salesmanView.delegate = self;
    [self.loanableBackgroundView addSubview:self.salesmanView];
    
    //申请贷款金额
    NSString *stringAmount = [NSString stringWithFormat:@"%@",[ZSTool yuanIntoTenThousandYuanWithCount:global.pcOrderDetailModel.order.applyLoanAmount WithType:YES]];
    self.loanAmountView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.salesmanView.bottom, ZSWIDTH, CellHeight) withLeftTitle:@"申请贷款金额" withRightTitle:[NSString stringWithFormat:@"%.2f  万元",[stringAmount floatValue]]];
    [self.loanableBackgroundView addSubview:self.loanAmountView];
    
    //房产评估总价
    self.totalPriceView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.loanAmountView.bottom, ZSWIDTH, CellHeight) withInputAction:@"房产评估总价" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad withElement:@"万元"];
    self.totalPriceView.inputTextFeild.delegate = self;
    [self.loanableBackgroundView addSubview:self.totalPriceView];
    
    //最高可贷额度(必填)
    self.maxLoanAmountView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.totalPriceView.bottom, ZSWIDTH, CellHeight) withInputAction:@"最高可贷额度 *" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad withElement:@"万元"];
    self.maxLoanAmountView.inputTextFeild.delegate = self;
    [self.loanableBackgroundView addSubview:self.maxLoanAmountView];
    
    //贷款银行
    self.loanBankView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.maxLoanAmountView.bottom, ZSWIDTH, CellHeight) withClickAction:@"贷款银行"];
    self.loanBankView.delegate = self;
    [self.loanableBackgroundView addSubview:self.loanBankView];

    //贷款利率
    self.loanRateView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.loanBankView.bottom, ZSWIDTH, CellHeight) withInputAction:@"贷款利率" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad withElement:@"%"];
    self.loanRateView.inputTextFeild.delegate = self;
    [self.loanableBackgroundView addSubview:self.loanRateView];
}

#pragma mark 输入框
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
    
    //金额类的0-100000000元,最多两位小数
    if (textField == self.maxLoanAmountView.inputTextFeild || textField == self.totalPriceView.inputTextFeild)
    {
        if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"10000.00" alert:YES]){
            [ZSTool showMessage:@"金额太大了!" withDuration:DefaultDuration];
            return NO;
        }
        if ([toBeString length] > 8) {
            textField.text = [toBeString substringToIndex:8];
            return NO;
        }
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }
    
    //利率类的0-100,最多四位小数
    if (textField == self.loanRateView.inputTextFeild)
    {
        if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"100.0000" alert:YES]){
            [ZSTool showMessage:@"利率太大了!" withDuration:DefaultDuration];
            return NO;
        }
        if ([toBeString length] > 8) {
            textField.text = [toBeString substringToIndex:8];
            return NO;
        }
        return [textField checkTextField:textField WithString:string Range:range numInt:4];
    }
    
    return YES;
}

//#pragma mark 选择用户资质
//- (void)qualificationBtnAction:(UIButton *)sender
//{
//    if (sender.tag == 1000) {
//        self.custQualification = @"1";
//    }
//    else if (sender.tag == 1000 + 1) {
//        self.custQualification = @"2";
//    }
//    else {
//        self.custQualification = @"3";
//    }
//
//    if (sender.selected == YES) {
//        return;
//    }
//
//    for (int i = 0 ; i < 3; i++)
//    {
//        if (sender.tag == i+1000) {
//            sender.selected = YES;
//            sender.layer.borderColor = ZSColorRed.CGColor;
//            continue;
//        }
//        UIButton *btn = (UIButton *)[self.whiteBackgroundView viewWithTag:i+1000];
//        btn.selected = NO;
//        btn.layer.borderColor = ZSColorAllNotice.CGColor;
//    }
//}

#pragma mark 选择专属客户经理/贷款银行
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    //键盘回收
    [self hideKeyboard];
    
    //专属客户经理
    if (view == self.salesmanView)
    {
        if (self.sendPersonArray.count == 0) {
            [ZSTool showMessage:@"暂无可派单人员" withDuration:DefaultDuration];
            return;
        }
        ZSSendOrderPopView *sendView = [[ZSSendOrderPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:self.sendPersonArray];
        sendView.delegate = self;
        [sendView show];
    }
    //贷款银行
    else if (view == self.loanBankView)
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [self.bankDataArray enumerateObjectsUsingBlock:^(ZSBanklistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZSBanklistModel *model = self.bankDataArray[idx];
            [array addObject:model.bankName];
        }];
        
        ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
        pickerView.titleArray = array;
        pickerView.delegate = self;
        [pickerView show];
    }
}

#pragma mark 选择专属客户经理
- (void)selectWithData:(ZSSendOrderPersonModel *)model
{
    self.salesmanView.rightLabel.textColor = ZSColorListRight;
    self.salesmanView.rightLabel.text = model.username;
    self.salesmanID = model.tid;
}

#pragma mark 选择贷款银行 ZSPickerViewDelegate
- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index;
{
    ZSBanklistModel *model = self.bankDataArray[index];
    self.loanBankView.rightLabel.textColor = ZSColorListRight;
    self.loanBankView.rightLabel.text = model.bankName;
    self.loanBankID = model.tid;
}

#pragma mark /*-------------------------------------------------输入框-----------------------------------------------------*/
- (void)configureInputView
{
    //创建输入框
    [self configureInputViewWithFrame:CGRectMake(0, self.loanableBackgroundView.bottom, ZSWIDTH, 244) withString:@"备注"];
    [self.backgroundScroll addSubview:self.inputBgScroll];
    self.inputBgScroll.scrollEnabled = NO;
    
    //重新设置scrollview的滑动范围
    self.backgroundScroll.contentSize = CGSizeMake(0, self.loanableBackgroundView.height + self.inputBgScroll.height);
}

#pragma mark /*-----------------------------------------------提交---------------------------------------------------*/
- (void)submitBtnAction
{
    ZSCreditReportModel *model = [[ZSCreditReportModel alloc]init];
    
    //是否可贷
    model.canLoan = self.canLoan;
    
//    //用户资质
//    if (self.custQualification != nil) {
//        model.custQualification = self.custQualification;
//    }
    
    //可贷的需要传递以下字段
    if ([self.canLoan isEqualToString:@"1"])
    {
        //专属客户经理(必填)
        if (self.salesmanID) {
            model.customerManager = self.salesmanID;
        }
        else{
            [ZSTool showMessage:@"请选择专属客户经理" withDuration:DefaultDuration];
            return;
        }
        
        //房产评估总价
        if (self.totalPriceView.inputTextFeild.text.length) {
            model.evaluationAmount = [ZSTool yuanIntoTenThousandYuanWithCount:self.totalPriceView.inputTextFeild.text WithType:NO];
        }
        //最高可贷金额(必填)
        if (self.maxLoanAmountView.inputTextFeild.text.length)
        {
            NSString *maxString = [ZSTool yuanIntoTenThousandYuanWithCount:self.maxLoanAmountView.inputTextFeild.text WithType:NO];
            NSDecimalNumber *applyLoanAmount = [NSDecimalNumber decimalNumberWithString:global.pcOrderDetailModel.order.applyLoanAmount];
            NSDecimalNumber *maxLoanAmount = [NSDecimalNumber decimalNumberWithString:maxString];
            NSDecimalNumber *numResult = [applyLoanAmount decimalNumberBySubtracting:maxLoanAmount];
            NSString *endStr = [numResult stringValue];
            if (endStr.floatValue < 0){
                [ZSTool showMessage:@"最高可贷金额不能大于申请贷款金额" withDuration:DefaultDuration];
                return;
            }
            model.maxCreditLimit = maxString;
        }
        else
        {
            [ZSTool showMessage:@"请输入最高可贷金额" withDuration:DefaultDuration];
            return;
        }
        //贷款银行
        if (self.loanBankID) {
            model.loanBankId = self.loanBankID;
        }
        //贷款利率
        if (self.loanRateView.inputTextFeild.text.length) {
            model.loanRate = self.loanRateView.inputTextFeild.text;
        }
    }
    
    //备注
    if (self.inputTextView.text.length) {
        model.remark = self.inputTextView.text;
    }
    
    //隐藏弹窗
    [self dismiss];
    
    //代理传值
    if (_delegate && [_delegate respondsToSelector:@selector(sendData:)]){
        [_delegate sendData:model];
    }
}

#pragma mark /*-------------------------------------------------显隐-----------------------------------------------------*/
#pragma mark 可贷view显隐
- (void)showloanableBackgroundView:(BOOL)isLoanable
{
    [self.backgroundScroll setContentOffset:CGPointMake(0, 0)];
    
    if (isLoanable)
    {
        self.loanableBackgroundView.hidden = NO;
        self.inputBgScroll.top = self.loanableBackgroundView.bottom;
        self.canLoan = @"1";
        self.custQualification = nil;
    }
    else
    {
        self.loanableBackgroundView.hidden = YES;
        self.inputBgScroll.top = 0;
        self.canLoan = @"2";
        self.custQualification = @"4";
    }
}

@end
