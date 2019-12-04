//
//  ZSLogInViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSLogInViewController.h"
#import "ZSTabBarViewController.h"
#import "ZSForgetPasswordViewController.h"
#import <TYRZSDK/TYRZSDK.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

static NSString *const KZGYDAppID      = @"300011876989";                                //中国移动APPID
static NSString *const KZGYDAppKey     = @"74A70B48E111EF6438F03FF1C0AE0DAA";            //中国移动APPKey

@interface ZSLogInViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *phoneTxt;
@property(nonatomic,strong)UITextField *passwordTxt;
@property(nonatomic,strong)UIButton    *loginBtn;
@end

@implementation ZSLogInViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//设置状态栏字体颜色
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:YES];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//设置状态栏字体颜色
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ZSColorWhite;
    [self initView];
}

- (void)initView
{
    //底色
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, ZSWIDTH-30, ZSHEIGHT)];
    backgroundView.backgroundColor = ZSColorWhite;
    backgroundView.layer.cornerRadius = 3;
    [self.view addSubview:backgroundView];
   
    //title
    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake((backgroundView.width-170)/2, 136, 170, 33)];
    titleImg.image = [UIImage imageNamed:@"login_logo_n"];
    [backgroundView addSubview:titleImg];
  
    //输入框-用户名
    self.phoneTxt = [[UITextField alloc]initWithFrame:CGRectMake(20, titleImg.bottom+60, backgroundView.width-40, 30)];
    self.phoneTxt.font = [UIFont systemFontOfSize:15];
    self.phoneTxt.placeholder = @"请输入用户名/手机号";
    [self.phoneTxt setValue:ZSColorAllNotice forKeyPath:@"_placeholderLabel.textColor"];
    self.phoneTxt.delegate = self;
    self.phoneTxt.inputAccessoryView = [self addToolbar];
    [self.phoneTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.phoneTxt];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, self.phoneTxt.bottom, backgroundView.width-40, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [backgroundView addSubview:lineView];
  
    //输入框-密码
    self.passwordTxt = [[UITextField alloc]initWithFrame:CGRectMake(20, lineView.bottom+20, backgroundView.width-60, 30)];
    self.passwordTxt.font = [UIFont systemFontOfSize:15];
    self.passwordTxt.placeholder = @"请输入密码";
    [self.passwordTxt setValue:ZSColorAllNotice forKeyPath:@"_placeholderLabel.textColor"];
    self.passwordTxt.delegate = self;
    self.passwordTxt.inputAccessoryView = [self addToolbar];
    [self.passwordTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.passwordTxt.secureTextEntry = YES;
    [backgroundView addSubview:self.passwordTxt];
    UIView *lineView_psw = [[UIView alloc]initWithFrame:CGRectMake(20, self.passwordTxt.bottom, backgroundView.width-40, 0.5)];
    lineView_psw.backgroundColor = ZSColorLine;
    [backgroundView addSubview:lineView_psw];
  
    //是否显示密码按钮
    UIButton *seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seeBtn.frame = CGRectMake(backgroundView.width-30-20,lineView.bottom+20, 30, 30);
    [seeBtn addTarget:self action:@selector(seeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [seeBtn setImage:[UIImage imageNamed:@"login_password_n"] forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"login_password_s"] forState:UIControlStateSelected];
    [backgroundView addSubview:seeBtn];
  
    //登陆按钮
    [self configuBottomButtonWithTitle:@"登录" OriginY:self.passwordTxt.bottom+20];
    [self setBottomBtnEnable:NO];//默认不可点击
    self.bottomBtn.frame = CGRectMake(20,self.passwordTxt.bottom+20, backgroundView.width-40, CellHeight);
    [backgroundView addSubview:self.bottomBtn];
   
    //忘记密码按钮
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(20,self.bottomBtn.bottom+10, 75, CellHeight);
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    forgetBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backgroundView addSubview:forgetBtn];
 
    //一键登录按钮
    UIButton *aKeyLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aKeyLoginBtn.frame = CGRectMake((ZSWIDTH-30-44)/2, backgroundView.height - 150, 44, 44);
    [aKeyLoginBtn setImage:[UIImage imageNamed:@"a_key_login"] forState:UIControlStateNormal];
    [aKeyLoginBtn addTarget:self action:@selector(aKeyLoginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:aKeyLoginBtn];
    //title
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, aKeyLoginBtn.bottom, ZSWIDTH-30, 30)];
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = ZSColorAllNotice;
    title.text = [NSString stringWithFormat:@"一键登录"];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroundView
     addSubview:title];
    
    //底部图片
    UIImageView *imgview_bottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT-50, ZSWIDTH, 50)];
    imgview_bottom.image = [UIImage imageNamed:@"login_bg_n"];
    [self.view addSubview:imgview_bottom];
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    if (self.phoneTxt.text.length>0 && self.passwordTxt.text.length>0) {
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
    if (self.phoneTxt == textField){
        if ([toBeString length] > 20) { //如果输入框内容大于20则不让输入
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    if (self.passwordTxt == textField){
        if ([toBeString length] > 16) {//如果输入框内容大于18则不让输入
            textField.text = [toBeString substringToIndex:16];
            return NO;
        }
    }
    return YES;
}

#pragma mark 查看密码
- (void)seeBtnAction:(UIButton *)btn
{
    if (btn.selected == NO) {
        btn.selected = YES;
        self.passwordTxt.secureTextEntry = NO;//显示密码
    }else{
        btn.selected = NO;
        self.passwordTxt.secureTextEntry = YES;//隐藏
    }
}

#pragma mark 登录
- (void)bottomClick:(UIButton *)sender
{
    //键盘回收
    [self hideKeyboard];
    //接口
    [self gotoLoginWithType:@"1" withToken:nil];
}

#pragma mark 忘记密码
- (void)forgetBtnAction
{
    ZSForgetPasswordViewController *forgetVC = [[ZSForgetPasswordViewController alloc]init];
    [self presentViewController:forgetVC animated:YES completion:nil];
}

#pragma mark 一键登录
- (void)aKeyLoginBtnAction
{
    //判断当前用户是否安装sim卡
    if (![self isSIMInstalled]) {
        [ZSTool showMessage:@"请先安装SIM卡" withDuration:DefaultDuration];
        return;
    }
    
    //判断当前用户sim卡的运营商
    NSDictionary *typeDic = [TYRZUILogin networkType];
    NSString *carrierType = [NSString stringWithFormat:@"%@",typeDic[@"carrier"]];
    if ([carrierType isEqualToString:@"2"]) {
        [ZSTool showMessage:@"联通用户暂不支持一键登录" withDuration:DefaultDuration];
        return;
    }
    
    //授权页面样式修改
    UACustomModel *model = [[UACustomModel alloc]init];
    model.barStyle = UIBarStyleBlack;
    model.navColor = ZSColorWhite;
    model.navReturnImg = [UIImage imageNamed:@"tool_guanbi_n"];
    model.logoImg = [UIImage imageNamed:@"login_logo_n"];
    model.logoWidth = 170;
    model.logoHeight = 33;
    model.navText = [[NSAttributedString alloc]initWithString:@"" attributes:@{}];
    model.swithAccHidden = YES;
    model.logBtnColor = ZSColorRed;
    model.appPrivacyColor = ZSColorRed;
    [TYRZUILogin customUIWithParams:model
                        customViews:^(UIView *customAreaView)
    {
        //自定义view
        UIButton *accountPsdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        accountPsdBtn.frame = CGRectMake((ZSWIDTH-44)/2, ZSHEIGHT-kNavigationBarHeight-150, 44, 44);
        [accountPsdBtn setImage:[UIImage imageNamed:@"accountPsd_login"] forState:UIControlStateNormal];
        [accountPsdBtn addTarget:self action:@selector(accountPsdBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [customAreaView addSubview:accountPsdBtn];
        //title
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, accountPsdBtn.bottom, ZSWIDTH, 30)];
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = ZSColor(163, 163, 163);
        title.text = [NSString stringWithFormat:@"账号登录"];
        title.textAlignment = NSTextAlignmentCenter;
        [customAreaView addSubview:title];
    }
    ];
    
    //跳转至授权页
    __weak typeof(self) weakSelf = self;
    [TYRZUILogin getTokenExpWithController:self timeout:8000 complete:^(id sender) {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:sender];
        ZSLOG(@"-------哈哈哈:%@",result);
        if (result[@"token"]) {
            [weakSelf gotoLoginWithType:@"2" withToken:result[@"token"]];
        }
    }];
}

- (void)accountPsdBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 登录接口
- (void)gotoLoginWithType:(NSString *)loginType withToken:(NSString *)token
{
    NSMutableDictionary *parameterDict = @{@"loginType":loginType}.mutableCopy;//1手机号密码登录 2本机登录 3微信登录
    if ([loginType isEqualToString:@"1"])
    {
        [parameterDict setObject:[ZSTool filteringTheBlankSpace:self.phoneTxt.text] forKey:@"telephone"];
        [parameterDict setObject:self.passwordTxt.text forKey:@"password"];
    }
    else if ([loginType isEqualToString:@"2"])
    {
        [parameterDict setObject:KZGYDAppID forKey:@"appid"];
        [parameterDict setObject:KZGYDAppKey forKey:@"appkey"];
        [parameterDict setObject:token forKey:@"token"];
    }
    
    [LSProgressHUD show];
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
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 判断设备是否安装sim卡
- (BOOL)isSIMInstalled
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    if (!carrier.isoCountryCode) {
        NSLog(@"无SIM卡");
        return NO;
    }else{
        NSLog(@"有SIM卡");
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
