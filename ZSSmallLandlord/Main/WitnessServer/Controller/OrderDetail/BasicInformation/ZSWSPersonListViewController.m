//
//  ZSViewPersonListController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSPersonListViewController.h"
#import "ZSWSPersonListViewCell.h"
#import "ZSWSPersonListAddViewCell.h"
#import "ZSBankReferenceEditorViewController.h"
#import "ZSWSAddCustomerViewController.h"
#import "ZSWSPersonDetailViewController.h"
#import "ZSWSAddCustomerBankViewController.h"

@interface ZSWSPersonListViewController ()<ZSActionSheetViewDelegate,ZSAlertViewDelegate,ZSWSRightAlertViewDelegate>
@property (nonatomic,strong)UIButton       *rightAction;
@property (nonatomic,strong)UIView         *footerView;
@property (nonatomic,strong)NSMutableArray *arrayAdd;
@end

@implementation ZSWSPersonListViewController

- (NSMutableArray *)arrayAdd
{
    if (_arrayAdd == nil){
        _arrayAdd = [[NSMutableArray alloc]init];
    }
    return _arrayAdd;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"人员列表";
    [self setLeftBarButtonItem];//返回
    [self configureTableView:CGRectMake(0, 44, ZSWIDTH, ZSHEIGHT-64-44) withStyle:UITableViewStylePlain];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    self.glt_scrollView = self.tableView;
    [self createRightBtn];//右侧按钮
    [self initFooterView];//底部按钮
    //Data
    //从订单详情和添加主贷人信息过来都有数据,订单列表过来的需要请求详情接口
    if (self.TypeOfself == orderDetail) {
        [self reloadCell];
    }
    else{
        global.wsOrderDetail.custInfo = nil;
        [self requestOrderDetail];
    }
    [NOTI_CENTER addObserver:self selector:@selector(reloadCell) name:kOrderDetailFreshDataNotification object:nil];
    //提前通知图片格式转换(避免点击的时候进入编辑页面太慢了)
    if (self.TypeOfself == addCustomer || [self.str_orderState isEqualToString:@"待提交征信查询"] || [self.str_orderState isEqualToString:@"1"] ) {
        for (int i = 0; i<global.wsOrderDetail.custInfo.count; i++) {
            global.wsCustInfo = global.wsOrderDetail.custInfo[i];
            [NOTI_CENTER postNotificationName:@"KSUpdatePhotos" object:nil];
        }
    }
}

#pragma mark /*-----------------------返回事件-----------------------*/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self leftAction];
    return NO;
}

- (void)leftAction
{
    //如果上个页面是添加客户信息,返回到订单列表
    UIViewController *lastVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count-2];
    if ([lastVC isKindOfClass:[ZSWSAddCustomerViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 获取订单详情接口
- (void)requestOrderDetail
{
    __weak typeof(self) weakSelf  = self;
    NSMutableDictionary *parameter=  @{
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getQueryWitnessOrderDetails] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:nil];
        //赋值
        global.wsOrderDetail = [ZSWSOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
        //从订单详情和添加主贷人信息过来都有数据,订单列表过来的需要请求详情接口
        if (weakSelf.TypeOfself == orderDetail) {
            //通知子控制器列表刷新
            [NOTI_CENTER postNotificationName:kOrderDetailFreshDataNotification object:nil];
        }
        else{
            //自己页面刷新
            [weakSelf reloadCell];
        }
    } ErrorBlock:^(NSError *error) {
        [weakSelf requestFail:weakSelf.tableView array:nil];
    }];
}

#pragma mark 刷新数据
- (void)reloadCell
{
    [self.arrayAdd removeAllObjects];
    [self initDatas];
    [self.tableView reloadData];
}

#pragma mark 填充数据
- (void)initDatas
{
    global.wsOrderDetail.custInfo = [NSMutableArray arrayWithArray:global.wsOrderDetail.custInfo];

    //人数不满6人添加假数据
    if (global.wsOrderDetail.custInfo.count < 6) {
        [self falseDataFill];
    }
}

//先遍历已有角色和主贷人.担保人婚姻状况判断,填充相应的假数据  //角色信息 1贷款人,2配偶,3配偶&共有人,4共有人,5担保人,6担保人配偶
- (void)falseDataFill
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:@"贷款人配偶"];
    [array addObject:@"共有人"];
    [array addObject:@"担保人"];
    //共有人计数
    int a = 0;
    int b = 0;
    //配偶计数
    int c = 0;
    int d = 0;
    for (int i = 0; i < global.wsOrderDetail.custInfo.count; i++) {
        CustInfo *info = global.wsOrderDetail.custInfo[i];
        if (info.releation.intValue == 2) {
            c++;
        }else if (info.releation.intValue == 5) {
            [array removeObject:@"担保人"];
            if (info.beMarrage.intValue == 2) {
                [array addObject:@"担保人配偶"];
            }
        }else if (info.releation.intValue == 6) {
            BOOL isbool = [array containsObject:@"担保人配偶"];
            if (isbool) {
                [array removeObject:@"担保人配偶"];
            }
        }else if (info.releation.intValue == 4) {
            a++;
        }else if (info.releation.intValue == 3) {
            b++;
            d++;
        }else if (info.releation.intValue == 1) {
            if (info.beMarrage.intValue != 2) {
                [array removeObject:@"贷款人配偶"];
            }
        }
    }
    if (a+b == 2) {
        [array removeObject:@"共有人"];
    }
    if (c + d == 2 || c + d == 1) {
        BOOL isbool = [array containsObject:@"贷款人配偶"];
        if (isbool) {
            [array removeObject:@"贷款人配偶"];
        }
    }
    
    self.arrayAdd = [NSMutableArray arrayWithArray:array];
}

