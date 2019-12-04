//
//  ZSWSLoanMaterialViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ZSWSLoanAmountStyle) {
    ZSWSLoanAmountStyleLoanCategory = 101,       //贷款种类
    ZSWSLoanAmountStyleLoanType,               //还款方式
    ZSWSLoanAmountStyleLoanBanker,             //贷款银行
};

#import "ZSWSLoanMaterialViewController.h"


@interface ZSWSLoanMaterialViewController ()<ZSActionSheetViewDelegate,ZSAlertViewDelegate,ZSPickerViewDelegate>
@property(nonatomic,strong)NSMutableArray *loanCategoryArray; //贷款种类
@property(nonatomic,strong)NSMutableArray *loanTypeArray;     //还款方式
@property(nonatomic,strong)NSMutableArray *loanBankerArray;   //贷款银行
@property(nonatomic,strong)NSMutableArray *loanBankerIDArray; //贷款银行
@property(nonatomic,copy)NSString *loanBankerId;              //银行ID
@property(nonatomic,copy)NSString *bankrCredit;               //是否查询银行征信

@end

@implementation ZSWSLoanMaterialViewController

- (NSMutableArray *)loanCategoryArray
{
    if (_loanCategoryArray == nil){
        _loanCategoryArray = [[NSMutableArray alloc]init];
    }
    return _loanCategoryArray;
}

- (NSMutableArray *)loanTypeArray
{
    if (_loanTypeArray == nil){
        _loanTypeArray = [[NSMutableArray alloc]init];
    }
    return _loanTypeArray;
}

- (NSMutableArray *)loanBankerArray
{
    if (_loanBankerArray == nil){
        _loanBankerArray = [[NSMutableArray alloc]init];
    }
    return _loanBankerArray;
}

- (NSMutableArray *)loanBankerIDArray
{
    if (_loanBankerIDArray == nil){
        _loanBankerIDArray = [[NSMutableArray alloc]init];
    }
    return _loanBankerIDArray;
}

