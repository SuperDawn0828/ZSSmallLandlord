//
//  ZSWitnessServerOrderListViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWitnessServerOrderListViewController.h"
#import "ZSWSOrderListCell.h"
#import "ZSWSPageController.h"
#import "ZSWSPersonListViewController.h"

@interface ZSWitnessServerOrderListViewController ()
@property (nonatomic,strong)NSMutableArray  *arrayData;
@property (nonatomic,assign)int             currentPage;//当前页
@end

@implementation ZSWitnessServerOrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];//返回按钮
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64) withStyle:UITableViewStylePlain];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    self.glt_scrollView = self.tableView;
    //Data
    [self addHeader];
    [self addFooter];
    [NOTI_CENTER addObserver:self selector:@selector(reloadCell) name:KSUpdateAllOrderListNotification object:nil];
    //无数据页面
    if (self.searchKeyWord) {
        [self configureErrorViewWithStyle:ZSErrorSearchNoData];//搜索无数据
    }else if ([self.Orderstate intValue] == 1){
        [self configureErrorViewWithStyle:ZSErrorWithoutOrder];//无订单
    }else if ([self.Orderstate intValue] == 2){
        [self configureErrorViewWithStyle:ZSErrorCompletedOrder];//无完成订单
    }else if ([self.Orderstate intValue] == 3){
        [self configureErrorViewWithStyle:ZSErrorClosedOrder];//无关闭订单
    }
}

#pragma mark 数据请求
- (void)reloadCell
{
    self.currentPage = 0;
    self.arrayData  = [[NSMutableArray alloc]init];
    [self requestData];
}

- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        weakSelf.arrayData  = [[NSMutableArray alloc]init];
        [weakSelf requestData];
    }];
    [weakSelf.tableView.mj_header beginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf requestData];
    }];
    footer.automaticallyHidden = YES;
    weakSelf.tableView.mj_footer = footer;
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@""];
    NSMutableDictionary *dic_parameter = @{
                                           @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                           @"pageSize":[NSNumber numberWithInt:10],
                                           @"prdType":kProduceTypeWitnessServer}.mutableCopy;
    [dic_parameter setObject:self.Orderstate ? self.Orderstate : @"" forKey:@"orderState"];//订单状态
    [dic_parameter setObject:self.searchKeyWord ? self.searchKeyWord : @"" forKey:@"keywords"];//搜索的时候
    NSString *titleString = [USER_DEFALT objectForKey:KWitnessServer];//只查询我创建的订单 1是 0否,默认是
    if (titleString) {
        if (![titleString containsString:@"我创建的"]) {
            [dic_parameter setObject:@"0" forKey:@"queryMySelf"];
        }else{
            [dic_parameter setObject:@"1" forKey:@"queryMySelf"];
        }
    }else{
        [dic_parameter setObject:@"1" forKey:@"queryMySelf"];
    }
    [ZSRequestManager requestWithParameter:dic_parameter url:[ZSURLManager getAllOrderList] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            global.allListModel = [ZSAllListModel yy_modelWithJSON:dict];
            [weakSelf.arrayData addObject:global.allListModel];
        }
        if (array.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }
        if (weakSelf.arrayData.count > 0 ) {
            weakSelf.errorView.hidden = YES;
        }else{
            weakSelf.errorView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
        //手动改一下tableview的偏移量
        if (weakSelf.currentPage > 0) {
            [weakSelf.tableView setContentOffset:CGPointMake(0, weakSelf.tableView.contentOffset.y+40) animated:YES];
        }
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [weakSelf requestFail:weakSelf.tableView array:weakSelf.arrayData];
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSWSOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSWSOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (self.arrayData.count > 0) {
        ZSAllListModel *model= self.arrayData[indexPath.row];
        if (model) {
            cell.model = model;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //判断订单状态: 待提交征信查询时进入人员列表,其他进订单详情
    if (self.arrayData.count > 0)
    {
        ZSAllListModel *model= self.arrayData[indexPath.row];
        if ([model.order_state_desc isEqualToString:@"待提交征信查询"]) {
            ZSWSPersonListViewController *personalVC = [[ZSWSPersonListViewController alloc]init];
            personalVC.TypeOfself = orderList;
            personalVC.orderIDString = model.tid;
            personalVC.str_orderState = model.order_state_desc;
            [self.navigationController pushViewController:personalVC animated:YES];
        }
        else {
            ZSWSPageController *detailVC = [[ZSWSPageController alloc]init];
            detailVC.orderIDString = model.tid;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

