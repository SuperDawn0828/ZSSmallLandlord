//
//  ZSSLPersonListViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLPersonListViewController.h"
#import "ZSSLPersonDetailViewController.h"
#import "ZSBaseAddCustomerViewController.h"
#import "ZSChangeCustomerSourceViewController.h"
#import "ZSSLAddLoanMaterialViewController.h"
#import "ZSRFAddLoanMaterialViewController.h"
#import "ZSMLAddLoanMaterialViewController.h"
#import "ZSELAddLoanMaterialViewController.h"
#import "ZSCHAddLoanMaterialViewController.h"
#import "ZSELAddLoanMaterialViewController.h"
#import "ZSStarLoanPageController.h"
#import "ZSApplyForOnlinePageController.h"
#import "ZSTheMediationViewController.h"
#import "ZSSLPersonalListCell.h"
#import "ZSWSPersonListAddViewCell.h"
#import "ZSSLPersonListFooterView.h"

@interface ZSSLPersonListViewController ()<ZSSLPersonListFooterViewDelegate,ZSAlertViewDelegate,ZSSLPersonalListCellDelegate>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSMutableArray *arrayAdd;
@property (nonatomic,assign)NSInteger      count;
@property (nonatomic,strong)BizCustomers   *nexchangeCustomer;
@end

@implementation ZSSLPersonListViewController

- (NSMutableArray *)arrayData
{
    if (_arrayData == nil) {
        _arrayData = [[NSMutableArray alloc]init];
    }
    return _arrayData;
}

- (NSMutableArray *)arrayAdd
{
    if (_arrayAdd == nil) {
        _arrayAdd = [[NSMutableArray alloc]init];
    }
    return _arrayAdd;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];//返回
    self.glt_scrollView = self.tableView;
    [self reSetBottomBtnFrameByFormType];//根据来源展示UI
    //Data
    //刷新详情数据通知(未提交订单)
    [NOTI_CENTER addObserver:self selector:@selector(requestOrdertailForNoCommitData) name:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
    //刷新详情数据通知(已提交订单)
    [NOTI_CENTER addObserver:self selector:@selector(initDatas) name:kOrderDetailFreshDataNotification object:nil];
    
}

#pragma mark /*-----------------------返回事件-----------------------*/
#pragma mark 订单操作后返回
- (void)goBackAntion
{
    NSArray *array = self.navigationController.viewControllers;
    //第二个页面是抵押贷订单列表页
    if ([array[1] isKindOfClass:[ZSStarLoanPageController class]]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    //第二个页面是微信申请订单列表
    else if ([array[1] isKindOfClass:[ZSApplyForOnlinePageController class]]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    //第二个页面是中介端跟进订单列表
    else if ([array[1] isKindOfClass:[ZSTheMediationViewController class]]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else
    {
        //首页
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
}

#pragma mark 返回事件
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.isFromCreatOrder)
    {
        [self leftAction];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)leftAction
{
    if (self.isFromCreatOrder)
    {
        NSArray *array = self.navigationController.viewControllers;
        //第二个页面是金融产品订单列表页
        if ([array[1] isKindOfClass:[ZSStarLoanPageController class]]){
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        //第二个页面是微信申请订单列表
        else if ([array[1] isKindOfClass:[ZSApplyForOnlinePageController class]]){
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        //第二个页面是中介端跟进订单列表
        else if ([array[1] isKindOfClass:[ZSTheMediationViewController class]]){
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        else {
            //首页
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
    }
    else
    {
        //全局修改值
        if (self.lastVCPrdType) {
            self.prdType = self.lastVCPrdType;
        }
        //返回到上一页
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark /*-----------------------订单详情下拉刷新用-----------------------*/
- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestOrderDetail];
    }];
    if (weakSelf.count > 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    weakSelf.count = 1;
}

#pragma mark 获取订单详情接口
- (void)requestOrderDetail
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameter = @{
                                       @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getSpdQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
            //赋值
            global.slOrderDetails = [ZSSLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //刷新tableview
            [weakSelf initDatas];
        } ErrorBlock:^(NSError *error) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
        }];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getRedeemFloorQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
            //赋值
            global.rfOrderDetails = [ZSRFOrderDetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //刷新tableview
            [weakSelf initDatas];
        } ErrorBlock:^(NSError *error) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
            [LSProgressHUD hide];
        }];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getMortgageLoanQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
            //赋值
            global.mlOrderDetails = [ZSMLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //刷新tableview
            [weakSelf initDatas];
        } ErrorBlock:^(NSError *error) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
        }];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getEasyLoanQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
            //赋值
            global.elOrderDetails = [ZSELOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //刷新tableview
            [weakSelf initDatas];
        } ErrorBlock:^(NSError *error) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
        }];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getCarHireQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
            //赋值
            global.chOrderDetails = [ZSCHOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //刷新tableview
            [weakSelf initDatas];
        } ErrorBlock:^(NSError *error) {
            [weakSelf requestFail:weakSelf.tableView array:nil];
        }];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getAngencyBusinessQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
            //赋值
            global.abOrderDetails = [ZSABOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //刷新tableview
            [weakSelf initDatas];
        } ErrorBlock:^(NSError *error) {
            [weakSelf requestFail:weakSelf.tableView array:nil];
        }];
    }
}

