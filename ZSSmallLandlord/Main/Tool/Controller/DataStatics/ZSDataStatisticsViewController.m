//
//  ZSDataStatisticsViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/18.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSDataStatisticsViewController.h"
//#import "HYCalendarViewController.h"
#import "ZSBaseSectionView.h"
#import "ZSCalendarPopView.h"
#import "ZSTotalNumTableViewCell.h"
#import "ZSPieChartTableViewCell.h"
#import "ZSLineChartTableViewCell.h"
#import "ZSQuaryNewOrCompleteDataModel.h"
#import "ZSQuaryOrderChangeModel.h"
#import "ZSQuaryPieChartsModel.h"

@interface ZSDataStatisticsViewController ()
@property(nonatomic,strong)UIButton                      *topDateBtn;          //顶部日期
@property(nonatomic,strong)NSArray                       *firstDate;
@property(nonatomic,strong)NSArray                       *lastDate;
@property(nonatomic,strong)NSArray                       *sectionTitleArray;   //区头数组
@property(nonatomic,strong)ZSQuaryNewOrCompleteDataModel *modelNew;            //数据总览-新增订单model
@property(nonatomic,strong)ZSQuaryNewOrCompleteDataModel *modelComplete;       //数据总览-完成订单model
@property(nonatomic,strong)NSMutableArray                *prdTypeArray;        //产品分布数组
@property(nonatomic,strong)NSMutableArray                *areaArray;           //区域分布数组
@property(nonatomic,strong)NSMutableArray                *bankArray;           //贷款银行分布数组
@property(nonatomic,strong)NSMutableArray                *sourceArray;         //订单来源分布数组
@property(nonatomic,strong)NSMutableArray                *changeArray;         //订单日/月变化数组
@end

@implementation ZSDataStatisticsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
    //导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[ZSTool createImageWithColor:ZSColor(249, 249, 249)] forBarPosition:UIBarPositionAny  barMetrics:UIBarMetricsDefault];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavBar];
    self.sectionTitleArray = @[@"数据总览",@"产品分布",@"区域分布",@"贷款银行分布",@"订单来源",@"订单日变化"];
    [self configureTableView:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight) withStyle:UITableViewStyleGrouped];
    [self.tableView registerNib:[UINib nibWithNibName:KZSTotalNumTableViewCell bundle:nil] forCellReuseIdentifier:KZSTotalNumTableViewCell];
    //Data
    //默认请求当月1号到当前日期的数据
    [self requestWithStartDate:[self getCurrentDate:YES] withEndDate:[self getCurrentDate:NO]];
}

#pragma mark /*------------------------------------------接口请求------------------------------------------*/
- (void)requestWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate
{
    [self requestQueryNewOrderDataWithStartDate:startDate      withEndDate:endDate];
    [self requestQueryCompleteOrderDataWithStartDate:startDate withEndDate:endDate];
    [self requestQueryPrdOrderDataWithStartDate:startDate      withEndDate:endDate];
    [self requestQueryAreaOrderDataWithStartDate:startDate     withEndDate:endDate];
    [self requestQueryBankOrderDataWithStartDate:startDate     withEndDate:endDate];
    [self requestQuerySourceOrderDataWithStartDate:startDate   withEndDate:endDate];
    [self requestQueryOrderChangeWithStartDate:startDate       withEndDate:endDate];
}