#pragma mark 右侧按钮--关闭订单
- (void)createRightBtn
{
    if ([self.str_orderState isEqualToString:@"1"] || global.wsOrderDetail.projectInfo.orderState.intValue == 1) {//订单状态为"待提交征信查询",显示关闭按钮
        [self configureRightNavItem];
    }
}

- (void)configureRightNavItem
{
    self.rightAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightAction setFrame:CGRectMake(0, 0, 80, 40)];
    UIView *backBtnView = [[UIView alloc] initWithFrame:self.rightAction.bounds];
    backBtnView.bounds = CGRectOffset(backBtnView.bounds, -6, 0);
    [backBtnView addSubview:self.rightAction];
    [self.rightAction setImage:ImageName(@"head_more_n") forState:UIControlStateNormal];
    self.rightAction.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightAction.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightAction addTarget:self action:@selector(RightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backBtnView];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

- (void)RightBtnAction:(UIButton *)sender
{
    ZSWSRightAlertView *alertView = [[ZSWSRightAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withArray:@[KCloseBtnTitle]];
    alertView.delegate = self;
    [alertView show];
}

- (void)didSelectBtnClick:(NSInteger)tag;
{
    ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"关闭订单后，该订单将不可进行任何操作，是否确认关闭订单？" sureTitle:@"确认" cancelTitle:@"取消"];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark 底部按钮
- (void)initFooterView
{
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 64)];
    self.footerView.backgroundColor = [UIColor clearColor];
    if (self.TypeOfself == orderDetail)
    {
        //1.订单详情页面: 单子人数大于6时,不显示底部"添加"按钮
        [self initOrderDetailFooterView];
    }
    else if (self.TypeOfself == addCustomer) {
        //2.添加客户分两种情况
        //2.1 创建订单时: 不管单子人数大不大于6,都显示底部"下一步"按钮
        //2.2 已有订单时: 单子人数大于6时,不显示底部"下一步"按钮
        [self initAddCustomerFooterView];
    }
    else if (self.TypeOfself == orderList){
        //3.订单列表
        [self initPersonListFooterView];
    }
}

//订单详情页面底部按钮
- (void)initOrderDetailFooterView
{
    //已完成和已关闭的单子不能操作
    if ([ZSTool checkWitnessServerOrderIsCanEditing]){
        [self falseDataFill];
        if (self.arrayAdd.count > 0) {
            [self configuBottomButtonWithTitle:@"添加" OriginY:15];
            [self.footerView addSubview:self.bottomBtn];
        }
    }
    self.tableView.tableFooterView = self.footerView;
}

//添加客户页面底部按钮
- (void)initAddCustomerFooterView
{
    [self configuBottomButtonWithTitle:@"下一步" OriginY:15];
    [self.footerView addSubview:self.bottomBtn];
    self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, self.view.height+10);
    self.tableView.tableFooterView = self.footerView;
}

