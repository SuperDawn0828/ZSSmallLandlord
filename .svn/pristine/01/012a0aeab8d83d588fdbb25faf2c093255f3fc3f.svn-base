//
//  ZSInputOrSelectView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSInputOrSelectView.h"

@interface ZSInputOrSelectView ()<UITextViewDelegate>
@property (nonatomic,strong)NSMutableArray *array_insurance;
@property (nonatomic,strong)NSMutableArray *array_company;
@property (nonatomic,assign)CGRect         keyboardHeight;//键盘高度
//@property (nonatomic,strong)UILabel        *placeholderLabel;
@end

@implementation ZSInputOrSelectView

#pragma mark 选择
- (id)initWithFrame:(CGRect)frame withClickAction:(NSString *)leftTitle
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ZSColorWhite;
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 180, self.height)];
        self.leftLabel.font = [UIFont systemFontOfSize:15];
        self.leftLabel.textColor = ZSColorListLeft;
        if ([leftTitle containsString:@"*"]) {
            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:leftTitle];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:ZSColorRed range:NSMakeRange(leftTitle.length-1, 1) ];
            self.leftLabel.attributedText = mutableStr;
        }else{
            self.leftLabel.text = leftTitle;
        }
        [self addSubview:self.leftLabel];
        
        self.rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-30, (self.height-15)/2, 15, 15)];
        self.rightImgView.image = [UIImage imageNamed:@"list_arrow_n"];
        [self addSubview:self.rightImgView];
        
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.leftLabel.right, 0, ZSWIDTH-180-45, self.height)];
        self.rightLabel.font = [UIFont systemFontOfSize:15];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.numberOfLines = 0;
        self.rightLabel.textColor = ZSColorAllNotice;
        self.rightLabel.text = KPlaceholderChoose;
        [self addSubview:self.rightLabel];
        
        self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clickBtn.frame = CGRectMake(145, 0, ZSWIDTH-145, self.height);
        [self.clickBtn addTarget:self action:@selector(btnClickACtion) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.clickBtn];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, self.height-0.5, ZSWIDTH, 0.5)];
        self.lineView.backgroundColor = ZSColorLine;
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)btnClickACtion
{
    [self.delegate clickBtnAction:self];
}

#pragma mark 输入(UITextField)
- (id)initWithFrame:(CGRect)frame withInputAction:(NSString *)leftTitle
     withRightTitle:(NSString *)rightTitle
   withKeyboardType:(UIKeyboardType)keyType
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = ZSColorWhite;
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 180, self.height)];
        self.leftLabel.font = [UIFont systemFontOfSize:15];
        self.leftLabel.textColor = ZSColorListLeft;
      
        //带*号的
        if ([leftTitle containsString:@"*"]) {
            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:leftTitle];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:ZSColorRed range:NSMakeRange(leftTitle.length-1, 1) ];
            self.leftLabel.attributedText = mutableStr;
        }else{
            self.leftLabel.text = leftTitle;
        }
        [self addSubview:self.leftLabel];
        
        self.inputTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(self.leftLabel.right, 0, ZSWIDTH-180-30, self.height)];
        self.inputTextFeild.textColor = ZSColorListRight;
        self.inputTextFeild.textAlignment = NSTextAlignmentRight;
        self.inputTextFeild.font = [UIFont systemFontOfSize:15];
        self.inputTextFeild.delegate = self;
        [self addSubview:self.inputTextFeild];
      
        //设置键盘类型
        if (keyType) {
            self.inputTextFeild.keyboardType = keyType;
        }
      
        //设置placeholder
        NSString *holderText = rightTitle ? rightTitle : KPlaceholderInput;
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ZSColorAllNotice
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:15]
                            range:NSMakeRange(0, holderText.length)];
        self.inputTextFeild.attributedPlaceholder = placeholder;
        self.inputTextFeild.inputAccessoryView = [self addToolbar];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, self.height-0.5, ZSWIDTH, 0.5)];
        self.lineView.backgroundColor = ZSColorLine;
        [self addSubview:self.lineView];
        
        //键盘回收
        [NOTI_CENTER addObserver:self selector:@selector(hideKeyboard) name:@"hideKeyboard" object:nil];
    }
    return self;
}

