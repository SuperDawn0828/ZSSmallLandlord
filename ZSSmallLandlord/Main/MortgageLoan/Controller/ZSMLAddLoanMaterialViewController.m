//
//  ZSMLAddLoanMaterialViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/7/31.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSMLAddLoanMaterialViewController.h"
#import "ZSSLAddHouseMaterialViewController.h"
#import "ZSStarLoanPageController.h"
#import "ZSLoanBankModel.h"
#import "ZSMonthlyPaymentsPopView.h"

@interface ZSMLAddLoanMaterialViewController ()<ZSActionSheetViewDelegate,ZSPickerViewDelegate>
@property (nonatomic,weak  ) IBOutlet UILabel            *loanBankerLabel;   //贷款银行
@property (nonatomic,weak  ) IBOutlet UIButton           *loanBankBtn;
@property (nonatomic,weak  ) IBOutlet UITextField        *loanAmountField;   //贷款金额
@property (nonatomic,weak  ) IBOutlet UITextField        *loanLimitField;    //贷款年限
@property (nonatomic,weak  ) IBOutlet UITextField        *loanRateField;     //贷款利率
@property (nonatomic,weak  ) IBOutlet UIButton           *loanTypeBtn;       //还款方式
@property (weak, nonatomic ) IBOutlet UIButton           *monthlyPaymentsBtn;//预计月供
@property (nonatomic,weak  ) IBOutlet NSLayoutConstraint *viewTopContraint;  //距上高度
@property (nonatomic,strong) NSMutableArray              *loanTypeArray;
@property (nonatomic,strong) NSMutableArray              *loanBankNameArray;
@property (nonatomic,strong) NSMutableArray              *loanBankIDArray;
@property (nonatomic,copy  ) NSString                    *currentLoanBankID;
@end

@implementation ZSMLAddLoanMaterialViewController

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

- (void)viewWillLayoutSubviews
{
    //添加完成按钮
    self.loanAmountField.inputAccessoryView     = [self addToolbar];
    self.loanLimitField.inputAccessoryView      = [self addToolbar];
    self.loanRateField.inputAccessoryView       = [self addToolbar];
   
    //颜色
    self.loanAmountField.textColor     = ZSColorListRight;
    self.loanLimitField.textColor      = ZSColorListRight;
    self.loanRateField.textColor       = ZSColorListRight;
  
    //改变placeholder颜色
    [self.loanAmountField     changePlaceholderColor];
    [self.loanLimitField      changePlaceholderColor];
    [self.loanRateField       changePlaceholderColor];
    
    //必填项
    self.loanBankerLabel.attributedText = [@"贷款银行" addStar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];
    [self reSetBottomBtnFrameByFormType];//根据来源展示底部按钮
    //Data
    [self requestLoanBankData];//获取贷款银行列表
    [self displayContent];  //填充数据
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
    //是否来自订单创建
    if ([self.orderState isEqualToString:@"暂存"])
    {
        self.title = @"创建订单";
        self.view_top.hidden = NO;
        //判断顶部图片展示
        [self.view_progress setImgViewWithProduct:kProduceTypeMortgageLoan withIndex:ZSCreatOrderStyleLoan];
        [self.view addSubview:self.view_top];
        self.viewTopContraint.constant = viewTopHeight;
        [self configuBottomButtonWithTitle:@"下一步"];//底部按钮
    }
    else
    {
        self.title = @"按揭贷款信息";
        self.view_top.hidden = YES;
        [self configuBottomButtonWithTitle:@"保存"];//底部按钮
        [self setBottomBtnEnable:NO];
    }
}

