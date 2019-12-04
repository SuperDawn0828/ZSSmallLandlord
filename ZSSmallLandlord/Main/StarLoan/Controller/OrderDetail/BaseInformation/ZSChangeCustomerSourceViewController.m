//
//  ZSChangeCustomerSourceViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/10/16.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSChangeCustomerSourceViewController.h"
#import "ZSInputOrSelectView.h"

@interface ZSChangeCustomerSourceViewController ()<ZSInputOrSelectViewDelegate,UITextFieldDelegate,ZSPickerViewDelegate,ZSActionSheetViewDelegate>
@property(nonatomic,strong)ZSInputOrSelectView      *sourceView;          //客户来源
@property(nonatomic,strong)ZSInputOrSelectView      *mediumView;          //中介结构
@property(nonatomic,strong)ZSInputOrSelectView      *nameView;            //姓名
@property(nonatomic,strong)ZSInputOrSelectView      *phoneNumView;        //联系方式
@property(nonatomic,strong)NSMutableArray           *array_name;          //中介名称
@property(nonatomic,strong)NSMutableArray           *array_ID;            //中介id
@property(nonatomic,copy  )NSString                 *currentSelectMedium; //当前选中的中介ID
@property(nonatomic,assign)NSInteger                i_phoneNumber;        //用来设置输入手机号做空格用
@end

@implementation ZSChangeCustomerSourceViewController

#pragma mark 懒加载
- (NSMutableArray *)array_name
{
    if (_array_name == nil) {
        _array_name = [NSMutableArray array];
    }
    return _array_name;
}

- (NSMutableArray *)array_ID
{
    if (_array_ID == nil) {
        _array_ID = [NSMutableArray array];
    }
    return _array_ID;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势(自定义返回按钮会导致手势失效)
    [self openInteractivePopGestureRecognizerEnable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"客户来源";
    [self setLeftBarButtonItem];
    [self initView];
    //Data
    [self fillinData];
    [self getMediumList];
}

#pragma mark 赋值
- (void)fillinData
{
    NSString *sourceString;//客户来源
    NSString *sourceName;//中接名字
    NSString *nameString;//中接联系人名字
    NSString *phoneString;//中接联系人电话
    SpdOrder *model;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        model = global.slOrderDetails.spdOrder;
        sourceName = global.slOrderDetails.agencyName;
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        model = global.rfOrderDetails.redeemOrder;
        sourceName = global.rfOrderDetails.agencyName;
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        model = global.mlOrderDetails.dydOrder;
        sourceName = global.mlOrderDetails.agencyName;
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        model = global.elOrderDetails.easyOrder;
        sourceName = global.elOrderDetails.agencyName;
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        model = global.chOrderDetails.cwfqOrder;
        sourceName = global.chOrderDetails.agencyName;
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        model = global.abOrderDetails.insteadOrder;
        sourceName = global.abOrderDetails.agencyName;
    }
    sourceString = model.dataSrc ? [NSString stringWithFormat:@"%ld",(long)model.dataSrc] : @"";
    nameString = model.agencyContact ? model.agencyContact : @"";
    phoneString = model.agencyContactPhone ? model.agencyContactPhone : @"";


    if (sourceString.intValue == 2)
    {
        self.sourceView.rightLabel.text = @"线下客户";
        self.sourceView.rightLabel.textColor = ZSColorListRight;
        [self showMediumMessage:NO];
    }
    else if (sourceString.intValue == 1)
    {
        self.sourceView.rightLabel.text = @"中介推荐";
        self.sourceView.rightLabel.textColor = ZSColorListRight;
        [self showMediumMessage:YES];
        
        //中介id
        self.currentSelectMedium = model.agencyId;
        //中介名称
        if (sourceName.length) {
            self.mediumView.rightLabel.text = sourceName;
            self.mediumView.rightLabel.textColor = ZSColorListRight;
        }
        //中介联系人
        if (nameString.length) {
            self.nameView.inputTextFeild.text = nameString;
            self.nameView.inputTextFeild.textColor = ZSColorListRight;
        }
        //中介联系人手机
        if (phoneString.length) {
            self.phoneNumView.inputTextFeild.text = [ZSTool addTheBlankSpace:phoneString];
            self.phoneNumView.inputTextFeild.textColor = ZSColorListRight;
        }
    }
    
    [self CheckBottomBtnClick];
}

