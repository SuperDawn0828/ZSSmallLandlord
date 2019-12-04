//
//  ZSSLAddLoanMaterialViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//



#import "ZSSLAddLoanMaterialViewController.h"
#import "ZSSLAddHouseMaterialViewController.h"
#import "ZSStarLoanPageController.h"
#import "ZSLoanBankModel.h"
#import "ZSMonthlyPaymentsPopView.h"

@interface ZSSLAddLoanMaterialViewController ()<ZSActionSheetViewDelegate,ZSAlertViewDelegate,ZSPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel     *loanBankerLabel;   //贷款银行
@property (weak, nonatomic) IBOutlet UIButton    *loanBankBtn;
@property (weak, nonatomic) IBOutlet UITextField *contractPriceField;//合同总价
@property (weak, nonatomic) IBOutlet UITextField *loanAmountField;   //贷款金额
@property (weak, nonatomic) IBOutlet UITextField *downPaymentField;  //首付金额
@property (weak, nonatomic) IBOutlet UITextField *loanLimitField;    //贷款年限
@property (weak, nonatomic) IBOutlet UITextField *loanRateField;     //贷款利率
@property (weak, nonatomic) IBOutlet UIButton    *loanTypeBtn;       //还款方式
@property (weak, nonatomic) IBOutlet UIButton    *loanCategoryBtn;   //贷款种类
@property (weak, nonatomic) IBOutlet UIButton    *monthlyPaymentsBtn;//预计月供
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopContraint;//距上高度

@property(nonatomic,strong)NSMutableArray *loanCategoryArray;     //贷款种类
@property(nonatomic,strong)NSMutableArray *loanTypeArray;         //还款方式
@property(nonatomic,strong)NSMutableArray *loanBankNameArray;     //贷款银行
@property(nonatomic,strong)NSMutableArray *loanBankIDArray;       //贷款银行id
@property(nonatomic,copy  )NSString       *currentLoanBankID;     //贷款银行id
@end

@implementation ZSSLAddLoanMaterialViewController

- (NSMutableArray *)loanCategoryArray
{
    if (_loanCategoryArray == nil){
        _loanCategoryArray = [[NSMutableArray alloc]initWithObjects:@"商业住房贷",@"商用贷",@"纯公积金",@"组合贷（公积金+商业贷款)",@"装修贷", nil];
    }
    return _loanCategoryArray;
}

- (NSMutableArray *)loanTypeArray
{
    if (_loanTypeArray == nil){
        _loanTypeArray = [[NSMutableArray alloc]initWithObjects:@"等额本息",@"等额本金",nil];
    }
    return _loanTypeArray;
}

- (NSMutableArray *)loanBankNameArray
{
    if (_loanBankNameArray == nil){
        _loanBankNameArray = [[NSMutableArray alloc]init];
    }
    return _loanBankNameArray;
}

- (NSMutableArray *)loanBankIDArray
{
    if (_loanBankIDArray == nil){
        _loanBankIDArray = [[NSMutableArray alloc]init];
    }
    return _loanBankIDArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];
    [self reSetBottomBtnFrameByFormType]; //据来源展示底部按钮
    //Data
    [self requestLoanBankData];//请求贷款银行列表
    [self displayContent];//填充数据
}

- (void)viewWillLayoutSubviews
{
    //添加完成按钮
    self.contractPriceField.inputAccessoryView  = [self addToolbar];
    self.loanAmountField.inputAccessoryView     = [self addToolbar];
    self.downPaymentField.inputAccessoryView    = [self addToolbar];
    self.loanLimitField.inputAccessoryView      = [self addToolbar];
    self.loanRateField.inputAccessoryView       = [self addToolbar];
    //颜色
    self.contractPriceField.textColor  = ZSColorListRight;
    self.loanAmountField.textColor     = ZSColorListRight;
    self.downPaymentField.textColor    = ZSColorListRight;
    self.loanLimitField.textColor      = ZSColorListRight;
    self.loanRateField.textColor       = ZSColorListRight;
    //改变placeholder颜色
    [self.contractPriceField  changePlaceholderColor];
    [self.loanAmountField     changePlaceholderColor];
    [self.downPaymentField    changePlaceholderColor];
    [self.loanLimitField      changePlaceholderColor];
    [self.loanRateField       changePlaceholderColor];
    
    //设置必填项
    self.loanBankerLabel.attributedText = [@"贷款银行" addStar];
}