#pragma mark /*-----------------------接口请求-----------------------*/
#pragma mark 删除订单接口
- (void)requestForCloseOrderData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                           @"prdType":self.prdType
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getDeleteOrderOfNoSubmitURL] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //提示
        [ZSTool showMessage:@"删除成功" withDuration:DefaultDuration];
        [weakSelf goBackAntion]; //返回
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 获取暂存订单详情
- (void)requestOrdertailForNoCommitData
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showWithMessage:@"加载中"];
    NSMutableDictionary *parameter = @{
                                           @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                           }.mutableCopy;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getSpdQueryOrderDetailForZCURL] SuccessBlock:^(NSDictionary *dic) {
            [LSProgressHUD hide];
            global.slOrderDetails = [ZSSLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            [weakSelf createOperateBtns];
            [weakSelf.view_progress setImgViewWithProduct:self.prdType withIndex:ZSCreatOrderStyleCustomer];
            weakSelf.title = NSStringFormat(@"%@-%@",[global.slOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
            [weakSelf initDatas];
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getRedeemFloorQueryOrderDetailForZCURL] SuccessBlock:^(NSDictionary *dic) {
            [LSProgressHUD hide];
            global.rfOrderDetails = [ZSRFOrderDetailsModel yy_modelWithDictionary:dic[@"respData"]];
            [weakSelf createOperateBtns];
            [weakSelf.view_progress setImgViewWithProduct:self.prdType withIndex:ZSCreatOrderStyleCustomer];
            weakSelf.title = NSStringFormat(@"%@-%@",[global.rfOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
            [weakSelf initDatas];
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getMortgageLoanQueryOrderDetailForZCURL] SuccessBlock:^(NSDictionary *dic) {
            [LSProgressHUD hide];
            global.mlOrderDetails = [ZSMLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            [weakSelf.view_progress setImgViewWithProduct:self.prdType withIndex:ZSCreatOrderStyleCustomer];
            weakSelf.title = NSStringFormat(@"%@-%@",[global.mlOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
            [weakSelf createOperateBtns];
            [weakSelf initDatas];//填充数据
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getEasyLoanQueryOrderDetailForZCURL] SuccessBlock:^(NSDictionary *dic) {
            [LSProgressHUD hide];
            global.elOrderDetails = [ZSELOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            [weakSelf.view_progress setImgViewWithProduct:self.prdType withIndex:ZSCreatOrderStyleCustomer];
            weakSelf.title = NSStringFormat(@"%@-%@",[global.elOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
            [weakSelf createOperateBtns];
            [weakSelf initDatas];//填充数据
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getCarHireQueryOrderDetailForZCURL] SuccessBlock:^(NSDictionary *dic) {
            [LSProgressHUD hide];
            global.chOrderDetails = [ZSCHOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            [weakSelf.view_progress setImgViewWithProduct:self.prdType withIndex:ZSCreatOrderStyleCustomer];
            weakSelf.title = NSStringFormat(@"%@-%@",[global.chOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
            [weakSelf createOperateBtns];
            [weakSelf initDatas];//填充数据
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getAngencyBusinessQueryOrderDetailForZCURL] SuccessBlock:^(NSDictionary *dic) {
            [LSProgressHUD hide];
            global.abOrderDetails = [ZSABOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            [weakSelf.view_progress setImgViewWithProduct:self.prdType withIndex:ZSCreatOrderStyleCustomer];
            weakSelf.title = NSStringFormat(@"%@-%@",[global.abOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
            [weakSelf createOperateBtns];
            [weakSelf initDatas];//填充数据
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
}

#pragma mark 角色互换请求
- (void)exchangeRole
{
    //获取当前点击cell的index
    NSInteger index = 0;
    for (int i = 0; i < self.arrayData.count; i++) {
        BizCustomers *cust = self.arrayData[i];
        if ([cust isEqual:self.nexchangeCustomer]) {
            index = i;
        }
    }
    
    NSString *custId1;
    NSString *custId2;
    NSString *relation1;
    NSString *relation2;
    //根据showDown和showUp判断是主角色还是配偶
    if (self.nexchangeCustomer.showDown == YES)
    {
        BizCustomers *nextCutomerModel = self.arrayData[index+1];
        custId1 = self.nexchangeCustomer.tid;
        relation1 = self.nexchangeCustomer.releation;
        custId2 = nextCutomerModel.tid;
        relation2 = nextCutomerModel.releation;
    }
    else
    {
        BizCustomers *nextCutomerModel = self.arrayData[index-1];
        custId1 = self.nexchangeCustomer.tid;
        relation1 = self.nexchangeCustomer.releation;
        custId2 = nextCutomerModel.tid;
        relation2 = nextCutomerModel.releation;
    }
    
    //角色互换接口
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameter = @{
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"prdType":self.prdType,
                                       @"custId1":custId1,
                                       @"relation1":relation1,
                                       @"custId2":custId2,
                                       @"relation2":relation2
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getExchangeRelationURL] SuccessBlock:^(NSDictionary *dic) {
        //重新请求订单详情
        if ([weakSelf.orderState isEqualToString:@"暂存"])
        {
            [weakSelf requestOrdertailForNoCommitData];//获取暂存状态下的订单详情数据
        }
        else
        {
            //            [weakSelf requestOrderDetail];
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];//获取普通的订单详情
        }
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 角色互换 ZSSLPersonalListCellDelegate
- (void)changeRole:(BizCustomers *)cutomerModel
{
    //存值
    self.nexchangeCustomer = cutomerModel;
    NSString *noticeString;
    if (cutomerModel.releation.intValue == 1 || cutomerModel.releation.intValue == 2) {
        noticeString = @"是否确认交换贷款人和配偶的身份?";
    }
    else if (cutomerModel.releation.intValue == 5 || cutomerModel.releation.intValue == 6) {
        noticeString = @"是否确认交换担保人和配偶的身份?";
    }
    else if (cutomerModel.releation.intValue == 7 || cutomerModel.releation.intValue == 8) {
        noticeString = @"是否确认交换卖方和配偶的身份?";
    }
    else if (cutomerModel.releation.intValue == 9 || cutomerModel.releation.intValue == 10) {
        noticeString = @"是否确认交换买方和配偶的身份?";
    }
    
    //弹窗
    ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:noticeString];
    alertView.delegate = self;
    alertView.tag = 1000;
    [alertView show];
}

- (void)AlertView:(ZSAlertView *)alert;//确认按钮响应的方法
{
    //删除订单
    if (alert.tag == 1001)
    {
        [self requestForCloseOrderData];
    }
    //更换角色
    else if (alert.tag == 1000)
    {
        [self exchangeRole];
    }
}

#pragma mark /*-----------------------UI按钮显示等-----------------------*/
- (void)reSetBottomBtnFrameByFormType
{
    //来自创建订单则展示顶部视图，否则不展示
    if ([self.orderState isEqualToString:@"暂存"])
    {
        //1.暂存订单
        self.title = @"创建订单";
        self.view_top.hidden = NO;
        if (self.orderIDString) { //是否来自订单列表（只有订单列表传过来订单号）
            [self requestOrdertailForNoCommitData];//获取暂存状态下的订单详情数据
        }else {
            //1.2判断顶部图片展示（从详情接口里面拿数据）
            [self.view_progress setImgViewWithProduct:self.prdType withIndex:ZSCreatOrderStyleCustomer];
        }
    }
    else
    {
        //2.来自详情
        self.view_top.hidden = YES;
        [self addHeader];
    }
}

#pragma mark 根据是否是订单创建人显示操作按钮
- (void)createOperateBtns
{
    //只有订单创建人才能操作订单
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        if ([global.slOrderDetails.isOrder isEqualToString:@"1"] && [global.slOrderDetails.spdOrder.orderState isEqualToString:@"暂存"]) {
            [self configureRightNavItemWithTitle:nil withNormalImg:@"head_more_n" withHilightedImg:nil];//右侧按钮
            [self configuBottomButtonWithTitle:@"下一步"];//底部按钮
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if ([global.rfOrderDetails.isOrder isEqualToString:@"1"] && [global.rfOrderDetails.redeemOrder.orderState isEqualToString:@"暂存"]) {
            [self configureRightNavItemWithTitle:nil withNormalImg:@"head_more_n" withHilightedImg:nil];//右侧按钮
            [self configuBottomButtonWithTitle:@"下一步"];//底部按钮
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        if ([global.mlOrderDetails.isOrder isEqualToString:@"1"] && [global.mlOrderDetails.dydOrder.orderState isEqualToString:@"暂存"]) {
            [self configureRightNavItemWithTitle:nil withNormalImg:@"head_more_n" withHilightedImg:nil];//右侧按钮
            [self configuBottomButtonWithTitle:@"下一步"];//底部按钮
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        if ([global.elOrderDetails.isOrder isEqualToString:@"1"] && [global.elOrderDetails.easyOrder.orderState isEqualToString:@"暂存"]) {
            [self configureRightNavItemWithTitle:nil withNormalImg:@"head_more_n" withHilightedImg:nil];//右侧按钮
            [self configuBottomButtonWithTitle:@"下一步"];//底部按钮
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        if ([global.chOrderDetails.isOrder isEqualToString:@"1"] && [global.chOrderDetails.cwfqOrder.orderState isEqualToString:@"暂存"]) {
            [self configureRightNavItemWithTitle:nil withNormalImg:@"head_more_n" withHilightedImg:nil];//右侧按钮
            [self configuBottomButtonWithTitle:@"下一步"];//底部按钮
        }
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        if ([global.abOrderDetails.isOrder isEqualToString:@"1"] && [global.abOrderDetails.insteadOrder.orderState isEqualToString:@"暂存"]) {
            [self configureRightNavItemWithTitle:nil withNormalImg:@"head_more_n" withHilightedImg:nil];//右侧按钮
            [self configuBottomButtonWithTitle:@"下一步"];//底部按钮
        }
    }
}

#pragma mark 底部按钮的点击事件
- (void)bottomClick:(UIButton *)sender
{
    //星速贷和代办业务
    if ([self.prdType isEqualToString:kProduceTypeStarLoan] || [self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        ZSSLAddLoanMaterialViewController *vc = [[ZSSLAddLoanMaterialViewController alloc]init];
        vc.orderState = @"暂存";
        vc.prdType = self.prdType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        ZSRFAddLoanMaterialViewController *vc = [[ZSRFAddLoanMaterialViewController alloc]init];
        vc.orderState = @"暂存";
        vc.prdType = self.prdType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        ZSMLAddLoanMaterialViewController *vc = [[ZSMLAddLoanMaterialViewController alloc]init];
        vc.orderState = @"暂存";
        vc.prdType = self.prdType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        ZSELAddLoanMaterialViewController *vc = [[ZSELAddLoanMaterialViewController alloc]init];
        vc.orderState = @"暂存";
        vc.prdType = self.prdType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        ZSCHAddLoanMaterialViewController *vc = [[ZSCHAddLoanMaterialViewController alloc]init];
        vc.orderState = @"暂存";
        vc.prdType = self.prdType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark /*-----------------------tableView-----------------------*/
#pragma mark 刷新数据
- (void)initDatas
{
    [self.arrayData removeAllObjects];
    [self.arrayAdd removeAllObjects];
    [self dataFill];
    [self resetTableViewHeight];
    [self.tableView reloadData];
}

#pragma mark 填充数据
- (void)dataFill
{
    //1.往人员列表添加是否查询大数据风控的字段
    BOOL isPermissions = NO;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        for (int i = 0; i < global.slOrderDetails.bizCustomers.count; i++) {
            BizCustomers *info = global.slOrderDetails.bizCustomers[i];
            info.isCredit = global.slOrderDetails.isCredit;
            [self.arrayData addObject:info];
        }
        isPermissions = [ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && [global.slOrderDetails.isOrder isEqualToString:@"1"] ? YES : NO;
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        for (int i = 0; i < global.rfOrderDetails.bizCustomers.count; i++) {
            BizCustomers *info = global.rfOrderDetails.bizCustomers[i];
            info.isCredit = global.rfOrderDetails.isCredit;
            [self.arrayData addObject:info];
        }
        isPermissions = [ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && [global.rfOrderDetails.isOrder isEqualToString:@"1"] ? YES : NO;
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        for (int i = 0; i < global.mlOrderDetails.bizCustomers.count; i++) {
            BizCustomers *info = global.mlOrderDetails.bizCustomers[i];
            info.isCredit = global.mlOrderDetails.isCredit;
            [self.arrayData addObject:info];
        }
        isPermissions = [ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && [global.mlOrderDetails.isOrder isEqualToString:@"1"] ? YES : NO;
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        for (int i = 0; i < global.elOrderDetails.bizCustomers.count; i++) {
            BizCustomers *info = global.elOrderDetails.bizCustomers[i];
            info.isCredit = global.elOrderDetails.isCredit;
            [self.arrayData addObject:info];
        }
        isPermissions = [ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && [global.elOrderDetails.isOrder isEqualToString:@"1"] ? YES : NO;
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        for (int i = 0; i < global.chOrderDetails.bizCustomers.count; i++) {
            BizCustomers *info = global.chOrderDetails.bizCustomers[i];
            info.isCredit = global.chOrderDetails.isCredit;
            [self.arrayData addObject:info];
        }
        isPermissions = [ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && [global.chOrderDetails.isOrder isEqualToString:@"1"] ? YES : NO;
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        for (int i = 0; i < global.abOrderDetails.bizCustomers.count; i++) {
            BizCustomers *info = global.abOrderDetails.bizCustomers[i];
            info.isCredit = global.abOrderDetails.isCredit;
            [self.arrayData addObject:info];
        }
        isPermissions = [ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && [global.abOrderDetails.isOrder isEqualToString:@"1"] ? YES : NO;
    }
    
    //2.往人员列表添加本地数据,用于夫妻俩角色互换
    if (isPermissions == YES)
    {
        [self changeRoleWithArray:self.arrayData];
    }
    
    //3.添加假数据
    [self falseDataFill];
}

//人员角色 1贷款人 2贷款人配偶 3配偶&共有人 4共有人 5担保人 6担保人配偶 7卖方 8卖方配偶 9买方 10买方配偶
- (void)changeRoleWithArray:(NSArray *)personListArray
{
    for (int i = 0; i < personListArray.count; i++)
    {
        BizCustomers *customer = personListArray[i];
        if (customer.releation.intValue == 1 ||
            customer.releation.intValue == 5 ||
            customer.releation.intValue == 7 ||
            customer.releation.intValue == 9 )
        {
            //1.判断婚姻状况是否是已婚
            if (customer.beMarrage.intValue == 2)
            {
                //2.判断列表中有没有对应的配偶
                if (customer.releation.intValue == 1)
                {
                    [personListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        BizCustomers *mateCustomer = personListArray[idx];
                        if (mateCustomer.releation.intValue == 2) {
                            customer.showDown = YES;
                            customer.showUp = NO;
                            [self.arrayData replaceObjectAtIndex:i withObject:customer];
                        }
                    }];
                }
                else if (customer.releation.intValue == 5)
                {
                    [personListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        BizCustomers *mateCustomer = personListArray[idx];
                        if (mateCustomer.releation.intValue == 6) {
                            customer.showDown = YES;
                            customer.showUp = NO;
                            [self.arrayData replaceObjectAtIndex:i withObject:customer];
                        }
                    }];
                }
                else if (customer.releation.intValue == 7)
                {
                    [personListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        BizCustomers *mateCustomer = personListArray[idx];
                        if (mateCustomer.releation.intValue == 8) {
                            customer.showDown = YES;
                            customer.showUp = NO;
                            [self.arrayData replaceObjectAtIndex:i withObject:customer];
                        }
                    }];
                }
                else if (customer.releation.intValue == 9)
                {
                    [personListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        BizCustomers *mateCustomer = personListArray[idx];
                        if (mateCustomer.releation.intValue == 10) {
                            customer.showDown = YES;
                            customer.showUp = NO;
                            [self.arrayData replaceObjectAtIndex:i withObject:customer];
                        }
                    }];
                }
            }
        }
        else if (customer.releation.intValue == 2 ||
                 customer.releation.intValue == 6 ||
                 customer.releation.intValue == 8 ||
                 customer.releation.intValue == 10)
        {
            customer.showUp = YES;
            customer.showDown = NO;
            [self.arrayData replaceObjectAtIndex:i withObject:customer];
        }
    }
}

//先遍历已有角色和主贷人婚姻状况判断,填充相应的假数据  //角色信息 1贷款人 2贷款人配偶 4共有人 7卖方 8卖方配偶
- (void)falseDataFill
{
    //星速贷和代办业务
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        [self.arrayAdd addObject:@"贷款人配偶"];
        [self.arrayAdd addObject:@"共有人"];
        [self.arrayAdd addObject:@"卖方"];
        //顺序遍历
        [global.slOrderDetails.bizCustomers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BizCustomers *info = global.slOrderDetails.bizCustomers[idx];
            if (info.releation.intValue == 1) {
                if (info.beMarrage.intValue != 2) {
                    [self.arrayAdd removeObject:@"贷款人配偶"];
                }
            }
            else if (info.releation.intValue == 2) {
                [self.arrayAdd removeObject:@"贷款人配偶"];
            }
            else if (info.releation.intValue == 4) {
                [self.arrayAdd removeObject:@"共有人"];
            }
            else if (info.releation.intValue == 7) {
                [self.arrayAdd removeObject:@"卖方"];
                if (info.beMarrage.intValue == 2) {
                    if (![self.arrayAdd containsObject:@"卖方配偶"]) {
                        [self.arrayAdd addObject:@"卖方配偶"];
                    }
                }
            }
            else if (info.releation.intValue == 8) {
                [self.arrayAdd removeObject:@"卖方配偶"];
            }
        }];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        [self.arrayAdd addObject:@"贷款人配偶"];
        [self.arrayAdd addObject:@"买方"];
        //顺序遍历
        [global.rfOrderDetails.bizCustomers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BizCustomers *info = global.rfOrderDetails.bizCustomers[idx];
            if (info.releation.intValue == 1) {
                if (info.beMarrage.intValue != 2) {
                    [self.arrayAdd removeObject:@"贷款人配偶"];
                }
            }
            else if (info.releation.intValue == 2) {
                [self.arrayAdd removeObject:@"贷款人配偶"];
            }
            else if (info.releation.intValue == 9) {
                [self.arrayAdd removeObject:@"买方"];
                if (info.beMarrage.intValue == 2) {
                    if (![self.arrayAdd containsObject:@"买方配偶"]) {
                        [self.arrayAdd addObject:@"买方配偶"];
                    }
                }
            }
            else if (info.releation.intValue == 10) {
                [self.arrayAdd removeObject:@"买方配偶"];
            }
        }];
    }
    //抵押贷和融易贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan] || [self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        [self.arrayAdd addObject:@"贷款人配偶"];
        [self.arrayAdd addObject:@"担保人"];
        //顺序遍历
        [global.mlOrderDetails.bizCustomers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BizCustomers *info = global.mlOrderDetails.bizCustomers[idx];
            if (info.releation.intValue == 1) {
                if (info.beMarrage.intValue != 2) {
                    [self.arrayAdd removeObject:@"贷款人配偶"];
                }
            }
            else if (info.releation.intValue == 2) {
                [self.arrayAdd removeObject:@"贷款人配偶"];
            }
            else if (info.releation.intValue == 5) {
                [self.arrayAdd removeObject:@"担保人"];
                if (info.beMarrage.intValue == 2) {
                    if (![self.arrayAdd containsObject:@"担保人配偶"]) {
                        [self.arrayAdd addObject:@"担保人配偶"];
                    }
                }
            }
            else if (info.releation.intValue == 6) {
                [self.arrayAdd removeObject:@"担保人配偶"];
            }
        }];
    }
    //车位分期
    else if ( [self.prdType isEqualToString:kProduceTypeCarHire])
    {
        [self.arrayAdd addObject:@"贷款人配偶"];
        //顺序遍历
        [global.rfOrderDetails.bizCustomers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BizCustomers *info = global.rfOrderDetails.bizCustomers[idx];
            if (info.releation.intValue == 1) {
                if (info.beMarrage.intValue != 2) {
                    [self.arrayAdd removeObject:@"贷款人配偶"];
                }
            }
            else if (info.releation.intValue == 2) {
                [self.arrayAdd removeObject:@"贷款人配偶"];
            }
        }];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        [self.arrayAdd addObject:@"贷款人配偶"];
        [self.arrayAdd addObject:@"共有人"];
        [self.arrayAdd addObject:@"卖方"];
        //顺序遍历
        [global.abOrderDetails.bizCustomers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BizCustomers *info = global.abOrderDetails.bizCustomers[idx];
            if (info.releation.intValue == 1) {
                if (info.beMarrage.intValue != 2) {
                    [self.arrayAdd removeObject:@"贷款人配偶"];
                }
            }
            else if (info.releation.intValue == 2) {
                [self.arrayAdd removeObject:@"贷款人配偶"];
            }
            else if (info.releation.intValue == 4) {
                [self.arrayAdd removeObject:@"共有人"];
            }
            else if (info.releation.intValue == 7) {
                [self.arrayAdd removeObject:@"卖方"];
                if (info.beMarrage.intValue == 2) {
                    if (![self.arrayAdd containsObject:@"卖方配偶"]) {
                        [self.arrayAdd addObject:@"卖方配偶"];
                    }
                }
            }
            else if (info.releation.intValue == 8) {
                [self.arrayAdd removeObject:@"卖方配偶"];
            }
        }];
    }
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return KZSSLPersonalListCellHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *sourceString;
    NSString *nameString;
    NSString *phoneString;
    SpdOrder *model;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        model = global.slOrderDetails.spdOrder;
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        model = global.rfOrderDetails.redeemOrder;
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        model = global.mlOrderDetails.dydOrder;
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        model = global.elOrderDetails.easyOrder;
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        model = global.chOrderDetails.cwfqOrder;
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        model = global.abOrderDetails.insteadOrder;
    }
    sourceString = model.dataSrc ? [NSString stringWithFormat:@"%ld",(long)model.dataSrc] : @"";
    nameString = model.agencyContact ? model.agencyContact : @"";
    phoneString = model.agencyContactPhone ? model.agencyContactPhone : @"";

    ZSSLPersonListFooterView *footerView = [[ZSSLPersonListFooterView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 80) withMOrderSource:sourceString withAgencyContact:nameString withAgencyContactPhone:phoneString];
    footerView.delegate = self;
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //只有订单创建人才能添加人员
            if (global.slOrderDetails.isOrder.intValue == 1) {
                return self.arrayData.count + self.arrayAdd.count;
            }else{
                return self.arrayData.count;
            }
        }else{
            return self.arrayData.count;//已关闭和已完成的订单不允许添加
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //只有订单创建人才能添加人员
            if (global.rfOrderDetails.isOrder.intValue == 1) {
                return self.arrayData.count + self.arrayAdd.count;
            }else{
                return self.arrayData.count;
            }
        }else{
            return self.arrayData.count;//已关闭和已完成的订单不允许添加
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //只有订单创建人才能添加人员
            if (global.mlOrderDetails.isOrder.intValue == 1) {
                return self.arrayData.count + self.arrayAdd.count;
            }else{
                return self.arrayData.count;
            }
        }else{
            return self.arrayData.count;//已关闭和已完成的订单不允许添加
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //只有订单创建人才能添加人员
            if (global.elOrderDetails.isOrder.intValue == 1) {
                return self.arrayData.count + self.arrayAdd.count;
            }else{
                return self.arrayData.count;
            }
        }else{
            return self.arrayData.count;//已关闭和已完成的订单不允许添加
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //只有订单创建人才能添加人员
            if (global.chOrderDetails.isOrder.intValue == 1) {
                return self.arrayData.count + self.arrayAdd.count;
            }else{
                return self.arrayData.count;
            }
        }else{
            return self.arrayData.count;//已关闭和已完成的订单不允许添加
        }
    }
    //代办业务
    else
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //只有订单创建人才能添加人员
            if (global.abOrderDetails.isOrder.intValue == 1) {
                return self.arrayData.count + self.arrayAdd.count;
            }else{
                return self.arrayData.count;
            }
        }else{
            return self.arrayData.count;//已关闭和已完成的订单不允许添加
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row < self.arrayData.count) {
        ZSSLPersonalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
        if (cell == nil) {
            cell = [[ZSSLPersonalListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
            cell.delegate = self;
        }
        if (self.arrayData.count > 0) {
            cell.detailModel = self.arrayData[indexPath.row];
        }
        return cell;
    }
    else
    {
        ZSWSPersonListAddViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify1"];
        if (cell == nil) {
            cell = [[ZSWSPersonListAddViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.arrayAdd.count > 0) {
            cell.label_role.text = self.arrayAdd[indexPath.row-self.arrayData.count];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row < self.arrayData.count)
    {
        BizCustomers *customerInfo = self.arrayData[indexPath.row];
        global.bizCustomers = customerInfo;
        [self eitorPersonalInfoWithRoleName:[NSString stringWithFormat:@"%@信息",[ZSGlobalModel getReleationStateWithCode:customerInfo.releation]]];
    }
    else
    {
        NSString *string = self.arrayAdd[indexPath.row-self.arrayData.count];
        [self addPersonalInfoWithRoleName:[NSString stringWithFormat:@"%@信息",string]];
    }
}

#pragma mark 编辑人员信息
- (void)eitorPersonalInfoWithRoleName:(NSString *)roleName
{
    //如果是订单创建人, 并且订单状态为暂存, 则直接进入编辑页面, 其余的都进人员详情页面
    if ([self checkOrderState])
    {
        ZSBaseAddCustomerViewController *addVC = [[ZSBaseAddCustomerViewController alloc]init];
        addVC.title = roleName;
        addVC.isFromEditor = YES;
        addVC.orderIDString = self.orderIDString;//订单id
        addVC.prdType = self.prdType;
        [self.navigationController pushViewController:addVC animated:YES];
    }
    else
    {
        ZSSLPersonDetailViewController *personVC = [[ZSSLPersonDetailViewController alloc]init];
        personVC.title = roleName;
        personVC.personIDString = global.bizCustomers.tid;//人员id
        personVC.orderIDString = self.orderIDString;//订单id
        personVC.prdType = self.prdType;
        [self.navigationController pushViewController:personVC animated:YES];
    }
}

#pragma mark 新增人员信息
- (void)addPersonalInfoWithRoleName:(NSString *)roleName
{
    global.bizCustomers = nil;//清空人员信息
    ZSBaseAddCustomerViewController *addVC = [[ZSBaseAddCustomerViewController alloc]init];
    addVC.title = roleName;
    addVC.isFromAdd = YES;
    addVC.orderIDString = self.orderIDString;//订单id
    addVC.prdType = self.prdType;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark ZSSLPersonListFooterViewDelegate 修改客户来源
- (void)goToChangeAgency//如果是中介信息/线下客户可以进行修改
{
    //已关闭的订单不能操作
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType])
    {
        ZSChangeCustomerSourceViewController *mediumMessageVC = [[ZSChangeCustomerSourceViewController alloc]init];
        mediumMessageVC.orderIDString = self.orderIDString;
        mediumMessageVC.prdType = self.prdType;
        [self.navigationController pushViewController:mediumMessageVC animated:YES];
    }
}

//如果是订单创建人, 并且订单状态为暂存, 则直接进入编辑页面, 其余的都进人员详情页面
- (BOOL)checkOrderState
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan]) {
        if ([global.slOrderDetails.isOrder isEqualToString:@"1"] && [global.slOrderDetails.spdOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor]) {
        if ([global.rfOrderDetails.isOrder isEqualToString:@"1"] && [global.rfOrderDetails.redeemOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan]) {
        if ([global.mlOrderDetails.isOrder isEqualToString:@"1"] && [global.mlOrderDetails.dydOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        if ([global.elOrderDetails.isOrder isEqualToString:@"1"] && [global.elOrderDetails.easyOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire]) {
        if ([global.chOrderDetails.isOrder isEqualToString:@"1"] && [global.chOrderDetails.cwfqOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
        }
    }
    //代办业务
    else
    {
        if ([global.abOrderDetails.isOrder isEqualToString:@"1"] && [global.abOrderDetails.insteadOrder.orderState isEqualToString:@"暂存"])
        {
            return YES;
        }
        else{
            return NO;
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
