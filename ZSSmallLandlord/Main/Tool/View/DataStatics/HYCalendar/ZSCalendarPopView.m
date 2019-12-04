//
//  ZSCalendarPopView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/24.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSCalendarPopView.h"
#import "HYCalendarCollectionReusableView.h"
#import "HYCalendarCollectionViewCell.h"

static NSString * const calendarCell = @"CalendarCell";//cell的ide
static NSString * const calendarHeader = @"CalendarHeader";//header的ide

@interface ZSCalendarPopView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSDate           * nowDate;        //当前的时间
@property (nonatomic, strong) NSTimeZone       * timeZone;       //当地时区
@property (nonatomic, strong) NSCalendar       * calendar;       //当前日历
@property (nonatomic, strong) NSDateComponents * components;     //当前日期的零件
@property (nonatomic, strong) NSDateFormatter  * formatter;      //时间书写格式
@property (nonatomic, strong) NSArray          * weekdays;       //日历星期格式
@property (nonatomic, assign) BOOL             isFirstLoad;      //是否是第一次加载
@property (nonatomic, assign) BOOL             isFirstClicked;   //是否是第一次点击
@end

@implementation ZSCalendarPopView

#pragma mark - -----------lazy load-------------
- (NSTimeZone *)timeZone
{
    //时区为中国上海
    if (!_timeZone) {
        _timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    }
    return _timeZone;
}

- (NSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

- (NSDateComponents *)components
{
    if (!_components) {
        _components = [[NSDateComponents alloc] init];
    }
    return _components;
}

- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}

- (NSArray *)weekdays
{
    //苹果日历每周第一天是周一，修改日历格式
    if (!_weekdays) {
        _weekdays = @[[NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6"];
    }
    return _weekdays;
}

- (NSDate *)nowDate
{
    if (!_nowDate) {
        _nowDate = [NSDate date];
    }
    return _nowDate;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.isFirstLoad = YES;
        self.isFirstClicked = YES;
        [self configureViews];
        [self creatBaseUI];
    }
    return self;
}

#pragma mark /*------------------------------------------------黑底白底----------------------------------------------------*/
- (void)creatBaseUI
{
    //选择统计时间
    self.titleLabel.text = @"选择统计时间";
    
    //星期label
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0; i < weekArray.count; i++)
    {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake((ZSWIDTH/7)*i, 54, ZSWIDTH/7, CellHeight)];
        weekLabel.font = [UIFont systemFontOfSize:15];
        weekLabel.textColor = ZSColorBlack;
        weekLabel.text = weekArray[i];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        [self.whiteBackgroundView addSubview:weekLabel];
    }
    
    //日历
    [self configureCollectionViewWith:CGRectMake(0, 108, ZSWIDTH, self.whiteBackgroundView.height - 108)];
}

#pragma mark /*-------------------------------------------------创建collectionView-----------------------------------------------------*/
- (void)configureCollectionViewWith:(CGRect)frame
{
    //设置布局
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(ZSWIDTH/7, ZSWIDTH/7);//item大小
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.headerReferenceSize = CGSizeMake(ZSWIDTH, 50);//header大小
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//边界距离
    
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"HYCalendarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:calendarCell];
    //注册headerView
    [_collectionView registerNib:[UINib nibWithNibName:@"HYCalendarCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:calendarHeader];
    [self.whiteBackgroundView addSubview:_collectionView];
}

- (void)viewDidLayoutSubviews
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    NSInteger month1 = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger months = (year - 2017) * 7 + month1 - 1;//希望从哪年开始写日历 例如2017年6月
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:day inSection:months] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}

// headerView的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ZSWIDTH, 50);
}

// section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //只显示从2017年6月开始-当前的月份
    return [self caculateMonthCount];
}

// item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDate    *dateTime  = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:section];
    NSString  *firstTime = [self getBeginTimeInMonth:dateTime];
    NSInteger startDay   = [firstTime integerValue];//开始时间，同样表示这个月开始前几天是空白
    NSInteger totalDays  = [self getTotalDaysInMonth:dateTime];//某个月总天数
    return startDay + totalDays;
}

