//
//  ZSAFOOrderListViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSAFOOrderListViewController.h"
#import "ZSAFOListCell.h"
#import "ZSAFOOrderDetailViewController.h"

@interface ZSAFOOrderListViewController ()
@property (nonatomic,strong)NSMutableArray   *arrayData;
@property (nonatomic,assign)int              currentPage;     //当前页
@end

@implementation ZSAFOOrderListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //清除缓存数据
    global.slOrderDetails = nil;
    global.rfOrderDetails = nil;
    global.mlOrderDetails = nil;
    global.chOrderDetails = nil;
    global.abOrderDetails = nil;
}

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
    [LSProgressHUD showToView:self.view message:@""];
    NSMutableDictionary *parameterDict = @{
                                           @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                           @"pageSize":[NSNumber numberWithInt:10],
                                           @"startTime":@"",
                                           @"endTime":@""}.mutableCopy;
    [parameterDict setObject:self.Orderstate ? self.Orderstate : @"" forKey:@"dealState"];//订单状态 1未处理 2已处理
    [parameterDict setObject:self.searchKeyWord ? self.searchKeyWord : @"" forKey:@"keywords"];//搜索的时候
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getApplyOnlineOrderListURL] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            ZSAOListModel *model = [ZSAOListModel yy_modelWithJSON:dict];
            [weakSelf.arrayData addObject:model];
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
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSAFOListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSAFOListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (self.arrayData.count > 0) {
        ZSAOListModel *model = self.arrayData[indexPath.row];
        if (model) {
            cell.model = model;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZSAFOOrderDetailViewController *detailVC = [[ZSAFOOrderDetailViewController alloc]init];
    ZSAOListModel *model = self.arrayData[indexPath.row];
    detailVC.onlineOrderIDString = model.tid;
    detailVC.model = model;
    if (SystemVersion <= 11.0) {
        detailVC.style = UITableViewStyleGrouped;
    }
    detailVC.isFromNew = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
