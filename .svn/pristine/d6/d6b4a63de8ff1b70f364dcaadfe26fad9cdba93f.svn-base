//
//  ZSSetPasswordViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSetPasswordViewController.h"
#import "ZSTabBarViewController.h"
#import "ZSLogInViewController.h"

@interface ZSSetPasswordViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *passwordTxt;
@property(nonatomic,strong)UITextField *txt_againPassword;
@end

@implementation ZSSetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavView];
    [self initView];
}

- (void)initNavView
{
    //导航栏背景色
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, kNavigationBarHeight)];
    navView.backgroundColor = ZSColorRed;
    [self.view addSubview:navView];
   
    //导航栏返回按钮
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_back.frame = CGRectMake(15, kStatusBarHeight, 44, 44);
    [btn_back addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btn_back];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, ((kNavigationBarHeight-kStatusBarHeight)-25)/2, 25 , 25)];
    imgView.image = [UIImage imageNamed:@"head_return_n"];
    [btn_back addSubview:imgView];
   
    //导航栏标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ZSWIDTH-150)/2, kStatusBarHeight, 150, kNavigationBarHeight-kStatusBarHeight)];
    titleLabel.text = @"设置密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = ZSColorWhite;
    [navView addSubview:titleLabel];
}

- (void)initView
{
    //底色
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, CellHeight*2)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.view addSubview:backgroundView];
   
    //输入框-密码
    self.passwordTxt = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ZSWIDTH-30, CellHeight)];
    self.passwordTxt.font = [UIFont systemFontOfSize:15];
    self.passwordTxt.placeholder = @"输入新密码";
    self.passwordTxt.delegate = self;
    self.passwordTxt.inputAccessoryView = [self addToolbar];
    [self.passwordTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.passwordTxt.secureTextEntry = YES;
    [backgroundView addSubview:self.passwordTxt];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, self.passwordTxt.bottom, backgroundView.width-30, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [backgroundView addSubview:lineView];
  
    //输入框-确认密码
    self.txt_againPassword = [[UITextField alloc]initWithFrame:CGRectMake(15, self.passwordTxt.bottom,  ZSWIDTH-30, CellHeight)];
    self.txt_againPassword.font = [UIFont systemFontOfSize:15];
    self.txt_againPassword.placeholder = @"确认新密码";
    self.txt_againPassword.delegate = self;
    self.txt_againPassword.inputAccessoryView = [self addToolbar];
    [self.txt_againPassword addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.txt_againPassword.secureTextEntry = YES;
    [backgroundView addSubview:self.txt_againPassword];
  
    //提交按钮
    [self configuBottomButtonWithTitle:@"提交" OriginY:backgroundView.bottom+15];
    [self setBottomBtnEnable:NO];//默认不可点击
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    if (self.passwordTxt.text.length>0 && self.txt_againPassword.text.length>0) {
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

#pragma mark 返回
- (void)leftAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark 提交
- (void)bottomClick:(UIButton *)sender
{
    if (![ZSTool isPassword:self.passwordTxt.text] || ![ZSTool isPassword:self.txt_againPassword.text]) {
        [ZSTool showMessage:@"密码不符合规则,请重新输入" withDuration:DefaultDuration];
        return;
    }
    if (self.passwordTxt.text.length < 8 || self.txt_againPassword.text.length < 8) {
        [ZSTool showMessage:@"密码长度不能少于8位" withDuration:DefaultDuration];
        return;
    }
    if (![self.passwordTxt.text isEqualToString:self.txt_againPassword.text]) {
        [ZSTool showMessage:@"两次密码输入不一致" withDuration:DefaultDuration];
        return;
    }
    
    //键盘回收
    [self hideKeyboard];
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@""];
    NSMutableDictionary *parameterDict = @{@"cellphone":[ZSTool filteringTheBlankSpace:self.userphone],
                                           @"newPass":self.passwordTxt.text}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getForgetPassword] SuccessBlock:^(NSDictionary *dic) {
//        ZSLogInViewController *loginVC = [[ZSLogInViewController alloc]init];
//        [weakSelf presentViewController:loginVC animated:YES completion:nil];
        //重新登录
        [weakSelf reLogIn];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 修改密码以后重新登录
- (void)reLogIn
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"登录中..."];
    NSMutableDictionary *parameterDict = @{
                                           @"telephone":[ZSTool filteringTheBlankSpace:self.userphone],
                                           @"password":self.passwordTxt.text,
                                           @"loginType":@"1",//1手机号密码登录 2本机登录 3微信登录
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getLoginURL] SuccessBlock:^(NSDictionary *dic) {
        //通知极光设置用户的alias
        [NOTI_CENTER postNotificationName:KSSendUserAliasToJpush object:nil];
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSTool saveUserInfoWithDic:newdic];
        [USER_DEFALT setObject:dic[@"respData"][@"tokenForApp"] forKey:tokenForApp];
        //页面跳转
        ZSTabBarViewController *tabbarVC = [[ZSTabBarViewController alloc]init];
        APPDELEGATE.window.rootViewController = tabbarVC;
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