#pragma mark 获取所有中介机构信息
- (void)getMediumList
{
    __weak typeof(self) weakSelf  = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getAllAgency] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        for (NSDictionary *newDic in array) {
            [weakSelf.array_name addObject:newDic[@"agencyName"]];
            [weakSelf.array_ID addObject:newDic[@"tid"]];
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 界面搭建
- (void)initView
{
    //客户来源
    self.sourceView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withClickAction:@"客户来源 *"];
    self.sourceView.delegate = self;
    [self.view addSubview:self.sourceView];
    
    //中介结构
    self.mediumView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.sourceView.bottom, ZSWIDTH, CellHeight) withClickAction:@"中介机构 *"];
    self.mediumView.delegate = self;
    [self.view addSubview:self.mediumView];
    
    //姓名
    self.nameView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.mediumView.bottom, ZSWIDTH, CellHeight) withInputAction:@"联系人" withRightTitle:@"请输入姓名" withKeyboardType:UIKeyboardTypeDefault];
    self.nameView.inputTextFeild.delegate = self;
    [self.view addSubview:self.nameView];
    
    //手机号
    self.phoneNumView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.nameView.bottom, ZSWIDTH, CellHeight) withInputAction:@"联系方式" withRightTitle:@"请输入手机号" withKeyboardType:UIKeyboardTypeNumberPad];
    self.phoneNumView.inputTextFeild.delegate = self;
    [self.phoneNumView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.phoneNumView ];
    self.i_phoneNumber = 0;
    
    //底部按钮
    [self configuBottomButtonWithTitle:@"保存" OriginY:self.sourceView.bottom+15];
    [self setBottomBtnEnable:NO];//默认不可点击
}

- (void)showMediumMessage:(BOOL)isShow
{
    if (isShow)
    {
        self.mediumView.hidden = NO;
        self.nameView.hidden = NO;
        self.phoneNumView.hidden = NO;
        self.bottomBtn.y = self.phoneNumView.bottom+15;
    }
    else
    {
        self.mediumView.hidden = YES;
        self.nameView.hidden = YES;
        self.phoneNumView.hidden = YES;
        self.bottomBtn.y = self.sourceView.bottom+15;
    }
}

#pragma mark 选择客户来源/中介
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    //键盘回收
    [self.nameView.inputTextFeild resignFirstResponder];
    [self.phoneNumView.inputTextFeild resignFirstResponder];
    
    //客户来源
    if (view == self.sourceView)
    {
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"中介推荐",@"线下客户"]];
        actionsheet.delegate = self;
        [actionsheet show:2];
    }
    //中介
    if (view == self.mediumView)
    {
        if (self.array_name.count > 0) {
            ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
            pickerView.titleArray = self.array_name;
            pickerView.delegate = self;
            [pickerView show];
        }else{
            [ZSTool showMessage:@"获取中介机构失败" withDuration:DefaultDuration];
            [self getMediumList];//获取项名称
        }
    }

}

//客户来源
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag;//选中某个按钮响应方法
{
    if (tag == 0)
    {
        [self showMediumMessage:YES];
        self.sourceView.rightLabel.text = @"中介推荐";
        self.sourceView.rightLabel.textColor = ZSColorListRight;
    }
    if (tag == 1)
    {
        [self showMediumMessage:NO];
        self.sourceView.rightLabel.text = @"线下客户";
        self.sourceView.rightLabel.textColor = ZSColorListRight;
    }
    
    [self CheckBottomBtnClick];//检测底部按钮点击状态
}
                                          

//中介
- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index
{
    self.mediumView.rightLabel.text = self.array_name[index];
    self.mediumView.rightLabel.textColor = ZSColorListRight;
    self.currentSelectMedium = self.array_ID[index];
    
    [self CheckBottomBtnClick];//检测底部按钮点击状态
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    //用于给手机号插入空格
    if (textField == self.phoneNumView.inputTextFeild) {
        if (textField.text.length > self.i_phoneNumber) {
            if (textField.text.length == 4 || textField.text.length == 9 ) {//输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:textField.text];
                [str insertString:@" " atIndex:(textField.text.length-1)];
                textField.text = str;
            }if (textField.text.length >= 13 ) {//输入完成
                textField.text = [textField.text substringToIndex:13];
                [textField resignFirstResponder];
            }
            self.i_phoneNumber = textField.text.length;
            
        }else if (textField.text.length < self.i_phoneNumber){//删除
            if (textField.text.length == 4 || textField.text.length == 9) {
                textField.text = [NSString stringWithFormat:@"%@",textField.text];
                textField.text = [textField.text substringToIndex:(textField.text.length-1)];
            }
            self.i_phoneNumber = textField.text.length;
        }
    }
}

