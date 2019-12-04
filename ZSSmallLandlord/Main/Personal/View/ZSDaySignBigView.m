//
//  ZSDaySignBigView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/9/30.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSDaySignBigView.h"

@interface ZSDaySignBigView ()
@property (nonatomic,strong)UILabel *dateLabel;      //年份+月份
@property (nonatomic,strong)UILabel *dayLabel;       //日期
@property (nonatomic,strong)UILabel *lunarDateLabel; //农历日期
@property (nonatomic,strong)UILabel *soupLabel;      //鸡汤文

@property (nonatomic,strong)UIView  *bottomView;
@property (nonatomic,strong)UILabel *leftcanDoLabel; //宜做
@property (nonatomic,strong)UILabel *canDoLabel;
@property (nonatomic,strong)UILabel *rightcannotDoLabel;  //不宜做
@property (nonatomic,strong)UILabel *cannotDoLabel;
@end

@implementation ZSDaySignBigView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureViews];
    }
    return self;
}

- (void)configureViews
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentTimeString = [dateformatter stringFromDate:date];
    
    NSArray *weekdays = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日"];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    //年份+月份
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.width, self.height*0.2)];
    self.dateLabel.font = [UIFont boldSystemFontOfSize:16];
    self.dateLabel.textColor = ZSColorListLeft;
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.text = [NSString stringWithFormat:@"%@年%@月",[currentTimeString substringToIndex:4],[currentTimeString substringWithRange:NSMakeRange(5, 2)]];
    [self addSubview:self.dateLabel];
    
    //日期
    self.dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.dateLabel.bottom, self.width, self.height*0.2)];
    self.dayLabel.font = [UIFont boldSystemFontOfSize:100];
    self.dayLabel.textColor = ZSColorBlack;
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.text = [currentTimeString substringWithRange:NSMakeRange(8, 2)];
    [self addSubview:self.dayLabel];
    
    //星期几
    self.lunarDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.dayLabel.bottom, self.width, self.height*0.2)];
    self.lunarDateLabel.font = [UIFont boldSystemFontOfSize:18];
    self.lunarDateLabel.textColor = ZSColorListLeft;
    self.lunarDateLabel.textAlignment = NSTextAlignmentCenter;
    self.lunarDateLabel.text = [weekdays objectAtIndex:theComponents.weekday];
    [self addSubview:self.lunarDateLabel];
    
    //鸡汤
    self.soupLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.soupLabel.font = [UIFont boldSystemFontOfSize:20];
    self.soupLabel.textColor = ZSColorListRight;
    self.soupLabel.textAlignment = NSTextAlignmentCenter;
    self.soupLabel.numberOfLines = 0;
    self.soupLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.soupLabel];
    
    [self configureBottomView];
}

