//
//  ZSTHOrderListViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/9/12.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSTHOrderListViewController.h"
#import "ZSPCOrderDetailController.h"
#import "ZSSLPersonListViewController.h"
#import "ZSSLPageController.h"
#import "ZSTHListCellTableViewCell.h"

@interface ZSTHOrderListViewController ()
@property (nonatomic,strong)NSMutableArray   *arrayData;
@property (nonatomic,assign)int              currentPage;     //当前页
@end

@implementation ZSTHOrderListViewController

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
    if (self.searchKeyWord) {
        [self configureErrorViewWithStyle:ZSErrorSearchNoData];//搜索无数据
    }else{
        [self configureErrorViewWithStyle:ZSErrorWithoutOrderOfBank];//银行后勤首页列表无订单
    }
}

#pragma mark 数据请求
- (void)reloadCell
{
    self.currentPage = 0;
    self.arrayData  = [[NSMutableArray alloc]init];
    [self requestData];//列表
}

- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        weakSelf.arrayData  = [[NSMutableArray alloc]init];
        [weakSelf requestData];//列表
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage += 1;
        [weakSelf requestData];
    }];
    footer.automaticallyHidden = YES;
    self.tableView.mj_footer = footer;
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"请求中..."];
    NSMutableDictionary *parameterDict = @{
                                           @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                           @"pageSize":[NSNumber numberWithInt:10],
                                           @"prdType":@"",
                                           }.mutableCopy;
    if (self.searchKeyWord) {
        [parameterDict setObject:self.searchKeyWord forKey:@"keywords"];//搜索内容
    }
    if (self.self.Orderstate) {
        [parameterDict setObject:self.Orderstate forKey:@"searchState"];//订单状态 1未处理 2已处理
    }
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getListFollowOrdersURL] SuccessBlock:^(NSDictionary *dic) {
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
        if (weakSelf.arrayData.count > 0) {
            weakSelf.errorView.hidden = YES;
        }else{
            weakSelf.errorView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [weakSelf requestFail:weakSelf.tableView array:weakSelf.arrayData];
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ZSTHListCellTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSTHListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSTHListCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (self.arrayData.count > 0) {
        ZSAllListModel *model = self.arrayData[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.arrayData.count > 0)
    {
        ZSAllListModel *model = self.arrayData[indexPath.row];
        self.prdType = model.prd_type;

        if ([model.order_state isEqualToString:@"待生成预授信报告"]|| [model.order_state isEqualToString:@"已生成预授信报告"])
        {
            ZSPCOrderDetailController *detailVC = [[ZSPCOrderDetailController alloc]init];
            detailVC.orderIDString = model.tid;
            detailVC.lastVC = ZSTheMediationViewController;
            detailVC.prdType = model.prd_type;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        else if ([model.order_state isEqualToString:@"暂存"])
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

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end