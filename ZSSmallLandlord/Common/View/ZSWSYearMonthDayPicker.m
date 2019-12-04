//
//  ZSWSYearMonthDayPicker.m
//  ZSMoneytocar
//
//  Created by 黄曼文 on 2017/5/19.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSWSYearMonthDayPicker.h"

typedef NS_ENUM(NSUInteger, ZSDateType) {
    ZSDateTypeMini = 0,
    ZSDateTypeMax,
   
};
@interface ZSWSYearMonthDayPicker ()
@property (nonatomic, strong)UIView   *backgroundView_black;
@property (nonatomic, strong)UIView   *backgroundView_white;
@property (nonatomic, strong)UIDatePicker *datePicker;
@property (nonatomic, copy  )NSString *string_date;
@end

@implementation ZSWSYearMonthDayPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatPickView];
        [self creatAnimation];
    }
    return self;
}

- (void)creatAnimation
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView_white.top = ZSHEIGHT_PopupWindow-250;
    }];
}

//picker上面的取消和确定按钮
- (void)creatPickView
{
    //黑底
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0.5;
    [window addSubview:self.backgroundView_black];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnAction)];
    [self.backgroundView_black addGestureRecognizer:tap];
    
    //白底
    self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT_PopupWindow, ZSWIDTH, 250)];
    self.backgroundView_white.backgroundColor = ZSColorWhite;
    [window addSubview:self.backgroundView_white];
   
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 100, 50);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ZSColorListLeft forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:cancelBtn];
   
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(ZSWIDTH-100, 0, 100, 50);
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:sureBtn];
   
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ZSWIDTH, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [self.backgroundView_white addSubview:lineView];
  
    //picker
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,50, ZSWIDTH, 200)];
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];//设置本地化支持的语言（在此是中文)
    if (self.hasDateRate) {
        self.datePicker.minimumDate=[self getDatebyType:ZSDateTypeMini];
        self.datePicker.maximumDate=[self getDatebyType:ZSDateTypeMax];
    }
    self.datePicker.maximumDate= [NSDate date];
    self.datePicker.datePickerMode = UIDatePickerModeDate;//显示方式是只显示年月日
    [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];//设置监听
    [self.backgroundView_white addSubview:self.datePicker];
}

- (NSDate*)getDatebyType:(ZSDateType)dateType
{
    NSDate * mydate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    if (dateType==ZSDateTypeMini) {
         [adcomps setYear:-5];
    }else{
         [adcomps setYear:5];
    }
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
   // NSString *beforDate = [dateFormatter stringFromDate:newdate];
    return newdate;
}

- (void)dateChanged
{
    NSDate *theDate = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH-mm-ss";
    self.string_date = [dateFormatter stringFromDate:theDate];
    self.string_date = [self.string_date substringToIndex:10];
}

// 弹回picker
- (void)cancelBtnAction
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView_black.alpha = 0;
        self.backgroundView_white.top = ZSHEIGHT_PopupWindow;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// picker确定按钮点击事件
- (void)sureBtnAction
{
    [self cancelBtnAction];
    if (self.string_date.length > 0) {

        self.datePickerBlock(self.string_date);
    }
    else
    {
        //没选择就默认当前时间
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd HH-mm-ss";
        NSString *nowtimeStr = [dateFormatter stringFromDate:date];
        nowtimeStr = [nowtimeStr substringToIndex:10];
        
        self.datePickerBlock(nowtimeStr);
    }
}

@end
