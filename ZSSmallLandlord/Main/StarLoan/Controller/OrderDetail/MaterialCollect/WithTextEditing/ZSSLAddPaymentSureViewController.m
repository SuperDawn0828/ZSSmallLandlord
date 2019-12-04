//
//  ZSSLAddPaymentSureViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/9/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLAddPaymentSureViewController.h"
#import "ZSInputOrSelectView.h"
#import "ZSWSYearMonthDayPicker.h"

@interface ZSSLAddPaymentSureViewController ()<UITextFieldDelegate,ZSSLDataCollectionViewDelegate,ZSInputOrSelectViewDelegate,ZSAlertViewDelegate>
@property (nonatomic,strong)ZSInputOrSelectView   *payMoneyView;      //回款金额
@property (nonatomic,strong)ZSInputOrSelectView   *payTimeView;       //回款日期
@property (nonatomic,strong)ZSInputOrSelectView   *payAccount;        //回款账号
@property (nonatomic,strong)NSMutableArray        *doctextVocsArray;  //星速贷新房见证和放款凭证和收款凭证文本数据
@property (nonatomic,copy  )NSString              *selectTimeStr;     //日期选择
@end

@implementation ZSSLAddPaymentSureViewController

- (NSMutableArray *)doctextVocsArray
{
    if (_doctextVocsArray == nil){
        _doctextVocsArray = [[NSMutableArray alloc]init];
    }
    return _doctextVocsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isOnlyText = YES;
}

#pragma mark initCollectionView
- (void)initCollectionView
{
    self.dataCollectionView.addDataStyle = (ZSAddResourceDataStyle)self.addDataStyle;
    self.dataCollectionView.userInteractionEnabled = YES;
    self.dataCollectionView.delegate = self;
    self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.dataCollectionView.bottom + 20 + 15 + self.topSpace);
}

#pragma mark 获取资料状态接口
- (void)requestForUpdateCollecState
{
    __weak typeof(self) weakSelf = self;
    [self.fileArray removeAllObjects];
    [LSProgressHUD showWithMessage:@"加载中"];
    [ZSRequestManager requestWithParameter:[weakSelf getMaterialsFilesParameter] url:[weakSelf getMaterialsFilesURL] SuccessBlock:^(NSDictionary *dic) {
        //文本信息解析
        if ([weakSelf.SLDocToModel.docname isEqualToString:@"回款确认"]){
            NSArray *array = dic[@"respData"][@"docTextVos"];
            if (array.count > 0) {
                for (NSDictionary *dict in array) {
                    SpdDocdocTextVos *model = [SpdDocdocTextVos yy_modelWithJSON:dict];
                    [weakSelf.doctextVocsArray addObject:model];
                }
            }
        }
        //不是两个加号
        if (self.addDataStyle != ZSAddResourceDataTwo){
            NSArray *array = dic[@"respData"][@"spdDocInfoVos"];
            if (array.count > 0) {
                for (NSDictionary *dict in array) {
                    ZSWSFileCollectionModel *model = [ZSWSFileCollectionModel yy_modelWithJSON:dict];
                    if (model.dataUrl.length > 0){
                        [weakSelf.fileArray addObject:model];
                    }
                }
            }
        }
        //是否可编辑
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && weakSelf.isShowAdd){
            [weakSelf configureDataSource];
        }else{
            [weakSelf configCloseAndCompletedata];
        }
        [weakSelf initViews];
        [weakSelf.dataCollectionView layoutSubviews];
        [weakSelf initCollectionView:weakSelf.topSpace];
        [weakSelf initCollectionView];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark initViews
- (void)initViews
{
    //回款金额
    self.payMoneyView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:@"回款金额 *" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad withElement:@"元"];
    self.payMoneyView.inputTextFeild.delegate = self;
    [self.payMoneyView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bgScrollView addSubview:self.payMoneyView];
   
    //回款账号
    self.payAccount = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, CellHeight, ZSWIDTH, CellHeight) withInputAction:@"回款账号" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad];
    [self.payAccount.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.payAccount.inputTextFeild.delegate = self;
    [self.bgScrollView addSubview:self.payAccount];
    
    //回款日期
    self.payTimeView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, CellHeight*2, ZSWIDTH, CellHeight) withClickAction:@"回款日期 *"];
    self.payTimeView.delegate = self;
    [self.bgScrollView addSubview:self.payTimeView];
   
    //判断界面是否可编辑
    [self checkTheViewCanEditing];
    
    //数据填充
    [self fillInData];
    
    //dataconllectionView的起始高度
    self.topSpace = self.payTimeView.bottom;
}

#pragma mark 判断界面是否可编辑
- (void)checkTheViewCanEditing
{
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd)
    {
        self.dataCollectionView.isShowAdd = YES;
        self.payTimeView.userInteractionEnabled = YES;
        self.payMoneyView.userInteractionEnabled = YES;
        self.payAccount.userInteractionEnabled = YES;
        
        self.payAccount.inputTextFeild.placeholder = KPlaceholderInput;
        self.payMoneyView.inputTextFeild.placeholder = KPlaceholderInput;
        self.payTimeView.rightLabel.text = KPlaceholderChoose;
        self.payTimeView.rightImgView.hidden = NO;
    }
    else
    {
        self.dataCollectionView.isShowAdd = NO;
        self.payTimeView.userInteractionEnabled = NO;
        self.payMoneyView.userInteractionEnabled = NO;
        self.payAccount.userInteractionEnabled = NO;
        
        self.payAccount.inputTextFeild.placeholder = @"";
        self.payMoneyView.inputTextFeild.placeholder = @"";
        self.payTimeView.rightLabel.text = @"";
        self.payTimeView.rightImgView.hidden = YES;
        self.payTimeView.rightLabel.width = ZSWIDTH-145-15;
        
        self.payMoneyView.leftLabel.text = @"回款金额";
        self.payTimeView.leftLabel.text = @"回款日期";
    }
}

