//
//  ZSAddRecordViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSAddRecordViewController.h"

@interface ZSAddRecordViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UITextView *inputTextView;
@property (nonatomic,strong) UILabel    *placeholderLabel;
@end

@implementation ZSAddRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新增跟进记录";
    [self setLeftBarButtonItem];//返回按钮
    [self initTextView];
}

- (void)initTextView
{
    self.automaticallyAdjustsScrollViewInsets = NO;//关闭导航栏自适应,使textview文字不居中
    //输入框
    self.inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 194)];
    self.inputTextView.font = [UIFont systemFontOfSize:15];
    self.inputTextView.textColor = ZSColorListRight;
    self.inputTextView.delegate = self;
    self.inputTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 5);//top left
    self.inputTextView.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    self.inputTextView.inputAccessoryView = [self addToolbar];//顶部工具栏
    [self.view addSubview:self.inputTextView];
    
    //placeholder
    self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 13.5, self.inputTextView.width, 20)];
    self.placeholderLabel.text = @"请输入跟进情况";
    self.placeholderLabel.textColor = ZSColorAllNotice;
    self.placeholderLabel.font = [UIFont systemFontOfSize:15];
    [self.inputTextView addSubview:self.placeholderLabel];
    
    //textView内容变化时调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ValueChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    //底部按钮
    [self configuBottomButtonWithTitle:@"保存" OriginY:self.inputTextView.bottom+15];
    [self setBottomBtnEnable:NO];
}

#pragma mark textView--输入限制
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //限制输入表情
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
        return NO;
    }
    //判断键盘是不是九宫格键盘
    if ([ZSTool isNineKeyBoard:text] ){
        return YES;
    }else{
        //限制输入表情
        if ([ZSTool stringContainsEmoji:text]) {
            return NO;
        }
    }
    
    //得到输入框的内容
    NSString *toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    //不允许输入空格
    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![text isEqualToString:tem]) {
        return NO;
    }
    
    //最多只能输入500个子
    if (range.location > 500) {
        [ZSTool showMessage:@"最多只能输入500字" withDuration:DefaultDuration];
        textView.text = [toBeString substringToIndex:500];
        return NO;
    }
    return YES;
}

#pragma mark textView内容变化时调用
- (void)ValueChange:(NSNotification *)obj
{
    //隐藏placeholer
    self.placeholderLabel.hidden = [@(self.inputTextView.text.length) boolValue];
    //解决复制粘贴的坑
    [self.inputTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    //超过长度字符串截取
    if (self.inputTextView.text.length > 500) {
        self.inputTextView.text = [self.inputTextView.text substringToIndex:500];
    }
    //控制按钮点击
    if (self.inputTextView.text.length > 0) {
        [self setBottomBtnEnable:YES];
    }else{
        [self setBottomBtnEnable:NO];
    }
}

#pragma mark 保存
- (void)bottomClick:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@""];
    NSMutableDictionary *parameterDict = @{
                                           @"applyId":self.onlineOrderIDString,
                                           @"followContent":self.inputTextView.text}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getAddRecordURL] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //通知订单详情刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
