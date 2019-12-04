//
//  ZSBankHomeOrderListViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBankHomeOrderListViewController.h"
#import "ZSBankHomeTableCell.h"
#import "ZSBankHomePersonListViewController.h"
#import "ZSSLPageController.h"
#import "ZSSLPersonListViewController.h"

@interface ZSBankHomeOrderListViewController ()
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,assign) int            currentPage;//当前页
@end

@implementation ZSBankHomeOrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"首页";
    if (self.searchKeyWord)
    {
        [self setLeftBarButtonItem];
        [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight) withStyle:UITableViewStylePlain];
    }
    else
    {
        [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight-kTabbarHeight+SafeAreaBottomHeight) withStyle:UITableViewStylePlain];
    }
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
    self.tableView.mj_footer = footer;
}

- (void)requestData
{
    [LSProgressHUD showToView:self.view message:@""];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                           @"pageSize":[NSNumber numberWithInt:10]
                                           }.mutableCopy;
    [parameterDict setObject:self.Orderstate ? self.Orderstate : @"" forKey:@"fedbackState"];//订单状态 0待处理 1已处理
    [parameterDict setObject:self.searchKeyWord ? self.searchKeyWord : @"" forKey:@"keywords"];//搜索的时候
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getBankOrCheckOrderList] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            global.allListModel = [ZSAllListModel yy_modelWithJSON:dict];
            global.allListModel.listType = 4;//审批列表
            [self.arrayData addObject:global.allListModel];
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
        if (!self.searchKeyWord)
        {
            if (weakSelf.currentPage > 0) {
                [weakSelf.tableView setContentOffset:CGPointMake(0, weakSelf.tableView.contentOffset.y+40) animated:YES];
            }
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
    return ZSBankHomeTableCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSBankHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSBankHomeTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
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
            ZSBankHomePersonListViewController *personalVC = [[ZSBankHomePersonListViewController alloc]init];
            personalVC.isNotFeedback = model.state_result.intValue==0 ? YES :NO;//用于人员列表创建底部按钮
            personalVC.orderIDString = model.tid;//订单id
            [self.navigationController pushViewController:personalVC animated:YES];
        }
        //2.金融产品
        else
        {
            if (![model.order_state_desc isEqualToString:@"暂存"])
            {
                ZSSLPageController *detailVC = [[ZSSLPageController alloc]init];
                detailVC.orderIDString = model.tid;
                detailVC.prdType = model.prd_type;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
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
