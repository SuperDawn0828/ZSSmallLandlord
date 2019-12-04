//
//  HYCalendarCollectionViewCell.m
//  HYCalendar
//
//  Created by 王厚一 on 16/11/14.
//  Copyright © 2016年 why. All rights reserved.
//

#import "HYCalendarCollectionViewCell.h"


@implementation HYCalendarCollectionViewCell

- (void)drawRect:(CGRect)rect
{
    self.day.font = [UIFont systemFontOfSize:16];
    self.status.font = [UIFont systemFontOfSize:12];
    
    //当形状为圆形时更换frame
    if (self.type == HYCalendarItemTypeRectAlone || self.type == HYCalendarItemTypeRectCollected)
    {
        CGRect rect = CGRectMake((CGRectGetWidth(self.day.frame) - 32) / 2.0, (CGRectGetHeight(self.day.frame) - 32) / 2.0, 32, 32);
        self.day.layer.cornerRadius = 16;
        self.day.layer.masksToBounds = YES;
        self.day.frame = rect;
    }
}

- (void)reloadCellWithFirstDay:(NSArray *)firstDay
                    andLastDay:(NSArray *)lastDay
                 andCurrentDay:(NSArray *)currentDay
              andSelectedColor:(UIColor *)selectedColor
                andNormalColor:(UIColor *)normalColor
                andMiddleColor:(UIColor *)middleColor
{
    //当前日期小于1,隐藏
    NSString *todayTime = [self getCurrentDate];//今天的日期
    NSString *currentTime = [NSString stringWithFormat:@"%@-%@-%@",currentDay[0],currentDay[1],currentDay[2]];//当前cell上面应该显示的日期
    NSString *firstDateString = [NSString stringWithFormat:@"%@-%@-%@",firstDay[0],firstDay[1],firstDay[2]];
    if ([currentDay[2] integerValue] > 0)
    {
        self.hidden = NO;
    }
    else
    {
        self.hidden = YES;
    }
    
    //当图形是圆形时状态标签换颜色
    self.status.textColor = self.type == HYCalendarItemTypeRectCollected || self.type == HYCalendarItemTypeRectAlone ? selectedColor : normalColor;
    
    
    //数据中没有数据则颜色全部初始化
    if (firstDay.count == 0 && lastDay.count == 0)
    {
        self.day.backgroundColor = normalColor;
        self.day.textColor = [UIColor blackColor];
        self.status.text = @"";
    }
    //只有开始的日期
    else if (firstDay.count && lastDay.count == 0)
    {
        //当前日期和开始日期相同
        if ([self compareDate:firstDateString withDate:currentTime] == 0)
        {
            self.day.backgroundColor = selectedColor;
            self.day.textColor = [UIColor whiteColor];
            self.status.text = @"开始";
        }
        //其他正常的
        else
        {
            //用currentDay和今天的日期做比较,大于今天的日期不可以点击
            if ([self compareDate:todayTime withDate:currentTime] == 1)
            {
                self.day.backgroundColor = normalColor;
                self.day.textColor = ZSColorAllNotice;
                self.status.text = @"";
                self.userInteractionEnabled = NO;
            }
            else
            {
                self.day.backgroundColor = normalColor;
                self.day.textColor = [UIColor blackColor];
                self.status.text = @"";
                self.userInteractionEnabled = YES;
            }
        }
    }
    //开始的日期+结束的日期
    else if (firstDay.count && lastDay.count)
    {
        NSString *lastDateString = [NSString stringWithFormat:@"%@-%@-%@",lastDay[0],lastDay[1],lastDay[2]];
        
        //当前日期与开始日期和结束日期都相同
        if ([self compareDate:firstDateString withDate:currentTime] == 0 && [self compareDate:currentTime withDate:lastDateString] == 0)
        {
            self.day.backgroundColor = selectedColor;
            self.day.textColor = [UIColor whiteColor];
            self.status.text = @"开始 结束";
        }
        //当前日期和开始日期相同
        else if ([self compareDate:firstDateString withDate:currentTime] == 0)
        {
            self.day.backgroundColor = selectedColor;
            self.day.textColor = [UIColor whiteColor];
            self.status.text = @"开始";
        }
        //当前日期和结束日期相同
        else if ([self compareDate:currentTime withDate:lastDateString] == 0)
        {
            self.day.backgroundColor = selectedColor;
            self.day.textColor = [UIColor whiteColor];
            self.status.text = @"结束";
        }
        //中间色的出现情况为当前时间在开始和结束时间之间
        else if ([self compareDate:firstDateString withDate:currentTime] == 1 && [self compareDate:currentTime withDate:lastDateString] == 1)
        {
            self.day.backgroundColor = middleColor;
            self.day.textColor = [UIColor whiteColor];
            self.status.text = @"";
        }
        //中间色的出现情况为当前时间在开始和结束时间之间
        else if ([self compareDate:lastDateString withDate:currentTime] == 1 && [self compareDate:currentTime withDate:firstDateString] == 1)
        {
            self.day.backgroundColor = middleColor;
            self.day.textColor = [UIColor whiteColor];
            self.status.text = @"";
        }
        //其他正常的
        else
        {
            //用currentDay和今天的日期做比较,大于今天的日期不可以点击
            if ([self compareDate:todayTime withDate:currentTime] == 1)
            {
                self.day.backgroundColor = normalColor;
                self.day.textColor = ZSColorAllNotice;
                self.status.text = @"";
                self.userInteractionEnabled = NO;
            }
            else
            {
                self.day.backgroundColor = normalColor;
                self.day.textColor = [UIColor blackColor];
                self.status.text = @"";
                self.userInteractionEnabled = YES;
            }
        }
    }
}

/**比较两个日期的大小*/
- (NSInteger)compareDate:(NSString *)firstDate withDate:(NSString *)lastDate
{
    NSInteger resultNum = 0;
    //设置日期格式
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    
    //两个日期
    NSDate *dateA = [dateformater dateFromString:firstDate];
    NSDate *dateB = [dateformater dateFromString:lastDate];
    
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedSame)
    {
        resultNum = 0;//一样大
    }
    else if (result == NSOrderedAscending)
    {
        resultNum = 1;//dateB比dateA大
    }
    else if (result == NSOrderedDescending)
    {
        resultNum =  -1;//dateB比dateA小
    }
    return resultNum;
}

#pragma mark 获取当前日期
- (NSString *)getCurrentDate
{
    //获取当前时间日期
    NSString *dateString;
    NSDate *date = [NSDate date];
    NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    dateString = [format1 stringFromDate:date];

    //今天的日期
    return dateString;
}

@end
