//
//  ZSRFAddLoanMaterialViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/7/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSRFAddLoanMaterialViewController.h"
#import "ZSSLAddHouseMaterialViewController.h"
#import "ZSAlertView.h"
#import "ZSStarLoanPageController.h"

@interface ZSRFAddLoanMaterialViewController ()<ZSPickerViewDelegate,ZSActionSheetViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel            *amountSourceLabel;     //资金来源
@property (weak, nonatomic) IBOutlet UIButton           *amountSourceBtn;
@property (weak, nonatomic) IBOutlet UILabel            *loanBankLabel;         //贷款银行
@property (weak, nonatomic) IBOutlet UIButton           *loanBankBtn;
@property (weak, nonatomic) IBOutlet UITextField        *applyForAmountField;   //贷款金额
@property (weak, nonatomic) IBOutlet UITextField        *loanRateField;         //贷款利率
@property (weak, nonatomic) IBOutlet UIButton           *loanTypoBtn;           //还款方式
@property (weak, nonatomic) IBOutlet UITextField        *loanBankerField;       //原按揭银行
@property (weak, nonatomic) IBOutlet UITextField        *remainAmountField;     //按揭剩余应还
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopContraint;      //距上高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loanBankViewHeight;    //贷款银行view的高度
@property (nonatomic,strong)NSMutableArray              *amountSourceArray;
@property (nonatomic,strong)NSMutableArray              *loanBankNameArray;
@property (nonatomic,strong)NSMutableArray              *loanBankIDArray;
@property (nonatomic,strong)NSMutableArray              *loanTypeArray;
@property (nonatomic,copy  )NSString                    *currentLoanBankID;
@end

@implementation ZSRFAddLoanMaterialViewController

- (NSMutableArray *)amountSourceArray
{
    if (_amountSourceArray == nil){
        _amountSourceArray = [[NSMutableArray alloc]initWithObjects:@"银行资金",@"自有资金",nil];
    }
    return _amountSourceArray;
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
    if (_loanBankIDArray == nil) {
        _loanBankIDArray = [[NSMutableArray alloc]init];
    }
    return _loanBankIDArray;
}

- (NSMutableArray *)loanTypeArray
{
    if (_loanTypeArray == nil){
        _loanTypeArray = [[NSMutableArray alloc]initWithObjects:@"等额本息",@"等额本金",nil];
    }
    return _loanTypeArray;
}