- (void)configureBottomView
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(GapWidth*2, self.lunarDateLabel.bottom, self.width-GapWidth*4, self.height*0.2)];
    self.bottomView.hidden = YES;
    [self addSubview:self.bottomView];
    
    //两条分割线
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(GapWidth*3, 0, self.width-GapWidth*6, 1)];
    topLine.backgroundColor = ZSColorLine;
    [self.bottomView addSubview:topLine];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(GapWidth*3, topLine.bottom+3, self.width-GapWidth*6, 1)];
    bottomLine.backgroundColor = ZSColorLine;
    [self.bottomView addSubview:bottomLine];

    //宜做
    self.leftcanDoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.leftcanDoLabel.frame = CGRectMake(GapWidth*3, (self.bottomView.height-15-30)/2, 30, 30);
    self.leftcanDoLabel.backgroundColor = ZSColorRed;
    self.leftcanDoLabel.layer.cornerRadius = 15;
    self.leftcanDoLabel.clipsToBounds = YES;
    self.leftcanDoLabel.textAlignment = NSTextAlignmentCenter;
    self.leftcanDoLabel.text = @"宜";
    self.leftcanDoLabel.font = [UIFont boldSystemFontOfSize:16];
    self.leftcanDoLabel.textColor = ZSColorWhite;
    [self.bottomView addSubview:self.leftcanDoLabel];
    
    
    self.canDoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.canDoLabel.frame = CGRectMake(self.leftcanDoLabel.right+10, (self.bottomView.height-15-30)/2, (self.width-GapWidth*6-60-30)/2, 30);
    self.canDoLabel.font = [UIFont boldSystemFontOfSize:16];
    self.canDoLabel.textColor = ZSColorBlack;
    [self.bottomView addSubview:self.canDoLabel];
    
    //不宜做
    self.rightcannotDoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.rightcannotDoLabel.frame = CGRectMake(self.canDoLabel.right+10, (self.bottomView.height-15-30)/2, 30, 30);
    self.rightcannotDoLabel.backgroundColor = ZSColorRed;
    self.rightcannotDoLabel.layer.cornerRadius = 15;
    self.rightcannotDoLabel.clipsToBounds = YES;
    self.rightcannotDoLabel.textAlignment = NSTextAlignmentCenter;
    self.rightcannotDoLabel.text = @"忌";
    self.rightcannotDoLabel.font = [UIFont boldSystemFontOfSize:16];
    self.rightcannotDoLabel.textColor = ZSColorWhite;
    [self.bottomView addSubview:self.rightcannotDoLabel];
    
    self.cannotDoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.cannotDoLabel.frame = CGRectMake(self.rightcannotDoLabel.right+10, (self.bottomView.height-15-30)/2, (self.width-GapWidth*6-60-30)/2, 30);
    self.cannotDoLabel.font = [UIFont boldSystemFontOfSize:16];
    self.cannotDoLabel.textColor = ZSColorBlack;
    [self.bottomView addSubview:self.cannotDoLabel];
}

#pragma mark 赋值
- (void)fillinData:(ZSDaySignModel *)model
{
    NSString *maxim = SafeStr(model.maxim);
    NSString *canDo = SafeStr(model.canDo);
    NSString *cannotDo = SafeStr(model.cannotDo);

//    if (!model.maxim && !model.canDo && !model.cannotDo)
    if (maxim.length == 0 && canDo.length == 0 && cannotDo.length == 0)
    {
        self.dateLabel.frame = CGRectMake(0, self.height*0.15, self.width, self.height*0.2);
        self.dayLabel.frame = CGRectMake(0, self.dateLabel.bottom, self.width, self.height*0.3);
        self.lunarDateLabel.frame = CGRectMake(0, self.dayLabel.bottom, self.width, self.height*0.2);
        self.soupLabel.height = 0;
        self.bottomView.height = 0;
        
        //农历日期
        if (model.lunarCalendar)
        {
            self.lunarDateLabel.text = [NSString stringWithFormat:@"%@ %@",model.lunarCalendar,self.lunarDateLabel.text];
        }
    }
    else
    {
        //农历日期
        if (model.lunarCalendar)
        {
            self.lunarDateLabel.text = [NSString stringWithFormat:@"%@ %@",model.lunarCalendar,self.lunarDateLabel.text];
        }
        
        //1.有鸡汤文,无宜做和不宜做
//        if (model.maxim && !model.canDo && !model.cannotDo)
        if (maxim.length && canDo.length == 0 && cannotDo.length == 0)
        {
            //frame
            self.dateLabel.frame = CGRectMake(0, 0, self.width, self.height*0.2);
            self.dayLabel.frame = CGRectMake(0, self.dateLabel.bottom, self.width, self.height*0.3);
            self.lunarDateLabel.frame = CGRectMake(0, self.dayLabel.bottom, self.width, self.height*0.2);
            self.soupLabel.frame = CGRectMake(GapWidth*2, self.lunarDateLabel.bottom, self.width-GapWidth*4, self.height*0.3);
            self.bottomView.height = 0;
            //数据展示
            self.soupLabel.text = [NSString stringWithFormat:@"%@",SafeStr(model.maxim)];
        }
        //2.无鸡汤文,有宜做或不宜做
//        else if (!model.maxim && (model.canDo || model.cannotDo))
        else if (maxim.length == 0 && (canDo.length || cannotDo.length))
        {
            //frame
            self.dateLabel.frame = CGRectMake(0, 0, self.width, self.height*0.2);
            self.dayLabel.frame = CGRectMake(0, self.dateLabel.bottom, self.width, self.height*0.3);
            self.lunarDateLabel.frame = CGRectMake(0, self.dayLabel.bottom, self.width, self.height*0.2);
            self.soupLabel.height = 0;
            self.bottomView.frame = CGRectMake(0, self.lunarDateLabel.bottom, ZSWIDTH, self.height*0.3);
            //数据展示
            [self showDoOrnotdo:model];
        }
        //3.都有
//        else if (model.maxim && (model.canDo || model.cannotDo))
        else if (maxim.length && (canDo.length || cannotDo.length))
        {
            //frame
            self.dateLabel.frame = CGRectMake(0, 0, self.width, self.height*0.2);
            self.dayLabel.frame = CGRectMake(0, self.dateLabel.bottom, self.width, self.height*0.2);
            self.lunarDateLabel.frame = CGRectMake(0, self.dayLabel.bottom, self.width, self.height*0.2);
            self.soupLabel.frame = CGRectMake(GapWidth*2, self.lunarDateLabel.bottom, self.width-GapWidth*4, self.height*0.2);
            self.bottomView.frame = CGRectMake(0, self.soupLabel.bottom, ZSWIDTH, self.height*0.2);
            //数据展示
            self.soupLabel.text = [NSString stringWithFormat:@"%@",SafeStr(model.maxim)];
            [self showDoOrnotdo:model];
        }
    }
}

