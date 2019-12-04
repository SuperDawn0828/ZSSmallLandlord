//
//  ZSWSPageController.m
//  ZSMoneytocar
//
//  Created by 武 on 2016/10/31.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSWSPageController.h"
#import "ZSWSPersonListViewController.h"
#import "ZSWSProjrctMaterialViewController.h"
#import "ZSWSMaterialCollectViewController.h"
#import "ZSWSOrderScheduleViewController.h"
#import "ZSWSAddScheduleViewController.h"
#import "ZSWSAddCustomerBankViewController.h"

@interface ZSWSPageController ()<ZSActionSheetViewDelegate,ZSWSRightAlertViewDelegate,ZSAlertViewDelegate>
@property(strong, nonatomic) LTSimpleManager           *managerView;
@property (strong, nonatomic) LTLayout                 *layout;
@property (copy,   nonatomic) NSArray                  *titleArray;
@property (copy,   nonatomic) NSArray                  *viewControllersArray;
@property (strong, nonatomic) NSMutableArray           *uploadFilesStateArray;
@end
@implementation ZSWSPageController

- (NSMutableArray*)uploadFilesStateArray
{
    if (!_uploadFilesStateArray) {
        _uploadFilesStateArray = [[NSMutableArray alloc]init];
    }
    return _uploadFilesStateArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestOrderDetail];//获取订单详情
    //开启返回手势(自定义返回按钮会导致手势失效)
    [self openInteractivePopGestureRecognizerEnable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];
    [self setupSubViews];
    //Data
    //刷新详情的通知
    [NOTI_CENTER addObserver:self selector:@selector(requestOrderDetail) name:KSUpdateAllOrderDetailNotification object:nil];
    //下拉刷新
    [self refreshData];
}

#pragma mark 页面初始化
- (void)setupSubViews
{
    [self.view addSubview:self.managerView];
}

- (LTSimpleManager *)managerView
{
    if (!_managerView) {
        _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)
                                              viewControllers:self.viewControllersArray
                                                       titles:self.titleArray
                                        currentViewController:self
                                                       layout:self.layout];
    }
    return _managerView;
}

- (LTLayout *)layout
{
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.titleViewBgColor = ZSColor(255, 255, 255);
        _layout.bottomLineColor = ZSColor(253, 114, 114);
        _layout.titleSelectColor = ZSColor(253, 114, 114);
        _layout.titleColor = ZSColor(168, 168, 168);
        _layout.pageBottomLineColor = ZSColor(248, 248, 248);
        _layout.sliderWidth = 60;
    }
    return _layout;
}
- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"基本信息", @"项目资料", @"资料收集", @"按揭进度"];
    }
    return _titleArray;
}

- (NSArray *)viewControllersArray
{
    if (!_viewControllersArray) {
        _viewControllersArray = [self setupViewControllers];
    }
    return _viewControllersArray;
}

#pragma mark 初始化的控制器
- (NSArray *)setupViewControllers
{
    NSMutableArray *testVCS = [NSMutableArray arrayWithCapacity:0];
    ZSWSPersonListViewController *personVC = [[ZSWSPersonListViewController alloc] init];
    personVC.orderIDString = self.orderIDString;
    [testVCS addObject:personVC];
    
    ZSWSProjrctMaterialViewController *projectVC = [[ZSWSProjrctMaterialViewController alloc] init];
    projectVC.orderIDString = self.orderIDString;
    [testVCS addObject:projectVC];
    
    ZSWSMaterialCollectViewController *MaterialVC = [[ZSWSMaterialCollectViewController alloc] init];
    MaterialVC.orderIDString = self.orderIDString;
    [testVCS addObject:MaterialVC];
    
    ZSWSOrderScheduleViewController *ScheduleVC = [[ZSWSOrderScheduleViewController alloc] init];
    ScheduleVC.orderIDString = self.orderIDString;
    [testVCS addObject:ScheduleVC];
    
    return testVCS.copy;
}

#pragma mark 控制器刷新事件
- (void)refreshData
{
    [self.managerView refreshTableViewHandle:^(UIScrollView * _Nonnull scrollView, NSInteger index) {
        __weak typeof(scrollView) weakScrollView = scrollView;
        scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakScrollView) strongScrollView = weakScrollView;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestOrderDetail];
                [strongScrollView.mj_header endRefreshing];
            });
        }];
    }];
}

