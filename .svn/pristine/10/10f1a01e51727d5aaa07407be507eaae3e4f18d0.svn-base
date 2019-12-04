//
//  ZSHomeSeacrResultsViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/8/21.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSHomeSeacrResultsViewController.h"
#import "ZSHomeTableCell.h"
#import "ZSWSPersonListViewController.h"
#import "ZSWSPageController.h"
#import "ZSSLPageController.h"
#import "ZSSLPersonListViewController.h"

@interface ZSHomeSeacrResultsViewController ()
@property (nonatomic,strong)NSMutableArray   *arrayData;
@property (nonatomic,assign)int              currentPage;//当前页
@end

@implementation ZSHomeSeacrResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];//返回按钮
    [self configureErrorViewWithStyle:ZSErrorSearchNoData];//搜索无数据
    //Data
    [self addHeader];
    [self addFooter];
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
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        weakSelf.arrayData  = [[NSMutableArray alloc]init];
        [weakSelf requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
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
    NSMutableDictionary *parameterDict = @{
                                           @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                           @"pageSize":[NSNumber numberWithInt:10],
                                           @"prdType":@"",
                                           @"orderState":@"1",
                                           @"keywords":self.searchKeyWord,
                                           @"queryMySelf":@"1"//只查询我创建的订单 1是 0否,默认是
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getAllOrderList] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            global.allListModel = [ZSAllListModel yy_modelWithJSON:dict];
            global.allListModel.listType = 5;//首页列表(搜索)
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
    } ErrorBlock:^(NSError *error) {
        [weakSelf requestFail:weakSelf.tableView array:weakSelf.arrayData];
    }];
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSHomeTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
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
    if (self.arrayData.count > 0)
    {
        ZSAllListModel *model = self.arrayData[indexPath.row];
        //1.新房见证
        if ([model.prd_type isEqualToString:@"新房见证"] || [model.prd_type isEqualToString:kProduceTypeWitnessServer])
        {
            //判断订单状态: 待提交征信查询时进入人员列表,其他进订单详情
            if ([model.order_state_desc isEqualToString:@"待提交征信查询"] || [model.order_state_desc isEqualToString:@"1"])
            {
                ZSWSPersonListViewController *personalVC = [[ZSWSPersonListViewController alloc]init];
                personalVC.TypeOfself = orderList;
                personalVC.orderIDString = model.tid;
                personalVC.str_orderState = model.order_state_desc;
                [self.navigationController pushViewController:personalVC animated:YES];
            }
            else
            {
                ZSWSPageController *detailVC = [[ZSWSPageController alloc]init];
                detailVC.orderIDString = model.tid;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
        //2.金融产品
        else
        {
            if ([model.order_state_desc isEqualToString:@"暂存"])
            {
                ZSSLPersonListViewController *vc = [[ZSSLPersonListViewController alloc]init];
                vc.orderState = @"暂存";
                vc.orderIDString = model.tid;
                vc.prdType = model.prd_type;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                ZSSLPageController *detailVC = [[ZSSLPageController alloc]init];
                detailVC.orderIDString = model.tid;
                detailVC.prdType = model.prd_type;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
