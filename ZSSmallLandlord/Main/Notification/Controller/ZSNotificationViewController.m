//
//  ZSNotificationViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/27.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSNotificationViewController.h"
#import "ZSNotificationCell.h"
#import "ZSBankHomePersonListViewController.h"
#import "ZSWSPageController.h"
#import "ZSSLPageController.h"
#import "ZSNotificationDetailView.h"
#import "ZSAFOOrderDetailViewController.h"
#import "ZSPCOrderDetailController.h"
#import "ZSSLPersonListViewController.h"

@interface ZSNotificationViewController ()
@property (nonatomic,strong)NSMutableArray   *arrayData;
@property (nonatomic,strong)UIView           *view_header;
@property (nonatomic,assign) int             currentPage;//当前页
@end

@implementation ZSNotificationViewController

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
    [self checkNotification];//判断是否开启了推送
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight-kTabbarHeight+SafeAreaBottomHeight) withStyle:UITableViewStylePlain];
    self.glt_scrollView = self.tableView;
    //Data
    [self addHeader];
    [self addFooter];
    [self configureErrorViewWithStyle:ZSErrorNotificationNoData];//通知无数据

    [NOTI_CENTER addObserver:self selector:@selector(checkNotification) name:KSCheckNoitfication object:nil];
    [NOTI_CENTER addObserver:self selector:@selector(reloadCell) name:KSUpdateNotificationList object:nil];
}

#pragma mark date request
- (void)reloadCell
{
    self.currentPage = 0;
    self.arrayData  = [[NSMutableArray alloc]init];
    [self requestData];
}

- (void)addHeader {
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
                                           @"pageSize":[NSNumber numberWithInt:10],
                                           @"noteType":self.notificationType
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getAllNotification] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            ZSNotificationModel *model = [ZSNotificationModel yy_modelWithJSON:dict];
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

#pragma mark 判断是否允许接收推送
- (void)checkNotification
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if(UIUserNotificationTypeNone != setting.types) {
        self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, self.view.height+10);
        [self.view_header removeFromSuperview];
    }else{
        [self initHeaderView];
        self.tableView.frame = CGRectMake(0, 20, ZSWIDTH, self.view.height-20);
    }
}

- (void)initHeaderView
{
    self.view_header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 30)];
    self.view_header.backgroundColor = UIColorFromRGB(0xFCAF4B);
    [self.view addSubview:self.view_header];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ZSWIDTH-100, self.view_header.height)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = ZSColorWhite;
    label.text = @"开启消息提醒，业务永不遗漏！";
    [self.view_header addSubview:label];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-30, (self.view_header.height-15)/2, 15, 15)];
    img.image = [UIImage imageNamed:@"list_arrow_1_n"];
    [self.view_header addSubview:img];
    
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-130, 0, 100, self.view_header.height)];
    rightLabel.font = [UIFont systemFontOfSize:13];
    rightLabel.textColor = ZSColorWhite;
    rightLabel.text = @"去开启";
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.view_header addSubview:rightLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToOpenNotification)];
    [self.view_header addGestureRecognizer:tap];
}

- (void)goToOpenNotification
{
    //1.跳到APP自身的设置页
    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:appSettings]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:^(BOOL success) {
                //有时候通知不生效,所以在这儿添加一个回调
                self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, self.view.height+10);
                [self.view_header removeFromSuperview];
            }];
        }else{
            [[UIApplication sharedApplication] openURL:appSettings];
        }
    }
}