#pragma mark 查询详情接口
- (void)requestOrderDetail
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameter=  @{
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getQueryWitnessOrderDetails] SuccessBlock:^(NSDictionary *dic) {
        //赋值
        global.wsOrderDetail = [ZSWSOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
        //标题
        weakSelf.title = NSStringFormat(@"%@的订单",[global.wsOrderDetail.custInfo firstObject].name);
        //右侧按钮
        [weakSelf checkRightItemCanShow];
        //通知子控制器列表刷新
        [NOTI_CENTER postNotificationName:kOrderDetailFreshDataNotification object:nil];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 判断右侧按钮是否展示
- (void)checkRightItemCanShow
{
    //已完成和已关闭右边按钮不显示
    if ([ZSTool checkWitnessServerOrderIsCanEditing]){
        [self initRightNavItems:YES];
    }else {
        [self initRightNavItems:NO];
    }
}

#pragma mark 右侧按钮
- (void)initRightNavItems:(BOOL)isShow
{
    if (isShow){
        [self configureRightNavItemWithTitle:nil withNormalImg:@"head_more_n" withHilightedImg:@"head_more_n"];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark 右侧按钮点击事件
- (void)RightBtnAction:(UIButton *)sender
{
    ZSWSRightAlertView *alertView = [[ZSWSRightAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withArray:@[KCompleteBtnTitle]];
   
    //1.没有完成订单按钮
    if ([global.wsOrderDetail.ifLoanApprove isEqualToString:@"0"]) {
        if (global.wsOrderDetail.projectInfo.fedbackState == 0) {
        }else{
            alertView = [[ZSWSRightAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withArray:@[KCompleteBtnTitle,KCreditBtnTitle]];
        }
    }
    //2.有完成订单按钮
    else if ([global.wsOrderDetail.ifLoanApprove isEqualToString:@"1"]) {
        //1.1没有征信重查
        if (global.wsOrderDetail.projectInfo.fedbackState == 0){
        }else{
            alertView = [[ZSWSRightAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withArray:@[KCompleteBtnTitle,KCreditBtnTitle]];
        }
    }
    //3.其他情况
    else {
    }
    
    alertView.delegate = self;
    [alertView show];
}

#pragma mark rightAlertViewDelegate
- (void)didSelectBtnClick:(NSInteger)tag
{
    if (tag == 101){
        //征信重查询
        ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"征信重查将清除原有已反馈的征信数据，是否确认重新查询征信？" sureTitle:@"确认" cancelTitle:@"取消"];
        alertView.delegate = self;
        [alertView show];
        alertView.tag = ZSWSPageAlertStyleCrdit;
    }
    if (tag == 102){
        //关闭订单
        ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"关闭订单后，该订单将不可进行任何操作，是否确认关闭订单？" sureTitle:@"确认" cancelTitle:@"取消"];
        alertView.delegate = self;
        [alertView show];
        alertView.tag = ZSWSPageAlertStyleClose;
    }
    if (tag == 103){
        //完成订单
        ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"确认完成订单后，APP上将无法编辑各项资料，是否确认完成？" sureTitle:@"确认" cancelTitle:@"取消"];
        alertView.delegate = self;
        [alertView show];
        alertView.tag = ZSWSPageAlertStyleComplete;
    }
}

- (void)AlertView:(ZSAlertView *)alert
{
    if (alert.tag == ZSWSPageAlertStyleCrdit){
        //征信重查
        [self requestForRequeryOrderCreditData];
    }
    if (alert.tag == ZSWSPageAlertStyleClose){
        //关闭订单
        [self requestForCloseOrderData];
    }else if(alert.tag == ZSWSPageAlertStyleComplete) {
        //完成订单
        [self requestForCompleteData];
    }
}

#pragma mark 征信重查点击事件
- (void)requestForRequeryOrderCreditData
{
    ZSWSAddCustomerBankViewController *vc = [[ZSWSAddCustomerBankViewController alloc]init];
    vc.orderIDString     = global.wsOrderDetail.projectInfo.tid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 关闭订单
- (void)requestForCloseOrderData
{
    //    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":global.wsOrderDetail.projectInfo.tid
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getCloseOrder] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //详情通知
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        //提示
        [ZSTool showMessage:@"关闭成功" withDuration:DefaultDuration];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 完成订单
- (void)requestForCompleteData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":global.wsOrderDetail.projectInfo.tid
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getCompleteWitnessOrderURL] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //提示
        [ZSTool showMessage:@"提交成功" withDuration:DefaultDuration];
    } ErrorBlock:^(NSError *error) {
    }];
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

@end