#pragma mark 数据填充
- (void)fillInData
{
    //赋值
    if (self.doctextVocsArray.count > 0)
    {
        SpdDocdocTextVos *model = [self.doctextVocsArray firstObject];
        if (![model.orderDocInsurance.insuranceAmount containsString:@"null"]){
            self.payMoneyView.inputTextFeild.text = model.orderDocInsurance.insuranceAmount;
        }
        if (![model.orderDocInsurance.insuranceAccount containsString:@"null"]){
            self.payAccount.inputTextFeild.text = model.orderDocInsurance.insuranceAccount;
        }
        
        if ([model.orderDocInsurance.insuranceTime containsString:@"null"] || [SafeStr(model.orderDocInsurance.insuranceTime)isEqualToString:@""]){
        }else{
            self.payTimeView.rightLabel.text = model.orderDocInsurance.insuranceTime;
            self.payTimeView.rightLabel.textColor  = ZSColorListRight;
            self.selectTimeStr = model.orderDocInsurance.insuranceTime;
        }
    }
}

#pragma mark yextfieldChanged 值改变
- (void)textFieldTextChange:(UITextField *)textField
{
    SpdDocdocTextVos *model = [self.doctextVocsArray firstObject];
    if (textField == self.payMoneyView.inputTextFeild)
    {
        if (![textField.text isEqualToString:model.orderDocInsurance.insuranceAmount]) {
            self.isChanged = YES;
        }
    }
    else if (textField == self.payAccount.inputTextFeild) {
        if (![textField.text isEqualToString:model.orderDocInsurance.insuranceAccount]) {
            self.isChanged = YES;
        }
    }
}

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
    if (textField == self.payMoneyView.inputTextFeild){
        //只能输入10位
        if (toBeString.length > 0){
            if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:KMaxAmount alert:YES]){
                [ZSTool showMessage:@"金额太大了! " withDuration:DefaultDuration];
                return NO;
            }
        }
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }
    if (textField == self.payAccount.inputTextFeild){
        if ([toBeString length] > 19) {
            textField.text = [toBeString substringToIndex:19];
            return NO;
        }
    }
    return YES;
}

#pragma mark ZSInputOrSelectViewDelegate
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    [self hideKeyboard];
    if (view == self.payTimeView){
        ZSWSYearMonthDayPicker *datePicker = [[ZSWSYearMonthDayPicker alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 250)];
        datePicker.datePickerBlock = ^(NSString *selectDate) {
            view.rightLabel.text = selectDate;
            view.rightLabel.textColor = ZSColorListRight;
            self.selectTimeStr = selectDate;
            //值是否改变
            SpdDocdocTextVos *model = [self.doctextVocsArray firstObject];
            if (![selectDate isEqualToString:model.orderDocInsurance.insuranceTime]) {
                self.isChanged = YES;
            }
        };
        [self.view addSubview:datePicker];
    }
}

#pragma mark /*--------------------------------请求参数-------------------------------------------*/
#pragma mark 上传文本参数
- (NSMutableDictionary *)getUploadOnlyTextParameter
{
    NSMutableDictionary *parameter=  @{
                                       @"prdType":self.prdType,
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    [parameter setValue:self.payMoneyView.inputTextFeild.text.length > 0 ? self.payMoneyView.inputTextFeild.text : @"" forKey:@"amount"];
    [parameter setValue:self.payAccount.inputTextFeild.text.length > 0 ? self.payAccount.inputTextFeild.text : @"" forKey:@"account"];
    [parameter setValue:self.selectTimeStr.length > 0 ? self.selectTimeStr : @"" forKey:@"date"];
    return parameter;
}

#pragma mark /*--------------------------------请求URL-------------------------------------------*/
#pragma mark 上传文本
- (NSString *)getUploadOnlyTextURL
{
    return [ZSURLManager getMateriaInsSureURL];
}

#pragma mark /*--------------------------------底部按钮------------------------------------------*/
#pragma mark 底部按钮点击事件
- (void)bottomClick:(UIButton *)btn
{
    if (!(self.payMoneyView.inputTextFeild.text.length > 0)){
        [ZSTool showMessage:@"回款金额不能为空" withDuration:DefaultDuration];
        return;
    }
    if ([self.payTimeView.rightLabel.text isEqualToString:KPlaceholderChoose]){
        [ZSTool showMessage:@"请选择回款日期" withDuration:DefaultDuration];
        return;
    }
    
    NSString *rightBtnString = [self.rightBtn.titleLabel.text substringFromIndex:3];
    NSArray *array = [rightBtnString componentsSeparatedByString:@"/"];
    NSString *string1 = array[0];
    NSString *string2 = array[1];    
    if (string1.intValue < string2.intValue) {
        hud = [LSProgressHUD showWithMessage: [rightBtnString stringByReplacingOccurrencesOfString:@"已" withString:@"正在"]];
        isShowHUD = YES;
        return;
    }
    //数据上传
    [self uploadTextDataAndImageData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
