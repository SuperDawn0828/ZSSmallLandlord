//
//  ZSMoreLineTextTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/17.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSMoreLineTextTableViewCell.h"

@interface ZSMoreLineTextTableViewCell ()<UITextViewDelegate>
@property (nonatomic,strong) UIView      *bgView;
@property (nonatomic,strong) UILabel     *leftLabel;
@property (nonatomic,strong) UITextView  *inputTextView;    //输入文本域
@property (nonatomic,strong) UILabel     *placeholderLabel;
@property (nonatomic,assign) CGFloat     textHeight;
@end

@implementation ZSMoreLineTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.backgroundColor = ZSViewBackgroundColor;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //背景view
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight*2)];
    self.bgView.backgroundColor = ZSColorWhite;
    [self addSubview:self.bgView];
    
    //提示label
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, CellHeight)];
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    self.leftLabel.textColor = ZSColorListLeft;
    [self.bgView  addSubview:self.leftLabel];
    
    //输入框
    self.inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, CellHeight, ZSWIDTH-30, CellHeight)];
    self.inputTextView.font = [UIFont systemFontOfSize:15];
    self.inputTextView.textColor = ZSColorListRight;
    self.inputTextView.delegate = self;
    self.inputTextView.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    self.inputTextView.inputAccessoryView = [self addToolbar];//顶部工具栏
    [self.bgView  addSubview:self.inputTextView];
    //textView内容变化时调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ValueChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    //placeholder
    self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 200, 20)];
    self.placeholderLabel.text = KPlaceholderInput;
    self.placeholderLabel.textColor = ZSColorAllNotice;
    self.placeholderLabel.font = [UIFont systemFontOfSize:15];
    [self.inputTextView addSubview:self.placeholderLabel];
    
    //键盘回收
    [NOTI_CENTER addObserver:self selector:@selector(hideKeyboard) name:@"hideKeyboard" object:nil];
}

- (void)setModel:(ZSDynamicDataModel *)model
{
    _model = model;
 
    //提示label
    if (model.isNecessary.intValue == 0) {
        self.leftLabel.text = model.fieldMeaning;
    }
    else {
        NSString *titleString = [NSString stringWithFormat:@"%@ *",model.fieldMeaning];
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:titleString];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:ZSColorRed range:NSMakeRange(titleString.length-1, 1) ];
        self.leftLabel.attributedText = mutableStr;
    }
    
    //输入框
    if (model.rightData.length > 0) {
        //数据
        self.inputTextView.text = SafeStr(model.rightData);
        self.placeholderLabel.hidden = [@(self.inputTextView.text.length) boolValue];
        //高度
        if (!model.cellHeight) {
            model.cellHeight = [ZSTool getStringHeight:SafeStr(model.rightData) withframe:CGSizeMake(ZSWIDTH-30-32, 1000) withSizeFont:[UIFont systemFontOfSize:15]];
        }
        self.bgView.frame = CGRectMake(0, 0, ZSWIDTH, CellHeight + model.cellHeight);
        self.inputTextView.frame = CGRectMake(15, CellHeight-8, ZSWIDTH-30, model.cellHeight);
    }
    
    //已完成和已操作的单子不能操作
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:model.prdType] && self.isShowAdd)
    {
    }
    else
    {
        self.userInteractionEnabled = NO;
        self.leftLabel.text = [self.leftLabel.text stringByReplacingOccurrencesOfString:@"*" withString:@""];
        self.placeholderLabel.text = @"";
        //如果没有数据才显示空的
        if (model.rightData.length == 0 || [model.rightData isKindOfClass:[NSNull class]]) {
            self.inputTextView.text = @"";
        }
    }
}

#pragma mark textView内容变化时调用 
- (void)ValueChange:(NSNotification *)obj
{
    UITextView *textView = obj.object;
    CGRect textviewRect = textView.frame;
    textviewRect.size.height = textView.contentSize.height;
    textView.frame = textviewRect;
    //隐藏placeholer
    self.placeholderLabel.hidden = [@(self.inputTextView.text.length) boolValue];
    //解决复制粘贴的坑
    [self.inputTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    //根据输入文字的高度判断输入框的高度
    if (textviewRect.size.height > CellHeight) {
        self.textHeight = textviewRect.size.height;
    }else{
        self.textHeight = CellHeight;
    }
    //页面重整
    self.bgView.frame = CGRectMake(0, 0, ZSWIDTH, CellHeight + self.textHeight);
    self.inputTextView.frame = CGRectMake(15, CellHeight, ZSWIDTH-30, self.textHeight);
    //代理传值
    if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:withHeight:)]){
        [self.delegate sendCurrentCellData:self.inputTextView.text withIndex:self.currentIndex withHeight:self.textHeight];
    }
}

#pragma mark UITextViewDelegate
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

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

@end
