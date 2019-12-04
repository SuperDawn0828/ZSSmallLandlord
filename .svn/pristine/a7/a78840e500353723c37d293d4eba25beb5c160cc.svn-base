//
//  ZSDaySignSmallView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/2.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSDaySignSmallView.h"

@interface ZSDaySignSmallView ()
@property (nonatomic,strong)UIView  *whiteView;
@property (nonatomic,strong)UILabel *dateLabel;      //年份+月份
@property (nonatomic,strong)UILabel *dayLabel;       //日期
@property (nonatomic,strong)UILabel *weekdayLabel;   //星期几
@end

@implementation ZSDaySignSmallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = ZSViewBackgroundColor;
        [self configureView];
        [self getDate];
    }
    return self;
}

- (void)configureView
{
    //底色
    self.whiteView = [[UIView alloc]initWithFrame:CGRectMake((ZSWIDTH-80)/2, 20, 80, 80)];
    self.whiteView.backgroundColor = ZSColorWhite;
    self.whiteView.layer.cornerRadius = 10;
    self.whiteView.layer.shadowColor = ZSColorListRight.CGColor;
    self.whiteView.layer.shadowOffset = CGSizeMake(2, 5);
    self.whiteView.layer.shadowOpacity = 0.5;
    self.whiteView.layer.shadowRadius = 5;
    [self addSubview:self.whiteView];
    
    //年份+月份
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.whiteView.width, 15)];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textColor = ZSColorListRight;
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:self.dateLabel];
    
    //日期
    self.dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.dateLabel.bottom, self.whiteView.width, 30)];
    self.dayLabel.font = [UIFont boldSystemFontOfSize:18];
    self.dayLabel.textColor = ZSColorListRight;
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:self.dayLabel];

    //日期底部黄黄的view
    UIView *yellowView = [[UIView alloc]initWithFrame:CGRectMake(35, self.dateLabel.bottom+12, 15, 6)];
    yellowView.backgroundColor = ZSColorYellow;
    [self.whiteView insertSubview:yellowView belowSubview:self.dayLabel];

    //星期几
    self.weekdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.dayLabel.bottom, self.whiteView.width, self.dateLabel.height)];
    self.weekdayLabel.font = [UIFont systemFontOfSize:10];
    self.weekdayLabel.textColor = ZSColorListRight;
    self.weekdayLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:self.weekdayLabel];
    
    //提示语
    self.noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.whiteView.bottom, ZSWIDTH, 40)];
    self.noticeLabel.font = [UIFont systemFontOfSize:14];
    self.noticeLabel.textColor = ZSColorListRight;
    self.noticeLabel.textAlignment = NSTextAlignmentCenter;
    self.noticeLabel.text = normalString;
    [self addSubview:self.noticeLabel];
}

#pragma mark 获取今天的日期
- (void)getDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentTimeString = [dateformatter stringFromDate:date];
    self.dateLabel.text = [currentTimeString substringToIndex:7];
    self.dayLabel.text = [currentTimeString substringWithRange:NSMakeRange(8, 2)];
    
    NSArray *weekdays = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日"];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    self.weekdayLabel.text = [weekdays objectAtIndex:theComponents.weekday];
}

@end
