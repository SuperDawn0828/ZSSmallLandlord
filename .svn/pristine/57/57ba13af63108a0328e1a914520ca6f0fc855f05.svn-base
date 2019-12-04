//
//  ZSSLMediumMessageViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLMediumMessageViewController.h"
#import "ZSBaseAddCustomerViewController.h"
#import "ZSInputOrSelectView.h"

@interface ZSSLMediumMessageViewController ()<ZSInputOrSelectViewDelegate,UITextFieldDelegate,ZSPickerViewDelegate,UITextViewDelegate>
@property(nonatomic,strong)ZSInputOrSelectView      *mediumView;          //中介结构
@property(nonatomic,strong)ZSInputOrSelectView      *nameView;            //姓名
@property(nonatomic,strong)ZSInputOrSelectView      *phoneNumView;        //联系方式
@property(nonatomic,strong)NSMutableArray           *array_name;          //中介名称
@property(nonatomic,strong)NSMutableArray           *array_ID;            //中介id
@property(nonatomic,copy  )NSString                 *currentSelectMedium; //当前选中的中介ID
@property(nonatomic,assign)NSInteger                i_phoneNumber;        //用来设置输入手机号做空格用
@end

@implementation ZSSLMediumMessageViewController

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
    self.title = @"中介信息";
    [self setLeftBarButtonItem];//返回按钮
    [self initView];
    //Data
    [self getMediumList];
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
    //中介结构
    self.mediumView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withClickAction:@"中介机构 *"];
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

    //底部按钮
    [self configuBottomButtonWithTitle:@"下一步" OriginY:self.phoneNumView.bottom+15];
    [self setBottomBtnEnable:NO];//默认不可点击
}

#pragma mark 选择中介
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    //键盘回收
    [self.nameView.inputTextFeild resignFirstResponder];
    [self.phoneNumView.inputTextFeild resignFirstResponder];

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

- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index
{
    self.mediumView.rightLabel.text = self.array_name[index];
    self.mediumView.rightLabel.textColor = ZSColorListRight;
    self.currentSelectMedium = self.array_ID[index];
    
    if (![self.mediumView.rightLabel.text isEqualToString:KPlaceholderChoose]) {
        [self setBottomBtnEnable:YES];//恢复点击
    }
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

#pragma mark 下一步
- (void)bottomClick:(UIButton *)sender
{
    if ([self.mediumView.rightLabel.text isEqualToString:KPlaceholderChoose]) {
        [ZSTool showMessage:@"请选择中介机构" withDuration:DefaultDuration];
        return;
    }
    if (self.phoneNumView.inputTextFeild.text.length > 0) {
        if (![ZSTool isMobileNumber:self.phoneNumView.inputTextFeild.text]) {
            [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
            return;
        }
    }
    
    //清空人员信息
    global.bizCustomers = nil;
    
    ZSBaseAddCustomerViewController *addVC = [[ZSBaseAddCustomerViewController alloc]init];
    addVC.isFromAdd = YES;
    addVC.title = @"贷款人信息";
    addVC.prdType = self.prdType;
    //中介id
    addVC.mediumID = self.currentSelectMedium;
    //中介联系人名字
    if (![self.nameView.inputTextFeild.text isEqualToString:@"请输入姓名"]) {
        addVC.mediumName = self.nameView.inputTextFeild.text;
    }
    //中介联系人联系方式
    if (![self.phoneNumView.inputTextFeild.text isEqualToString:@"请输入手机号"]) {
        addVC.mediumPhone = [ZSTool filteringTheBlankSpace:self.phoneNumView.inputTextFeild.text];//过滤手机号空格
    }
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
