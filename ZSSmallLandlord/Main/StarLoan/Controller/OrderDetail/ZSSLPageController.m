//
//  ZSSLPageController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLPageController.h"
#import "ZSSLMaterialCollectViewController.h"
#import "ZSSLOrderScheduleViewController.h"
#import "ZSStarLoanPageController.h"
#import "ZSApplyForOnlinePageController.h"
#import "ZSSLPersonListViewController.h"
#import "ZSSLLoanAmountViewController.h"
#import "ZSTheMediationViewController.h"
#import "ZSApprovalOpinionPopView.h"
#import "ZSSLOrderRejectNodeModel.h"
#import "ZSAddRemarkPopView.h"
#import "ZSCloseOrderPopView.h"

@interface ZSSLPageController ()<ZSApprovalOpinionPopViewDelegate,ZSAddRemarkPopViewDelegate,ZSCloseOrderPopViewDelegate>
@property(nonatomic,assign)BOOL           isAccept;//审批意见 通过/驳回
@property(nonatomic,strong)NSMutableArray *rejectArray;//审批驳回节点
@end

@implementation ZSSLPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self addGesture];
    [self configureErrorViewWithStyle:ZSErrorWithoutDelete];//银行后勤首页列表无订单
    //Data
    //获取订单详情
    [self requestOrderDetail];
    //获取驳回节点列表
    [self requestForrejectNameData];
    //请求详情接口通知
    [NOTI_CENTER addObserver:self selector:@selector(requestOrderDetail) name:KSUpdateAllOrderDetailNotification object:nil];
}

#pragma mark /*---------------------------------初始化的控制器---------------------------------*/
- (NSArray *)setupViewControllers
{
    NSMutableArray *testVCS = [NSMutableArray arrayWithCapacity:0];
   
    //人员信息
    ZSSLPersonListViewController *personVC = [[ZSSLPersonListViewController alloc] init];
    personVC.isFromCreatOrder = self.isFromCreatOrder;
    personVC.prdType = self.prdType;
    [testVCS addObject:personVC];
 
    //贷款信息
    ZSSLLoanAmountViewController *loanVC = [[ZSSLLoanAmountViewController alloc] init];
    loanVC.prdType = self.prdType;
    [testVCS addObject:loanVC];
 
    //资料列表
    ZSSLMaterialCollectViewController *collectVC = [[ZSSLMaterialCollectViewController alloc]init];
    collectVC.orderIDString = self.orderIDString;
    collectVC.prdType = self.prdType;
    [testVCS addObject:collectVC];
   
    //订单进度
    ZSSLOrderScheduleViewController *scheduleVC = [[ZSSLOrderScheduleViewController alloc] init];
    scheduleVC.orderIDString = self.orderIDString;
    scheduleVC.prdType = self.prdType;
    [testVCS addObject:scheduleVC];
    
    return testVCS.copy;
}

#pragma mark /*---------------------------------返回事件---------------------------------*/
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
        //返回到上一页
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark /*---------------------------------长按navBarTitle事件---------------------------------*/
- (void)addGesture
{
    UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
    longPressGest.minimumPressDuration = 1;
    longPressGest.allowableMovement = 30;//长按时候,手指头可以移动的距离
    [self.navigationController.navigationBar addGestureRecognizer:longPressGest];
}

- (void)longPressView:(UILongPressGestureRecognizer *)longPressGest
{
    if (longPressGest.state == UIGestureRecognizerStateBegan)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        //星速贷
        if ([self.prdType isEqualToString:kProduceTypeStarLoan])
        {
            pasteboard.string = global.slOrderDetails.spdOrder.orderNo;
        }
        //赎楼宝
        else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
        {
            pasteboard.string = global.rfOrderDetails.redeemOrder.orderNo;
        }
        //抵押贷
        else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
        {
            pasteboard.string = global.mlOrderDetails.dydOrder.orderNo;
        }
        //融易贷
        else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
        {
            pasteboard.string = global.elOrderDetails.easyOrder.orderNo;
        }
        //车位分期
        else if ([self.prdType isEqualToString:kProduceTypeCarHire])
        {
            pasteboard.string = global.chOrderDetails.cwfqOrder.orderNo;
        }
        //代办业务
        else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
        {
            pasteboard.string = global.abOrderDetails.insteadOrder.orderNo;
        }
        [ZSTool showMessage:@"订单编号已复制到剪贴板" withDuration:DefaultDuration];
    }
}

