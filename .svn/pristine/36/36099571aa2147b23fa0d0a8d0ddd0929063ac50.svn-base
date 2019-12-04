//
//  ZSYearMonthDayPicker.m
//  ZSCreditApp
//
//  Created by gengping on 2017/12/29.
//  Copyright © 2017年 gengping. All rights reserved.
//

#import "ZSYearMonthDayPicker.h"
#import "DVYearMonthDatePicker.h"

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@interface ZSYearMonthDayPicker ()<DVYearMonthDatePickerDelegate>
@property (nonatomic, strong)UIView   *backgroundView_black;
@property (nonatomic, strong)UIView   *backgroundView_white;
@property (nonatomic, strong)DVYearMonthDatePicker *datePicker;
@property (nonatomic, copy  )NSString *string_date;
@end

@implementation ZSYearMonthDayPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self creatPickView];
        [self creatAnimation];
    }
    return self;
}

//初始化最小年份
- (instancetype)initWithFrame:(CGRect)frame withMInYear:(NSInteger )minyear {
    if (self = [super initWithFrame:frame]) {
        self.minYear = minyear;
        [self creatPickView];
        [self creatAnimation];
    }
    return self;
}
- (void)creatAnimation
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView_white.top = ZSHEIGHT-250;
    }];
}

//picker上面的取消和确定按钮
- (void)creatPickView
{
    //黑底
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0.5;
    [window addSubview:self.backgroundView_black];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnAction)];
    [self.backgroundView_black addGestureRecognizer:tap];
    //白底
    self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT, ZSWIDTH, 250)];
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
    NSString *year = [NSString stringWithFormat:@"%ld",self.minYear];
    NSRange rang = NSMakeRange(0, 4);
    NSString *substring3 = [year substringWithRange:rang];
    NSInteger minYear =[substring3 integerValue];
    self.datePicker = [[DVYearMonthDatePicker alloc] initWithFrame:CGRectMake(0, 44.3, self.frame.size.width, 200) withMInYear:minYear];
    self.datePicker.dvDelegate = self;
    [self.datePicker selectToday];
    [self.backgroundView_white addSubview:self.datePicker];
}



- (void)dateChanged
{
    NSDate *theDate = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM";
    self.string_date = [dateFormatter stringFromDate:theDate];
    //    self.string_date = [self.string_date substringToIndex:10];
    
}

// 弹回picker
- (void)cancelBtnAction
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView_black.alpha = 0;
        self.backgroundView_white.top = ZSHEIGHT;
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
        dateFormatter.dateFormat = @"YYYY-MM";
        NSString *nowtimeStr = [dateFormatter stringFromDate:date];
        //        nowtimeStr = [nowtimeStr substringToIndex:10];
        
        self.datePickerBlock(nowtimeStr);
    }
}
#pragma mark 点击DVYearMonthDatePicker
- (void)yearMonthDatePicker:(DVYearMonthDatePicker *)yearMonthDatePicker didSelectedDate:(NSDate *)date {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    //设置日期格式
    formater.dateFormat = @"yyyy-MM";
    self.string_date = [formater stringFromDate:date];
    if (self.string_date.length==0) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        //设置日期的格式
        [dateFormater setDateFormat:@"yyyy-MM"];
        NSString *datestring1 = [dateFormater stringFromDate:date];
        self.string_date =datestring1;
    }
}


@end