//订单列表--人员列表页面底部按钮
- (void)initPersonListFooterView
{
    [self configuBottomButtonWithTitle:@"下一步" OriginY:15];
    [self.footerView addSubview:self.bottomBtn];
    self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, self.view.height+10);
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.TypeOfself == addCustomer || self.TypeOfself == orderList) {
        if (indexPath.row == global.wsOrderDetail.custInfo.count + self.arrayAdd.count -1) {
            return 75;
        }
        return 85;
    }
    else
    {
        if (indexPath.row == global.wsOrderDetail.custInfo.count-1) {
            return 75;
        }
        return 85;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.TypeOfself == addCustomer || self.TypeOfself == orderList) {
        return global.wsOrderDetail.custInfo.count + self.arrayAdd.count;
    }else{
        return global.wsOrderDetail.custInfo.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (self.TypeOfself == addCustomer || self.TypeOfself == orderList) {
        if (indexPath.row < global.wsOrderDetail.custInfo.count) {
            static NSString *identify = @"identify";
            ZSWSPersonListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (cell == nil) {
                cell = [[ZSWSPersonListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
            if (global.wsOrderDetail.custInfo.count > 0) {
                cell.detailModel = global.wsOrderDetail.custInfo[indexPath.row];
            }
            return cell;
        }else{
            static NSString *identify1 = @"identify1";
            ZSWSPersonListAddViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
            if (cell == nil) {
                cell = [[ZSWSPersonListAddViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
            }
            if (self.arrayAdd.count > 0) {
                cell.label_role.text = self.arrayAdd[indexPath.row-global.wsOrderDetail.custInfo.count];
            }
            return cell;
        }
    }
    else {
        static NSString *identify2 = @"identify2";
        ZSWSPersonListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (cell == nil) {
            cell = [[ZSWSPersonListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
        }
        if (global.wsOrderDetail.custInfo.count > 0) {
            cell.detailModel = global.wsOrderDetail.custInfo[indexPath.row];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //订单详情,编辑人员信息
    if (self.TypeOfself == orderDetail)
    {
        ZSWSPersonDetailViewController *personDetailVC = [[ZSWSPersonDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
        global.wsCustInfo = global.wsOrderDetail.custInfo[indexPath.row];
        personDetailVC.personIDString = global.wsCustInfo.tid;//人员id
        personDetailVC.orderIDString = global.wsCustInfo.orderId;//订单id
        personDetailVC.seleceIndex = indexPath.row;
        personDetailVC.title = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel getReleationStateWithCode:global.wsCustInfo.releation]];
        [self.navigationController pushViewController:personDetailVC animated:YES];
    }
    else if (self.TypeOfself == addCustomer || self.TypeOfself == orderList)
    {
        if (indexPath.row < global.wsOrderDetail.custInfo.count)
        {
            //该cell有人员信息时,如果是从添加客户信息过来的,进入客户信息修改页;如果是从订单详情过来的,订单状态为未提交征信,进入客户信息修改页,其他状态进入人员详情展示页
            if (self.TypeOfself == addCustomer || [self.str_orderState isEqualToString:@"待提交征信查询"] || [self.str_orderState isEqualToString:@"1"] )
            {
                ZSWSAddCustomerViewController *addVC = [[ZSWSAddCustomerViewController alloc]init];
                addVC.isFromEditor = YES;
                global.wsCustInfo = global.wsOrderDetail.custInfo[indexPath.row];
                addVC.orderIDString = self.orderIDString;
                addVC.title = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel getReleationStateWithCode:global.wsCustInfo.releation]];
                [self.navigationController pushViewController:addVC animated:YES];
            }
            else
            {
                ZSWSPersonDetailViewController *personDetailVC = [[ZSWSPersonDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
                global.wsCustInfo = global.wsOrderDetail.custInfo[indexPath.row];
                personDetailVC.personIDString = global.wsCustInfo.tid;//人员id
                personDetailVC.orderIDString = global.wsCustInfo.orderId;//订单id
                personDetailVC.seleceIndex = indexPath.row;
                personDetailVC.title = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel getReleationStateWithCode:global.wsCustInfo.releation]];
                [self.navigationController pushViewController:personDetailVC animated:YES];
            }
        }
        else
        {
            global.wsCustInfo = nil;//清空
            //该cell无人员信息时,进入添加人员信息页面,并且需要传递角色
            ZSWSAddCustomerViewController *addVC = [[ZSWSAddCustomerViewController alloc]init];
            NSString *string = self.arrayAdd[indexPath.row - global.wsOrderDetail.custInfo.count];
            addVC.isFromAdd = YES;
            addVC.orderIDString = self.orderIDString;
            addVC.title = [NSString stringWithFormat:@"%@信息",string];
            [self.navigationController pushViewController:addVC animated:YES];
        }
    }
}

#pragma mark 订单详情--新增/编辑人员信息, 银行后勤进行反馈
- (void)bottomClick:(UIButton *)sender
{
    if (self.TypeOfself == orderDetail)
    {
        //订单详情,添加其他人员信息
        [self falseDataFill];
        NSArray *array = self.arrayAdd;
        ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:array];
        actionsheet.delegate = self;
        [actionsheet show:array.count];
    }
    else if (self.TypeOfself == addCustomer || self.TypeOfself == orderList)
    {
        //添加完主贷人信息,选择项目名称和银行
        ZSWSAddCustomerBankViewController *addBankVC = [[ZSWSAddCustomerBankViewController alloc]init];
        addBankVC.orderIDString = self.orderIDString;
        [self.navigationController pushViewController:addBankVC animated:YES];
    }
}

#pragma mark ZSActionSheetViewDelegate
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag
{
    ZSWSAddCustomerViewController *addVC = [[ZSWSAddCustomerViewController alloc]init];
    CustInfo *info = global.wsOrderDetail.custInfo.firstObject;
    addVC.isFromOrderdetail = YES;
    addVC.isFromAdd = YES;
    addVC.orderIDString = info.orderId;
    addVC.title = [NSString stringWithFormat:@"%@信息",self.arrayAdd[tag]];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark ZSAlertViewDelegate
- (void)AlertView:(ZSAlertView *)alert;//按钮触发的方法
{
    [self requestForCloseOrderData];
}

#pragma mark 关闭订单
- (void)requestForCloseOrderData
{
    __weak typeof(self) weakSelf  = self;
    [LSProgressHUD showToView:self.view message:@"关闭中"];
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":global.wsOrderDetail.projectInfo.tid}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getCloseOrder] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //提示
        [ZSTool showMessage:@"关闭成功" withDuration:DefaultDuration];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