// cell代理方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYCalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:calendarCell forIndexPath:indexPath];
    
    //数据处理
    NSDate * dateTime = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:indexPath.section];
    //1号以前的负数日期不用显示
    NSInteger dayIndex = indexPath.row - [self getBeginTimeInMonth:dateTime].integerValue + 1;
    NSString  *dayString = dayIndex > 0 ? [NSString stringWithFormat:@"%ld", dayIndex] : @"";
    dayString = dayString.intValue < 10 ? [NSString stringWithFormat:@"0%@",dayString] : dayString;

    cell.day.text = dayString;
    
    NSDateComponents * components = [self getCurrentComponentWithDate:dateTime];
    
    cell.type = HYCalendarItemTypeSquartCollected;

    [cell reloadCellWithFirstDay:self.firstDay
                      andLastDay:self.lastDay
                   andCurrentDay:@[[NSNumber numberWithInteger:[components year]], [NSNumber numberWithInteger:[components month]], [NSNumber numberWithInteger:dayIndex]]
                andSelectedColor:ZSColorRedHighlighted
                  andNormalColor:[UIColor whiteColor]
                  andMiddleColor:ZSColor(249, 221, 221)];
    return cell;
}

// 点击代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate           *dateTime   = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:indexPath.section];
    NSInteger        dayIndex    = indexPath.row - [self getBeginTimeInMonth:dateTime].integerValue + 1;
    NSDateComponents *components = [self getCurrentComponentWithDate:dateTime];
    NSNumber         *yearNum    = [NSNumber numberWithInteger:[components year]];//年份
    NSNumber         *monthNum   = [NSNumber numberWithInteger:[components month]];//月份
    NSNumber         *dayNum     = [NSNumber numberWithInteger:dayIndex];//日期
   
    //由于上次选择时间有保留所以可能造成两个时间数组都有数据，如果可以点击并且后一个数组有数据说明是上次预留，清空数据。
    if (self.lastDay.count != 0)
    {
        self.firstDay = @[yearNum,monthNum,dayNum];
        self.lastDay = nil;
        [self.collectionView reloadData];
    }
    else
    {
        //只选择一项时值只刷新列表，全部选择时刷新并返回
        if (self.firstDay.count == 0)
        {
            self.firstDay = @[yearNum,monthNum,dayNum];
            [self.collectionView reloadData];
        }
        else
        {
            self.lastDay = @[yearNum,monthNum,dayNum];
            [self.collectionView reloadData];
            [self goback];
        }
    }
}

// header代理方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        HYCalendarCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:calendarHeader forIndexPath:indexPath];
        //设置headerView的title
        [headerView showTimeLabelWithArray:(NSArray *)[self getTimeFormatArrayWithDate:self.nowDate andMonth:indexPath.section]];
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[collectionView indexPathsForVisibleItems] lastObject]).row && self.isFirstLoad == YES)
    {
        //修改为不是第一次加载
        self.isFirstLoad = NO;
        
        //滑动到指定section
        NSInteger mySetion = [self caculateMonthCount]-1;//默认滑动最底部
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:0 inSection:mySetion];
        UICollectionViewLayoutAttributes* attr = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:cellIndexPath];
        UIEdgeInsets insets = self.collectionView.scrollIndicatorInsets;
        CGRect rect = attr.frame;
        rect.size = self.collectionView.frame.size;
        rect.size.height -= insets.top + insets.bottom;
        CGFloat offset = (rect.origin.y + rect.size.height) - self.collectionView.contentSize.height;
        if ( offset > 0.0 ) rect = CGRectOffset(rect, 0, -offset);
        [self.collectionView scrollRectToVisible:rect animated:NO];
    }
}