#pragma mark tableview--delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    view.backgroundColor = ZSViewBackgroundColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSNotificationCell *cell = (ZSNotificationCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"获取cell label的高度:%f",cell.contentLabel.height);
    if (cell.contentLabel.height <= 24) {
        return cell.contentLabel.bottom + 7;
    }else{
        return cell.contentLabel.bottom + 15;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSNotificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (self.arrayData.count > 0) {
        ZSNotificationModel *model = self.arrayData[indexPath.row];
        if (model) {
            cell.model = model;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZSNotificationModel *model = self.arrayData[indexPath.row];
    //----------------------------------------------业务通知------------------------------------------------------
    if (model.prdType)
    {
        self.prdType = model.prdType;

        //预授信评估 //待派单
        if ([model.title isEqualToString:@"待预授信评估通知"] || [model.title isEqualToString:@"待派单通知"])
        {
            if ([model.orderState isEqualToString:@"待生成预授信报告"]|| [model.orderState isEqualToString:@"已生成预授信报告"])
            {
                ZSPCOrderDetailController *detailVC = [[ZSPCOrderDetailController alloc]init];
                detailVC.orderIDString = model.serialNo;
                detailVC.lastVC = ZSPreliminaryCreditPageController;
                detailVC.prdType = model.prdType;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            else if ([model.orderState isEqualToString:@"暂存"])
            {
                [self gotoZCOrderDetailWithserialNo:model.serialNo withPrdtype:model.prdType];
            }
            else
            {
                [self gotoOrderDetailWithserialNo:model.serialNo withPrdtype:model.prdType];
            }
        }
        //待派单
        else if ([model.title isEqualToString:@"派单通知"])
        {
            //暂存状态进入人员列表,其他进入订单详情
            if ([model.orderState isEqualToString:@"暂存"])
            {
                [self gotoZCOrderDetailWithserialNo:model.serialNo withPrdtype:model.prdType];
            }
            else{
                [self gotoOrderDetailWithserialNo:model.serialNo withPrdtype:model.prdType];
            }
        }
        //新房见证
        else if ([model.prdType isEqualToString:@"新房见证"] || [model.prdType isEqualToString:kProduceTypeWitnessServer])
        {
            //待提交征信查询时进入人员列表,其他进订单详情
            if ([model.orderState isEqualToString:@"待提交征信查询"] || model.orderState.intValue == 2 || [model.title isEqualToString:@"待征信反馈通知"])
            {
                ZSBankHomePersonListViewController *personalVC = [[ZSBankHomePersonListViewController alloc]init];
                personalVC.orderIDString = model.serialNo;
                personalVC.isNotFeedback = model.fedbackState.intValue == 0 ? YES : NO;//判断订单状态: 是否已反馈
                personalVC.prdType = model.prdType;
                [self.navigationController pushViewController:personalVC animated:YES];
            }
            else
            {
                ZSWSPageController *detailVC = [[ZSWSPageController alloc]init];
                detailVC.orderIDString = model.serialNo;
                detailVC.prdType = model.prdType;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
        //金融产品
        else
        {
            //暂存状态进入人员列表,其他进入订单详情
            if ([model.orderState isEqualToString:@"暂存"])
            {
                [self gotoZCOrderDetailWithserialNo:model.serialNo withPrdtype:model.prdType];
            }
            else{
                [self gotoOrderDetailWithserialNo:model.serialNo withPrdtype:model.prdType];
            }
        }
    }
    //微信申请
    else if ([model.title isEqualToString:@"微信申请通知"] || [model.title isEqualToString:@"微信申请派发通知"] )
    {
        ZSAFOOrderDetailViewController *detailVC = [[ZSAFOOrderDetailViewController alloc]init];
        detailVC.onlineOrderIDString = model.serialNo;
        detailVC.isFromNew = YES;
        detailVC.prdType = model.prdType;
        if (SystemVersion <= 11.0) {
            detailVC.style = UITableViewStyleGrouped;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    //系统通知
    else
    {
        ZSNotificationDetailView *detailView = [[ZSNotificationDetailView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withTitle:@"系统通知" withContent:model.content withLeftBtnTitle:@"知道了" withRightBtnTitle:nil];
        [detailView show];
    }
}

#pragma mark 进入暂存订单详情
- (void)gotoZCOrderDetailWithserialNo:(NSString *)serialNo withPrdtype:(NSString *)prdType
{
    ZSSLPersonListViewController *vc = [[ZSSLPersonListViewController alloc]init];
    vc.orderState = @"暂存";
    vc.orderIDString = serialNo;
    vc.prdType = prdType;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 进入订单详情
- (void)gotoOrderDetailWithserialNo:(NSString *)serialNo withPrdtype:(NSString *)prdType
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
