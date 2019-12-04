//
//  ZSSLAddBankViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 2018/1/30.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSSLAddBankViewController.h"
#import "ZSInputOrSelectView.h"
#import "ZSWSYearMonthDayPicker.h"
#import "ZSYearMonthDayPicker.h"

@interface ZSSLAddBankViewController ()<UITextFieldDelegate,ZSSLDataCollectionViewDelegate,ZSInputOrSelectViewDelegate>
@property (nonatomic,strong)ZSInputOrSelectView   *bankerNoView;     //银行卡号
@property (nonatomic,strong)ZSInputOrSelectView   *bankerNameView;   //所属银行
@property (nonatomic,strong)ZSInputOrSelectView   *bankerTimeView;   //有效期
@property (nonatomic,strong)ZSInputOrSelectView   *accountNameView;  //开户名
@property (nonatomic,strong)UIView                *lineView;         //线
@property (nonatomic,strong)NSMutableArray        *doctextVocsArray; //还款银行/收款银行
@property (nonatomic,copy  )NSString              *selectTimeStr;    //日期选择
@end

@implementation ZSSLAddBankViewController

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
    self.dataCollectionView.bool_isFromBanker = YES;
    self.dataCollectionView.userInteractionEnabled = YES;
    self.dataCollectionView.delegate = self;
    self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.dataCollectionView.bottom + 20 + 15 + self.topSpace);
    self.isOnlyText = YES;
}

#pragma mark 获取资料状态接口
- (void)requestForUpdateCollecState
{
    __weak typeof(self) weakSelf = self;
    [self.fileArray removeAllObjects];
    [LSProgressHUD showWithMessage:@"加载中"];
    [ZSRequestManager requestWithParameter:[weakSelf getMaterialsFilesParameter] url:[weakSelf getMaterialsFilesURL] SuccessBlock:^(NSDictionary *dic) {
        //文本信息解析
        if ([weakSelf.SLDocToModel.doccode isEqualToString:@"BANK_REPAY"] ||
            [weakSelf.SLDocToModel.doccode isEqualToString:@"BANK_GATHER"] ||
            [weakSelf.SLDocToModel.doccode isEqualToString:@"CLEAR_ACCOUNT"])
        {
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
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && weakSelf.isShowAdd)
        {
            [weakSelf configureDataSource];
        }
        else
        {
            [weakSelf configCloseAndCompletedata];
        }
        [weakSelf initCollectionView:0];//父类collectionview的初始化高度
        [weakSelf initCollectionView];  //子类的collectionview一些参数
        [weakSelf.dataCollectionView layoutSubviews];
        [weakSelf initViews];           //UI
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark initViews
- (void)initViews
{
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0,[self.dataCollectionView resetCollectionViewFrame], ZSWIDTH, 0.5)];
    self.lineView.backgroundColor = ZSViewBackgroundColor;
    [self.bgScrollView addSubview:self.lineView];
  
    //银行卡号
    self.bankerNoView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0,self.lineView.bottom, ZSWIDTH, CellHeight) withInputAction:@"银行卡号 *" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
    self.bankerNoView.inputTextFeild.delegate = self;
    [self.bankerNoView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bgScrollView addSubview:self.bankerNoView];
   
    //所属银行
    self.bankerNameView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.bankerNoView.bottom, ZSWIDTH, CellHeight) withInputAction:@"所属银行" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
    [self.bankerNameView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.bankerNameView.inputTextFeild.delegate = self;
    [self.bgScrollView addSubview:self.bankerNameView];
  
    //有效期
    self.bankerTimeView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.bankerNameView.bottom, ZSWIDTH, CellHeight) withClickAction:@"有效期"];
    self.bankerTimeView.delegate = self;
    [self.bgScrollView addSubview:self.bankerTimeView];
    
    //开户人姓名
    self.accountNameView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.bankerTimeView.bottom, ZSWIDTH, CellHeight) withInputAction:@"开户名" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
    [self.accountNameView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.accountNameView.inputTextFeild.delegate = self;
    [self.bgScrollView addSubview:self.accountNameView];
    
    //判断界面是否可编辑
    [self checkTheViewCanEditing];
    
    //数据填充
    [self fillInData];
}

