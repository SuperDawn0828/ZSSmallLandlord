//
//  ZSWSProjectScheduleViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSOrderScheduleViewController.h"
#import "ZSWSOrderScheduleCell.h"
#import "ZSWSAddScheduleViewController.h"
#import "LSProgressHUD.h"
@interface ZSWSOrderScheduleViewController ()
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,assign)NSInteger      count;
@end

@implementation ZSWSOrderScheduleViewController

- (NSMutableArray *)titleArray
{
    if (_titleArray == nil){
        _titleArray = [[NSMutableArray alloc]init];
    }
    return _titleArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"按揭进度";
    [self configureTableView:CGRectMake(0, 44, ZSWIDTH, ZSHEIGHT-64-44) withStyle:UITableViewStylePlain];
    self.glt_scrollView = self.tableView;
    [self resisterCell];
//    [self addHeader];
    //已完成和已操作的单子不能操作 新增按揭进度按钮隐藏
    if ([ZSTool checkWitnessServerOrderIsCanEditing]){
        [self initWithBottomBtn];
        self.tableView.height = ZSHEIGHT - 58;
    }
    //Data
    [NOTI_CENTER addObserver:self selector:@selector(refreshOrderDetailData) name:kOrderDetailFreshDataNotification object:nil];
}

//#pragma mark /*-----------------------订单详情下拉刷新用-----------------------*/
//- (void)addHeader
//{
//    __weak typeof(self) weakSelf  = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestOrderDetail];
//    }];
//    if (weakSelf.count > 0) {
//        [self.tableView.mj_header beginRefreshing];
//    }
//    weakSelf.count = 1;
//}
//
//#pragma mark 获取订单详情接口
//- (void)requestOrderDetail
//{
//    __weak typeof(self) weakSelf  = self;
//    NSMutableDictionary *parameter=  @{
//                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
//                                       }.mutableCopy;
//    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getQueryWitnessOrderDetails] SuccessBlock:^(NSDictionary *dic) {
//        [weakSelf endRefresh:self.tableView array:nil];
//        //赋值
//        global.wsOrderDetail = [ZSWSOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
//        //通知子控制器列表刷新
//        [NOTI_CENTER postNotificationName:kOrderDetailFreshDataNotification object:nil];
//    } ErrorBlock:^(NSError *error) {
//        [weakSelf endRefresh:self.tableView array:nil];
//    }];
//}

#pragma mark 刷新详情数据通知
- (void)refreshOrderDetailData
{
    [self.tableView reloadData];
}

#pragma mark 创建底部按钮
- (void)initWithBottomBtn
{
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = ZSColorWhite;
    bottomView.frame = CGRectMake(0, ZSHEIGHT - 64 - 60 , ZSWIDTH, 60);
    [self.view addSubview:bottomView];
    [self configuBottomButtonWithTitle:@"新增进度" OriginY:7];
    [bottomView addSubview:self.bottomBtn];
}

#pragma mark 注册单元格
- (void)resisterCell
{
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    self.tableView.estimatedRowHeight = 98;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:KReuseZSWSOrderScheduleCellIdentifier bundle:nil] forCellReuseIdentifier:KReuseZSWSOrderScheduleCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return global.wsOrderDetail.scheduleInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSWSOrderScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSOrderScheduleCellIdentifier];
    ScheduleInfo *model = global.wsOrderDetail.scheduleInfo[indexPath.row];
    cell.model = model;
    cell.topView.hidden = NO;
    cell.bottomView.hidden = NO;
    cell.pointImgView.image = ImageName(@"");
    cell.pointImgViewWidthConstraint.constant = 8;
    cell.pointImgViewHeightConstraint.constant = 8;
    cell.pointImgViewLeftConstraint.constant = 17;
    cell.pointImgView.layer.cornerRadius = 4;
    cell.pointImgView.backgroundColor = UIColorFromRGB(0xcccccc);
    if (indexPath.row == 0) {
        cell.topView.hidden = YES;
    }
    if (indexPath.row == global.wsOrderDetail.scheduleInfo.count-1) {
        cell.bottomView.hidden = YES;
        cell.pointImgViewWidthConstraint.constant = 13;
        cell.pointImgViewHeightConstraint.constant = 13;
        cell.pointImgViewLeftConstraint.constant = 15;
        cell.pointImgView.layer.cornerRadius = 6;
        cell.pointImgView.backgroundColor = ZSColorWhite;
        cell.pointImgView.image = ImageName(@"list_select_s");
    }
    return cell;
}

#pragma mark 底部按钮点击
- (void)bottomClick:(UIButton *)sender
{
    ZSWSAddScheduleViewController *vc = [[ZSWSAddScheduleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