#pragma mark 限制输入
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
    if (self.nameView.inputTextFeild == textField){
        //姓名长度限制40
        if ([toBeString length] > 40) {
            textField.text = [toBeString substringToIndex:40];
            return NO;
        }
    }
    //手机号长度限制11
    if (self.phoneNumView.inputTextFeild == textField){
        if ([toBeString length] > 13) {
            textField.text = [toBeString substringToIndex:13];
            return NO;
        }
    }
    return YES;
}

#pragma mark 键盘收回触发--判断输入是否正确
- ( void )textFieldDidEndEditing:( UITextField *)textField
{
    if (self.phoneNumView.inputTextFeild.text.length > 0) {
        if (![ZSTool isMobileNumber:self.phoneNumView.inputTextFeild.text]) {
            [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
        }
    }
}

#pragma mark 保存
- (void)bottomClick:(UIButton *)sender
{
    NSMutableDictionary *parameter = @{
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"prdType":self.prdType
                                       }.mutableCopy;
    if ([self.sourceView.rightLabel.text isEqualToString:@"线下客户"])
    {
        [parameter setObject:@"2" forKey:@"dataSrc"];
        [parameter setObject:@"" forKey:@"agencyId"];
        [parameter setObject:@"" forKey:@"agencyContact"];
        [parameter setObject:@"" forKey:@"agencyContactPhone"];
    }
    
    if ([self.sourceView.rightLabel.text isEqualToString:@"中介推荐"])
    {
        if (![self.phoneNumView.inputTextFeild.placeholder isEqualToString:@"请输入手机号"]) {
            if (![ZSTool isMobileNumber:self.phoneNumView.inputTextFeild.text]) {
                [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
                return;
            }
        }
        [parameter setObject:@"1" forKey:@"dataSrc"];
        [parameter setObject:self.currentSelectMedium forKey:@"agencyId"];
        //中介联系人名字
        if (![self.nameView.inputTextFeild.text isEqualToString:@"请输入姓名"]) {
            [parameter setObject:self.nameView.inputTextFeild.text forKey:@"agencyContact"];
        }else{
            [parameter setObject:@"" forKey:@"agencyContact"];
        }
        //中介联系人联系方式
        if (![self.phoneNumView.inputTextFeild.text isEqualToString:@"请输入手机号"]) {
            [parameter setObject:[ZSTool filteringTheBlankSpace:self.phoneNumView.inputTextFeild.text] forKey:@"agencyContactPhone"];
        }else{
            [parameter setObject:@"" forKey:@"agencyContactPhone"];
        }
    }
    __weak typeof(self) weakSelf  = self;
    [LSProgressHUD showWithMessage:@"提交中"];
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager changeCustomerSourceURL] SuccessBlock:^(NSDictionary *dic) {
        NSLog(@"修改成功");
        [weakSelf postNotification];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

- (void)postNotification
{
    [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
    [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
}

#pragma mark 根据情况判断底部按钮可否点击
- (void)CheckBottomBtnClick
{
    if ([self.sourceView.rightLabel.text isEqualToString:KPlaceholderChoose]) {
        [self setBottomBtnEnable:NO];//不可点击
    }
    else if ([self.sourceView.rightLabel.text isEqualToString:@"线下客户"]) {
        [self setBottomBtnEnable:YES];//可点击
    }
    else if ([self.sourceView.rightLabel.text isEqualToString:@"中介推荐"]) {
        if ([self.mediumView.rightLabel.text isEqualToString:KPlaceholderChoose]) {
            [self setBottomBtnEnable:NO];//不可点击
        }else{
            [self setBottomBtnEnable:YES];//可点击
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