#pragma mark 新增订单的总数
- (void)requestQueryNewOrderDataWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"startDate":startDate,
                                  @"endDate":endDate
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getQueryNewOrderData] SuccessBlock:^(NSDictionary *dic) {
        weakSelf.modelNew = [ZSQuaryNewOrCompleteDataModel yy_modelWithDictionary:dic[@"respData"]];
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 完成订单的总数
- (void)requestQueryCompleteOrderDataWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"startDate":startDate,
                                  @"endDate":endDate
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getQueryCompleteOrderData] SuccessBlock:^(NSDictionary *dic) {
        weakSelf.modelComplete = [ZSQuaryNewOrCompleteDataModel yy_modelWithDictionary:dic[@"respData"]];
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 产品分布
- (void)requestQueryPrdOrderDataWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate
{
    self.prdTypeArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"startDate":startDate,
                                  @"endDate":endDate
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getQueryPrdOrderData] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0){
            for (NSDictionary *newDidc in array){
                ZSQuaryPieChartsModel *model = [ZSQuaryPieChartsModel yy_modelWithDictionary:newDidc];
                [weakSelf.prdTypeArray addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 区域分布
- (void)requestQueryAreaOrderDataWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate
{
    self.areaArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"startDate":startDate,
                                  @"endDate":endDate
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getQueryAreaOrderData] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0){
            for (NSDictionary *newDidc in array){
                ZSQuaryPieChartsModel *model = [ZSQuaryPieChartsModel yy_modelWithDictionary:newDidc];
                [weakSelf.areaArray addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 贷款银行分布
- (void)requestQueryBankOrderDataWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate
{
    self.bankArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"startDate":startDate,
                                  @"endDate":endDate
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getQueryBankOrderData] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0){
            for (NSDictionary *newDidc in array){
                ZSQuaryPieChartsModel *model = [ZSQuaryPieChartsModel yy_modelWithDictionary:newDidc];
                [weakSelf.bankArray addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 订单来源
- (void)requestQuerySourceOrderDataWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate
{
    self.sourceArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"startDate":startDate,
                                  @"endDate":endDate
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getQuerySourceOrderData] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0){
            for (NSDictionary *newDidc in array){
                ZSQuaryPieChartsModel *model = [ZSQuaryPieChartsModel yy_modelWithDictionary:newDidc];
                [weakSelf.sourceArray addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 订单日变化/月变化
- (void)requestQueryOrderChangeWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate
{
    self.changeArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"startDate":startDate,
                                  @"endDate":endDate
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getQueryOrderChangerURL] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0){
            for (NSDictionary *newDidc in array){
                ZSQuaryOrderChangeModel *model = [ZSQuaryOrderChangeModel yy_modelWithDictionary:newDidc];
                [weakSelf.changeArray addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark /*------------------------------------------日期选择------------------------------------------*/
- (void)configureNavBar
{
    //导航栏
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, kNavigationBarHeight)];
    navView.backgroundColor = ZSColor(249, 249, 249);
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, kStatusBarHeight, 44, 44);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, (44-20)/2, 20, 20)];
    backImg.image = [UIImage imageNamed:@"tool_guanbi_n"];
    [leftButton addSubview:backImg];
    [navView addSubview:leftButton];
    
    //中间显示的日期
    self.topDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topDateBtn.frame = CGRectMake(44, kStatusBarHeight, ZSWIDTH-88, 44);
    self.topDateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.topDateBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.topDateBtn setTitleColor:ZSColorBlack forState:UIControlStateNormal];
    [self.topDateBtn addTarget:self action:@selector(showSelectView) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:self.topDateBtn];
    //日期
    NSString *start = [self changeDateFormatWithArray:[[self getCurrentDate:YES] componentsSeparatedByString:@"-"] isShowOrRequest:YES];
    NSString *end = [self changeDateFormatWithArray:[[self getCurrentDate:NO] componentsSeparatedByString:@"-"] isShowOrRequest:YES];
    [self.topDateBtn setTitle:[NSString stringWithFormat:@"%@-%@  ▼",start,end] forState:UIControlStateNormal];
  
    self.firstDate = [[self getCurrentDate:YES] componentsSeparatedByString:@"-"];
    self.lastDate = [[self getCurrentDate:NO] componentsSeparatedByString:@"-"];
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showSelectView
{
    ZSCalendarPopView *calendar = [[ZSCalendarPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    //将上次的时间传递回日历中
    if (self.firstDate && self.lastDate)
    {
        calendar.firstDay = self.firstDate;
        calendar.lastDay = self.lastDate;
    }
    __weak typeof(self) weakSelf = self;
    calendar.getTime = ^(NSArray *firstDay, NSArray *lastDay)
    {
        //选择的时间回显
        [weakSelf.topDateBtn setTitle:[NSString stringWithFormat:@"%@-%@  ▼", [weakSelf changeDateFormatWithArray:firstDay isShowOrRequest:YES], [weakSelf changeDateFormatWithArray:lastDay isShowOrRequest:YES]] forState:UIControlStateNormal];
        //保存,用于进入日历选择器时传递
        weakSelf.firstDate = firstDay;
        weakSelf.lastDate = lastDay;
        //重新请求
        [weakSelf requestWithStartDate:[weakSelf changeDateFormatWithArray:firstDay isShowOrRequest:NO]
                           withEndDate:[weakSelf changeDateFormatWithArray:lastDay isShowOrRequest:NO]];
    };
    [calendar show];
}

#pragma mark 获取当前日期
- (NSString *)getCurrentDate:(BOOL)isStart//isStart为yes表示返回当前月份的1号,为no则返回今天的日期
{
    NSString *dateString;
    //获取当前时间日期
    NSDate *date = [NSDate date];
    NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    
    //当月1号
    if (isStart == YES)
    {
        dateString = [format1 stringFromDate:date];
        dateString = [dateString substringToIndex:dateString.length-2];
        dateString = [NSString stringWithFormat:@"%@01",dateString];
    }
    //今天的日期
    else
    {
        dateString = [format1 stringFromDate:date];
    }
    return dateString;
}

#pragma mark 修改日期格式
- (NSString *)changeDateFormatWithArray:(NSArray *)dateArray isShowOrRequest:(BOOL)isShow //isShow为yes表示展示, no表示是返回请求接口的格式
{
    NSString *date;
    NSString *day = [NSString stringWithFormat:@"%@",dateArray[2]];
    if ([day intValue] < 10 && ![day containsString:@"0"])//日期为10以下的数字,在前面补0
    {
        if (isShow == YES)
        {
            date = [NSString stringWithFormat:@"%@年%@月%@日", dateArray[0], dateArray[1], [NSString stringWithFormat:@"0%@",dateArray[2]]];
        }
        else
        {
            date = [NSString stringWithFormat:@"%@-%@-%@", dateArray[0], dateArray[1], [NSString stringWithFormat:@"0%@",dateArray[2]]];
        }
    }
    else
    {
        if (isShow == YES)
        {
            date = [NSString stringWithFormat:@"%@年%@月%@日", dateArray[0], dateArray[1], dateArray[2]];
        }
        else
        {
            date = [NSString stringWithFormat:@"%@-%@-%@", dateArray[0], dateArray[1], dateArray[2]];
        }
    }
    return date;
}

#pragma mark /*------------------------------------------tableview------------------------------------------*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return KZSTotalNumHeight;
    }
    else if (indexPath.section == 5)
    {
        return KZSLineChartHeight;
    }
    else
    {
        return ZSPieChartHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    view.backgroundColor = ZSViewBackgroundColor;
    ZSBaseSectionView *sectionView = [[ZSBaseSectionView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    sectionView.backgroundColor = ZSColorWhite;
    sectionView.bottomLine.hidden = NO;
    sectionView.leftLab.text = self.sectionTitleArray[section];
    sectionView.rightLab.hidden = YES;
    sectionView.rightArrowImgV.hidden = YES;
    [view addSubview:sectionView];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ZSTotalNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KZSTotalNumTableViewCell];
        if (self.modelNew) {
            cell.modelNew = self.modelNew;
        }
        //数据总览
        if (self.modelComplete) {
            cell.modelComplete = self.modelComplete;
        }
        return cell;
    }
    else if (indexPath.section == 5)
    {
        ZSLineChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KZSLineChartTableViewCell];
        if (cell == nil) {
            cell = [[ZSLineChartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KZSLineChartTableViewCell];
        }
        //订单日/月变化
        if (self.changeArray.count > 0) {
            cell.dataArray = self.changeArray;
        }
        return cell;
    }
    else
    {
        ZSPieChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KZSPieChartTableViewCell];
        if (cell == nil) {
            cell = [[ZSPieChartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KZSPieChartTableViewCell];
        }
        //产品分布
        if (indexPath.section == 1) {
            cell.dataArray = self.prdTypeArray;
        }
        //区域分布
        if (indexPath.section == 2) {
            cell.dataArray = self.areaArray;
        }
        //贷款银行分布
        if (indexPath.section == 3) {
            cell.dataArray = self.bankArray;
        }
        //订单来源
        if (indexPath.section == 4) {
            cell.dataArray = self.sourceArray;
        }
        return cell;
    }
}

@end