- (void)viewWillLayoutSubviews
{
    self.contractPriceField.inputAccessoryView = [self addToolbar];
    self.loanAmountField.inputAccessoryView = [self addToolbar];
    self.downPaymentField.inputAccessoryView = [self addToolbar];
    self.loanLimitField.inputAccessoryView = [self addToolbar];
    self.loanRateField.inputAccessoryView = [self addToolbar];
    [self.contractPriceField changePlaceholderColor];
    [self.loanAmountField changePlaceholderColor];
    [self.downPaymentField changePlaceholderColor];
    [self.loanLimitField changePlaceholderColor];
    [self.loanRateField changePlaceholderColor];
    self.loanBankerLabel.attributedText = [@"贷款银行" addStar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"按揭贷款资料";
    [self initDatas];
    [self setLeftBarButtonItem];
    [self configuBottomButtonWithTitle:@"保存" OriginY:CellHeight*8 + 15];
    [self setBottomBtnEnable:NO];
    self.bankrCredit = @"0";
    [self displayContent];
}

- (void)initDatas
{
    self.loanTypeArray = @[@"等额本息",@"等额本金"].mutableCopy;
    self.loanCategoryArray = @[@"商业住房贷",@"商用贷",@"纯公积金",@"组合贷（公积金+商业贷款)",@"装修贷"].mutableCopy;
}

#pragma mark 赋值
- (void)displayContent
{
    self.projeftInfo = global.wsOrderDetail.projectInfo;
   
    //合同总价
    NSString *contractAmount = self.projeftInfo.contractAmount.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:self.projeftInfo.contractAmount]] : @"";
    self.contractPriceField.text = contractAmount;

    //贷款金额
    NSString *loanAmount = self.projeftInfo.loanAmount.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:self.projeftInfo.loanAmount]] : @"";
    self.loanAmountField.text    = loanAmount;

    //首付金额
    NSString *payAmount = @"";
    if (self.projeftInfo.contractAmount.length > 0 && self.projeftInfo.loanAmount.length > 0){
        NSString *payString = [ZSTool calculateNumWithTheNum:self.projeftInfo.contractAmount ortherNum:self.projeftInfo.loanAmount];
        payAmount =  payString.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:payString]]: @"";
    }
    self.downPaymentField.text   = payAmount;

    //贷款利率
    NSString *rateAmount = self.projeftInfo.loanRate.length > 0 ? [NSString stringWithFormat:@"%@",self.projeftInfo.loanRate] : @"";
    self.loanRateField.text = rateAmount;
  
    //贷款年限
    if (self.projeftInfo.loanLimit.integerValue > 0){
        self.loanLimitField.text = self.projeftInfo.loanLimit;
    }
  
    //还款方式
    if (self.projeftInfo.loanType.length > 0){
        [self.loanTypeBtn setTitle:self.projeftInfo.loanType forState:UIControlStateNormal];
        [self.loanTypeBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }
 
    //贷款种类
    if (self.projeftInfo.loanCategory.length > 0){
        [self.loanCategoryBtn setTitle:self.projeftInfo.loanCategory forState:UIControlStateNormal];
        [self.loanCategoryBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }
  
    //贷款银行
    if (self.projeftInfo.loanBank.length > 0){
        [self.loanBankerBtn setTitle:self.projeftInfo.loanBank forState:UIControlStateNormal];
        [self.loanBankerBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
        self.loanBankerId = self.projeftInfo.loanBankId;//银行ID赋值
    }
  
    //判断底部按钮
    [self judeBottomBtnEnabled];
}

#pragma mark /*--------------------------------请求数据-------------------------------------------*/
#pragma mark 请求银行数据
- (void)requestBankList
{
    __weak typeof(self) weakSelf  = self;
    [self.loanBankerArray removeAllObjects];
    [self.loanBankerIDArray removeAllObjects];
    NSMutableDictionary *parameterDict = @{
                                           @"projId":global.wsOrderDetail.projectInfo.projId
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getBankListWithProduct] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                global.banklistModel = [ZSBanklistModel yy_modelWithJSON:dict];
                [weakSelf.loanBankerArray addObject:global.banklistModel.bankName];
                [weakSelf.loanBankerIDArray addObject:global.banklistModel.bankId];
            }
             [weakSelf pickerViewShow:ZSWSLoanAmountStyleLoanBanker];
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 编辑项目资料数据
- (void)requestEditOrderData
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[self getEditOrderParameter] url:[ZSURLManager getUpdateOrderDataURL] SuccessBlock:^(NSDictionary *dic) {
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } ErrorBlock:^(NSError *error) {
    }];
}