#pragma mark 判断界面是否可编辑
- (void)checkTheViewCanEditing
{
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd)
    {
        self.dataCollectionView.isShowAdd = YES;
        self.bankerNoView.userInteractionEnabled = YES;
        self.bankerNameView.userInteractionEnabled = YES;
        self.bankerTimeView.userInteractionEnabled = YES;
        self.accountNameView.userInteractionEnabled = YES;
        
        self.bankerNoView.inputTextFeild.placeholder = KPlaceholderInput;
        self.bankerNameView.inputTextFeild.placeholder = KPlaceholderInput;
        self.bankerTimeView.rightLabel.text = KPlaceholderChoose;
        self.bankerTimeView.rightImgView.hidden = NO;
        self.accountNameView.inputTextFeild.placeholder = KPlaceholderInput;
    }
    else
    {
        self.dataCollectionView.isShowAdd = NO;
        self.bankerNoView.userInteractionEnabled = NO;
        self.bankerNameView.userInteractionEnabled = NO;
        self.bankerTimeView.userInteractionEnabled = NO;
        self.accountNameView.userInteractionEnabled = NO;
        
        self.bankerNoView.inputTextFeild.placeholder = @"";
        self.bankerNameView.inputTextFeild.placeholder = @"";
        self.bankerTimeView.rightLabel.text = @"";
        self.bankerTimeView.rightImgView.hidden = YES;
        self.bankerTimeView.rightLabel.width = ZSWIDTH-145-15;
        self.accountNameView.inputTextFeild.placeholder = @"";
        
        self.bankerNoView.leftLabel.text = @"银行卡号";
    }
}

#pragma mark 数据填充
- (void)fillInData
{
    //赋值
    if (self.doctextVocsArray.count > 0)
    {
        //银行卡号
        SpdDocdocTextVos *model = [self.doctextVocsArray firstObject];
        if (![model.bankInfo.bankNo containsString:@"null"]){
            self.bankerNoView.inputTextFeild.text = model.bankInfo.bankNo;
        }
        //所属银行
        if (![model.bankInfo.bankName containsString:@"null"]){
            self.bankerNameView.inputTextFeild.text = model.bankInfo.bankName;
        }
        //有效期
        if (![model.bankInfo.expiryDate containsString:@"null"] && ![SafeStr(model.bankInfo.expiryDate)isEqualToString:@""]){
            self.bankerTimeView.rightLabel.text       = model.bankInfo.expiryDate;
            self.bankerTimeView.rightLabel.textColor  = ZSColorListRight;
            self.selectTimeStr = model.bankInfo.expiryDate;
        }
        //开户名
        if (![model.bankInfo.accountName containsString:@"null"]){
            self.accountNameView.inputTextFeild.text = model.bankInfo.accountName;
        }
    }
}

