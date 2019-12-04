//
//  ZSSLAddPayAmountViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//


#import "ZSSLAddPayAmountViewController.h"
#import "ZSInputOrSelectView.h"
#import "ZSWSYearMonthDayPicker.h"

@interface ZSSLAddPayAmountViewController ()<UITextFieldDelegate,ZSSLDataCollectionViewDelegate,ZSInputOrSelectViewDelegate,ZSAlertViewDelegate>
@property (nonatomic,strong)ZSInputOrSelectView   *payMoneyView;   // 放款金额
@property (nonatomic,strong)ZSInputOrSelectView   *payTimeView;    // 放款日期
@property (nonatomic,strong)NSMutableArray *doctextVocsArray;       //星速贷新房见证和放款凭证和收款凭证文本数据
@property (nonatomic,strong)NSMutableDictionary *titleDic;
@end

@implementation ZSSLAddPayAmountViewController

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
    self.titleDic = [[NSMutableDictionary alloc]init];
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
        if ([weakSelf.SLDocToModel.docname isEqualToString:@"放款凭证"]){
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
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd)
        {
            [weakSelf configureDataSource];
        }
        else
        {
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
    // 放款金额
    self.payMoneyView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:@"放款金额" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad withElement:@"元"];
    [self.payMoneyView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.payMoneyView.inputTextFeild.delegate = self;
    [self.bgScrollView addSubview:self.payMoneyView];
  
    // 放款日期
    self.payTimeView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, CellHeight, ZSWIDTH, CellHeight) withClickAction:@"放款日期"];
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
        
        self.payMoneyView.inputTextFeild.placeholder = KPlaceholderInput;
        self.payTimeView.rightLabel.text     = KPlaceholderChoose;
        self.payTimeView.rightImgView.hidden = NO;
    }
    else
    {
        self.dataCollectionView.isShowAdd = NO;
        self.payTimeView.userInteractionEnabled = NO;
        self.payMoneyView.userInteractionEnabled = NO;
        
        self.payMoneyView.inputTextFeild.placeholder = @"";
        self.payTimeView.rightLabel.text     = @"";
        self.payTimeView.rightImgView.hidden = YES;
        self.payTimeView.rightLabel.width =  ZSWIDTH-145-15;
    }
}

#pragma mark 数据填充
- (void)fillInData
{
    if (self.doctextVocsArray.count > 0)
    {
        SpdDocdocTextVos *model = self.doctextVocsArray[0];
        if (![model.textType containsString:@"null"]){
            self.payMoneyView.inputTextFeild.text = [NSString ReviseString:model.textType];
            self.payMoneyView.rightLabel.textColor = ZSColorListRight;
            [self.titleDic setValue:model.textType forKey:@"amount"];
        }
        if (![model.text containsString:@"null"]){
            self.payTimeView.rightLabel.text = model.text;
            self.payTimeView.rightLabel.textColor = ZSColorListRight;
            [self.titleDic setValue:model.text forKey:@"date"];
        }
    }
}

#pragma mark textfieldDelagate
- (void)textFieldTextChange:(UITextField *)textField
{
    SpdDocdocTextVos *model = [self.doctextVocsArray firstObject];
    if (textField == self.payMoneyView.inputTextFeild)
    {
        [self.titleDic setValue:textField.text forKey:@"amount"];
        if (![textField.text isEqualToString:model.textType]) {
            self.isChanged = YES;
        }
    }
}

#pragma mark textfieldDelagate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.payMoneyView.inputTextFeild){
        [self.titleDic setValue:textField.text forKey:@"amount"];
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
    //只能输入10位
    if (toBeString.length > 0){
        if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:KMaxAmount alert:YES]){
            [ZSTool showMessage:@"金额太大了! " withDuration:DefaultDuration];
            return NO;
        }
    }
    if (textField == self.payMoneyView.inputTextFeild){
        [self.titleDic setValue:toBeString forKey:@"amount"];
    }
    return [textField checkTextField:textField WithString:string Range:range numInt:2];
    //(只允许保留2位小数)
//    return [textField checkLeftAndRightTextField:textField WithString:toBeString Range:range numInt:8 pointNum:2];
    return YES;
}

#pragma mark ZSInputOrSelectViewDelegate
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    [self hideKeyboard];
    if (view == self.payTimeView)
    {
        ZSWSYearMonthDayPicker *datePicker = [[ZSWSYearMonthDayPicker alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 250)];
        datePicker.datePickerBlock = ^(NSString *selectDate) {
            view.rightLabel.text = selectDate;
            view.rightLabel.textColor = ZSColorListRight;
            [self.titleDic setValue:selectDate forKey:@"date"];
            //值是否改变
            SpdDocdocTextVos *model = [self.doctextVocsArray firstObject];
            if (![selectDate isEqualToString:model.text]) {
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
                                       @"maType":@"DKPZ",
                                       @"prdType":self.prdType,
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    NSString *deleteIDStr = [NSString StingByJson:self.titleDic];
    [parameter setValue:deleteIDStr forKey:@"data"];

    return parameter;
}

@end
