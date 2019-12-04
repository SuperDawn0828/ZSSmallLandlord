//
//  ZSToolViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/27.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSToolViewController.h"
#import "ZSToolWebViewController.h"
#import "ZSDataStatisticsViewController.h"
#import "ZSHousInfoViewController.h"
#import "ZSBaseSectionView.h"
#import "ZSToolTableViewCell.h"
#import "ZSCustomReportListViewController.h"
#import "ZSCalendarViewController.h"

@interface ZSToolViewController ()<ZSToolTableViewCellDelegate>
@property(nonatomic,strong)NSMutableArray *arrayData;
@end

@implementation ZSToolViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //导航栏标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:ZSColorBlack}];
    //导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[ZSTool createImageWithColor:ZSColor(249, 249, 249)] forBarPosition:UIBarPositionAny  barMetrics:UIBarMetricsDefault];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //导航栏标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:ZSColorWhite}];
    //导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forBarPosition:UIBarPositionAny  barMetrics:UIBarMetricsDefault];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight-kTabbarHeight) withStyle:UITableViewStyleGrouped];
    //Data
    [self addHeader];
}

#pragma mark 数据请求
- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.arrayData  = [[NSMutableArray alloc]init];
        [weakSelf getToolList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 获取工具页列表数据
- (void)getToolList
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getToolListURL] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSToolModel *model = [ZSToolModel yy_modelWithDictionary:dict];
                [weakSelf.arrayData addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
        [weakSelf requestFail:weakSelf.tableView array:weakSelf.arrayData];
    }];
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayData.count > 0)
    {
        ZSToolModel *model = self.arrayData[indexPath.section];
        if (model.data.count % 3 > 0)
        {
            return (model.data.count / 3) * KZZSToolTableViewCellHeight + KZZSToolTableViewCellHeight;
        }
        else
        {
            return (model.data.count / 3) * KZZSToolTableViewCellHeight;
        }
    }
    else
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

#pragma mark 区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    view.backgroundColor = ZSViewBackgroundColor;
    ZSBaseSectionView *sectionView = [[ZSBaseSectionView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    sectionView.backgroundColor = ZSColorWhite;
    sectionView.tag = section;
    sectionView.bottomLine.hidden = NO;
    sectionView.rightLab.hidden = YES;
    sectionView.rightArrowImgV.hidden = YES;
    [view addSubview:sectionView];
    if (self.arrayData.count > 0)
    {
        ZSToolModel *model = self.arrayData[section];
        sectionView.leftLab.text = SafeStr(model.name);
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ZSToolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    if (cell == nil) {
        cell = [[ZSToolTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
        cell.delegate = self;
    }
    if (self.arrayData.count > 0) {
        ZSToolModel *model = self.arrayData[indexPath.section];
        if (model) {
            cell.model = model;
        }
    }
    
    return cell;
}

#pragma mark ZSToolTableViewCellDelegate 点击小工具
- (void)selectCurrentTool:(ToolDatamodel *)model
{
    if (model.type.intValue == 1)
    {
        //数据统计
        if ([model.toolLink containsString:@"DataStatistics"])
        {
            ZSDataStatisticsViewController *dataVC = [[ZSDataStatisticsViewController alloc]init];
            [self.navigationController pushViewController:dataVC animated:YES];
        }
        //房产资讯
        else if ([model.toolLink containsString:@"HouseInfo"])
        {
            ZSHousInfoViewController *homeVC = [[ZSHousInfoViewController alloc]init];
            homeVC.title = model.toolName;
            [self.navigationController pushViewController:homeVC animated:YES];
        }
        //自定义报表
        else if ([model.toolLink containsString:@"CustomReports"])
        {
            ZSCustomReportListViewController *dataVC = [[ZSCustomReportListViewController alloc]init];
            [self.navigationController pushViewController:dataVC animated:YES];
        }
        //日签
        else if ([model.toolLink containsString:@"DaySign"])
        {
            ZSCalendarViewController *calendarVC = [[ZSCalendarViewController alloc]init];
            //创建动画
            CATransition *animation = [CATransition animation];
            //设置运动轨迹的速度
            //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
            //设置动画类型为立方体动画
            animation.type = @"moveIn";
            //设置动画时长
            animation.duration = 0.5f;
            //设置运动的方向
            animation.subtype = kCATransitionFromBottom;
            //控制器间跳转动画
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
            [self.navigationController pushViewController:calendarVC animated:NO];
        }
    }
    else
    {
        //testFlight测试版
        if ([model.toolName containsString:@"内测"])
        {
            NSURL *customAppURL = [NSURL URLWithString:@"itms-beta://"];
            if ([[UIApplication sharedApplication] canOpenURL:customAppURL])
            {
                customAppURL = [NSURL URLWithString:model.toolLink];
                [[UIApplication sharedApplication] openURL:customAppURL];
            }
        }
        //其他
        else
        {
            ZSToolWebViewController *webViewVC = [[ZSToolWebViewController alloc]init];
            webViewVC.stringUrl = model.toolLink;
            webViewVC.type = model.toolName;
            [self.navigationController pushViewController:webViewVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
