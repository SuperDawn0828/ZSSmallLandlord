//
//  ZSForgetPasswordViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSForgetPasswordViewController.h"
#import "ZSSetPasswordViewController.h"

@interface ZSForgetPasswordViewController ()
@property(nonatomic,strong)UITextField *phoneTxt;
@property(nonatomic,strong)UITextField *txt_authCode;
@property(nonatomic,strong)UIButton    *btn_getCode;
@property(nonatomic,assign)NSInteger   i_phoneNumber;
@end

@implementation ZSForgetPasswordViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//设置状态栏字体颜色
}

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
    titleLabel.text = @"找回密码";
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
   
    //输入框-手机号
    self.phoneTxt = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ZSWIDTH-30, CellHeight)];
    self.phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTxt.font = [UIFont systemFontOfSize:15];
    self.phoneTxt.placeholder = @"请输入手机号";
    self.phoneTxt.inputAccessoryView = [self addToolbar];
    [self.phoneTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.phoneTxt];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, self.phoneTxt.bottom, backgroundView.width-30, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [backgroundView addSubview:lineView];
    self.i_phoneNumber = 0;
 
    //输入框-验证码
    self.txt_authCode = [[UITextField alloc]initWithFrame:CGRectMake(15, self.phoneTxt.bottom, 100, CellHeight)];
    self.txt_authCode.font = [UIFont systemFontOfSize:15];
    self.txt_authCode.placeholder = @"验证码";
    self.txt_authCode.inputAccessoryView = [self addToolbar];
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
 
    //提交按钮
    [self configuBottomButtonWithTitle:@"提交" OriginY:backgroundView.bottom+15];
    [self setBottomBtnEnable:NO];//默认不可点击]
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
    
    if (self.phoneTxt.text.length>0 && self.txt_authCode.text.length>0) {
        [self setBottomBtnEnable:YES];//恢复点击
    }
    else
    {
        [self setBottomBtnEnable:NO];//不可点击
    }
}

#pragma mark 返回
- (void)leftAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
        [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getVerificationCode] SuccessBlock:^(NSDictionary *dic) {
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

#pragma mark 提交
- (void)bottomClick:(UIButton *)sender
{
    //键盘回收
    [self hideKeyboard];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{@"cellphone":[ZSTool filteringTheBlankSpace:self.phoneTxt.text],
                                           @"validateCode":self.txt_authCode.text}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getVerificationCodeCompare] SuccessBlock:^(NSDictionary *dic) {
        ZSSetPasswordViewController *setpasswordVC = [[ZSSetPasswordViewController alloc]init];
        setpasswordVC.userphone = weakSelf.phoneTxt.text;
        [weakSelf presentViewController:setpasswordVC animated:NO completion:nil];
    } ErrorBlock:^(NSError *error) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
