//
//  ZSChangePhoneViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/31.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSChangePhoneViewController.h"

@interface ZSChangePhoneViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *phoneTxt;
@property(nonatomic,strong)UITextField *txt_authCode;
@property(nonatomic,strong)UITextField *passwordTxt;
@property(nonatomic,strong)UIButton    *btn_getCode;
@property(nonatomic,assign)NSInteger   i_phoneNumber;//定义全局变量
@end

@implementation ZSChangePhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"手机号";
    [self setLeftBarButtonItem];//返回按钮
    if (self.isChange == YES) {
        [self initChangePhoneNumberView];
    }else{
        [self initGoToBindingView];
    }
}

#pragma mark 已绑定-更换手机号
- (void)initChangePhoneNumberView
{
    //背景view
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 155)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.view addSubview:backgroundView];
    //手机图标
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((ZSWIDTH-70)/2, 15,85, 85)];
    imgview.image = [UIImage imageNamed:@"list_binding_n"];
    [backgroundView addSubview:imgview];
    
    //手机号
    UILabel *label_phone = [[UILabel alloc]initWithFrame:CGRectMake(0,imgview.bottom+20, ZSWIDTH, 15)];
    label_phone.textColor = ZSColorListLeft;
    label_phone.font = [UIFont systemFontOfSize:15];
    label_phone.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label_phone];
    ZSUidInfo *userInfo = [ZSTool readUserInfo];
    label_phone.text = [NSString stringWithFormat:@"手机号码: %@",userInfo.telphone];
    //底部按钮
    [self configuBottomButtonWithTitle:@"更换手机号" OriginY:backgroundView.bottom + 15];
}

#pragma mark 未绑定-去绑定
- (void)initGoToBindingView
{
    //先移除底部按钮
    if (self.bottomBtn) {
        [self.bottomBtn removeFromSuperview];
    }
    //背景view
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 155)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.view addSubview:backgroundView];
    //手机图标
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((ZSWIDTH-70)/2, 15,85, 85)];
    imgview.image = [UIImage imageNamed:@"list_unbound_n"];
    [backgroundView addSubview:imgview];
    
    //手机号
    UILabel *label_phone = [[UILabel alloc]initWithFrame:CGRectMake(0,imgview.bottom+20, ZSWIDTH, 15)];
    label_phone.textColor = ZSColorListLeft;
    label_phone.font = [UIFont systemFontOfSize:15];
    label_phone.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label_phone];
    label_phone.text = @"暂未绑定手机";
    //底部按钮
    [self configuBottomButtonWithTitle:@"立即绑定" OriginY:backgroundView.bottom + 15];
}

#pragma mark 绑定手机号
- (void)initBindingView
{
    //先移除底部按钮
    if (self.bottomBtn) {
        [self.bottomBtn removeFromSuperview];
    }
    //背景view
    UIView *backgroundView_gray = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    backgroundView_gray.backgroundColor = ZSViewBackgroundColor;
    [self.view addSubview:backgroundView_gray];

    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight*3)];
    backgroundView.backgroundColor = ZSColorWhite;
    [backgroundView_gray addSubview:backgroundView];
    //登录密码
    UILabel *label_newagain = [[UILabel alloc]initWithFrame:CGRectMake(15,0,70, CellHeight)];
    label_newagain.font = [UIFont systemFontOfSize:15];
    label_newagain.textColor = ZSColorListLeft;
    label_newagain.text = @"登录密码";
    [backgroundView addSubview:label_newagain];
    self.passwordTxt = [[UITextField alloc]initWithFrame:CGRectMake(label_newagain.right+10,0, ZSWIDTH-110, CellHeight)];
    self.passwordTxt.placeholder = @"请输入";
    self.passwordTxt.font = [UIFont systemFontOfSize:15];
    self.passwordTxt.textAlignment = NSTextAlignmentRight;
    self.passwordTxt.inputAccessoryView = [self addToolbar];
    self.passwordTxt.secureTextEntry = YES;
    self.passwordTxt.delegate = self;
    [self.passwordTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.passwordTxt];
    //手机号
    UILabel *label_old = [[UILabel alloc]initWithFrame:CGRectMake(15,CellHeight,70, CellHeight)];
    label_old.font = [UIFont systemFontOfSize:15];
    label_old.textColor = ZSColorListLeft;
    label_old.text = @"新手机号";
    [backgroundView addSubview:label_old];
    self.phoneTxt = [[UITextField alloc]initWithFrame:CGRectMake(label_old.right+10, CellHeight, ZSWIDTH-110, CellHeight)];
    self.phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTxt.placeholder = @"请输入";
    self.phoneTxt.font = [UIFont systemFontOfSize:15];
    self.phoneTxt.textAlignment = NSTextAlignmentRight;
    self.phoneTxt.inputAccessoryView = [self addToolbar];
    self.phoneTxt.delegate = self;
    [self.phoneTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.phoneTxt];
    self.i_phoneNumber = 0;
    //验证码
    UILabel *label_new = [[UILabel alloc]initWithFrame:CGRectMake(15,CellHeight*2,70, CellHeight)];
    label_new.font = [UIFont systemFontOfSize:15];
    label_new.textColor = ZSColorListLeft;
    label_new.text = @"验证码";
    [backgroundView addSubview:label_new];
    self.txt_authCode = [[UITextField alloc]initWithFrame:CGRectMake(label_new.right+10,CellHeight*2, ZSWIDTH-110-130, CellHeight)];
    self.txt_authCode.placeholder = @"请输入";
    self.txt_authCode.font = [UIFont systemFontOfSize:15];
    self.txt_authCode.textAlignment = NSTextAlignmentLeft;
    self.txt_authCode.inputAccessoryView = [self addToolbar];
    self.txt_authCode.delegate = self;
    [self.txt_authCode addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.txt_authCode];
    //分割线
    UIView *lineView_s = [[UIView alloc]initWithFrame:CGRectMake(ZSWIDTH-130, self.phoneTxt.bottom+12, 0.5, 20)];
    lineView_s.backgroundColor = ZSColorLine;
    [backgroundView addSubview:lineView_s];
    //获取验证码按钮
    self.btn_getCode = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_getCode.frame = CGRectMake(lineView_s.right,self.phoneTxt.bottom,130, CellHeight);
    [self.btn_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.btn_getCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btn_getCode setTitleColor:ZSColorRed forState:UIControlStateNormal];
    [self.btn_getCode addTarget:self action:@selector(btn_getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:self.btn_getCode];
    //分割线
    [self.view addSubview:[ZSsmallControl lineViewFrame:CGRectMake(15, CellHeight-0.5  , ZSWIDTH-15, 0.5)]];
    [self.view addSubview:[ZSsmallControl lineViewFrame:CGRectMake(15, CellHeight*2-0.5, ZSWIDTH-15, 0.5)]];
    [self.view addSubview:[ZSsmallControl lineViewFrame:CGRectMake(15, CellHeight*3-0.5, ZSWIDTH-15, 0.5)]];

    //底部按钮
    [self configuBottomButtonWithTitle:@"确认" OriginY:CellHeight*3 + 15];
    [self setBottomBtnEnable:NO];
}