#pragma mark /*--------------------------------接口-------------------------------------------*/
#pragma mark 获取订单详情接口
- (void)requestOrderDetail
{
    //1.详情接口
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameter=  @{@"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],}.mutableCopy;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getSpdQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            //赋值
            global.slOrderDetails = [ZSSLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //缺省页
            if (global.slOrderDetails.spdOrder.state != 1 ) {
                weakSelf.errorView.hidden = NO;
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
                view.backgroundColor = ZSViewBackgroundColor;
                [weakSelf.view insertSubview:view belowSubview:weakSelf.errorView];
                weakSelf.title = @"订单详情";
            }else{
                weakSelf.errorView.hidden = YES;
                //顶部订单信息
                [weakSelf initTitleMenuItems];
                //标题
                weakSelf.title = NSStringFormat(@"%@-%@",[global.slOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
                //判断右侧按钮是否可以展示
                [weakSelf checkRightBtnShow];
                //判断底部按钮是否可以展示
                [weakSelf checkBottomBtnShow];
                //通知子控制器刷新数据
                [NOTI_CENTER postNotificationName:kOrderDetailFreshDataNotification object:nil];
            }
        } ErrorBlock:^(NSError *error) {
            [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
        }];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getRedeemFloorQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            //赋值
            global.rfOrderDetails = [ZSRFOrderDetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //缺省页
            if (global.rfOrderDetails.redeemOrder.state != 1 ) {
                weakSelf.errorView.hidden = NO;
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
                view.backgroundColor = ZSViewBackgroundColor;
                [weakSelf.view insertSubview:view belowSubview:weakSelf.errorView];
                weakSelf.title = @"订单详情";
            }else{
                weakSelf.errorView.hidden = YES;
                //顶部订单信息
                [weakSelf initTitleMenuItems];
                //标题
                weakSelf.title = NSStringFormat(@"%@-%@",[global.rfOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
                //判断右侧按钮是否可以展示
                [weakSelf checkRightBtnShow];
                //判断底部按钮是否可以展示
                [weakSelf checkBottomBtnShow];
                //通知子控制器刷新数据
                [NOTI_CENTER postNotificationName:kOrderDetailFreshDataNotification object:nil];
            }
        } ErrorBlock:^(NSError *error) {
            [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
        }];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getMortgageLoanQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            //赋值
            global.mlOrderDetails = [ZSMLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //缺省页
            if (global.mlOrderDetails.dydOrder.state != 1 ) {
                weakSelf.errorView.hidden = NO;
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
                view.backgroundColor = ZSViewBackgroundColor;
                [weakSelf.view insertSubview:view belowSubview:weakSelf.errorView];
                weakSelf.title = @"订单详情";
            }else{
                weakSelf.errorView.hidden = YES;
                //顶部订单信息
                [weakSelf initTitleMenuItems];
                //标题
                weakSelf.title = NSStringFormat(@"%@-%@",[global.mlOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
                //判断右侧按钮是否可以展示
                [weakSelf checkRightBtnShow];
                //判断底部按钮是否可以展示
                [weakSelf checkBottomBtnShow];
                //通知子控制器刷新数据
                [NOTI_CENTER postNotificationName:kOrderDetailFreshDataNotification object:weakSelf];
            }
        } ErrorBlock:^(NSError *error) {
            [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
        }];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getEasyLoanQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            //赋值
            global.elOrderDetails = [ZSELOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //缺省页
            if (global.elOrderDetails.easyOrder.state != 1 ) {
                weakSelf.errorView.hidden = NO;
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
                view.backgroundColor = ZSViewBackgroundColor;
                [weakSelf.view insertSubview:view belowSubview:weakSelf.errorView];
                weakSelf.title = @"订单详情";
            }else{
                weakSelf.errorView.hidden = YES;
                //顶部订单信息
                [weakSelf initTitleMenuItems];
                //标题
                weakSelf.title = NSStringFormat(@"%@-%@",[global.elOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
                //判断右侧按钮是否可以展示
                [weakSelf checkRightBtnShow];
                //判断底部按钮是否可以展示
                [weakSelf checkBottomBtnShow];
                //通知子控制器刷新数据
                [NOTI_CENTER postNotificationName:kOrderDetailFreshDataNotification object:weakSelf];
            }
        } ErrorBlock:^(NSError *error) {
            [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
        }];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getCarHireQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            //赋值
            global.chOrderDetails = [ZSCHOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //缺省页
            if (global.chOrderDetails.cwfqOrder.state != 1 ) {
                weakSelf.errorView.hidden = NO;
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
                view.backgroundColor = ZSViewBackgroundColor;
                [weakSelf.view insertSubview:view belowSubview:weakSelf.errorView];
                weakSelf.title = @"订单详情";
            }else{
                weakSelf.errorView.hidden = YES;
                //顶部订单信息
                [weakSelf initTitleMenuItems];
                //标题
                weakSelf.title = NSStringFormat(@"%@-%@",[global.chOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
                //判断右侧按钮是否可以展示
                [weakSelf checkRightBtnShow];
                //判断底部按钮是否可以展示
                [weakSelf checkBottomBtnShow];
                //通知子控制器刷新数据
                [NOTI_CENTER postNotificationName:kOrderDetailFreshDataNotification object:weakSelf];
            }
        } ErrorBlock:^(NSError *error) {
            [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
        }];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getAngencyBusinessQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            //赋值
            global.abOrderDetails = [ZSABOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //缺省页
            if (global.abOrderDetails.insteadOrder.state != 1 ) {
                weakSelf.errorView.hidden = NO;
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
                view.backgroundColor = ZSViewBackgroundColor;
                [weakSelf.view insertSubview:view belowSubview:weakSelf.errorView];
                weakSelf.title = @"订单详情";
            }else{
                weakSelf.errorView.hidden = YES;
                //顶部订单信息
                [weakSelf initTitleMenuItems];
                //标题
                weakSelf.title = NSStringFormat(@"%@-%@",[global.abOrderDetails.bizCustomers firstObject].name,[ZSGlobalModel getProductStateWithCode:self.prdType]);
                //判断右侧按钮是否可以展示
                [weakSelf checkRightBtnShow];
                //判断底部按钮是否可以展示
                [weakSelf checkBottomBtnShow];
                //通知子控制器刷新数据
                [NOTI_CENTER postNotificationName:kOrderDetailFreshDataNotification object:weakSelf];
            }
        } ErrorBlock:^(NSError *error) {
            [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
        }];
    }
    
    //2.资料接口
    [self requestForMaterialData];
}

#pragma mark 获取资料列表接口
- (void)requestForMaterialData
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"加载中"];
    NSMutableDictionary *parameter=  @{
                                       @"orderno":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"prdType":self.prdType,
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getOrderListOrderMateriaURL] SuccessBlock:^(NSDictionary *dic) {
        //资料model
        //赎楼宝
        if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
        {
            global.rfMaterialCollectModel = [ZSSLMaterialCollectModel yy_modelWithDictionary:dic[@"respData"]];
        }
        else
        {
            global.slMaterialCollectModel = [ZSSLMaterialCollectModel yy_modelWithDictionary:dic[@"respData"]];
        }
        //通知资料列表刷新数据
        [NOTI_CENTER postNotificationName:kOrderDetailFreshMaterialDataNotification object:nil];
        //判断按钮颜色
        [weakSelf checkBottomBtnColor];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 关闭订单接口
- (void)requestForCloseOrderDataWithReasonString:(NSString *)reason withRemark:(NSString *)remark
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameter = @{
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"prdType":self.prdType,
                                       @"reason":reason,
                                       @"remark":remark
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getAllOrderCloseURL] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //详情接口
        [weakSelf requestOrderDetail];
        //提示
//        [ZSTool showMessage:@"关闭成功" withDuration:DefaultDuration];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 撤回订单接口
- (void)requestForWithdrawOrderData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameter = @{
                                       @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"prdType":self.prdType,
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getWithdrawOrderURL] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //通知订单详情刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
        //返回到待提交订单状态
        ZSSLPersonListViewController *vc = [[ZSSLPersonListViewController alloc]init];
        vc.orderState = @"暂存";
        vc.orderIDString = [ZSGlobalModel getOrderID:self.prdType];
        vc.prdType = self.prdType;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        //提示
        [ZSTool showMessage:@"撤回成功" withDuration:DefaultDuration];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 添加订单备注
- (void)sendData:(NSString *)remarkString
{
    NSMutableDictionary *parameter = @{
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"prdType":self.prdType,
                                       @"remark":remarkString
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getAddOrderRemarkURL] SuccessBlock:^(NSDictionary *dic) {
        //通知子控制器刷新数据
        [NOTI_CENTER postNotificationName:kOrderDetailFreshDataNotification object:nil];
        //提示
        [ZSTool showMessage:@"添加备注成功" withDuration:DefaultDuration];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 提交资料接口
- (void)requestForSubmitMaterialData
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"加载中"];
    NSMutableDictionary *parameter = @{
                                       @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"prdType":self.prdType,
                                       @"result":@"1",
                                       @"force":@"1",
                                       @"remark":@"",
                                       @"nodeid":@""
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getAuditOrderURL] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //详情资料列表
        [NOTI_CENTER postNotificationName:kOrderDetailFreshMaterialDataNotification object:nil];
        //详情接口
        [weakSelf requestOrderDetail];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 获取驳回节点列表
- (void)requestForrejectNameData
{
    self.rejectArray = [[NSMutableArray alloc]init];
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary * parameter = @{
                                        @"prdType":self.prdType,
                                        @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                        }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getOrderRejectNodeURL] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSSLOrderRejectNodeModel *model = [ZSSLOrderRejectNodeModel yy_modelWithJSON:dict];
                [weakSelf.rejectArray addObject:model];
            }
        }
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark ZSApprovalOpinionPopViewDelegate 审批订单
- (void)sendAcceptState:(NSString *)isAccept withNodeID:(NSString *)nodeID withRemarkString:(NSString *)remark;
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"加载中"];
    NSMutableDictionary * parameter = @{
                                        @"result":isAccept,
                                        @"prdType":self.prdType,
                                        @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                        @"force":@"1",
                                        @"nodeid":nodeID,
                                        @"remark":remark,
                                        }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getAuditOrderURL] SuccessBlock:^(NSDictionary *dic) {
        //列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //详情通知
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 创建其他产品的订单
- (void)requestCreateOtherProduct:(NSString *)newPrdType
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameter=  @{
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"prdType":self.prdType,
                                       @"newPrdType":newPrdType
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getCopyOrderkURL] SuccessBlock:^(NSDictionary *dic) {
        //刷新当前页面订单详情数据
        [weakSelf requestOrderDetail];
        //返回订单id和产品类型后进入下一个页面重新请求
        ZSSLPersonListViewController *vc = [[ZSSLPersonListViewController alloc]init];
        vc.orderState = @"暂存";
        vc.orderIDString = dic[@"respData"][@"orderId"];
        vc.prdType = dic[@"respData"][@"prdType"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        //通知所有订单列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
    } ErrorBlock:^(NSError *error) {
        [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
    }];
}

#pragma mark /*---------------------------------顶部tab---------------------------------*/
- (void)initTitleMenuItems
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        //图片
        self.myHeaderView.headerImView.image = [UIImage getImageByOrderState:SafeStr(global.slOrderDetails.spdOrder.orderState)];
        //订单当前节点名称
        self.myHeaderView.stateLabel.text = [NSString getStringByOrderState:SafeStr(global.slOrderDetails.curNodeName)];
        //订单创建人显示当前节点处理人, 其余显示订单创建人
        if (global.slOrderDetails.isOrder.intValue == 1)
        {
            SpdOrderStates *model = global.slOrderDetails.spdOrderStates[0];
            if ([self showName:model].length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"当前处理人:%@",[self showName:model]];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系处理人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = NO;
            }
        }
        else {
            NSString *stringName = [NSString stringWithFormat:@"%@",SafeStr(global.slOrderDetails.spdOrder.createBy)];
            if (stringName.length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"订单创建人:%@",stringName];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系创建人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = YES;
            }
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        //图片
        self.myHeaderView.headerImView.image = [UIImage getImageByOrderState:SafeStr(global.rfOrderDetails.redeemOrder.orderState)];
        //订单当前节点名称
        self.myHeaderView.stateLabel.text = [NSString getStringByOrderState:SafeStr(global.rfOrderDetails.curNodeName)];
        //订单创建人显示当前节点处理人, 其余显示订单创建人
        if (global.rfOrderDetails.isOrder.intValue == 1)
        {
            SpdOrderStates *model = global.rfOrderDetails.redeemOrderStates[0];
            if ([self showName:model].length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"当前处理人:%@",[self showName:model]];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系处理人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = NO;
            }
        }
        else {
            NSString *stringName = [NSString stringWithFormat:@"%@",SafeStr(global.rfOrderDetails.redeemOrder.createBy)];
            if (stringName.length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"订单创建人:%@",stringName];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系创建人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = YES;
            }
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        //图片
        self.myHeaderView.headerImView.image = [UIImage getImageByOrderState:SafeStr(global.mlOrderDetails.dydOrder.orderState)];
        //订单当前节点名称
        self.myHeaderView.stateLabel.text = [NSString getStringByOrderState:SafeStr(global.mlOrderDetails.curNodeName)];
        //订单创建人显示当前节点处理人, 其余显示订单创建人
        if (global.mlOrderDetails.isOrder.intValue == 1)
        {
            SpdOrderStates *model = global.mlOrderDetails.dydOrderStates[0];
            if ([self showName:model].length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"当前处理人:%@",[self showName:model]];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系处理人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = NO;
            }
        }
        else {
            NSString *stringName = [NSString stringWithFormat:@"%@",SafeStr(global.mlOrderDetails.dydOrder.createBy)];
            if (stringName.length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"订单创建人:%@",stringName];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系创建人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = YES;
            }
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        //图片
        self.myHeaderView.headerImView.image = [UIImage getImageByOrderState:SafeStr(global.elOrderDetails.easyOrder.orderState)];
        //订单当前节点名称
        self.myHeaderView.stateLabel.text = [NSString getStringByOrderState:SafeStr(global.elOrderDetails.curNodeName)];
        //订单创建人显示当前节点处理人, 其余显示订单创建人
        if (global.elOrderDetails.isOrder.intValue == 1)
        {
            SpdOrderStates *model = global.elOrderDetails.easyOrderStates[0];
            if ([self showName:model].length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"当前处理人:%@",[self showName:model]];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系处理人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = NO;
            }
        }
        else
        {
            NSString *stringName = [NSString stringWithFormat:@"%@",SafeStr(global.elOrderDetails.easyOrder.createBy)];
            if (stringName.length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"订单创建人:%@",stringName];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系创建人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = YES;
            }
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        //图片
        self.myHeaderView.headerImView.image = [UIImage getImageByOrderState:SafeStr(global.chOrderDetails.cwfqOrder.orderState)];
        //订单当前节点名称
        self.myHeaderView.stateLabel.text = [NSString getStringByOrderState:SafeStr(global.chOrderDetails.curNodeName)];
        //订单创建人显示当前节点处理人, 其余显示订单创建人
        if (global.chOrderDetails.isOrder.intValue == 1)
        {
            SpdOrderStates *model = global.chOrderDetails.cwfqOrderStates[0];
            if ([self showName:model].length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"当前处理人:%@",[self showName:model]];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系处理人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = NO;
            }
        }
        else {
            NSString *stringName = [NSString stringWithFormat:@"%@",SafeStr(global.chOrderDetails.cwfqOrder.createBy)];
            if (stringName.length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"订单创建人:%@",stringName];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系创建人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = YES;
            }
        }
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        //图片
        self.myHeaderView.headerImView.image = [UIImage getImageByOrderState:SafeStr(global.abOrderDetails.insteadOrder.orderState)];
        //订单当前节点名称
        self.myHeaderView.stateLabel.text = [NSString getStringByOrderState:SafeStr(global.abOrderDetails.curNodeName)];
        //订单创建人显示当前节点处理人, 其余显示订单创建人
        if (global.abOrderDetails.isOrder.intValue == 1)
        {
            SpdOrderStates *model = global.abOrderDetails.insteadOrderStates[0];
            if ([self showName:model].length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"当前处理人:%@",[self showName:model]];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系处理人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = NO;
            }
        }
        else {
            NSString *stringName = [NSString stringWithFormat:@"%@",SafeStr(global.abOrderDetails.insteadOrder.createBy)];
            if (stringName.length > 0) {
                self.myHeaderView.nameLabel.text = [NSString stringWithFormat:@"订单创建人:%@",stringName];
                [self.myHeaderView.phoneCallBtn setTitle:@"联系创建人" forState:UIControlStateNormal];
                self.myHeaderView.phoneCallBtn.hidden = NO;
                self.myHeaderView.rushBtn.hidden = YES;
            }
        }
    }
}

