//
//  ZSBasePopView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/27.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSBasePopView.h"

@implementation ZSBasePopView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {

    }
    return self;
}

#pragma mark /*------------------------------------------------黑底白底----------------------------------------------------*/
- (void)configureViews
{
    //黑底
    self.blackBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    self.blackBackgroundView.backgroundColor = ZSColorBlack;
    self.blackBackgroundView.alpha = 0;
    [self addSubview:self.blackBackgroundView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.blackBackgroundView addGestureRecognizer:tap];
    
    //白底
    self.whiteBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT_PopupWindow, ZSWIDTH, ZSHEIGHT_PopupWindow*0.66)];
    self.whiteBackgroundView.backgroundColor = ZSColorWhite;
    self.whiteBackgroundView.layer.cornerRadius = 3;
    self.whiteBackgroundView.alpha = 0;
    [self addSubview:self.whiteBackgroundView];
    
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 10, 100, CellHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = ZSColorBlack;
    [self.whiteBackgroundView addSubview:self.titleLabel];
    
    //关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(ZSWIDTH-CellHeight-GapWidth, 10, CellHeight, CellHeight);
    [closeBtn setImage:[UIImage imageNamed:@"tool_guanbi_n"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.whiteBackgroundView addSubview:closeBtn];
}

#pragma mark /*-------------------------------------------------底部按钮-----------------------------------------------------*/
- (void)configureSubmitBtn:(NSString *)titleString
{
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(GapWidth, self.whiteBackgroundView.height-SafeAreaBottomHeight-CellHeight-7, ZSWIDTH-GapWidth*2, CellHeight);
    [submitBtn setTitle:titleString forState:UIControlStateNormal];
    [submitBtn setTitleColor:ZSColorRed forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = ZSColorWhite;
    submitBtn.layer.borderWidth = 0.5;
    submitBtn.layer.borderColor = ZSColorRed.CGColor;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 22;
    [self.whiteBackgroundView addSubview:submitBtn];
}

- (void)submitBtnAction
{
    
}

#pragma mark /*-------------------------------------------------输入框-----------------------------------------------------*/
- (void)configureInputViewWithFrame:(CGRect)frame withString:(NSString *)string
{
    //背景ScrollView
    self.inputBgScroll = [[UIScrollView alloc]initWithFrame:frame];
    self.inputBgScroll.contentSize = CGSizeMake(0, self.whiteBackgroundView.height);
    [self.whiteBackgroundView addSubview:self.inputBgScroll];
    
    //title
    UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 0, 100, CellHeight)];
    remarkLabel.font = [UIFont systemFontOfSize:14];
    remarkLabel.textColor = ZSColorBlack;
    remarkLabel.text = string;
    [self.inputBgScroll addSubview:remarkLabel];
    
    //输入框
    self.inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(GapWidth, remarkLabel.bottom, ZSWIDTH-GapWidth*2, 200)];
    self.inputTextView.font = [UIFont systemFontOfSize:14];
    self.inputTextView.textColor = ZSColorListRight;
    self.inputTextView.layer.borderWidth = 0.5;
    self.inputTextView.layer.borderColor = ZSColorAllNotice.CGColor;
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.layer.cornerRadius = 5;
    self.inputTextView.delegate = self;
    self.inputTextView.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    self.inputTextView.inputAccessoryView = [self addToolbar];//顶部工具栏
    [self.inputBgScroll addSubview:self.inputTextView];
    
    //placeholder
    self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.inputTextView.width, 18)];
    self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
    self.placeholderLabel.text = KPlaceholderInput;
    self.placeholderLabel.textColor = ZSColorAllNotice;
    self.placeholderLabel.font = [UIFont systemFontOfSize:15];
    [self.inputTextView addSubview:self.placeholderLabel];
    
    //不需要title的时候
    if ([string isEqualToString:@""]) {
        [remarkLabel removeFromSuperview];
        self.inputTextView.frame = CGRectMake(GapWidth, 10, ZSWIDTH-GapWidth*2, 200);
    }
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

- (void)textViewDidChange:(UITextView *)textView
{
    //隐藏placeholer
    self.placeholderLabel.hidden = [@(self.inputTextView.text.length) boolValue];
    
    if (textView.text.length > 500) {
        [ZSTool showMessage:@"最多只能输入500字" withDuration:DefaultDuration];
        textView.text = [textView.text substringToIndex:500];
    }
}

//键盘添加工具栏
- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, 35)];
    toolbar.tintColor = ZSColor(0, 126, 229);
    toolbar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    toolbar.items = @[nextButton, prevButton, space, bar];
    return toolbar;
}

//隐藏键盘
- (void)hideKeyboard
{
    [self endEditing:YES];
}

#pragma mark /*-------------------------------------------------tableView----------------------------------------------------*/
- (void)configureTableView:(CGRect)frame withStyle:(UITableViewStyle)style
{
    self.tableView = [[UITableView alloc]initWithFrame:frame style:style];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ZSViewBackgroundColor;
    [self.whiteBackgroundView addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark /*-------------------------------------------------显隐-----------------------------------------------------*/
#pragma mark 显示自己
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.blackBackgroundView.alpha = 0.5;
        self.whiteBackgroundView.alpha = 1;
        self.whiteBackgroundView.top = ZSHEIGHT_PopupWindow - ZSHEIGHT_PopupWindow*0.66;
    }];
}

#pragma mark 移除自己
- (void)dismiss
{
    [self removeFromSuperview];
}

@end