#pragma mark 提交
- (void)bottomClick:(UIButton *)sender
{
    //键盘回收
    [self.passwordTxt resignFirstResponder];
    [self.phoneTxt    resignFirstResponder];
    [self.txt_authCode resignFirstResponder];

    if ([sender.titleLabel.text isEqualToString:@"更换手机号"] || [sender.titleLabel.text isEqualToString:@"立即绑定"]) {
        [self initBindingView];
    }
    else{
        [self updateUserInformation];
    }
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField == self.phoneTxt) {
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
    
    if ([self.bottomBtn.titleLabel.text isEqualToString:@"确认"]) {
        if (self.phoneTxt.text.length>0 && self.txt_authCode.text.length>0 && self.passwordTxt.text.length > 0) {
            [self setBottomBtnEnable:YES];//恢复点击
        }else{
            [self setBottomBtnEnable:NO];//不可点击
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

    //手机号长度限制11
    if (self.phoneTxt == textField){
        if ([toBeString length] > 13) {
            textField.text = [toBeString substringToIndex:13];
            return NO;
        }
    }
    return YES;
}

#pragma mark 获取验证码
- (void)btn_getCodeAction
{
    if (self.phoneTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入手机号" withDuration:DefaultDuration];
    }else if (![ZSTool isMobileNumber:self.phoneTxt.text]){
        [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
    }
    else{
        __weak typeof(self) weakSelf = self;
        NSMutableDictionary *parameterDict = @{@"cellphone":[ZSTool filteringTheBlankSpace:self.phoneTxt.text]}.mutableCopy;
        [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getVerificationCodeOfBindingTelephone] SuccessBlock:^(NSDictionary *dic) {
            [ZSTool showMessage:@"验证码发送成功,请注意查收" withDuration:DefaultDuration];
            [weakSelf openCountdown];
            //不是正式环境直接显示到框框里面
            if (![APPDELEGATE.zsurlHead isEqualToString:KFormalServerUrl]) {
                weakSelf.txt_authCode.text = dic[@"respData"];
                [weakSelf setBottomBtnEnable:YES];
            }
        } ErrorBlock:^(NSError *error) {
        }];
    }
}

#pragma mark 倒计时
- (void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.btn_getCode setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.btn_getCode setTitleColor:ZSColorRed forState:UIControlStateNormal];
                self.btn_getCode.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.btn_getCode setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds]  forState:UIControlStateNormal];
                [self.btn_getCode setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
                self.btn_getCode.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark 修改绑定的手机号
- (void)updateUserInformation
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@""];
    NSMutableDictionary *parameter = @{@"tid":[ZSTool readUserInfo].tid,
                                       @"cellphone":[ZSTool filteringTheBlankSpace:self.phoneTxt.text],
                                       @"validateCode":self.txt_authCode.text,
                                       @"password":self.passwordTxt.text}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager updateTheBindingPhone] SuccessBlock:^(NSDictionary *dic){
        ZSLOG(@"修改手机号成功:%@",dic);
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSTool saveUserInfoWithDic:newdic];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