#pragma mark 返回
- (void)goBackAntion
{
    NSArray *array = self.navigationController.viewControllers;
    //第二个页面是抵押贷订单列表页
    if ([array[1] isKindOfClass:[ZSStarLoanPageController class]]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else {
        //首页
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
}

#pragma mark 根据来源展示底部按钮
- (void)reSetBottomBtnFrameByFormType
{
    [self.tableView removeFromSuperview];
    //来自创建订单则展示顶部视图，否则不展示（来自订单创建，没有必填项，底部按钮一直可点击）
    if ([self.orderState isEqualToString:@"暂存"])
    {
        self.title = @"创建订单";
        self.view_top.hidden = NO;
        //判断顶部图片展示
        [self.view_progress setImgViewWithProduct:self.prdType withIndex:ZSCreatOrderStyleLoan];
        [self.view addSubview:self.view_top];
        //居上高度
        self.viewTopContraint.constant = viewTopHeight;
        [self configuBottomButtonWithTitle:@"下一步"];//底部按钮
    }
    else {
        self.title = @"按揭贷款信息";
        self.view_top.hidden = YES;
        [self configuBottomButtonWithTitle:@"保存"];//底部按钮
        [self setBottomBtnEnable:NO];
    }
}

#pragma mark 赋值
- (void)displayContent
{
    SpdOrder *model = [self.prdType isEqualToString:kProduceTypeStarLoan] ? global.slOrderDetails.spdOrder : global.abOrderDetails.insteadOrder;
   
    //贷款银行
    if (model.loanBank2.length > 0){
        [self.loanBankBtn setTitle:model.loanBank2 forState:UIControlStateNormal];
        [self.loanBankBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
        self.currentLoanBankID = model.loanBankId2;
    }
   
    //合同总价
    NSString *contractAmount = model.contractAmount.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:model.contractAmount]] : @"";
    self.contractPriceField.text = contractAmount;
    
    //贷款金额
    NSString *loanAmount = model.loanAmount.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:model.loanAmount]] : @"";
    self.loanAmountField.text = loanAmount;

    //首付金额
    NSString *payAmount = @"";
    if (model.contractAmount.length > 0 && model.loanAmount.length > 0){
        NSString *payString = [ZSTool calculateNumWithTheNum:model.contractAmount ortherNum:model.loanAmount];
        payAmount =  payString.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:payString]]: @"";
    }
    self.downPaymentField.text = payAmount;
 
    //贷款年限
    if (model.loanLimit.length > 0){
        self.loanLimitField.text = model.loanLimit;
    }else{
        self.loanLimitField.text = @"";
    }
    
    //贷款利率
    NSString *rateAmount = model.loanRate.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:model.loanRate WithDigits:4]] : @"";
    self.loanRateField.text = rateAmount;
 
    //还款方式
    if (model.loanType.length > 0){
        [self.loanTypeBtn setTitle:model.loanType forState:UIControlStateNormal];
        [self.loanTypeBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }

    //贷款种类
    if (model.loanCategory.length > 0){
        [self.loanCategoryBtn setTitle:model.loanCategory forState:UIControlStateNormal];
        [self.loanCategoryBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }

    //底部按钮判断
    [self checkBottomBtnEnabled];
}

#pragma mark 获取贷款银行列表
- (void)requestLoanBankData
{
    [self.loanBankNameArray removeAllObjects];
    [self.loanBankIDArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"prdType":self.prdType
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getLoanBankListURL] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSLoanBankListModel *model = [ZSLoanBankListModel yy_modelWithJSON:dict];
                [weakSelf.loanBankNameArray addObject:model.bankName];
                [weakSelf.loanBankIDArray addObject:model.tid];
            }
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 预计月供接口
- (void)requestMonthPayData
{
    [LSProgressHUD show];
    [ZSRequestManager requestWithParameter:[self getEditOrderParameter:NO] url:[ZSURLManager getQueryRepayDetailsURL] SuccessBlock:^(NSDictionary *dic) {
        NSDictionary *ndict = dic[@"respData"];
        NSArray *array = ndict[@"repayDetails"];
        if (array.count > 0)
        {
            ZSMonthlyPaymentsModel *model = [ZSMonthlyPaymentsModel yy_modelWithDictionary:ndict];
            ZSMonthlyPaymentsPopView *monthPayView = [[ZSMonthlyPaymentsPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withModel:model];
            [monthPayView show];
        }
        else
        {
            [ZSTool showMessage:@"暂无数据" withDuration:DefaultDuration];
        }
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 删除订单接口
- (void)requestForCloseOrderData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                           @"prdType":self.prdType
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getDeleteOrderOfNoSubmitURL] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //提示
        [ZSTool showMessage:@"删除成功" withDuration:DefaultDuration];
        [weakSelf goBackAntion]; //返回
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 编辑按揭贷款信息接口
//是否来自创建订单返回上一界面（goBack是）
- (void)requestEditOrderData:(BOOL)isGoBack
{
    //点击返回按钮不转圈 点击下一步转圈
    if (!isGoBack){
        [LSProgressHUD showWithMessage:@"加载中"];
    }
    __weak typeof(self) weakSelf = self;
    NSString *urlString;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        urlString = [ZSURLManager getSpdUpdateMortgageInfoURL];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        urlString = [ZSURLManager getAngencyBusinessUpdateMortgageInfoURL];
    }
    [ZSRequestManager requestWithParameter:[self getEditOrderParameter:YES] url:urlString SuccessBlock:^(NSDictionary *dic) {
        //1.如果来自创建订单则调提交订单接口，若来自详情则返回上一页面
        if ([self.orderState isEqualToString:@"暂存"]) {
            //存值
            //星速贷
            if ([self.prdType isEqualToString:kProduceTypeStarLoan])
            {
                global.slOrderDetails = [ZSSLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            }
            //代办业务
            else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
            {
                global.abOrderDetails = [ZSABOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            }
            //1.1返回按钮
            if (isGoBack) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                //1.2(底部按钮）房产信息编辑
                ZSSLAddHouseMaterialViewController *vc = [[ZSSLAddHouseMaterialViewController alloc]init];
                vc.orderState = @"暂存";
                vc.prdType = self.prdType;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }else {
            //2.来自订单详情 返回上一页面
            //刷新订单详情
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
            //刷新订单列表
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

- (NSMutableDictionary *)getEditOrderParameter:(BOOL)isEditor
{
    NSMutableDictionary *parameterDict = @{}.mutableCopy;
    //贷款金额
    if (self.loanAmountField.text.length > 0){
        [parameterDict setValue:self.loanAmountField.text forKey:@"loanAmount"];
    }
    //贷款年限
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
    //贷款银行
    if (![[self.loanBankBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
        [parameterDict setValue:[self.loanBankBtn titleForState:UIControlStateNormal] forKey:@"loanBank"];
    }
    if (self.currentLoanBankID.length > 0) {
        [parameterDict setValue:self.currentLoanBankID forKey: @"loanBankId"];
    }
    
    if (isEditor == YES)
    {
        //订单号
        [parameterDict setValue:self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType] forKey:@"orderNo"];
        //合同总价
        if (self.contractPriceField.text.length > 0){
            [parameterDict setValue: self.contractPriceField.text forKey:@"contractAmount"];
        }
        //首付金额
        if (self.downPaymentField.text.length > 0){
            [parameterDict setValue:self.downPaymentField.text forKey:@"downpayAmount"];
        }
        //贷款种类
        if (![[self.loanCategoryBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
            [parameterDict setValue:[self.loanCategoryBtn titleForState:UIControlStateNormal] forKey:@"loanCategory"];
        }
    }
    else
    {
        [parameterDict setValue:self.prdType forKey:@"prdType"];
    }
    return parameterDict;
}

#pragma mark TextfieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.contractPriceField || textField == self.loanAmountField) {
        if (textField.text.length == 0){
            self.downPaymentField.text = @"";
        }
        return  [self calculateDownPayment:YES];
    }
    return YES;
}

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
    
    //贷款金额、合同总价、首付金额、 放款金额限制最大100000000.00元，最多两位小数
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
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
    if (textField == self.contractPriceField || textField == self.loanAmountField) {
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }
    //贷款年限限制最大100年
    if (textField == self.loanLimitField) {
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

#pragma mark 贷款银行
- (IBAction)loanBankClick:(UIButton *)sender
{
    [self hideKeyboard];
    //贷款银行
    if (sender == self.loanBankBtn)
    {
        if (self.loanBankNameArray.count > 0)
        {
            ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
            pickerView.titleArray = self.loanBankNameArray;
            pickerView.tag = 103;
            pickerView.delegate = self;
            [pickerView show];
        }
        else
        {
            [self requestLoanBankData];
        }
    }
    //还款方式
    else if (sender == self.loanTypeBtn)
    {
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:self.loanTypeArray];
        actionsheet.delegate = self;
        [actionsheet show:self.loanTypeArray.count];
    }
    //贷款种类
    else if (sender == self.loanCategoryBtn)
    {
        ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        pickerView.titleArray = self.loanCategoryArray;
        pickerView.tag = 102;
        pickerView.delegate = self;
        [pickerView show];
    }
    //预计月供
    else if (sender == self.monthlyPaymentsBtn)
    {
        [self requestMonthPayData];//请求月供接口
    }
}

#pragma mark ZSActionSheetViewDelegate
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag
{
    [self.loanTypeBtn setTitle:self.loanTypeArray[tag] forState:UIControlStateNormal];
    [self.loanTypeBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
}

#pragma mark ZSPickerViewDelegate
- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index;
{
    if (pickerView.tag == 102)
    {
        [self.loanCategoryBtn setTitle:self.loanCategoryArray[index] forState:UIControlStateNormal];
        [self.loanCategoryBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }
    else if (pickerView.tag == 103)
    {
        [self.loanBankBtn setTitle:self.loanBankNameArray[index] forState:UIControlStateNormal];
        [self.loanBankBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
        self.currentLoanBankID = self.loanBankIDArray[index];
    }
    
    //判断底部按钮是否可点击
    [self checkBottomBtnEnabled];
}

#pragma mark 底部按钮点击事件
- (void)bottomClick:(UIButton *)sender
{
    //贷款银行不能为空
    if ([[self.loanBankBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
        [ZSTool showMessage:@"请选择贷款银行" withDuration:DefaultDuration];
        return;
    }
    if (self.contractPriceField.text.floatValue == 0 && self.contractPriceField.text.length > 0){
        [ZSTool showMessage:@"合同总额不能为0" withDuration:DefaultDuration];
        return;
    }
    if (self.loanAmountField.text.floatValue == 0 && self.loanAmountField.text.length > 0){
        [ZSTool showMessage:@"贷款金额不能为0" withDuration:DefaultDuration];
        return;
    }
    if (self.loanLimitField.text.floatValue == 0 && self.loanLimitField.text.length > 0){
        [ZSTool showMessage:@"贷款年限不能为0" withDuration:DefaultDuration];
        return;
    }
    //计算首付金额
    if (![self calculateDownPayment:NO]) {
        return;
    }
    if ([self.loanLimitField.text containsString:@"."]){
        [ZSTool showMessage:@"贷款年限不能为小数" withDuration:DefaultDuration];
        return;
    }
    //请求数据接口
    [self requestEditOrderData:NO];
}

#pragma mark 判断底部按钮是否可以点击
- (void)checkBottomBtnEnabled
{
    if (![[self.loanBankBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
        [self setBottomBtnEnable:YES];
    }else {
        [self setBottomBtnEnable:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end