- (NSMutableDictionary *)getEditOrderParameter
{
    NSMutableDictionary *parameterDict = @{
                                           @"orderNo":global.wsOrderDetail.projectInfo.tid,
                                           @"loanBankId":SafeStr(self.loanBankerId),
                                           @"bankrCredit":self.bankrCredit
                                           }.mutableCopy;
    //合同总价
    if (self.contractPriceField.text.length > 0){
        [parameterDict setValue: self.contractPriceField.text forKey:@"contractAmount"];
    }
    //贷款金额
    if (self.loanAmountField.text.length > 0){
        [parameterDict setValue:self.loanAmountField.text forKey:@"loanAmount"];
    }
    //首付金额
    if (self.downPaymentField.text.length > 0){
        [parameterDict setValue:self.downPaymentField.text forKey:@"downpayAmount"];
    }
    //贷款期限
    if (self.loanLimitField.text.length > 0){
        [parameterDict setValue:self.loanLimitField.text forKey: @"loanLimit"];
    }
    //贷款利率
    if (self.loanRateField.text.length > 0){
        [parameterDict setValue:self.loanRateField.text forKey: @"loanRate"];
    }
    //还款方式
    if (![[self.loanTypeBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
        [parameterDict setValue:[self.loanTypeBtn titleForState:UIControlStateNormal] forKey:@"loanType"];
    }
    //贷款种类
    if (![[self.loanCategoryBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
        [parameterDict setValue:[self.loanCategoryBtn titleForState:UIControlStateNormal] forKey:@"loanCategory"];
    }
//    ZSLOG(@"%@",SafeStr(self.loanBankerId));
//    ZSLOG(@"%@",parameterDict);
    return parameterDict;
}

#pragma mark -----------TextfieldDelegate-----------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.contractPriceField || textField == self.loanAmountField) {//利率(只允许保留2位小数)
        if (textField.text.length == 0){
            self.downPaymentField.text = @"";
        }
       return  [self calculateDownPayment:YES];
    }
     return YES;
}

#pragma mark /*--------------------------------textfield-------------------------------------------*/
#pragma mark textField--限制输入的字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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
    
    //贷款金额、合同总价、首付金额、 放款金额限制最大100000000.00元，最多两位小数
    if (textField == self.contractPriceField || textField == self.loanAmountField){
        if (toBeString.length > 0){
            if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:KMaxAmount alert:YES]){
                [ZSTool showMessage:@"金额太大了! " withDuration:DefaultDuration];
                return NO;
            }
            if ([toBeString length] > 12) {
                textField.text = [toBeString substringToIndex:12];
                return NO;
            }
        }
    }
    //合同总价和贷款金额只能保留两位小数
    if (textField == self.contractPriceField || textField == self.loanAmountField) {//利率(只允许保留2位小数)
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }
    
    //贷款年限限制最大100年
    if (textField == self.loanLimitField){
        if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"100" alert:YES]){
            [ZSTool showMessage:@"年份超过最大限制了！" withDuration:DefaultDuration];
            return NO;
        }
        if ([toBeString length] > 3) {
            textField.text = [toBeString substringToIndex:3];
            return NO;
        }
    }

    //贷款利率限制最大100.0000%,最多4位小数
    if (textField == self.loanRateField){
        if (toBeString.length > 0) {
            if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"100.00" alert:YES]){
                [ZSTool showMessage:@"超过最大限制了！" withDuration:DefaultDuration];
                return NO;
            }
            if ([toBeString length] > 8) {
                textField.text = [toBeString substringToIndex:8];
                return NO;
            }
        }
    }
    //贷款利率保留四位小数
    if (textField == self.loanRateField){//利率(只允许保留4位小数)
        return [textField checkTextField:textField WithString:string Range:range numInt:4];
    }
    return YES;
}

#pragma mark /*--------------------------------点击事件-------------------------------------------*/
#pragma mark 还款方式
- (IBAction)loanModeBtnClick:(UIButton *)sender
{
    [self hideKeyboard];
    [self actionSheetViewShow:ZSWSLoanAmountStyleLoanCategory];
}

#pragma mark 贷款种类
- (IBAction)loanTypeBtnClick:(UIButton *)sender
{
    [self hideKeyboard];
    [self pickerViewShow:ZSWSLoanAmountStyleLoanType];
}

#pragma mark 贷款银行
- (IBAction)loanBankerBtnClick:(UIButton *)sender
{
    [self hideKeyboard];
    [self requestBankList];
}

#pragma mark sheetView 弹框
- (void)actionSheetViewShow:(NSInteger)tag
{
    if (tag == ZSWSLoanAmountStyleLoanCategory){
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:self.loanTypeArray];
        actionsheet.tag = ZSWSLoanAmountStyleLoanCategory;
        actionsheet.delegate = self;
        [actionsheet show:self.loanTypeArray.count];
    }
}

#pragma mark ZSActionSheetViewDelegate
//按钮响应事件,需重写
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag
{
    if (sheetView.tag == ZSWSLoanAmountStyleLoanCategory){
        [self.loanTypeBtn setTitle:self.loanTypeArray[tag] forState:UIControlStateNormal];
    }
}

#pragma mark pickerView 弹框
- (void)pickerViewShow:(NSInteger)tag
{
    switch (tag) {
        case ZSWSLoanAmountStyleLoanType:{
            ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
            pickerView.titleArray = self.loanCategoryArray;
            pickerView.tag = ZSWSLoanAmountStyleLoanType;
            pickerView.delegate = self;
            [pickerView show];
        }
            break;
        case ZSWSLoanAmountStyleLoanBanker:{
            ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
            pickerView.titleArray = self.loanBankerArray;
            pickerView.tag = ZSWSLoanAmountStyleLoanBanker;
            pickerView.delegate = self;
            [pickerView show];
        }
            break;
        default:
            break;
    }
}

