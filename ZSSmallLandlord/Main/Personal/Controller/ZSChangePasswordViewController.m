//
//  ChangePasswordViewController.m
//  ZSSmallLandlord
//
//  Created by cong on 17/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSChangePasswordViewController.h"
#import "ZSLogInViewController.h"

@interface ZSChangePasswordViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *oldPassword;
@property(nonatomic,strong)UITextField *NewPassword;
@property(nonatomic,strong)UITextField *TwoNewPassword;

@end

@implementation ZSChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    [self setLeftBarButtonItem];//返回按钮
    [self initTextField];
}

- (void)initTextField
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight*3)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.view addSubview:backgroundView];
    //旧密码
    UILabel *label_old = [[UILabel alloc]initWithFrame:CGRectMake(15,0,70, CellHeight)];
    label_old.font = [UIFont systemFontOfSize:15];
    label_old.textColor = ZSColorListLeft;
    label_old.text = @"旧密码";
    [backgroundView addSubview:label_old];
    self.oldPassword = [[UITextField alloc]initWithFrame:CGRectMake(label_old.right+10, 0, ZSWIDTH-110, CellHeight)];
    self.oldPassword.placeholder = @"请输入旧密码";
    self.oldPassword.font = [UIFont systemFontOfSize:15];
    self.oldPassword.textAlignment = NSTextAlignmentRight;
    self.oldPassword.inputAccessoryView = [self addToolbar];
    self.oldPassword.secureTextEntry = YES;
    self.oldPassword.delegate = self;
    [self.oldPassword addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.oldPassword];
    //新密码
    UILabel *label_new = [[UILabel alloc]initWithFrame:CGRectMake(15,CellHeight,70, CellHeight)];
    label_new.font = [UIFont systemFontOfSize:15];
    label_new.textColor = ZSColorListLeft;
    label_new.text = @"新密码";
    [backgroundView addSubview:label_new];
    self.NewPassword = [[UITextField alloc]initWithFrame:CGRectMake(label_new.right+10,CellHeight, ZSWIDTH-110, CellHeight)];
    self.NewPassword.placeholder = @"请输入新密码";
    self.NewPassword.font = [UIFont systemFontOfSize:15];
    self.NewPassword.textAlignment = NSTextAlignmentRight;
    self.NewPassword.inputAccessoryView = [self addToolbar];
    self.NewPassword.secureTextEntry = YES;
    self.NewPassword.delegate = self;
    [self.NewPassword addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.NewPassword];
    //第二次新密码
    UILabel *label_newagain = [[UILabel alloc]initWithFrame:CGRectMake(15,CellHeight*2,70, CellHeight)];
    label_newagain.font = [UIFont systemFontOfSize:15];
    label_newagain.textColor = ZSColorListLeft;
    label_newagain.text = @"确认密码";
    [backgroundView addSubview:label_newagain];
    self.TwoNewPassword = [[UITextField alloc]initWithFrame:CGRectMake(label_newagain.right+10,CellHeight*2, ZSWIDTH-110, CellHeight)];
    self.TwoNewPassword.placeholder = @"确认密码";
    self.TwoNewPassword.font = [UIFont systemFontOfSize:15];
    self.TwoNewPassword.textAlignment = NSTextAlignmentRight;
    self.TwoNewPassword.inputAccessoryView = [self addToolbar];
    self.TwoNewPassword.secureTextEntry = YES;
    self.TwoNewPassword.delegate = self;
    [self.TwoNewPassword addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.TwoNewPassword];
    //分割线
    [self.view addSubview:[ZSsmallControl lineViewFrame:CGRectMake(15, CellHeight-0.5  , ZSWIDTH-15, 0.5)]];
    [self.view addSubview:[ZSsmallControl lineViewFrame:CGRectMake(15, CellHeight*2-0.5, ZSWIDTH-15, 0.5)]];
    [self.view addSubview:[ZSsmallControl lineViewFrame:CGRectMake(15, CellHeight*3-0.5, ZSWIDTH-15, 0.5)]];
    //提示
    UILabel *promptlabel = [ZSsmallControl LFrame:CGRectMake(15, CellHeight*3, ZSWIDTH, CellHeight) LText:@"如果您忘记旧密码，请联系管理员进行重置！" LColor:ZSColorWhite LFont:13];
    promptlabel.textColor =ZSColor(168, 168, 168);
    [self.view addSubview:promptlabel];
    //确定按钮
    [self configuBottomButtonWithTitle:@"确定" OriginY:CellHeight*4];
    [self setBottomBtnEnable:NO];//默认不可点击
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    if (self.oldPassword.text.length>0 && self.NewPassword.text.length>0 && self.TwoNewPassword.text.length>0) {
        [self setBottomBtnEnable:YES];//恢复点击
    }
    else
    {
        [self setBottomBtnEnable:NO];//不可点击
    }
}

#pragma mark textField--限制输入的字数
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
    if ([toBeString length] > 16) { //如果输入框内容大于16则不让输入
        textField.text = [toBeString substringToIndex:16];
        return NO;
    }
    return YES;
}

#pragma mark 确定
- (void)bottomClick:(UIButton *)sender
{
    if (![ZSTool isPassword:self.NewPassword.text] || ![ZSTool isPassword:self.TwoNewPassword.text]) {
        [ZSTool showMessage:@"密码不符合规则,请重新输入" withDuration:DefaultDuration];
        return;
    }
    if (self.NewPassword.text.length < 8 || self.TwoNewPassword.text.length < 8) {
        [ZSTool showMessage:@"密码长度不能少于8位" withDuration:DefaultDuration];
        return;
    }
    if ([self.NewPassword.text isEqualToString:self.oldPassword.text]) {
        [ZSTool showMessage:@"新旧密码不能一样" withDuration:DefaultDuration];
        return;
    }
    if (![self.NewPassword.text isEqualToString:self.TwoNewPassword.text]) {
        [ZSTool showMessage:@"两次密码输入不一致" withDuration:DefaultDuration];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"修改中..."];
    NSMutableDictionary *parameterDict = @{@"tid":[ZSTool readUserInfo].tid,
                                           @"oldPwd":self.oldPassword.text,
                                           @"newPwd":self.NewPassword.text
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getRsetPassword] SuccessBlock:^(NSDictionary *dic) {
        [ZSTool showMessage:@"密码修改成功,请重新登录" withDuration:DefaultDuration];
        ZSLogInViewController *loginVC = [[ZSLogInViewController alloc]init];
        [weakSelf.navigationController presentViewController:loginVC animated:YES completion:nil];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

@end
