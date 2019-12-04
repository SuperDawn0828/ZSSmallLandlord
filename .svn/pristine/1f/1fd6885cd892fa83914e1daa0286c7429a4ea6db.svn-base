//
//  ZSChangeUserIDViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/8/4.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSChangeUserIDViewController.h"

@interface ZSChangeUserIDViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *txt_userId;
@end

@implementation ZSChangeUserIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"用户名";
    [self setLeftBarButtonItem];//返回按钮
    [self initView];
}

- (void)initView
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.view addSubview:backgroundView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0,70, CellHeight)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = ZSColorListLeft;
    nameLabel.attributedText = [@"用户名" addStar];
    [backgroundView addSubview:nameLabel];
    
    self.txt_userId = [[UITextField alloc]initWithFrame:CGRectMake(95,0, ZSWIDTH-95-15, CellHeight)];
    self.txt_userId.font = [UIFont systemFontOfSize:15];
    self.txt_userId.textAlignment = NSTextAlignmentRight;
    self.txt_userId.inputAccessoryView = [self addToolbar];
    self.txt_userId.delegate = self;
    [self.txt_userId addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.txt_userId];
    
    //底部按钮
    [self configuBottomButtonWithTitle:@"确认" OriginY:CellHeight + 15];
    
    //赋值
    ZSUidInfo *userInfo = [ZSTool readUserInfo];
    if (userInfo.userid.length) {
        self.txt_userId.text = userInfo.userid;
        [self setBottomBtnEnable:YES];
    }else{
        self.txt_userId.text = @"";
        self.txt_userId.placeholder = @"请输入";
        [self setBottomBtnEnable:NO];
    }
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    if (self.txt_userId.text.length >= 4) {
        [self setBottomBtnEnable:YES];
    }else{
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
    if ([toBeString length] > 20) { //如果输入框内容大于16则不让输入
        textField.text = [toBeString substringToIndex:20];
        return NO;
    }
    
    return YES;
}

#pragma mark 提交
- (void)bottomClick:(UIButton *)sender
{
    if (![ZSTool isLettersAndNumbersAndUnderScore:self.txt_userId.text]) {
        [ZSTool showMessage:@"用户名只能是字母数字下划线" withDuration:DefaultDuration];
        return;
    }

    [self changeNoticeState];
}

#pragma mark 修改个人资料
- (void)changeNoticeState
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@""];
    NSMutableDictionary *parameter = @{@"tid":[ZSTool readUserInfo].tid,
                                       @"userid":self.txt_userId.text}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager updateUserInformation] SuccessBlock:^(NSDictionary *dic){
        ZSLOG(@"修改资料成功:%@",dic);
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSTool saveUserInfoWithDic:newdic];
        //返回上级页面
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
