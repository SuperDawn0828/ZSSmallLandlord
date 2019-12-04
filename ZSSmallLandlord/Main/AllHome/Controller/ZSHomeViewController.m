//
//  ZSHomeViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSHomeViewController.h"
#import "ZSWSPageController.h"
#import "ZSHomeHeaderView.h"
#import "ZSHomeTableCell.h"
#import "ZSWitnessServerPageController.h"
#import "ZSWSPersonListViewController.h"
#import "ZSStarLoanPageController.h"
#import "ZSHomeWebViewController.h"
#import "ZSSLPageController.h"
#import "ZSApplyForOnlinePageController.h"
#import "ZSSLPersonListViewController.h"
#import "ZSBaseSearchViewController.h"
#import "ZSPreliminaryCreditPageController.h"
#import "ZSTheMediationViewController.h"

@interface ZSHomeViewController ()<ZSHomeHeaderViewDelegate>
@property (nonatomic,strong)ZSHomeHeaderView *headerView;
@property (nonatomic,strong)NSMutableArray   *imageDataArray; //轮播图数据
@property (nonatomic,strong)NSMutableArray   *arrayData;      //列表数据
@property (nonatomic,assign)int              currentPage;     //当前页
@property (nonatomic,strong)UIView           *navBar;         //自定义导航栏
@property (nonatomic,strong)UIButton         *searchBtn;  //输入框
@property (nonatomic,strong)UIImageView      *searchImage;
@property (nonatomic,strong)UILabel          *searchLabel;
@end

@implementation ZSHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //清除列表数据权限title
    [USER_DEFALT removeObjectForKey:KWitnessServer];
    [USER_DEFALT removeObjectForKey:KStarLoan];
    [USER_DEFALT removeObjectForKey:KRedeemFloor];
    [USER_DEFALT removeObjectForKey:KMortgageLoan];
    [USER_DEFALT removeObjectForKey:KEasyLoan];
    [USER_DEFALT removeObjectForKey:KCarHire];
    [USER_DEFALT removeObjectForKey:KAgencyBusiness];
    //清空资料model
    global.slMaterialCollectModel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //Table
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kTabbarHeight+SafeAreaBottomHeight) withStyle:UITableViewStylePlain];
    self.headerView = [[ZSHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0)];
    [self.headerView resetSelfHeight];
    self.headerView.delegate = self;
    self.tableView.tableHeaderView = self.headerView;
 
    //搜索框
    [self initNavBar];
  
    //Data
    [self addHeader];
    [self addFooter];
    [NOTI_CENTER addObserver:self selector:@selector(reloadCell) name:KSUpdateAllOrderListNotification object:nil];
    [NOTI_CENTER addObserver:self selector:@selector(gotoOrderDetail:) name:@"gotoOrderDetail" object:nil];
}

#pragma mark 自定义导航栏
- (void)initNavBar
{
    self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, kNavigationBarHeight)];
    self.navBar.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[ZSTool createImageWithColor:ZSColorRed] Withview:self.navBar]];
    self.navBar.alpha = 0;
    [self.view addSubview:self.navBar];
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(36, kStatusBarHeight+7, ZSWIDTH-36*2, 27);
    self.searchBtn.backgroundColor = ZSColorWhite;
    self.searchBtn.alpha = 0;
    self.searchBtn.layer.cornerRadius = 13.5;
    self.searchBtn.layer.masksToBounds = YES;
    [self.searchBtn addTarget:self action:@selector(goToSearchCtrl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBtn];
    
    self.searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, (27-15)/2, 15, 15)];
    self.searchImage.image = [UIImage imageNamed:@"head_search_1_n"];
    [self.searchBtn addSubview:self.searchImage];
    
    self.searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(37, 0, 200, 27)];
    self.searchLabel.font = [UIFont systemFontOfSize:12];
    self.searchLabel.textColor = ZSColorAllNotice;
    [self.searchBtn addSubview:self.searchLabel];
    