- (NSString *)showName:(SpdOrderStates *)model
{
    NSString *stringName;
    if (model.creator && model.creator_role) {
        stringName = [NSString stringWithFormat:@"%@(%@)",model.creator,model.creator_role];
    }
    else if (model.creator && !model.creator_role){
        stringName = [NSString stringWithFormat:@"%@",model.creator];
    }
    else if (!model.creator && model.creator_role){
        stringName = [NSString stringWithFormat:@"%@",model.creator_role];
    }
    return stringName;
}

#pragma mark 拨打电话
//订单创建人电话/当前节点处理人电话(即催办电话)
- (void)phoneCallBtnClick
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        if (global.slOrderDetails.isOrder.intValue == 1)
        {
            if (global.slOrderDetails.todoUserTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.slOrderDetails.todoUserTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
        else{
            if (global.slOrderDetails.createByTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.slOrderDetails.createByTel) withVC:self];
            }
            else{
                 [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if (global.rfOrderDetails.isOrder.intValue == 1)
        {
            if (global.rfOrderDetails.todoUserTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.rfOrderDetails.todoUserTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
        else{
            if (global.rfOrderDetails.createByTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.rfOrderDetails.createByTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        if (global.mlOrderDetails.isOrder.intValue == 1)
        {
            if (global.mlOrderDetails.todoUserTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.mlOrderDetails.todoUserTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
        else{
            if (global.mlOrderDetails.createByTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.mlOrderDetails.createByTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        if (global.elOrderDetails.isOrder.intValue == 1)
        {
            if (global.elOrderDetails.todoUserTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.elOrderDetails.todoUserTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
        else{
            if (global.elOrderDetails.createByTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.mlOrderDetails.createByTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        if (global.chOrderDetails.isOrder.intValue == 1)
        {
            if (global.chOrderDetails.todoUserTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.chOrderDetails.todoUserTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
        else{
            if (global.chOrderDetails.createByTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.chOrderDetails.createByTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        if (global.abOrderDetails.isOrder.intValue == 1)
        {
            if (global.abOrderDetails.todoUserTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.abOrderDetails.todoUserTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
        else{
            if (global.abOrderDetails.createByTel.length > 0){
                [ZSTool callPhoneStr:SafeStr(global.abOrderDetails.createByTel) withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前处理人未录入电话号码" withDuration:DefaultDuration];
            }
        }
    }
}

#pragma mark 催办
- (void)rushBtnClick
{
    NSMutableDictionary *dict = @{
                                  @"prdType":self.prdType,
                                  @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getRushtodoURL] SuccessBlock:^(NSDictionary *dic) {
        [ZSTool showMessage:@"已催办" withDuration:DefaultDuration];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark /*---------------------------------右侧按钮---------------------------------*/
#pragma mark 右侧按钮是否显示的判断
- (void)checkRightBtnShow
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        //只有订单创建人能关闭订单/撤回订单
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && global.slOrderDetails.isOrder.intValue == 1) {
            [self initRightNavItem:YES];
        }else{
            [self initRightNavItem:NO];
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && global.rfOrderDetails.isOrder.intValue == 1) {
            [self initRightNavItem:YES];
        }else{
            [self initRightNavItem:NO];
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && global.mlOrderDetails.isOrder.intValue == 1) {
            [self initRightNavItem:YES];
        }else{
            [self initRightNavItem:NO];
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && global.elOrderDetails.isOrder.intValue == 1) {
            [self initRightNavItem:YES];
        }else{
            [self initRightNavItem:NO];
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && global.chOrderDetails.isOrder.intValue == 1) {
            [self initRightNavItem:YES];
        }else{
            [self initRightNavItem:NO];
        }
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && global.abOrderDetails.isOrder.intValue == 1) {
            [self initRightNavItem:YES];
        }else{
            [self initRightNavItem:NO];
        }
    }
}

#pragma mark 导航栏右边按钮
- (void)initRightNavItem:(BOOL)isShow
{
    if (isShow){
        [self configureRightNavItemWithTitle:nil withNormalImg:@"head_more_n" withHilightedImg:@"head_more_n"];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark 右侧按钮点击事件 弹窗弹出来的按钮
- (void)RightBtnAction:(UIButton *)sender
{
    //默认显示"关闭订单","添加备注"
    //根据判断是否添加"撤回订单"
    //如果订单能够创建订单则根据不同的情况添加"创建星速贷","创建赎楼宝","创建抵押贷","相关订单"
    NSMutableArray *btnTitleArray = [self isShowWithdraw] == YES ?  @[KCloseBtnTitle,KAddrRemarkBtnTitle,KWithdrawBtnTitle].mutableCopy : @[KCloseBtnTitle,KAddrRemarkBtnTitle].mutableCopy;
    [btnTitleArray addObjectsFromArray:[self showOrderBtnTitle]];
    ZSWSRightAlertView *alertView = [[ZSWSRightAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withArray:btnTitleArray];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark 是否显示撤回订单
- (BOOL)isShowWithdraw
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        if ([global.slOrderDetails.spdOrder.orderState isEqualToString:@"完成审批"] || [global.slOrderDetails.spdOrder.orderState isEqualToString:@"已关闭"]){
            return NO;
        }else{
            return YES;
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if ([global.rfOrderDetails.redeemOrder.orderState isEqualToString:@"完成审批"] || [global.rfOrderDetails.redeemOrder.orderState isEqualToString:@"已关闭"]){
            return NO;
        }else{
            return YES;
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        if ([global.mlOrderDetails.dydOrder.orderState isEqualToString:@"完成审批"] || [global.mlOrderDetails.dydOrder.orderState isEqualToString:@"已关闭"]){
            return NO;
        }else{
            return YES;
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        if ([global.elOrderDetails.easyOrder.orderState isEqualToString:@"完成审批"] || [global.elOrderDetails.easyOrder.orderState isEqualToString:@"已关闭"]){
            return NO;
        }else{
            return YES;
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        if ([global.chOrderDetails.cwfqOrder.orderState isEqualToString:@"完成审批"] || [global.chOrderDetails.cwfqOrder.orderState isEqualToString:@"已关闭"]){
            return NO;
        }else{
            return YES;
        }
    }
    //代办业务
    else
    {
        if ([global.abOrderDetails.insteadOrder.orderState isEqualToString:@"完成审批"] || [global.abOrderDetails.insteadOrder.orderState isEqualToString:@"已关闭"]){
            return NO;
        }else{
            return YES;
        }
    }
}

#pragma mark 是否显示创建赎楼宝/创建星速贷/床架抵押贷相关订单
- (NSArray *)showOrderBtnTitle
{
    NSArray *titleArray;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        if (!global.slOrderDetails.orderRelation)
        {
            titleArray = @[KCreateRedeenFloorBtnTitle];//创建赎楼宝
        }
        else
        {
            titleArray = @[KRelatedOrderBtnTitle];//相关订单
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if (!global.rfOrderDetails.orderRelation)
        {
            titleArray = @[KCreateStarLoanBtnTitle,KCreateMortgageLoanTitle];//创建星速贷,创建抵押贷
        }
        else
        {
            titleArray = @[KRelatedOrderBtnTitle];//相关订单
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        if (!global.mlOrderDetails.orderRelation)
        {
            titleArray = @[KCreateRedeenFloorBtnTitle];//创建赎楼宝
        }
        else
        {
            titleArray = @[KRelatedOrderBtnTitle];//相关订单
        }
    }
    
    return titleArray;
}

#pragma mark rightAlertViewDelegate 关闭订单/撤回订单/添加备注/创建赎楼宝/相关订单
- (void)didSelectBtnClick:(NSInteger)tag
{
    //关闭订单
    if (tag == ZSCloseBtnTag)
    {
        ZSCloseOrderPopView *closeView = [[ZSCloseOrderPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
        closeView.delegate = self;
        [closeView show];
    }
    //撤回订单
    else if (tag == ZSWithdrawBtnTag)
    {
        ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"订单撤回后，不会删除已上传资料，但订单已经走过的流程将会失效，是否确认撤回？" sureTitle:@"确定" cancelTitle:@"取消"];
        alertView.delegate = self;
        [alertView show];
        alertView.tag = 122;
    }
    //添加备注
    else if (tag == ZSAddrRemarkBtnTag)
    {
        ZSAddRemarkPopView *addView = [[ZSAddRemarkPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        addView.delegate = self;
        [addView show];
    }
    //创建星速贷
    else if (tag == ZSCreateStarLoanBtnTag)
    {
        if ([self checkTheRole:9] == NO) {
            [ZSTool showMessage:@"请完善买方信息后再创建星速贷订单！" withDuration:DefaultDuration];
            return;
        }
        ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"因后期不再做订单信息同步，请完善人员信息、房产信息及其他资料后进行创建。"];
        alertView.delegate = self;
        [alertView show];
        alertView.tag = 111;
    }
    //创建赎楼宝
    else if (tag == ZSCreateRedeenFloorBtnTag)
    {
        if ([self checkTheRole:7] == NO) {
            [ZSTool showMessage:@"请完善卖方信息后再创建赎楼宝订单！" withDuration:DefaultDuration];
            return;
        }
        ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"因后期不再做订单信息同步，请完善人员信息、房产信息及其他资料后进行创建。"];
        alertView.delegate = self;
        [alertView show];
        alertView.tag = 222;
    }
    //创建抵押贷
    else if (tag == ZSCreateMortgageLoanTag)
    {
        ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"因后期不再做订单信息同步，请完善人员信息、房产信息及其他资料后进行创建。"];
        alertView.delegate = self;
        [alertView show];
        alertView.tag = 333;
    }
    //相关订单
    else if (tag == ZSRelatedOrderBtnTag)
    {
        NSString *orderState;
        NSString *nextVCOrderID;
        NSString *nextVCPrdType;
        //星速贷
        if ([self.prdType isEqualToString:kProduceTypeStarLoan])
        {
            //当前产品类型跟prdType1相同时,跳转页面的订单id取orderId2,产品类型取prdType2; 反之都取orderId1和prdType1
            if ([self.prdType isEqualToString:global.slOrderDetails.orderRelation.prdType1])
            {
                nextVCOrderID = global.slOrderDetails.orderRelation.orderId2;
                nextVCPrdType = global.slOrderDetails.orderRelation.prdType2;
            }
            else
            {
                nextVCOrderID = global.slOrderDetails.orderRelation.orderId1;
                nextVCPrdType = global.slOrderDetails.orderRelation.prdType1;
            }
            orderState = global.slOrderDetails.orderRelation.orderState;
        }
        //赎楼宝
        else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
        {
            if ([self.prdType isEqualToString:global.rfOrderDetails.orderRelation.prdType1])
            {
                nextVCOrderID = global.rfOrderDetails.orderRelation.orderId2;
                nextVCPrdType = global.rfOrderDetails.orderRelation.prdType2;
            }
            else
            {
                nextVCOrderID = global.rfOrderDetails.orderRelation.orderId1;
                nextVCPrdType = global.rfOrderDetails.orderRelation.prdType1;
            }
            orderState = global.rfOrderDetails.orderRelation.orderState;
        }
        //抵押贷
        else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
        {
            if ([self.prdType isEqualToString:global.mlOrderDetails.orderRelation.prdType1])
            {
                nextVCOrderID = global.mlOrderDetails.orderRelation.orderId2;
                nextVCPrdType = global.mlOrderDetails.orderRelation.prdType2;
            }
            else
            {
                nextVCOrderID = global.mlOrderDetails.orderRelation.orderId1;
                nextVCPrdType = global.mlOrderDetails.orderRelation.prdType1;
            }
            orderState = global.mlOrderDetails.orderRelation.orderState;
        }
        
        //未提交的订单
        if ([orderState isEqualToString:@"暂存"])
        {
            ZSSLPersonListViewController *detailVC = [[ZSSLPersonListViewController alloc]init];
            detailVC.orderState = @"暂存";
            detailVC.orderIDString = nextVCOrderID;
            detailVC.prdType = nextVCPrdType;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        //已提交的订单
        else
        {
            ZSSLPageController *detailVC = [[ZSSLPageController alloc]init];
            detailVC.orderIDString = nextVCOrderID;
            detailVC.prdType = nextVCPrdType;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

#pragma mark ZSCloseOrderPopViewDelegate 关闭订单弹窗代理
- (void)sendReasonString:(NSString *)reason withRemark:(NSString *)remark;
{
    //关闭订单
    [self requestForCloseOrderDataWithReasonString:reason withRemark:remark];
}

#pragma mark ZSAlertViewDelegate
- (void)AlertView:(ZSAlertView *)alert
{
    //撤回订单
    if (alert.tag == 122)
    {
        [self requestForWithdrawOrderData];
    }
    //提交资料
    else if (alert.tag == 102)
    {
        [self requestForSubmitMaterialData];
    }
    //审批意见弹窗
    else if (alert.tag == 1002)
    {
        ZSApprovalOpinionPopView *approvalView = [[ZSApprovalOpinionPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withType:self.isAccept withArray:self.rejectArray];
        approvalView.delegate = self;
        [approvalView show];
    }
    //创建星速贷订单
    else if (alert.tag == 111)
    {
        [self requestCreateOtherProduct:kProduceTypeStarLoan];
    }
    //创建赎楼宝订单
    else if (alert.tag == 222)
    {
        [self requestCreateOtherProduct:kProduceTypeRedeemFloor];
    }
    //创建赎楼宝订单
    else if (alert.tag == 333)
    {
        [self requestCreateOtherProduct:kProduceTypeMortgageLoan];
    }
}

#pragma mark 判断人员列表是否有想对应的人员角色
- (BOOL)checkTheRole:(NSInteger)releation
{
    NSArray<BizCustomers *> *bizCustomers;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        bizCustomers = global.slOrderDetails.bizCustomers;
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        bizCustomers = global.rfOrderDetails.bizCustomers;
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        bizCustomers = global.mlOrderDetails.bizCustomers;
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        bizCustomers = global.elOrderDetails.bizCustomers;
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        bizCustomers = global.chOrderDetails.bizCustomers;
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        bizCustomers = global.abOrderDetails.bizCustomers;
    }
    
    for (int i = 0; i < bizCustomers.count; i++) {
        BizCustomers *info = bizCustomers[i];
        if ([info.releation intValue] == releation) {
            return YES;
        }
    }
    return NO;
}

#pragma mark /*---------------------------------底部按钮---------------------------------*/
- (void)checkBottomBtnShow
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //底部按钮的判断 不可操作 0  资料上传1  审批 2
            if ([global.slOrderDetails.approvalState isEqualToString:@"2"]) {
                [self.bottomBtn removeFromSuperview];
                [self configuBottomBtnsWithTitles:@[@"通过",@"驳回"]];
            }
            else if ([global.slOrderDetails.approvalState isEqualToString:@"1"]) {
                [self configuBottomButtonWithTitle:@"提交资料"];
                [self setBottomBtnBackgroundColorWithWhite];//默认白色
            }
            else{
                self.bottomView.hidden = YES;
            }
        }
        else{
            self.bottomView.hidden = YES;
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //底部按钮的判断 不可操作 0  资料上传1  审批 2
            if ([global.rfOrderDetails.approvalState isEqualToString:@"2"]){
                [self.bottomBtn removeFromSuperview];
                [self configuBottomBtnsWithTitles:@[@"通过",@"驳回"]];
            }
            else if ([global.rfOrderDetails.approvalState isEqualToString:@"1"]) {
                [self configuBottomButtonWithTitle:@"提交资料"];
                [self setBottomBtnBackgroundColorWithWhite];//默认白色
            }
            else{
                self.bottomView.hidden = YES;
            }
        }
        else{
            self.bottomView.hidden = YES;
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //底部按钮的判断 不可操作 0  资料上传1  审批 2
            if ([global.mlOrderDetails.approvalState isEqualToString:@"2"]){
                [self.bottomBtn removeFromSuperview];
                [self configuBottomBtnsWithTitles:@[@"通过",@"驳回"]];
            }
            else if ([global.mlOrderDetails.approvalState isEqualToString:@"1"]) {
                [self configuBottomButtonWithTitle:@"提交资料"];
                [self setBottomBtnBackgroundColorWithWhite];//默认白色
            }
            else{
                self.bottomView.hidden = YES;
            }
        }
        else{
            self.bottomView.hidden = YES;
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //底部按钮的判断 不可操作 0  资料上传1  审批 2
            if ([global.elOrderDetails.approvalState isEqualToString:@"2"]){
                [self.bottomBtn removeFromSuperview];
                [self configuBottomBtnsWithTitles:@[@"通过",@"驳回"]];
            }
            else if ([global.elOrderDetails.approvalState isEqualToString:@"1"]) {
                [self configuBottomButtonWithTitle:@"提交资料"];
                [self setBottomBtnBackgroundColorWithWhite];//默认白色
            }
            else{
                self.bottomView.hidden = YES;
            }
        }
        else{
            self.bottomView.hidden = YES;
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //底部按钮的判断 不可操作 0  资料上传1  审批 2
            if ([global.chOrderDetails.approvalState isEqualToString:@"2"]){
                [self.bottomBtn removeFromSuperview];
                [self configuBottomBtnsWithTitles:@[@"通过",@"驳回"]];
            }
            else if ([global.chOrderDetails.approvalState isEqualToString:@"1"]) {
                [self configuBottomButtonWithTitle:@"提交资料"];
                [self setBottomBtnBackgroundColorWithWhite];//默认白色
            }
            else{
                self.bottomView.hidden = YES;
            }
        }
        else{
            self.bottomView.hidden = YES;
        }
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
            //底部按钮的判断 不可操作 0  资料上传1  审批 2
            if ([global.abOrderDetails.approvalState isEqualToString:@"2"]){
                [self.bottomBtn removeFromSuperview];
                [self configuBottomBtnsWithTitles:@[@"通过",@"驳回"]];
            }
            else if ([global.abOrderDetails.approvalState isEqualToString:@"1"]) {
                [self configuBottomButtonWithTitle:@"提交资料"];
                [self setBottomBtnBackgroundColorWithWhite];//默认白色
            }
            else{
                self.bottomView.hidden = YES;
            }
        }
        else{
            self.bottomView.hidden = YES;
        }
    }
}

#pragma mark 底部按钮的颜色
- (void)checkBottomBtnColor
{
    NSMutableArray *fileArray;
    
    //赎楼宝
    if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        fileArray = [[NSMutableArray alloc]initWithArray:global.rfMaterialCollectModel.handle];
    }
    else
    {
        fileArray = [[NSMutableArray alloc]initWithArray:global.slMaterialCollectModel.handle];
    }
    if ([[ZSTool isCheckingNeedingUploadFilesWithArray:fileArray] isEqualToString:@""])
    {
        //可以改成红的了
        [self setBottomBtnBackgroundColorWithRed];
    }
}

#pragma mark 底部按钮点击 提交资料/审批
- (void)bottomClick:(UIButton *)sender
{
    //页面滑动到第三个控制器
    [self.managerView scrollToIndexWithIndex:2];
    
    //先判断资料列表是否有数据,没数据就请求接口
    //赎楼宝
    if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if (!global.rfMaterialCollectModel) {
            [self requestForMaterialData];
            return;
        }
    }
    else
    {
        if (!global.slMaterialCollectModel) {
            [self requestForMaterialData];
            return;
        }
    }
    
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        //0:不可操作\2:审批\1:提交资料
        if ([global.slOrderDetails.approvalState containsString:@"2"]){
            self.isAccept = sender.tag == 0 ? YES : NO;
            [self gotoAuditOrderVC];
        }else if ([global.slOrderDetails.approvalState containsString:@"1"]) {
            [self judgeSubmitMaterialAlertShow];
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        //0:不可操作\2:审批\1:提交资料
        if ([global.rfOrderDetails.approvalState containsString:@"2"]){
            self.isAccept = sender.tag == 0 ? YES : NO;
            [self gotoAuditOrderVC];
        }else if ([global.rfOrderDetails.approvalState containsString:@"1"]) {
            [self judgeSubmitMaterialAlertShow];
        }
        
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        //0:不可操作\2:审批\1:提交资料
        if ([global.mlOrderDetails.approvalState containsString:@"2"]){
            self.isAccept = sender.tag == 0 ? YES : NO;
            [self gotoAuditOrderVC];
        }else if ([global.mlOrderDetails.approvalState containsString:@"1"]) {
            [self judgeSubmitMaterialAlertShow];
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        //0:不可操作\2:审批\1:提交资料
        if ([global.elOrderDetails.approvalState containsString:@"2"]){
            self.isAccept = sender.tag == 0 ? YES : NO;
            [self gotoAuditOrderVC];
        }else if ([global.elOrderDetails.approvalState containsString:@"1"]) {
            [self judgeSubmitMaterialAlertShow];
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        //0:不可操作\2:审批\1:提交资料
        if ([global.chOrderDetails.approvalState containsString:@"2"]){
            self.isAccept = sender.tag == 0 ? YES : NO;
            [self gotoAuditOrderVC];
        }else if ([global.chOrderDetails.approvalState containsString:@"1"]) {
            [self judgeSubmitMaterialAlertShow];
        }
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        //0:不可操作\2:审批\1:提交资料
        if ([global.abOrderDetails.approvalState containsString:@"2"]){
            self.isAccept = sender.tag == 0 ? YES : NO;
            [self gotoAuditOrderVC];
        }else if ([global.abOrderDetails.approvalState containsString:@"1"]) {
            [self judgeSubmitMaterialAlertShow];
        }
    }
}

#pragma mark 跳转审批订单
- (void)gotoAuditOrderVC
{
    NSString *uploadStr;
    //赎楼宝
    if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        uploadStr = [ZSTool isCheckingNeedingUploadFilesWithArray:global.rfMaterialCollectModel.handle];
    }
    else
    {
        uploadStr = [ZSTool isCheckingNeedingUploadFilesWithArray:global.slMaterialCollectModel.handle];
    }
    
    if (uploadStr.length > 0)
    {
        [self initWithAlertViewWithTitle:uploadStr tag:1002];
    }
    else
    {
        ZSApprovalOpinionPopView *approvalView = [[ZSApprovalOpinionPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withType:self.isAccept withArray:self.rejectArray];
        approvalView.delegate = self;
        [approvalView show];
    }
}

#pragma mark 判断提交资料
- (void)judgeSubmitMaterialAlertShow
{
    //有必填
    NSMutableArray *fileArray;
    NSString *uploadStr;

    //赎楼宝
    if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        fileArray = [[NSMutableArray alloc]initWithArray:global.rfMaterialCollectModel.handle];
        uploadStr = [ZSTool checkingIsNotNeedUploadFilesWithArray:global.rfMaterialCollectModel.handle];
    }
    else
    {
        fileArray = [[NSMutableArray alloc]initWithArray:global.slMaterialCollectModel.handle];
        uploadStr = [ZSTool checkingIsNotNeedUploadFilesWithArray:global.slMaterialCollectModel.handle];
    }
    
    BOOL canGoOn = [ZSTool chekIsNeedUploadFilesWithArray:fileArray];//检查有无需要上传的
    if (!canGoOn) {
        [NOTI_CENTER postNotificationName:kOrderDetailDatalistScrollNotification object:nil userInfo:@{@"isNeed":@"YES"}];
        return;
    }
    //判断有无选填项
    if (uploadStr.length > 0){
        [self initWithAlertViewWithTitle:uploadStr tag:102];
        [NOTI_CENTER postNotificationName:kOrderDetailDatalistScrollNotification object:nil userInfo:@{@"isNeed":@"NO"}];
    }else{
        [self requestForSubmitMaterialData];
    }
}

#pragma mark 弹框样式
- (void)initWithAlertViewWithTitle:(NSString *)title tag:(NSInteger)tag
{
    ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:title sureTitle:@"立即提交" cancelTitle:@"继续完善"];
    alertView.delegate = self;
    alertView.tag = tag;
    [alertView show];
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

