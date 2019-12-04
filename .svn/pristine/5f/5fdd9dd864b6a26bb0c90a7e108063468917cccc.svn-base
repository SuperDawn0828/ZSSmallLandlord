//
//  ZSStarLoanOrderListViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/27.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSStarLoanOrderListViewController.h"
#import "ZSSLPageController.h"
#import "ZSSLPersonListViewController.h"
#import "ZSBankHomeTableCell.h"
#import "ZSHomeTableCell.h"

@interface ZSStarLoanOrderListViewController ()
@property (nonatomic,strong)NSMutableArray  *arrayData;
@property (nonatomic,assign) int            currentPage;//当前页
@end

@implementation ZSStarLoanOrderListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
    //清空资料model
    global.slMaterialCollectModel = nil;
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

#pragma mark 数据权限
- (NSString *)checkDataPermissions
{
    //只查询我创建的订单 1是 0否,默认是
    NSString *titleString;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        titleString = [USER_DEFALT objectForKey:KStarLoan];
        if (titleString) {
            if (![titleString containsString:@"我创建的"]) {
                return @"0";
            }else{
                return @"1";
            }
        }else{
            return @"1";
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        titleString = [USER_DEFALT objectForKey:KRedeemFloor];
        if (titleString) {
            if (![titleString containsString:@"我创建的"]) {
                return @"0";
            }else{
                return @"1";
            }
        }else{
            return @"1";
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        titleString = [USER_DEFALT objectForKey:KMortgageLoan];
        if (titleString) {
            if (![titleString containsString:@"我创建的"]) {
                return @"0";
            }else{
                return @"1";
            }
        }else{
            return @"1";
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        titleString = [USER_DEFALT objectForKey:KEasyLoan];
        if (titleString) {
            if (![titleString containsString:@"我创建的"]) {
                return @"0";
            }else{
                return @"1";
            }
        }else{
            return @"1";
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        titleString = [USER_DEFALT objectForKey:KCarHire];
        if (titleString) {
            if (![titleString containsString:@"我创建的"]) {
                return @"0";
            }else{
                return @"1";
            }
        }else{
            return @"1";
        }
    }
    //代办业务
    else
    {
        titleString = [USER_DEFALT objectForKey:KAgencyBusiness];
        if (titleString) {
            if (![titleString containsString:@"我创建的"]) {
                return @"0";
            }else{
                return @"1";
            }
        }else{
            return @"1";
        }
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
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"请求中..."];
    NSMutableDictionary *dic_parameter = @{
                                           @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                           @"pageSize":[NSNumber numberWithInt:10],
                                           @"prdType":self.prdType
                                           }.mutableCopy;
    [dic_parameter setObject:self.Orderstate ? self.Orderstate : @"" forKey:@"orderState"];//订单状态 1未完成 2已完成 3已关闭
    [dic_parameter setObject:self.searchKeyWord ? self.searchKeyWord : @"" forKey:@"keywords"];//搜索的时候
    [dic_parameter setObject:[self checkDataPermissions] forKey:@"queryMySelf"];//只查询我创建的订单 1是 0否,默认是

    //数据请求
    [ZSRequestManager requestWithParameter:dic_parameter url:[ZSURLManager getAllOrderList] SuccessBlock:^(NSDictionary *dic) {
        [LSProgressHUD hideForView:weakSelf.view];
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            global.allListModel = [ZSAllListModel yy_modelWithJSON:dict];
            global.allListModel.listType = 3;//3订单列表
            global.allListModel.state_result = self.Orderstate;//订单状态 1未完成 2已完成 3已关闭
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
    } ErrorBlock:^(NSError *error) {
        [weakSelf requestFail:weakSelf.tableView array:weakSelf.arrayData];
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self checkDataPermissions] isEqualToString:@"1"])
    {
        return 80;
    }
    else
    {
        return ZSBankHomeTableCellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifyZSHomeTableCell = @"identifyZSHomeTableCell";
    static NSString *identifyZSBankHomeTableCell = @"identifyZSBankHomeTableCell";

//    ZSLOG(@"奇了怪了:%@",[self checkDataPermissions]);
    if ([[self checkDataPermissions] isEqualToString:@"1"])
    {
        ZSHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyZSHomeTableCell];
        if (cell == nil) {
            cell = [[ZSHomeTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyZSHomeTableCell];
        }
        if (self.arrayData.count > 0) {
            ZSAllListModel *model= self.arrayData[indexPath.row];
            if (model) {
                cell.model = model;
            }
        }
        return cell;
    }
    else
    {
        ZSBankHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyZSBankHomeTableCell];
        if (cell == nil) {
            cell = [[ZSBankHomeTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyZSBankHomeTableCell];
        }
        if (self.arrayData.count > 0) {
            ZSAllListModel *model= self.arrayData[indexPath.row];
            if (model) {
                cell.model = model;
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.arrayData.count > 0)
    {
        ZSAllListModel *model = self.arrayData[indexPath.row];
        //未提交的订单
        if ([model.order_state_desc isEqualToString:@"暂存"])
        {
            [self gotoZCOrderDetail:self.prdType withserialNo:model.tid];
        }
        //已提交的订单
        else
        {
            [self gotoOrderDetail:self.prdType withserialNo:model.tid];
        }
    }
}

#pragma mark 进入暂存订单详情
- (void)gotoZCOrderDetail:(NSString *)prdType withserialNo:(NSString *)serialNo
{
    ZSSLPersonListViewController *detailVC = [[ZSSLPersonListViewController alloc]init];
    detailVC.orderState = @"暂存";
    detailVC.orderIDString = serialNo;
    detailVC.prdType = prdType;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 进入订单详情
- (void)gotoOrderDetail:(NSString *)prdType withserialNo:(NSString *)serialNo
{
    ZSSLPageController *detailVC = [[ZSSLPageController alloc]init];
    detailVC.orderIDString = serialNo;
    detailVC.prdType = prdType;
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