#pragma mark yextfieldChanged 值改变
- (void)textFieldTextChange:(UITextField *)textField
{
    SpdDocdocTextVos *model = [self.doctextVocsArray firstObject];
    if (textField == self.bankerNoView.inputTextFeild) {
        if (![textField.text isEqualToString:model.bankInfo.bankNo]) {
            self.isChanged = YES;
        }
    }
    else if (textField == self.bankerNameView.inputTextFeild) {
        if (![textField.text isEqualToString:model.bankInfo.bankName]) {
            self.isChanged = YES;
        }
    }
    else if (textField == self.accountNameView.inputTextFeild) {
        if (![textField.text isEqualToString:model.bankInfo.accountName]) {
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
    return YES;
}

#pragma mark ZSInputOrSelectViewDelegate
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    [self hideKeyboard];
    if (view == self.bankerTimeView){
        ZSYearMonthDayPicker *datePicker = [[ZSYearMonthDayPicker alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 250)withMInYear:[ZSTool getCurrentYear]];
        datePicker.datePickerBlock = ^(NSString *selectDate) {
            view.rightLabel.text = selectDate;
            view.rightLabel.textColor = ZSColorListRight;
            self.selectTimeStr = selectDate;
            //值是否改变
            SpdDocdocTextVos *model = [self.doctextVocsArray firstObject];
            if (![selectDate isEqualToString:model.bankInfo.expiryDate]) {
                self.isChanged = YES;
            }
        };
        [self.view addSubview:datePicker];
    }
}

#pragma mark /*--------------------------------请求参数-------------------------------------------*/
#pragma mark 上传文本参数
- (NSMutableDictionary *)getUploadTextParameter
{
    NSMutableDictionary *parameter=  @{
                                       @"prdType":self.prdType,
                                       @"orderno":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    //资料类型Id
    if (self.SLDocToModel.docid > 0){
        [parameter setObject:self.SLDocToModel.docid forKey:@"docId"];
    }
    //银行卡号
    [parameter setValue:self.bankerNoView.inputTextFeild.text.length > 0 ? self.bankerNoView.inputTextFeild.text : @"" forKey:@"bankNo"];
    //所属银行
    [parameter setValue:self.bankerNameView.inputTextFeild.text.length > 0 ? self.bankerNameView.inputTextFeild.text : @"" forKey:@"bankName"];
    //有效期
    [parameter setValue:self.selectTimeStr.length > 0 ? self.selectTimeStr : @"" forKey:@"expiryDate"];
    //开户名
    [parameter setValue:self.accountNameView.inputTextFeild.text.length > 0 ? self.accountNameView.inputTextFeild.text : @"" forKey:@"accountName"];
    //上传图片id集合
    NSString *deleteIDStr = [[self getNeedFilesArray] componentsJoinedByString:@","];
    [parameter setObject:deleteIDStr forKey:@"urls"];
    return parameter;
}


#pragma mark 上传图片获取银行卡信息代理
- (void)getBankerInfoWithBankerModel:(BankRepay *)bankModel
{
    //有银行卡号才替换
    if (bankModel.bankCardNo.length > 0) {
        //银行卡号
        self.bankerNoView.inputTextFeild.text     = bankModel.bankCardNo;
        self.bankerNameView.inputTextFeild.text   = bankModel.bankCardName;
        self.bankerTimeView.rightLabel.text = bankModel.bankCardExpiryDate;
        self.bankerTimeView.rightLabel.textColor  = ZSColorListRight;
        self.selectTimeStr = bankModel.bankCardExpiryDate;
    }
}

#pragma mark 上传文本
- (NSString *)getUploadOnlyTextURL
{
    return [ZSURLManager getMateriaInsSureURL];
}

#pragma mark /*--------------------------------ZSSLDataCollectionViewDelegate------------------------------------------*/
//重置collview高度代理
- (void)refershDataCollectionViewHegiht
{
    //多张的时候更新坐标
    if (self.addDataStyle == ZSAddResourceDataCountless)
    {
        [self.dataCollectionView layoutSubviews];
        //文本信息高度重新刷新
        self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
        self.lineView.top       = self.dataCollectionView.height;
        self.bankerNoView.top   = self.lineView.bottom;
        self.bankerNameView.top = self.bankerNoView.bottom;
        self.bankerTimeView.top = self.bankerNameView.bottom;
        self.accountNameView.top = self.bankerTimeView.bottom;
        self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.dataCollectionView.myCollectionView.bottom + 120 + self.topSpace);
    }
}

#pragma mark /*--------------------------------底部按钮------------------------------------------*/
#pragma mark 底部按钮点击事件
- (void)bottomClick:(UIButton *)btn
{
    if (!(self.bankerNoView.inputTextFeild.text.length > 0)){
        [ZSTool showMessage:@"银行卡号不能为空" withDuration:DefaultDuration];
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

#pragma mark 上传资料
- (void)uploadTextDataAndImageData
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showWithMessage:@"保存中"];
    [ZSRequestManager requestWithParameter:[self getUploadTextParameter] url:[ZSURLManager getSaveBankURL] SuccessBlock:^(NSDictionary *dic) {
        [LSProgressHUD hide];
        //请求资料列表数据
        //根据不同的产品发不同的通知
        [weakSelf postNotificationForProductType];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark获取所要上传数据
- (NSMutableArray*)getNeedFilesArray
{
    NSMutableArray *upArray=@[].mutableCopy;
    if ([self.dataCollectionView.itemArray count]) {
        for (NSMutableArray *array in self.dataCollectionView.itemArray) {
            if ([array count]) {
                for (ZSWSFileCollectionModel *colletionModel in array) {
                    if (colletionModel.dataUrl) {//如果是本地拍的图片或视频.
                        [upArray addObject:colletionModel.dataUrl];
                        ZSLOG(@"colletionModel.dataUrl:%@",colletionModel.dataUrl);
                    }
                }
            }
        }
    }
    return upArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
