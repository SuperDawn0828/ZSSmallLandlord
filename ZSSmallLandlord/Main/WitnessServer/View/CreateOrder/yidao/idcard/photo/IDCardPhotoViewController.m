//
//  IDCardPhotoViewController.m
//  EXOCR
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "IDCardPhotoViewController.h"
#import<QuartzCore/QuartzCore.h>

#define FRONT_TAG         0x1033
#define BACK_TAG          0x1034
#define STATUS_BAR_HEIGHT 20
#define NAV_BAR_HIGHT     44
#define LEFT_MARGIN       20
#define RIGHT_MARGIN      20
#define DISTANCR_HOR      10
#define LABEL_WIDTH       90

@implementation IDCardPhotoViewController
@synthesize IDInfo;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGB(0xf0eff5)];
    self.navigationItem.title = @"身份证信息";
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

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //关闭scrollView自动调整
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (IDInfo != nil) {
        [self createUI];
    }
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
    
    if (GET_FULLIMAGE) {
        scr.contentSize=CGSizeMake(ZSWIDTH, ZSHEIGHT * 1.5);
    } else {
        scr.contentSize=CGSizeMake(ZSWIDTH, ZSHEIGHT * 1.2);
    }
    [self.view addSubview: scr];
    float lastY = 10;
    
    CGFloat valueOffset = LEFT_MARGIN + LABEL_WIDTH + DISTANCR_HOR;
    CGFloat valueWidth = ZSWIDTH - valueOffset - RIGHT_MARGIN;
    
    if (IDInfo.type == 1) {
        if (![IdInfo getNoShowIDFaceImg]) {
            //人脸
            UILabel *faceBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, 80+borderWidth*2, 80+borderWidth*2)];
            faceBackground.backgroundColor = ZSColorWhite;
            faceBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            faceBackground.layer.borderWidth = borderWidth;
            [scr addSubview:faceBackground];
            
            faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, 80, 80)];
            [faceImageView setBackgroundColor:ZSColorWhite];
            [scr addSubview:faceImageView];
            lastY = faceImageView.bounds.origin.y + faceImageView.bounds.size.height + 30;
        }
        if (![IdInfo getNoShowIDName]) {
            //姓名
            UILabel *nameBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            nameBackground.backgroundColor = ZSColorWhite;
            nameBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            nameBackground.layer.borderWidth = borderWidth;
            [scr addSubview:nameBackground];
            
            nameLable = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            nameLable.text = @"  姓名";
            [scr addSubview: nameLable];
            
            nameValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            nameValueTextField.delegate = self;
            [scr addSubview:nameValueTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
        if (![IdInfo getNoShowIDSex]) {
            //性别
            UILabel *sexBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            sexBackground.backgroundColor = ZSColorWhite;
            sexBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            sexBackground.layer.borderWidth = borderWidth;
            [scr addSubview:sexBackground];
            
            sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            sexLabel.text = @"  性别";
            [scr addSubview: sexLabel];
            
            sexValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            sexValueTextField.delegate = self;
            [scr addSubview:sexValueTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
        if (![IdInfo getNoShowIDNation]) {
            //民族
            UILabel *nationBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            nationBackground.backgroundColor = ZSColorWhite;
            nationBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            nationBackground.layer.borderWidth = borderWidth;
            [scr addSubview:nationBackground];
            
            nationLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            nationLabel.text = @"  民族";
            [scr addSubview: nationLabel];
            
            nationValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:nationValueTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
        if (![IdInfo getNoShowIDBirth]) {
            //出生日期
            UILabel *birthdayBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            birthdayBackground.backgroundColor = ZSColorWhite;
            birthdayBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            birthdayBackground.layer.borderWidth = borderWidth;
            [scr addSubview:birthdayBackground];
            
            birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            birthdayLabel.text = @"  出生";
            [scr addSubview: birthdayLabel];
            
            birthdayTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:birthdayTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
        if (![IdInfo getNoShowIDAddress]) {
            //住址
            UILabel *addressBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight*2+borderWidth*2)];
            addressBackground.backgroundColor = ZSColorWhite;
            addressBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            addressBackground.layer.borderWidth = borderWidth;
            [scr addSubview:addressBackground];
            
            addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            addressLabel.text = @"  住址";
            [scr addSubview: addressLabel];
            
            if (IS_IPHONE) {
                addressValueTextView = [[UITextView alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight*2)];
                addressValueTextView.delegate = self;
                [addressValueTextView setFont:[UIFont systemFontOfSize:17]];
                [scr addSubview:addressValueTextView];
                lastY = lastY + labelHeight*2 + distanceY - borderWidth;
            } else {
                addressValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
                [scr addSubview:addressValueTextField];
                lastY = lastY + labelHeight + distanceY - borderWidth;
            }
        }
        if (![IdInfo getNoShowIDCode]) {
            //身份证号
            UILabel *codeBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            codeBackground.backgroundColor = ZSColorWhite;
            codeBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            codeBackground.layer.borderWidth = borderWidth;
            [scr addSubview:codeBackground];
            
            codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            codeLabel.text = @"  身份证号";
            [scr addSubview: codeLabel];
            
            codeValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:codeValueTextField];
            lastY = lastY + labelHeight + 20;
        }
        if (![IdInfo getNoShowIDFrontFullImg]) {
            //正面fullImage
            if(GET_FULLIMAGE){
                UILabel *frontFullBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, (ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN)*0.632+borderWidth*2)];
                frontFullBackground.backgroundColor = ZSColorWhite;
                frontFullBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
                frontFullBackground.layer.borderWidth = borderWidth;
                [scr addSubview:frontFullBackground];
                
                frontFullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN, (ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN) * 0.632)];
                [scr addSubview:frontFullImageView];
                lastY = lastY + (ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN) * 0.632 + 20;
            }
        }
    } else if (IDInfo.type == 2){
        scr.scrollEnabled = NO;
        lastY += 50;
        if (![IdInfo getNoShowIDOffice]) {
            //签发机关
            UILabel *issueBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            issueBackground.backgroundColor = ZSColorWhite;
            issueBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            issueBackground.layer.borderWidth = borderWidth;
            [scr addSubview:issueBackground];
            
            issueLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            issueLabel.text = @"  签发机关";
            [scr addSubview: issueLabel];
            
            issueValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:issueValueTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
        if (![IdInfo getNoShowIDValid]) {
            //有效期限
            UILabel *validBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            validBackground.backgroundColor = ZSColorWhite;
            validBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            validBackground.layer.borderWidth = borderWidth;
            [scr addSubview:validBackground];
            
            validLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            validLabel.text = @"  有效期限";
            [scr addSubview: validLabel];
            
            validValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:validValueTextField];
            lastY = lastY + labelHeight + 20;
        }
        if (![IdInfo getNoShowIDBackFullImg]) {
            //背面fullImage
            if(GET_FULLIMAGE){
                UILabel *backFullBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, (ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN)*0.632+borderWidth*2)];
                backFullBackground.backgroundColor = ZSColorWhite;
                backFullBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
                backFullBackground.layer.borderWidth = borderWidth;
                [scr addSubview:backFullBackground];
                
                backFullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN, (ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN) * 0.632)];
                [scr addSubview:backFullImageView];
            }
        }
    } else if (IDInfo.type == 0) {  //无识别结果
        //未识别图片
        UILabel *frontFullBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, (ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN)*0.632+borderWidth*2)];
        frontFullBackground.backgroundColor = ZSColorWhite;
        frontFullBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        frontFullBackground.layer.borderWidth = borderWidth;
        [scr addSubview:frontFullBackground];
        
        frontFullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN, (ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN) * 0.632)];
        [scr addSubview:frontFullImageView];
        lastY = lastY + (ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN) * 0.632 + 20;
        
        if (![IdInfo getNoShowIDName]) {
            //姓名
            UILabel *nameBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            nameBackground.backgroundColor = ZSColorWhite;
            nameBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            nameBackground.layer.borderWidth = borderWidth;
            [scr addSubview:nameBackground];
            
            nameLable = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            nameLable.text = @"  姓名";
            [scr addSubview: nameLable];
            
            nameValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            nameValueTextField.delegate = self;
            [scr addSubview:nameValueTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
        if (![IdInfo getNoShowIDSex]) {
            //性别
            UILabel *sexBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            sexBackground.backgroundColor = ZSColorWhite;
            sexBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            sexBackground.layer.borderWidth = borderWidth;
            [scr addSubview:sexBackground];
            
            sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            sexLabel.text = @"  性别";
            [scr addSubview: sexLabel];
            
            sexValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            sexValueTextField.delegate = self;
            [scr addSubview:sexValueTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
        if (![IdInfo getNoShowIDNation]) {
            //民族
            UILabel *nationBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            nationBackground.backgroundColor = ZSColorWhite;
            nationBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            nationBackground.layer.borderWidth = borderWidth;
            [scr addSubview:nationBackground];
            
            nationLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            nationLabel.text = @"  民族";
            [scr addSubview: nationLabel];
            
            nationValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:nationValueTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
        if (![IdInfo getNoShowIDBirth]) {
            //出生日期
            UILabel *birthdayBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            birthdayBackground.backgroundColor = ZSColorWhite;
            birthdayBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            birthdayBackground.layer.borderWidth = borderWidth;
            [scr addSubview:birthdayBackground];
            
            birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            birthdayLabel.text = @"  出生";
            [scr addSubview: birthdayLabel];
            
            birthdayTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:birthdayTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
        if (![IdInfo getNoShowIDAddress]) {
            //住址
            UILabel *addressBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight*2+borderWidth*2)];
            addressBackground.backgroundColor = ZSColorWhite;
            addressBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            addressBackground.layer.borderWidth = borderWidth;
            [scr addSubview:addressBackground];
            
            addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            addressLabel.text = @"  住址";
            [scr addSubview: addressLabel];
            
            if (IS_IPHONE) {
                addressValueTextView = [[UITextView alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight*2)];
                addressValueTextView.delegate = self;
                [addressValueTextView setFont:[UIFont systemFontOfSize:17]];
                [scr addSubview:addressValueTextView];
                lastY = lastY + labelHeight*2 + distanceY - borderWidth;
            } else {
                addressValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
                [scr addSubview:addressValueTextField];
                lastY = lastY + labelHeight + distanceY - borderWidth;
            }
        }
        if (![IdInfo getNoShowIDCode]) {
            //身份证号
            UILabel *codeBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            codeBackground.backgroundColor = ZSColorWhite;
            codeBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            codeBackground.layer.borderWidth = borderWidth;
            [scr addSubview:codeBackground];
            
            codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            codeLabel.text = @"  身份证号";
            [scr addSubview: codeLabel];
            
            codeValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:codeValueTextField];
            lastY = lastY + labelHeight + 20;
        }
        if (![IdInfo getNoShowIDOffice]) {
            //签发机关
            UILabel *issueBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            issueBackground.backgroundColor = ZSColorWhite;
            issueBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            issueBackground.layer.borderWidth = borderWidth;
            [scr addSubview:issueBackground];
            
            issueLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            issueLabel.text = @"  签发机关";
            [scr addSubview: issueLabel];
            
            issueValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:issueValueTextField];
            lastY = lastY + labelHeight + distanceY - borderWidth;
        }
        if (![IdInfo getNoShowIDValid]) {
            //有效期限
            UILabel *validBackground = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN-borderWidth, lastY-borderWidth, ZSWIDTH-LEFT_MARGIN-RIGHT_MARGIN+borderWidth*2, labelHeight+borderWidth*2)];
            validBackground.backgroundColor = ZSColorWhite;
            validBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
            validBackground.layer.borderWidth = borderWidth;
            [scr addSubview:validBackground];
            
            validLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastY, LABEL_WIDTH, labelHeight)];
            validLabel.text = @"  有效期限";
            [scr addSubview: validLabel];
            
            validValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(valueOffset, lastY, valueWidth, labelHeight)];
            [scr addSubview:validValueTextField];
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
    [self loadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)loadData
{
    if (IDInfo.type == 1) {
        //人脸
        if (IDInfo.faceImg != nil) {
            [faceImageView setImage:IDInfo.faceImg];
        }
        
        //姓名
        if (nameValueTextField != nil)
            nameValueTextField.text = IDInfo.name;
        
        //性别
        if (sexValueTextField != nil)
            sexValueTextField.text = IDInfo.gender;
        
        //民族
        if (nationValueTextField != nil)
            nationValueTextField.text = IDInfo.nation;
        
        //出生日期
        if (birthdayTextField != nil) {
            NSString * birthdayYear  = [IDInfo.code substringWithRange:NSMakeRange(6,4)];
            NSString * birthdayMonth = [IDInfo.code substringWithRange:NSMakeRange(10,2)];
            NSString * birthdayDay   = [IDInfo.code substringWithRange:NSMakeRange(12,2)];
            birthdayTextField.text = [[[[birthdayYear stringByAppendingString:@"-"] stringByAppendingString:birthdayMonth] stringByAppendingString:@"-"] stringByAppendingString:birthdayDay];
        }
        //住址
        if (IS_IPHONE) {
            if (addressValueTextView != nil) {
                addressValueTextView.text = IDInfo.address;
                //textview 改变字体的行间距
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 10;// 字体的行间距
                
                NSDictionary *attributes = @{
                                             NSFontAttributeName:[UIFont systemFontOfSize:17.0],
                                             NSParagraphStyleAttributeName:paragraphStyle
                                             };
                addressValueTextView.attributedText = [[NSAttributedString alloc] initWithString:addressValueTextView.text attributes:attributes];
            }
        } else {
            if (addressValueTextField != nil)
                addressValueTextField.text = IDInfo.address;
        }
        //身份证号
        if (codeValueTextField != nil)
            codeValueTextField.text = IDInfo.code;
        //是否显示整幅身份证图像
        if(GET_FULLIMAGE){
            if (frontFullImageView != nil)
                [frontFullImageView setImage:IDInfo.frontFullImg];
        }
    }else if (IDInfo.type == 2){
        //签发机关
        if (issueValueTextField != nil)
            issueValueTextField.text = IDInfo.issue;
        //有效期限
        if (validValueTextField != nil)
            validValueTextField.text = IDInfo.valid;
        //是否显示整幅身份证图像
        if(GET_FULLIMAGE){
            if (backFullImageView != nil)
                [backFullImageView setImage:IDInfo.backFullImg];
        }
    } else if (IDInfo.type == 0) {
        [frontFullImageView setImage:IDInfo.frontFullImg];
    }
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    //    textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17.0],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
}
@end