#pragma mark 显示当前服务器环境
    if ([APPDELEGATE.zsurlHead isEqualToString:KTestServerUrl]) {
        self.searchLabel.text = @"测试环境";
    }
    else if ([APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl] || [APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl_port]) {
        self.searchLabel.text = @"预生产环境";
    }
    else if ([APPDELEGATE.zsurlHead isEqualToString:KFormalServerUrl] || [APPDELEGATE.zsurlHead isEqualToString:KFormalServerUrl_port]) {
        self.searchLabel.text = @"输入客户姓名/身份证号/手机号";
    }
}

#pragma mark 跳转到搜索页面
- (void)goToSearchCtrl
{
    ZSBaseSearchViewController *searchVC = [[ZSBaseSearchViewController alloc]init];
    searchVC.filePathString = KAllListSearch;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark 数据请求
- (void)reloadCell
{
    self.currentPage = 0;
    self.arrayData  = [[NSMutableArray alloc]init];
    self.imageDataArray  = [[NSMutableArray alloc]init];
    [self requestImages];//轮播图接口
    [self requestData];//列表
}

- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        weakSelf.arrayData  = [[NSMutableArray alloc]init];
        weakSelf.imageDataArray  = [[NSMutableArray alloc]init];
        [weakSelf requestData];//列表
        [weakSelf requestImages];//轮播图接口
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

//轮播图
- (void)requestImages
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getRoastingChart] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSHomeCarouselModel *model = [ZSHomeCarouselModel yy_modelWithDictionary:dict];
                [weakSelf.imageDataArray addObject:model];
            }
        }
        //刷新headerView
        [weakSelf.headerView fillInCarouselViewData:weakSelf.imageDataArray];
        [weakSelf.headerView resetSelfHeight];
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
    } ErrorBlock:^(NSError *error) {
        //刷新headerView
        [weakSelf.headerView fillInCarouselViewData:weakSelf.imageDataArray];
        [weakSelf.headerView resetSelfHeight];
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
    }];
}

//订单列表
- (void)requestData
{
    [LSProgressHUD showToView:self.view message:@""];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                           @"pageSize":[NSNumber numberWithInt:10],
                                           @"prdType":@"",
                                           @"orderState":@"1",
                                           @"keywords":@"",
                                           @"queryMySelf":@"1"//只查询我创建的订单 1是 0否,默认是
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getAllOrderList] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            global.allListModel = [ZSAllListModel yy_modelWithJSON:dict];
            global.allListModel.listType = 5;//5首页列表
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
        //刷新headerView
        if (weakSelf.arrayData.count > 0) {
            [weakSelf.headerView configureNoticeLabel];
            [weakSelf.headerView resetSelfHeight];
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        }
        [weakSelf.tableView reloadData];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [weakSelf requestFail:weakSelf.tableView array:weakSelf.arrayData];
        [LSProgressHUD hideForView:weakSelf.view];
        //刷新headerView
        if (weakSelf.arrayData.count > 0) {
            [weakSelf.headerView configureNoticeLabel];
            [weakSelf.headerView resetSelfHeight];
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        }
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

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0)
    {
        self.navBar.alpha = 0;
        self.searchBtn.alpha = 0;
    }
    else if (scrollView.contentOffset.y < kNavigationBarHeight)
    {
        self.navBar.alpha = scrollView.contentOffset.y/kNavigationBarHeight;
        self.searchBtn.alpha = scrollView.contentOffset.y/kNavigationBarHeight;
    }
    else
    {
        self.navBar.alpha = 1;
        self.searchBtn.alpha = 1;
    }
}

