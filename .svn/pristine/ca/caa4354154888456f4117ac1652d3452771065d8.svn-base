//
//  ZSAFOOrderListViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSOListViewController.h"
#import "ZSHomeTableCell.h"
#import "ZSPCOrderDetailController.h"
#import "ZSSendOrderPersonModel.h"
#import "ZSSendOrderPopView.h"
#import "ZSNotificationDetailView.h"

@interface ZSSOListViewController ()<ZSHomeTableCellDelegate,ZSSendOrderPopViewDelegate,ZSNotificationDetailViewDelegate>
@property (nonatomic,assign)int                                      currentPage;       //当前页
@property (nonatomic,strong)NSMutableArray<ZSAllListModel *>         *arrayData;
@property (nonatomic,strong)NSMutableArray<ZSSendOrderPersonModel *> *sendPersonArray;  //派单人员列表
@property (nonatomic,strong)NSMutableArray<ZSAllListModel *>         *selectorPatnArray;//存放选中数据
@property (nonatomic,copy  )NSString                                 *receiveDistributeUserId;//接受派单人员的id
@end

@implementation ZSSOListViewController

- (NSMutableArray *)sendPersonArray
{
    if (_sendPersonArray == nil) {
        _sendPersonArray = [[NSMutableArray alloc]init];
    }
    return _sendPersonArray;
}

- (NSMutableArray *)selectorPatnArray
{
    if (!_selectorPatnArray) {
        _selectorPatnArray = [NSMutableArray array];
    }
    return _selectorPatnArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight) withStyle:UITableViewStylePlain];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    self.tableView.allowsSelectionDuringEditing = YES;//设置编辑状态下可点击
    self.glt_scrollView = self.tableView;
    //Data
    [self addHeader];
    [self addFooter];
    [self requestSendOrderPersonList];
    [NOTI_CENTER addObserver:self selector:@selector(reloadCell) name:KSUpdateAllOrderListNotification object:nil];
    [NOTI_CENTER addObserver:self selector:@selector(theBatch0peration:) name:@"theBatch0peration" object:nil];
    [self configureErrorViewWithStyle:ZSErrorWithoutOrderOfBank];
}

#pragma mark /*-------------------------------------数据请求-------------------------------------*/
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
                                           @"prdType":@"",
                                           }.mutableCopy;
    if (self.self.Orderstate) {
        [parameterDict setObject:self.Orderstate forKey:@"searchState"];//订单状态 1未处理 2已处理
    }
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getListDistributeOrders] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            global.allListModel = [ZSAllListModel yy_modelWithJSON:dict];
            global.allListModel.listType = 2;//预授信评估列表
            global.allListModel.state_result = self.Orderstate;//订单状态 1未处理 2已处理
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