- (void)viewWillLayoutSubviews
{
    //添加完成按钮
    self.applyForAmountField.inputAccessoryView  = [self addToolbar];
    self.loanRateField.inputAccessoryView        = [self addToolbar];
    self.loanBankerField.inputAccessoryView      = [self addToolbar];
    self.remainAmountField.inputAccessoryView    = [self addToolbar];
  
    //颜色
    self.applyForAmountField.textColor = ZSColorListRight;
    self.loanRateField.textColor       = ZSColorListRight;
    self.loanBankerField.textColor     = ZSColorListRight;
    self.remainAmountField.textColor   = ZSColorListRight;
  
    //改变placeholder颜色
    [self.applyForAmountField   changePlaceholderColor];
    [self.loanRateField         changePlaceholderColor];
    [self.loanBankerField       changePlaceholderColor];
    [self.remainAmountField     changePlaceholderColor];
    
    //必填项
    self.amountSourceLabel.attributedText = [@"资金来源" addStar];
    self.loanBankLabel.attributedText = [@"贷款银行" addStar];
    
    //页面布局
    [self reSetLoanBankView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];
    [self reSetBottomBtnFrameByFormType];//根据来源展示底部按钮
    //Data
    [self requestLoanBankData];//获取贷款银行列表
    [self displayContent];//填充数据
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

#pragma mark 根据资金来源显示贷款银行
- (void)reSetLoanBankView
{
    //资金来源(自有资金的时候不显示贷款银行)
    if ([[self.amountSourceBtn titleForState:UIControlStateNormal] isEqualToString:@"银行资金"]) {
        self.loanBankViewHeight.constant = 44;
    }
    else {
        self.loanBankViewHeight.constant = 0;
    }
}

#pragma mark 根据来源展示底部按钮
- (void)reSetBottomBtnFrameByFormType
{
    [self.tableView removeFromSuperview];
    if ([self.orderState isEqualToString:@"暂存"]){ //是否来自订单创建
        self.title = @"创建订单";
        self.view_top.hidden = NO;
        //判断顶部图片展示
        [self.view_progress setImgViewWithProduct:kProduceTypeRedeemFloor withIndex:ZSCreatOrderStyleLoan];
        [self.view addSubview:self.view_top];
        //居上高度
        self.viewTopContraint.constant = viewTopHeight;
        if ([[self.amountSourceBtn titleForState:UIControlStateNormal] isEqualToString:@"银行资金"]) {
            [self configuBottomButtonWithTitle:@"下一步"];//底部按钮
        }
        else {
            [self configuBottomButtonWithTitle:@"下一步"];//底部按钮
        }
        self.amountSourceBtn.enabled = YES;
    }
    else {
        self.title = @"贷款信息";
        self.view_top.hidden = YES;
        if ([[self.amountSourceBtn titleForState:UIControlStateNormal] isEqualToString:@"银行资金"]) {
            [self configuBottomButtonWithTitle:@"保存"];//底部按钮
        }
        else {
            [self configuBottomButtonWithTitle:@"保存"];//底部按钮
        }
        [self setBottomBtnEnable:NO];
        self.amountSourceBtn.enabled = NO;
    }
}

#pragma mark 获取贷款银行列表
- (void)requestLoanBankData
{
    [self.loanBankNameArray removeAllObjects];
    [self.loanBankIDArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"prdType":kProduceTypeRedeemFloor
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

#pragma mark 删除订单接口
- (void)requestForCloseOrderData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":global.rfOrderDetails.redeemOrder.tid,
                                           @"prdType":kProduceTypeRedeemFloor
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

#pragma mark 赋值
- (void)displayContent
{
    SpdOrder *model = global.rfOrderDetails.redeemOrder;
   
    //资金来源
    if (model.fundSource.length > 0){
        NSString *fundSource = [SafeStr(model.fundSource) isEqualToString:@"1"] ? @"银行资金" : @"自有资金";
        [self.amountSourceBtn setTitle:fundSource forState:UIControlStateNormal];
    }else{
        [self.amountSourceBtn setTitle:@"银行资金" forState:UIControlStateNormal];//资金来源默认填写银行资金
    }
    [self.amountSourceBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];

  
    //贷款银行
    if (model.loanBank.length) {
        [self.loanBankBtn setTitle:model.loanBank forState:UIControlStateNormal];
        [self.loanBankBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }
    if (model.loanBankId) {
        self.currentLoanBankID = model.loanBankId;
    }
   
    //贷款金额
    NSString *advanceAmount = model.advanceAmount.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:model.advanceAmount]] : @"";
    self.applyForAmountField.text = advanceAmount;
  
    //贷款利率
    NSString *rateAmount = model.loanRate.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:model.loanRate WithDigits:4]] : @"";
    self.loanRateField.text = rateAmount;
   
    //还款方式
    if (model.loanType) {
        [self.loanTypoBtn setTitle:model.loanType forState:UIControlStateNormal];
        [self.loanTypoBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }
   
    //原按揭银行
    self.loanBankerField.text = model.repayBank.length ? model.repayBank : @"";
   
    //按揭剩余金额
    NSString *loanleftAmount = model.loanleftAmount.length > 0 ? [NSString stringWithFormat:@"%@",[NSString ReviseString:model.loanleftAmount]] : @"";
    self.remainAmountField.text = loanleftAmount;
    
    //底部按钮判断
    [self checkBottomBtnEnabled];
}

#pragma mark 编辑贷款信息接口
//是否来自创建订单返回上一界面（goBack是）
- (void)requestEditOrderData:(BOOL)isGoBack
{
    __weak typeof(self) weakSelf = self;
    //点击返回按钮不转圈 点击下一步转圈
    if (!isGoBack){
        [LSProgressHUD showWithMessage:@"加载中"];
    }
    [ZSRequestManager requestWithParameter:[self getEditOrderParameter] url:[ZSURLManager getRedeemFloorUpdateMortgageInfoURL] SuccessBlock:^(NSDictionary *dic) {
//        ZSLOG(@"成功");
        [LSProgressHUD hide];
        //1.来源创建订单
        if ([self.orderState isEqualToString:@"暂存"]) {
            //存值
            global.rfOrderDetails = [ZSRFOrderDetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //1.1 (返回键） 返回上一界面
            if (isGoBack){
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                //1.2(底部按钮）房产信息编辑
                ZSSLAddHouseMaterialViewController *vc = [[ZSSLAddHouseMaterialViewController alloc]init];
                vc.orderState = @"暂存";
                vc.prdType = self.prdType;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }else {
            //2.返回订单详情
            //刷新订单详情
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
            //刷新订单列表
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

- (NSMutableDictionary *)getEditOrderParameter
{
    NSMutableDictionary *parameterDict = @{
                                           @"orderNo":global.rfOrderDetails.redeemOrder.tid,
                                           }.mutableCopy;
    //资金来源
    if ([self.amountSourceBtn titleForState:UIControlStateNormal].length > 0){
        NSString *fundSourceStr = [[self.amountSourceBtn titleForState:UIControlStateNormal] isEqualToString:@"银行资金"] ? @"1" :@"2";
        [parameterDict setValue:fundSourceStr forKey:@"fundSource"];
    }
    //贷款银行
    if (self.currentLoanBankID) {
        [parameterDict setValue:self.currentLoanBankID forKey:@"loanBankId"];
    }
    //贷款金额
    if (self.applyForAmountField.text.length > 0){
        [parameterDict setValue:self.applyForAmountField.text forKey:@"advanceAmount"];
    }
    //贷款利率
    if (self.loanRateField.text.length > 0) {
        [parameterDict setValue:self.loanRateField.text forKey:@"loanRate"];
    }
    //还款方式
    if (![[self.loanTypoBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
        [parameterDict setValue:[self.loanTypoBtn titleForState:UIControlStateNormal] forKey:@"loanType"];
    }
    //原按揭银行
    if (self.loanBankerField.text.length > 0){
        [parameterDict setValue:self.loanBankerField.text forKey: @"repayBank"];
    }
    //按揭剩余应还
    if (self.remainAmountField.text.length > 0){
        [parameterDict setValue: self.remainAmountField.text forKey:@"loanleftAmount"];
    }
    return parameterDict;
}

#pragma mark 按钮点击事件
- (IBAction)amountSourceSelectBtnClick:(id)sender
{
    [self hideKeyboard];
    //资金来源
    if (sender == self.amountSourceBtn) {
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:self.amountSourceArray];
        actionsheet.tag = 102;
        actionsheet.delegate = self;
        [actionsheet show:self.amountSourceArray.count];
    }
    //贷款银行
    else if (sender == self.loanBankBtn) {
        if (self.loanBankNameArray.count > 0) {
            ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
            pickerView.titleArray = self.loanBankNameArray;
            pickerView.delegate = self;
            [pickerView show];
        }
        else{
            [self requestLoanBankData];//重新获取
        }
    }
    //还款方式
    else if (sender == self.loanTypoBtn) {
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:self.loanTypeArray];
        actionsheet.tag = 104;
        actionsheet.delegate = self;
        [actionsheet show:self.loanTypeArray.count];
    }
}

#pragma mark ZSActionSheetViewDelegate
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag
{
    if (sheetView.tag == 102)
    {
        [self.amountSourceBtn setTitle:self.amountSourceArray[tag] forState:UIControlStateNormal];
        [self.amountSourceBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
        //重新刷新
        [self reSetLoanBankView];
    }
    else if (sheetView.tag == 104)
    {
        [self.loanTypoBtn setTitle:self.loanTypeArray[tag] forState:UIControlStateNormal];
        [self.loanTypoBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }
    
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

#pragma mark /*--------------------------------textfield-------------------------------------------*/
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
    //按揭剩余应还和贷款金额大于10000000.00则不让输入
    if (textField == self.remainAmountField || textField == self.applyForAmountField){
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
    //按揭剩余应还和贷款金额只能保留两位小数
    if (textField == self.remainAmountField || textField == self.applyForAmountField) {
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }
    //原按揭银行内容大于40则不让输入
    if (textField == self.loanBankerField){
        if ([toBeString length] > 40) {
            textField.text = [toBeString substringToIndex:40];
            return NO;
        }
    }
    //贷款利率限制最大100.0000%,最多4位小数
    if (textField == self.loanRateField){
        if (toBeString.length > 0) {
            if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"100.0000" alert:YES]){
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

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    [self checkBottomBtnEnabled];
}

#pragma mark 底部按钮点击事件
- (void)bottomClick:(UIButton *)sender
{
    if (self.remainAmountField.text.floatValue == 0 && self.remainAmountField.text.length > 0){
        [ZSTool showMessage:@"剩余按揭金额不能为0" withDuration:DefaultDuration];
        return;
    }
    if (self.applyForAmountField.text.floatValue == 0 && self.applyForAmountField.text.length > 0){
        [ZSTool showMessage:@"贷款金额不能为0" withDuration:DefaultDuration];
        return;
    }
    //请求数据
    [self requestEditOrderData:NO];
}

#pragma mark 判断底部按钮是否可以点击
- (void)checkBottomBtnEnabled
{
    //资金来源和贷款银行为必填
    if ([[self.amountSourceBtn titleForState:UIControlStateNormal] isEqualToString:@"银行资金"]) {
        if ([[self.amountSourceBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose] ||
            [[self.loanBankBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
            [self setBottomBtnEnable:NO];
        }else {
            [self setBottomBtnEnable:YES];
        }
    }
    else {
        if ([[self.amountSourceBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
            [self setBottomBtnEnable:NO];
        }else {
            [self setBottomBtnEnable:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