#pragma mark 点击轮播图
- (void)indexOfClickedImageBtn:(NSUInteger)index;//点击轮播图
{
    if (self.imageDataArray.count > 0) {
        ZSHomeCarouselModel *model = self.imageDataArray[index];
        NSString *linkString = [NSString stringWithFormat:@"%@",model.carouselLink];
        if (linkString.length) {
            ZSHomeWebViewController *webView = [[ZSHomeWebViewController alloc]init];
            webView.str_url = linkString;
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
}

#pragma mark 点击小工具
- (void)indexOfClickedToolsBtn:(NSString *)prdTypeString;//点击小工具
{
    //星速贷
    if ([prdTypeString isEqualToString:@"星速贷"])
    {
        ZSStarLoanPageController *SLVC = [[ZSStarLoanPageController alloc]init];
        SLVC.prdType = kProduceTypeStarLoan;
        [self.navigationController pushViewController:SLVC animated:YES];
    }
    //赎楼宝
    else if ([prdTypeString isEqualToString:@"赎楼宝"])
    {
        ZSStarLoanPageController *SLVC = [[ZSStarLoanPageController alloc]init];
        SLVC.prdType = kProduceTypeRedeemFloor;
        [self.navigationController pushViewController:SLVC animated:YES];
    }
    //抵押贷
    else if ([prdTypeString isEqualToString:@"抵押贷"])
    {
        ZSStarLoanPageController *SLVC = [[ZSStarLoanPageController alloc]init];
        SLVC.prdType = kProduceTypeMortgageLoan;
        [self.navigationController pushViewController:SLVC animated:YES];
    }
    //融易贷
    else if ([prdTypeString isEqualToString:@"融易贷"])
    {
        ZSStarLoanPageController *SLVC = [[ZSStarLoanPageController alloc]init];
        SLVC.prdType = kProduceTypeEasyLoans;
        [self.navigationController pushViewController:SLVC animated:YES];
    }
    //车位分期
    else if ([prdTypeString isEqualToString:@"车位分期"])
    {
        ZSStarLoanPageController *SLVC = [[ZSStarLoanPageController alloc]init];
        SLVC.prdType = kProduceTypeCarHire;
        [self.navigationController pushViewController:SLVC animated:YES];
    }
    //代办业务
    else if ([prdTypeString isEqualToString:@"代办业务"])
    {
        ZSStarLoanPageController *SLVC = [[ZSStarLoanPageController alloc]init];
        SLVC.prdType = kProduceTypeAgencyBusiness;
        [self.navigationController pushViewController:SLVC animated:YES];
    }
    //预授信评估
    else if ([prdTypeString isEqualToString:@"预授信评估"])
    {
        ZSPreliminaryCreditPageController *PCVC = [[ZSPreliminaryCreditPageController alloc]init];
        [self.navigationController pushViewController:PCVC animated:YES];
    }
    //中介端跟进
    else if ([prdTypeString isEqualToString:@"中介端跟进"])
    {
        ZSTheMediationViewController *SOVC = [[ZSTheMediationViewController alloc]init];
        [self.navigationController pushViewController:SOVC animated:YES];
    }
    //新房见证
    else if ([prdTypeString isEqualToString:@"新房见证"])
    {
        ZSWitnessServerPageController *WSVC = [[ZSWitnessServerPageController alloc]init];
        WSVC.prdType = kProduceTypeWitnessServer;
        [self.navigationController pushViewController:WSVC animated:YES];
    }
    //微信申请
    else if ([prdTypeString isEqualToString:@"微信申请"])
    {
        ZSApplyForOnlinePageController *WSVC = [[ZSApplyForOnlinePageController alloc]init];
        [self.navigationController pushViewController:WSVC animated:YES];
    }
}

#pragma mark 网页跳转至订单详情
- (void)gotoOrderDetail:(NSNotification *)info
{
    NSString *prdType = info.userInfo[@"prdType"];
    NSString *orderId = info.userInfo[@"orderId"];
    NSString *orderState = info.userInfo[@"orderState"];
    if ([orderState isEqualToString:@"暂存"])
    {
        ZSSLPersonListViewController *vc = [[ZSSLPersonListViewController alloc]init];
        vc.orderState = @"暂存";
        vc.orderIDString = orderId;
        vc.prdType = prdType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ZSSLPageController *detailVC = [[ZSSLPageController alloc]init];
        detailVC.orderIDString = orderId;
        detailVC.prdType = prdType;
        [self.navigationController pushViewController:detailVC animated:YES];
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