//宜做和不宜做的数据
- (void)showDoOrnotdo:(ZSDaySignModel *)model
{
    self.bottomView.hidden = NO;

    NSString *canDo = SafeStr(model.canDo);
    NSString *cannotDo = SafeStr(model.cannotDo);
    
//    if (model.canDo && model.cannotDo)
    if (canDo.length && cannotDo.length)
    {
        //赋值
        self.canDoLabel.text = [NSString stringWithFormat:@"%@",SafeStr(model.canDo)];
        self.cannotDoLabel.text = [NSString stringWithFormat:@"%@",SafeStr(model.cannotDo)];
    }
//    else if (model.canDo && !model.cannotDo)
    else if (canDo.length && cannotDo.length == 0)
    {
        //frame
        self.leftcanDoLabel.frame = CGRectMake(GapWidth*3, (self.bottomView.height-15-30)/2, 30, 30);
        self.canDoLabel.frame = CGRectMake(self.leftcanDoLabel.right+10, (self.bottomView.height-15-30)/2, (self.width-GapWidth*6-60-30)/2, 30);
        self.rightcannotDoLabel.frame = CGRectZero;
        self.cannotDoLabel.frame = CGRectZero;
        //数据赋值
        self.canDoLabel.text = [NSString stringWithFormat:@"%@",SafeStr(model.canDo)];
    }
//    else if (!model.canDo && model.cannotDo)
    else if (canDo.length == 0 && cannotDo.length)
    {
        //frame
        self.leftcanDoLabel.frame = CGRectZero;
        self.canDoLabel.frame = CGRectZero;
        self.rightcannotDoLabel.frame = CGRectMake(GapWidth*3, (self.bottomView.height-15-30)/2, 30, 30);
        self.cannotDoLabel.frame = CGRectMake(self.rightcannotDoLabel.right+10, (self.bottomView.height-15-30)/2, (self.width-GapWidth*6-60-30)/2, 30);
        //数据赋值
        self.cannotDoLabel.text = [NSString stringWithFormat:@"%@",SafeStr(model.cannotDo)];
    }
}

@end