#pragma mark 派单人员列表
- (void)requestSendOrderPersonList
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getListReceiveDistributeUsers] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSSendOrderPersonModel *model = [ZSSendOrderPersonModel yy_modelWithJSON:dict];
                [weakSelf.sendPersonArray addObject:model];
            }
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark /*-------------------------------------tableView-------------------------------------*/
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
    ZSHomeTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ZSHomeTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.delegate = self;
    }
    if (self.arrayData.count > 0) {
        ZSAllListModel *model = self.arrayData[indexPath.row];
        cell.model = model;
        cell.currentIndex = indexPath.row;
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //正常状态下点击cell
    if (self.tableView.isEditing == NO)
    {
        if (self.arrayData.count > 0)
        {
            ZSAllListModel *model = self.arrayData[indexPath.row];
            ZSPCOrderDetailController *detailVC = [[ZSPCOrderDetailController alloc]init];
            detailVC.orderIDString = model.tid;
            detailVC.lastVC = ZSSendOrderPageViewController;
            detailVC.prdType = model.prd_type;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    //编辑状态下,只需要改变数据源并刷新当前cell即可
    else
    {
        ZSAllListModel *newModel = self.arrayData[indexPath.row];
        if (newModel.isSelect == NO) {
            [self.selectorPatnArray addObject:self.arrayData[indexPath.row]];
            newModel.isSelect = YES;
        }
        else {
            if (self.selectorPatnArray.count > 0) {
                [self.selectorPatnArray removeObject:self.arrayData[indexPath.row]];
            }
            newModel.isSelect = NO;
        }
        //数据更换,避免cell复用导致的问题
        [self.arrayData replaceObjectAtIndex:indexPath.row withObject:newModel];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark ZSHomeTableCellDelegate  编辑状态下点击选中按钮,只需要改变数据源即可
- (void)sendData:(ZSAllListModel *)model withIndex:(NSUInteger)currentIndex withType:(BOOL)isAdd;//isAdd为YES则是添加
{
    ZSAllListModel *newModel = self.arrayData[currentIndex];
    if (isAdd == YES) {
        [self.selectorPatnArray addObject:self.arrayData[currentIndex]];
        newModel.isSelect = YES;
    }
    else {
        if (self.selectorPatnArray.count > 0) {
            [self.selectorPatnArray removeObject:self.arrayData[currentIndex]];
        }
        newModel.isSelect = NO;
    }
    //数据更换,避免cell复用导致的问题
    [self.arrayData replaceObjectAtIndex:currentIndex withObject:newModel];
}

#pragma mark /*-------------------------------------批量操作-------------------------------------*/
- (void)theBatch0peration:(NSNotification *)info
{
    //待处理的订单才可操作
    if (self.Orderstate.intValue == 1)
    {
        NSDictionary *dict = info.userInfo;
        NSString *showSelect = dict[@"showSelect"];
        if (showSelect.intValue == 0)
        {
            //进入编辑状态
            self.tableView.editing = YES;
            //显示底部按钮
            [self configuBottomButtonWithTitle:@"派单给"];
            [self setBottomBtnBackgroundColorWithWhite];
            self.bottomView.frame = CGRectMake(0, ZSHEIGHT- 58 - kNavigationBarHeight + CellHeight, ZSWIDTH, 60+SafeAreaBottomHeight);
            //设置tableview的frame
            self.tableView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight-20);
        }
        else
        {
            //取消编辑状态
            self.tableView.editing = NO;
            //隐藏底部按钮
            [self.bottomView removeFromSuperview];
            //设置tableview的frame
            self.tableView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight);
            //清除选中的数据
            [self.selectorPatnArray removeAllObjects];
            //刷新数据源的选中状态
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.arrayData];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZSAllListModel *newModel = array[idx];
                newModel.isSelect = NO;
                [self.arrayData replaceObjectAtIndex:idx withObject:newModel];
            }];
            //刷新tableview
            [self.tableView reloadData];
        }
    }
}

#pragma mark 显示可派单的人员列表弹窗
- (void)bottomClick:(UIButton *)sender
{
    if (self.selectorPatnArray.count == 0) {
        [ZSTool showMessage:@"请先选择需要派发的订单" withDuration:DefaultDuration];
        return;
    }
    if (self.sendPersonArray.count == 0) {
        [ZSTool showMessage:@"暂无可派单人员" withDuration:DefaultDuration];
        return;
    }
    ZSSendOrderPopView *sendView = [[ZSSendOrderPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:self.sendPersonArray];
    sendView.delegate = self;
    [sendView show];
}

#pragma mark 提示派单信息
- (void)selectWithData:(ZSSendOrderPersonModel *)model
{
    //接受派单的人员id
    self.receiveDistributeUserId = model.tid;
    
    NSString *string = [NSString stringWithFormat:@"是否确定把客户%@的订单派发给%@%@？",[self getNoticeString],model.rolename,model.username];
    ZSNotificationDetailView *detailView = [[ZSNotificationDetailView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withTitle:@"派单确认" withContent:string withLeftBtnTitle:@"取消" withRightBtnTitle:@"确认"];
    detailView.delegate = self;
    [detailView show];
}

- (NSString *)getNoticeString
{
    NSString *string;
    for (ZSAllListModel *model in self.selectorPatnArray) {
        if (string.length) {
            string = [NSString stringWithFormat:@"%@、%@",string,model.cust_name];
        }
        else
        {
            string = [NSString stringWithFormat:@"%@",model.cust_name];
        }
    }
    return string;
}

#pragma mark 提交派单
- (void)sureClick:(ZSNotificationDetailView *)noticeView;
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"请求中..."];
    NSMutableDictionary *dict = @{}.mutableCopy;
    //接受派单的人员id
    [dict setObject:self.receiveDistributeUserId forKey:@"receiveDistributeUserId"];
    //订单信息
    NSString *orderInfo = [NSString arrayToJsonString:[self getOrderInfoArray]];
    [dict setValue:orderInfo forKey:@"orderInfo"];

    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager submitDistributeBatch] SuccessBlock:^(NSDictionary *dic) {
        [ZSTool showMessage:@"派单成功" withDuration:DefaultDuration];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

- (NSArray *)getOrderInfoArray
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (ZSAllListModel *model in self.selectorPatnArray) {
        NSDictionary *infoDic = @{
                                  @"orderId":model.tid,
                                  @"prdType":[ZSGlobalModel getProductCodeWithState:model.prd_type],
                                  };
        [array addObject:infoDic];
    }
    return array;
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