#pragma mark 赋值
- (void)displayContent
{
    SpdOrder *model = global.mlOrderDetails.dydOrder;
    
    //贷款银行
    if (model.loanBank2.length > 0){
        [self.loanBankBtn setTitle:model.loanBank2 forState:UIControlStateNormal];
        [self.loanBankBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
        self.currentLoanBankID = model.loanBankId2;
    }
    
    //贷款金额
    NSString *loanAmount = model.loanAmount.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:model.loanAmount]] : @"";
    self.loanAmountField.text = loanAmount;
  
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
                                           @"prdType":kProduceTypeMortgageLoan
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getLoanBankListURL] SuccessBlock:^(NSDictionary *dic) {
        //        ZSLOG(@"获取银行成功:%@",dic);
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
                                           @"orderId":global.mlOrderDetails.dydOrder.tid,
                                           @"prdType":kProduceTypeMortgageLoan
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getDeleteOrderOfNoSubmitURL] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //提示
        [ZSTool showMessage:@"删除成功" withDuration:DefaultDuration];
        [weakSelf goBackAntion];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 编辑按揭贷款信息接口 
//是否来自创建订单返回上一界面（goBack是）
- (void)requestEditOrderData:(BOOL)isGoBack
{
    __weak typeof(self) weakSelf = self;
    //点击返回按钮不转圈 点击下一步转圈
    if (!isGoBack){
        [LSProgressHUD showWithMessage:@"加载中"];
    }
    [ZSRequestManager requestWithParameter:[weakSelf getEditOrderParameter:YES] url:[ZSURLManager getMortgageLoanUpdateMortgageInfoURL] SuccessBlock:^(NSDictionary *dic) {
        [LSProgressHUD hide];
        //下一个界面
        [weakSelf goToNextController:isGoBack dictionary:dic];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 跳下一个界面
- (void)goToNextController:(BOOL)isGoBack dictionary:(NSDictionary *)dic
{
    //来源创建订单  跳转下一个页面
    if ([self.orderState isEqualToString:@"暂存"]) {
        //详情数据存值
        global.mlOrderDetails = [ZSMLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
        //点击返回按钮的时候
        if (isGoBack){
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            //人员列表页面
            ZSSLAddHouseMaterialViewController *vc = [[ZSSLAddHouseMaterialViewController alloc]init];
            vc.orderState = @"暂存";
            vc.prdType = self.prdType;
            //存值
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else  {
        //刷新订单详情
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        //刷新订单列表
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    }
    else
    {
        [parameterDict setValue:self.prdType forKey:@"prdType"];
    }

    return parameterDict;
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
    if (textField == self.loanAmountField){
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
    if (textField == self.loanAmountField) {
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

#pragma mark /*--------------------------------点击事件-------------------------------------------*/
#pragma mark 选择贷款银行/还款方式
- (IBAction)selectBtnClick:(UIButton *)sender
{
    [self hideKeyboard];
    //贷款银行
    if (sender == self.loanBankBtn)
    {
        if (self.loanBankNameArray.count > 0) {
            ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
            pickerView.titleArray = self.loanBankNameArray;
            pickerView.delegate = self;
            [pickerView show];
        }
        else{
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

    //底部按钮判断
    [self checkBottomBtnEnabled];
}

#pragma mark ZSPickerViewDelegate
- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index;
{
    [self.loanBankBtn setTitle:self.loanBankNameArray[index] forState:UIControlStateNormal];
    [self.loanBankBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    self.currentLoanBankID = self.loanBankIDArray[index];
    
    //底部按钮判断
    [self checkBottomBtnEnabled];
}

#pragma mark /*--------------------------------底部按钮-------------------------------------------*/
#pragma mark 底部按钮点击事件
- (void)bottomClick:(UIButton *)sender
{
    //贷款银行不能为空
    if ([[self.loanBankBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
        [ZSTool showMessage:@"请选择贷款银行" withDuration:DefaultDuration];
        return;
    }
    //贷款金额不能为0
    if (self.loanAmountField.text.floatValue == 0 && self.loanAmountField.text.length > 0){
        [ZSTool showMessage:@"贷款金额不能为0" withDuration:DefaultDuration];
        return;
    }
    //贷款年限不能为0
    if (self.loanLimitField.text.floatValue == 0 && self.loanLimitField.text.length > 0){
        [ZSTool showMessage:@"贷款年限不能为0" withDuration:DefaultDuration];
        return;
    }
    if ([self.loanLimitField.text containsString:@"."]){
        [ZSTool showMessage:@"贷款年限不能为小数" withDuration:DefaultDuration];
        return;
    }
    //请求接口
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