#pragma mark ZSPickerViewDelegate
- (void)pickerView:(ZSPickerView *)sheetView didSelectIndex:(NSInteger)index
{
    switch (sheetView.tag) {
        case ZSWSLoanAmountStyleLoanType:{
            [self.loanCategoryBtn setTitle:self.loanCategoryArray[index] forState:UIControlStateNormal];
        }
            break;
        case ZSWSLoanAmountStyleLoanBanker:{
            [self.loanBankerBtn setTitle:self.loanBankerArray[index] forState:UIControlStateNormal];
            self.loanBankerId = self.loanBankerIDArray[index];
            [self judeBottomBtnEnabled];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark /*--------------------------------底部按钮-------------------------------------------*/
#pragma mark 底部按钮点击事件
- (void)bottomClick:(UIButton *)sender
{
    if (self.contractPriceField.text.floatValue == 0 && self.contractPriceField.text.length > 0){
        [ZSTool showMessage:@"合同总额不能为0" withDuration:DefaultDuration];
        return;
    }
    if (self.loanAmountField.text.floatValue == 0 && self.loanAmountField.text.length > 0){
        [ZSTool showMessage:@"贷款金额不能为0" withDuration:DefaultDuration];
        return;
    }
    if (![self calculateDownPayment:NO]) {
        return;
    }
    if ([self.loanLimitField.text containsString:@"."]){
        [ZSTool showMessage:@"贷款年限不能为小数" withDuration:DefaultDuration];
        return;
    }

    if (![[self.loanBankerBtn titleForState:UIControlStateNormal]isEqualToString:self.self.projeftInfo.loanBank]){
        [self showAlertView];
    }else{
        self.bankrCredit = @"0";
        [self requestEditOrderData];
    }
}

#pragma mark 银行改变的弹窗
- (void)showAlertView
{
    ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"贷款银行出现变更，是否重新查询征信?" sureTitle:@"查询" cancelTitle:@"不查询"];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark ZSAlertViewDelegate
//确认按钮触发的方法
- (void)AlertView:(ZSAlertView *)alert
{
    self.bankrCredit = @"1";
    [self requestEditOrderData];
}

//取消按钮响应时间
- (void)AlertViewCanCleClick:(ZSAlertView *)alert
{
    self.bankrCredit = @"0";
    [self requestEditOrderData];
}

#pragma mark 判断底部按钮是否可以点击
- (void)judeBottomBtnEnabled
{
    if (![[self.loanBankerBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]) {
        [self setBottomBtnEnable:YES];

    }else {
        [self setBottomBtnEnable:NO];
    }
}

#pragma mark 计算首付金额
- (BOOL)calculateDownPayment:(BOOL)isAlert
{
    if ([self.contractPriceField.text floatValue] >= 0 &&self.contractPriceField.text.length > 0 && [self.loanAmountField.text floatValue] >= 0 && self.loanAmountField.text.length > 0){
        NSDecimalNumber *numberBaseRate = [NSDecimalNumber decimalNumberWithString:self.contractPriceField.text];
        NSDecimalNumber *numberRateEnd = [NSDecimalNumber decimalNumberWithString:self.loanAmountField.text];
        /// 这里不仅包含Multiply还有加 减 除。
        NSDecimalNumber *numResult = [numberBaseRate decimalNumberBySubtracting:numberRateEnd];
        NSString *endStr = [numResult stringValue];
        if (endStr.floatValue < 0){
            self.downPaymentField.text = [NSString stringWithFormat:@"%@",endStr];
            if (isAlert){
                return YES;
            }else{
                [ZSTool showMessage:@"贷款金额不得高于合同总价" withDuration:DefaultDuration];
                return NO;
            }
        }else{
            self.downPaymentField.text = [NSString stringWithFormat:@"%@",endStr];
            return YES;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
 

@end