#pragma mark /*-------------------------------------------------日期相关的方法-----------------------------------------------------*/
/**计算2017年6月到现在的月份数量,整个日历就显示这几个月就好了*/
- (NSInteger)caculateMonthCount
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    //列出两个日期
    NSDate *validDate = [dateFormatter dateFromString:@"2017-06-01"];
    NSDate *currentDate = [NSDate date];

    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit1 = NSCalendarUnitMonth | NSCalendarUnitSecond;//同时比较月份差异
    NSDateComponents *delta1 = [calendar components:unit1 fromDate:validDate toDate:currentDate options:0];
    
    NSInteger monthCount = delta1.second > 0 ? delta1.month + 1 : delta1.month;
    return monthCount;
}

/**根据当前时间获取当前和以后各有多少个月，0为当前月*/
- (NSDate *)getEarlierAndLaterDaysFromDate:(NSDate *)date withMonth:(NSInteger)month
{
    //获取日期
    NSDate *newDate = [NSDate date];
    NSDateComponents *components = [self getCurrentComponentWithDate:newDate];
    
    //获取section表示的每个月份
    NSInteger year = [components year];
    NSInteger month_n = [components month];
    
    //希望从哪年开始写日历 例如2017年6月
    NSInteger month_count = (year - 2017) * 7;
    
    //获取当前section代表的月份和现在月份的差值
    NSInteger months = month - month_count - month_n + 1;
    [self.components setMonth:months];
    
    //返回各月份的当前日期，如：2016-01-14，2016-02-14
    NSDate *ndate = [self.calendar dateByAddingComponents:self.components toDate:date options:0];
    return ndate;
}

/**获取每个单位内开始时间*/
- (NSString *)getBeginTimeInMonth:(NSDate *)date
{
    NSTimeInterval count = 0;
    NSDate * beginDate = nil;
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    //返回日历每个月份的开始时间，类型是unitMonth
    BOOL findFirstTime = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&count forDate:date];
    
    if (findFirstTime)
    {
        //日历设置为当前时区
        [self.calendar setTimeZone:self.timeZone];
        
        //标识为星期
        NSCalendarUnit unitFlags = NSCalendarUnitWeekday;
        
        //返回每个月第一天是周几
        NSDateComponents * com = [self.calendar components:unitFlags fromDate:beginDate];
        
        //更换为新的星期格式
        NSString * weekday = [self.weekdays objectAtIndex:[com weekday]];
        return weekday;
    }
    else
    {
        return @"";
    }
}

/**获取每个月多少天*/
- (NSInteger)getTotalDaysInMonth:(NSDate *)date
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    //标识为day的单位在标识为month的单位中的格式，返回range
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

/**获取当前日期格式*/
- (NSArray *)getTimeFormatArrayWithDate:(NSDate *)date andMonth:(NSInteger)month
{
    NSDate   * dateTime     = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:month];
    NSString * stringFormat = [self.formatter stringFromDate:dateTime];
    //通过“-”拆分日期格式
    return [stringFormat componentsSeparatedByString:@"-"];
}

/**获取当前日期零件*/
- (NSDateComponents *)getCurrentComponentWithDate:(NSDate *)dateTime
{
    NSCalendar     *calendar = [NSCalendar currentCalendar];
    //日期拆分类型
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay;
    return [calendar components:unitFlags fromDate:dateTime];
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

#pragma mark 返回传值
- (void)goback
{
    if (self.getTime)
    {
        //判断一下是在self.lastDay之前的日期还是之后的日期, 之前的就不做变更, 之后的就交换一下位置
        NSString *firstDateString = [NSString stringWithFormat:@"%@-%@-%@",self.firstDay[0],self.firstDay[1],self.firstDay[2]];
        NSString *lastDateString = [NSString stringWithFormat:@"%@-%@-%@",self.lastDay[0],self.lastDay[1],self.lastDay[2]];
        if ([self compareDate:firstDateString withDate:lastDateString] == -1)
        {
            self.getTime(self.lastDay, self.firstDay);
        }
        else
        {
            self.getTime(self.firstDay, self.lastDay);
        }
        
        //返回
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.35];
    }
}


@end