#pragma mark 输入(UITextView)
- (id)initTextViewWithFrame:(CGRect)frame
            withInputAction:(NSString *)leftTitle
             withRightTitle:(NSString *)rightTitle
           withKeyboardType:(UIKeyboardType)keyType
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = ZSColorWhite;
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, self.height)];
        self.leftLabel.font = [UIFont systemFontOfSize:15];
        self.leftLabel.textColor = ZSColorListLeft;
      
        //带*号的
        if ([leftTitle containsString:@"*"]) {
            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:leftTitle];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:ZSColorRed range:NSMakeRange(leftTitle.length-1, 1) ];
            self.leftLabel.attributedText = mutableStr;
        }else{
            self.leftLabel.text = leftTitle;
        }
        [self addSubview:self.leftLabel];
        
        //输入框
        self.inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(self.leftLabel.right, 0, ZSWIDTH-100-30, self.height)];
        self.inputTextView.textAlignment = NSTextAlignmentRight;
        self.inputTextView.font = [UIFont systemFontOfSize:15];
        self.inputTextView.textColor = ZSColorListRight;
        self.inputTextView.delegate = self;
        self.inputTextView.keyboardType = keyType ? keyType : UIKeyboardTypeDefault;//设置键盘类型
        self.inputTextView.inputAccessoryView = [self addToolbar];//顶部工具栏
        [self addSubview:self.inputTextView];

        //placeholder
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.inputTextView.width, CellHeight)];
        self.placeholderLabel.textAlignment = NSTextAlignmentRight;
        self.placeholderLabel.text = rightTitle ? rightTitle : KPlaceholderInput;
        self.placeholderLabel.textColor = ZSColorAllNotice;
        self.placeholderLabel.font = [UIFont systemFontOfSize:15];
        [self.inputTextView addSubview:self.placeholderLabel];
        
        //分割线
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, self.height-0.5, ZSWIDTH, 0.5)];
        self.lineView.backgroundColor = ZSColorLine;
        [self addSubview:self.lineView];
        
        //键盘回收
        [NOTI_CENTER addObserver:self selector:@selector(hideKeyboard) name:@"hideKeyboard" object:nil];
    }
    return self;
}

#pragma mark 输入(UITextField) (后面拼接单位的)
- (id)initWithFrame:(CGRect)frame
     withInputAction:(NSString *)leftTitle
     withRightTitle:(NSString *)rightTitle
     withKeyboardType:(UIKeyboardType)keyType
     withElement:(NSString *)title
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = ZSColorWhite;
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 180, self.height)];
        self.leftLabel.font = [UIFont systemFontOfSize:15];
        self.leftLabel.textColor = ZSColorListLeft;
      
        //带*号的
        if ([leftTitle containsString:@"*"]) {
            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:leftTitle];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:ZSColorRed range:NSMakeRange(leftTitle.length-1, 1) ];
            self.leftLabel.attributedText = mutableStr;
        }else{
            self.leftLabel.text = leftTitle;
        }
        [self addSubview:self.leftLabel];
        
        self.inputTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(self.leftLabel.right, 0, ZSWIDTH-30-180-30-3, self.height)];
        self.inputTextFeild.textColor = ZSColorListRight;
        self.inputTextFeild.textAlignment = NSTextAlignmentRight;
        self.inputTextFeild.font = [UIFont systemFontOfSize:15];
        self.inputTextFeild.delegate = self;
        [self addSubview:self.inputTextFeild];
     
        //设置键盘类型
        if (keyType) {
            self.inputTextFeild.keyboardType = keyType;
        }
     
        //设置placeholder
        NSString *holderText = rightTitle ? rightTitle : KPlaceholderInput;
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ZSColorAllNotice
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:15]
                            range:NSMakeRange(0, holderText.length)];
        self.inputTextFeild.attributedPlaceholder = placeholder;
        self.inputTextFeild.inputAccessoryView = [self addToolbar];
        
        //单位
        self.elementLabel = [[UILabel alloc]init];
        self.elementLabel.frame = CGRectMake(ZSWIDTH - 45, 0, 30, self.height);
        self.elementLabel.textAlignment = NSTextAlignmentRight;
        self.elementLabel.text = title;
        self.elementLabel.font = [UIFont systemFontOfSize:14];
        self.elementLabel.textColor = ZSColorListRight;
        [self addSubview:self.elementLabel];
        
        //分割线
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, self.height-0.5, ZSWIDTH, 0.5)];
        self.lineView.backgroundColor = ZSColorLine;
        [self addSubview:self.lineView];
        
        //键盘回收
        [NOTI_CENTER addObserver:self selector:@selector(hideKeyboard) name:@"hideKeyboard" object:nil];
    }
    return self;
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
    if (textView.text.length > 500) {
        [ZSTool showMessage:@"最多只能输入500字" withDuration:DefaultDuration];
        textView.text = [textView.text substringToIndex:500];
    }
}

#pragma mark 纯展示
- (id)initWithFrame:(CGRect)frame withLeftTitle:(NSString *)leftTitle withRightTitle:(NSString *)rightTitle
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = ZSColorWhite;
        
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, self.height)];
        self.leftLabel.font = [UIFont systemFontOfSize:15];
        self.leftLabel.textColor = ZSColorListLeft;
        
        //带*号的
        if ([leftTitle containsString:@"*"]) {
            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:leftTitle];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(leftTitle.length-1, 1) ];
            self.leftLabel.attributedText = mutableStr;
        }else{
            self.leftLabel.text = leftTitle;
        }
        [self addSubview:self.leftLabel];
        
        //右侧的内容
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.leftLabel.right, 0, ZSWIDTH-100-30, self.height)];
        self.rightLabel.font = [UIFont systemFontOfSize:15];
        self.rightLabel.textColor = ZSColorListRight;
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.numberOfLines = 0;
        self.rightLabel.text = rightTitle;
        [self addSubview:self.rightLabel];

         //分割线
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, self.height-0.5, ZSWIDTH, 0.5)];
        self.lineView.backgroundColor = ZSColorLine;
        [self addSubview:self.lineView];
    }
    return self;
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
    if ([toBeString length] > 25) {
        textField.text = [toBeString substringToIndex:25];
        return NO;
    }
    return YES;
}

@end
