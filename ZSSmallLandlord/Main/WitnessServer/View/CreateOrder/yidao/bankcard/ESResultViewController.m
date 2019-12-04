//
//  ESResultViewController.m
//  EXOCR
//
//  Created by mac on 15/11/5.
//  Copyright © 2015年 z. All rights reserved.
//

#import "ESResultViewController.h"
#import<QuartzCore/QuartzCore.h>

#define FRONT_TAG         0x1033
#define BACK_TAG          0x1034
#define STATUS_BAR_HEIGHT 20
#define NAV_BAR_HIGHT     44
#define LEFT_MARGIN       20
#define RIGHT_MARGIN      20
#define DISTANCR_HOR      10
#define LABEL_WIDTH       90

@interface ESResultViewController ()
@property (nonatomic, strong) NSMutableArray *fieldArray;
@end

@implementation ESResultViewController
@synthesize bankInfo;
@synthesize delegate;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGB(0xf0eff5)];
    self.navigationItem.title = @"银行卡信息";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //关闭scrollView自动调整
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self createUI];
}

- (void) hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)createUI
{
    CGFloat borderWidth = IS_IPHONE ? 0.6 : 1.0;
    CGFloat distanceY = borderWidth * 2;
    CGFloat labelHeight = IS_IPHONE ? 40 : 60;
    
    UIScrollView * scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAV_BAR_HIGHT, ZSWIDTH, ZSHEIGHT)];
    [scr setBackgroundColor:UIColorFromRGB(0xf0eff5)];
    
    /*for dismiss keyboard*/
    UIView *backView = [[UIView alloc] initWithFrame:scr.frame];
    [backView setBackgroundColor:[UIColor clearColor]];
    [scr addSubview:backView];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGr.cancelsTouchesInView = NO;
    [backView addGestureRecognizer:tapGr];
    
    scr.contentSize=CGSizeMake(ZSWIDTH, ZSHEIGHT * 2);
  
    [self.view addSubview: scr];
    float lastY = 20;
    
    CGFloat valueOffset = LEFT_MARGIN + LABEL_WIDTH + DISTANCR_HOR;
    CGFloat valueWidth = ZSWIDTH - valueOffset - RIGHT_MARGIN;
    
    //卡号截图
    if (![BankInfo getNoShowBANKCardNumImg]) {
        cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lastY, ZSWIDTH, ZSWIDTH * 0.2)];
        [scr addSubview:cardImageView];
        lastY = lastY + cardImageView.frame.size.height + 20;
    }
    //卡号编辑框
    if (![BankInfo getNoShowBANKCardNum]) {
        cardNumView = [[UIView alloc]initWithFrame:CGRectMake(0, lastY-borderWidth, ZSWIDTH, labelHeight*1.5+borderWidth*2)];
        cardNumView.backgroundColor = ZSColorWhite;
        cardNumView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cardNumView.layer.borderWidth = borderWidth;
        [scr addSubview:cardNumView];
        lastY = lastY + labelHeight*1.5 + 20;
    }
    //银行名称
    if (![BankInfo getNoShowBANKBankName]) {
        UILabel *bankNameBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        bankNameBackground.backgroundColor = ZSColorWhite;
        bankNameBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        bankNameBackground.layer.borderWidth = borderWidth;
        [scr addSubview:bankNameBackground];
        
        bankNameLable = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        bankNameLable.text = @"  银行";
        [scr addSubview: bankNameLable];
        
        bankNameValue = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        bankNameValue.delegate = self;
        [scr addSubview:bankNameValue];
        lastY = lastY + labelHeight + distanceY - borderWidth;
    }
    //卡名称
    if (![BankInfo getNoShowBANKCardName]) {
        UILabel *cardNameBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        cardNameBackground.backgroundColor = ZSColorWhite;
        cardNameBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cardNameBackground.layer.borderWidth = borderWidth;
        [scr addSubview:cardNameBackground];
        
        cardNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        cardNameLabel.text = @"  卡名称";
        [scr addSubview: cardNameLabel];
        
        cardNameValue = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        cardNameValue.delegate = self;
        [scr addSubview:cardNameValue];
        lastY = lastY + labelHeight + distanceY - borderWidth;
    }
    //卡类型
    if (![BankInfo getNoShowBANKCardType]) {
        UILabel *cardTypeBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        cardTypeBackground.backgroundColor = ZSColorWhite;
        cardTypeBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cardTypeBackground.layer.borderWidth = borderWidth;
        [scr addSubview:cardTypeBackground];
        
        cardTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        cardTypeLabel.text = @"  卡类型";
        [scr addSubview: cardTypeLabel];
        
        cardTypeValue = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        [scr addSubview:cardTypeValue];
        lastY = lastY + labelHeight + distanceY - borderWidth;
    }
    //有效期
    if (![BankInfo getNoShowBANKValidDate]) {
        UILabel *validBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
        validBackground.backgroundColor = ZSColorWhite;
        validBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        validBackground.layer.borderWidth = borderWidth;
        [scr addSubview:validBackground];
        
        validLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
        validLabel.text = @"  有效期";
        [scr addSubview: validLabel];
        
        validValue = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
        [scr addSubview:validValue];
        lastY = lastY + labelHeight + distanceY - borderWidth;
    }
    //确认按钮
    lastY+=20;
    okBtn = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN, labelHeight)];
    [okBtn setBackgroundColor:UIColorFromRGB(0x06be04)];
    [okBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDown];
    [okBtn addTarget:self action:@selector(restoreColor:) forControlEvents:UIControlEventTouchDragOutside];
    [okBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDragEnter];
    [okBtn addTarget:self action:@selector(restoreColor:) forControlEvents:UIControlEventTouchDragOutside];
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 8;
    
    [scr addSubview:okBtn];
    
    if (![BankInfo getNoShowBANKBankName]) {
        if (bankInfo.bankName != nil) {
            bankNameValue.text = bankInfo.bankName;
        }
    }
    if (![BankInfo getNoShowBANKCardName]) {
        if (bankInfo.cardName != nil) {
            cardNameValue.text = bankInfo.cardName;
        }
    }
    if (![BankInfo getNoShowBANKCardType]) {
        if (bankInfo.cardType != nil) {
            cardTypeValue.text = bankInfo.cardType;
        }
    }
    if (![BankInfo getNoShowBANKValidDate]) {
        if (bankInfo.validDate != nil) {
            validValue.text = bankInfo.validDate;
        }
    }
    if (![BankInfo getNoShowBANKCardNumImg]) {
        if (bankInfo.cardNumImg != nil) {
            cardImageView.image = bankInfo.cardNumImg;
            cardImageView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    if (![BankInfo getNoShowBANKCardNum]) {
        NSArray *array = [bankInfo.cardNum componentsSeparatedByString:@" "];
        int len = bankInfo.cardNum.length;
        
        float x = 0;
        float w = 0;
        float h = cardNumView.frame.size.height;
        cardNumView.tag = array.count;
        for(int i=0; i<array.count; ++i)
        {
            NSString *tmp = [array objectAtIndex:i];
            w = cardNumView.frame.size.width * (tmp.length+1) / (len+1);
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, 0, w, h)];
            [cardNumView addSubview:textField];
            textField.tag = i+1;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = tmp;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.font = [UIFont systemFontOfSize:22.0];
            
            [self.fieldArray addObject:textField];
            x += w;
    //        x += cardNumView.frame.size.width / len;
        }
    }
    
    for (UIView *subView in self.view.subviews) {
        for (id controll in subView.subviews)
        {
            if ([controll isKindOfClass:[UITextField class]])
            {
                [controll setBackgroundColor:ZSColorWhite];
                [controll setDelegate:self];
                [controll setAdjustsFontSizeToFitWidth:YES];
                [controll setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            }
        }
    }
}

- (void)restoreColor:(UIButton *)sender
{
    [sender setBackgroundColor:UIColorFromRGB(0x06be04)];
    [sender setTitleColor:ZSColorWhite forState:UIControlStateNormal];
}

- (void)changeColor:(UIButton *)sender
{
    [sender setBackgroundColor:UIColorFromRGB(0x05ac04)];
    [sender setTitleColor:UIColorFromRGB(0x69cd68) forState:UIControlStateNormal];
}

- (void)click:(id)sender
{
    ZSLOG(@"okBtn clicked");
    [delegate didEndEdit:bankInfo.cardNum from:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}@end
