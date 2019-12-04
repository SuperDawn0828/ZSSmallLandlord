//
//  ZSPCOrderDetailController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/7/16.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSPCOrderDetailController.h"
#import "ZSPCOrderPersonDetailViewController.h"
#import "ZSSLPersonListViewController.h"
#import "ZSOrderDetailPersonCell.h"
#import "ZSWSNewLeftRightCell.h"
#import "ZSPCOrderDetailPhotoCell.h"
#import "ZSBaseSectionView.h"
#import "ZSPCOrderDetailModel.h"
#import "ZSDynamicDataModel.h"
#import "ZSCreditReportsPopView.h"
#import "ZSSendOrderPopView.h"
#import "ZSNotificationDetailView.h"

@interface ZSPCOrderDetailController ()<ZSTextWithPhotosTableViewCellDelegate,ZSCreditReportsPopViewDelegate,ZSSendOrderPopViewDelegate,ZSNotificationDetailViewDelegate,ZSCreditSectionViewDelegate,ZSAlertViewDelegate>
@property (nonatomic,strong) UIView         *topBackgroundView;//顶部背景色
@property (nonatomic,strong) UIImageView    *stateImageView;   //订单状态图标
@property (nonatomic,strong) UILabel        *stateLabel;       //订单状态
@property (nonatomic,strong) UIButton       *callMediationBtn; //联系中介按钮
@property (nonatomic,strong) UIButton       *callApprovalBtn;  //联系审批员按钮
@property (nonatomic,strong) NSMutableArray *dataArray;        //主数据源
@property (nonatomic,strong) NSMutableArray *dataTitleArray;   //主标题数据源
@property (nonatomic,strong) NSMutableArray<ZSBanklistModel *> *bankDataArray;   //预授信贷款银行
@property (nonatomic,strong) NSMutableArray<ZSSendOrderPersonModel *> *sendPersonArray;  //派单人员列表
@property (nonatomic,copy  ) NSString       *idString;          //接受派单业务员的id
@end

@implementation ZSPCOrderDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureTopView];
    [self configureTable];
    //Data
    [self requestData];
    [self requestSendOrderPersonList];
    [NOTI_CENTER addObserver:self selector:@selector(requestData) name:KSUpdateAllOrderDetailNotification object:nil];
}

#pragma mark /*---------------------------------------数据填充---------------------------------------*/
#pragma mark 请求订单详情接口
- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"prdType":self.prdType,
                                  @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getPrecreditOrderDetail] SuccessBlock:^(NSDictionary *dic) {
        //订单详情存值
        global.pcOrderDetailModel = [ZSPCOrderDetailModel yy_modelWithJSON:dic[@"respData"]];
        //数据填充
        [weakSelf fillTheData];
        //获取预授信贷款银行
        [weakSelf getListPrecreditBank];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 派单人员列表
- (void)requestSendOrderPersonList
{
    self.sendPersonArray = [[NSMutableArray alloc]init];
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

#pragma mark 获取预授信贷款银行
- (void)getListPrecreditBank
{
    self.bankDataArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"prdType":self.prdType,
                                  @"cityId":global.pcOrderDetailModel.order.loanCityId
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getListPrecreditBank] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSBanklistModel *model = [ZSBanklistModel yy_modelWithJSON:dict];
                [weakSelf.bankDataArray addObject:model];
            }
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 列表详情数据填充
- (void)fillTheData
{
    //title
    if (global.pcOrderDetailModel.customers.count) {
        CustomersModel *customerModel = global.pcOrderDetailModel.customers.firstObject;
        self.title = [NSString stringWithFormat:@"%@的订单",customerModel.name];
    }
    else {
        self.title = @"订单详情";
    }
    
    //订单状态
    OrderModel *orderModel = global.pcOrderDetailModel.order;
    AgentPrecredit *agentModel = global.pcOrderDetailModel.agentPrecredit;
    if (orderModel.orderState)
    {
        if ([orderModel.orderState isEqualToString:@"待生成预授信报告"])
        {
            self.stateImageView.image = [UIImage imageNamed:@"list_in approval_n"];
            self.stateLabel.text = [NSString stringWithFormat:@"%@",orderModel.orderState];
            self.callMediationBtn.hidden = NO;
            self.callApprovalBtn.hidden = YES;
        }
        else if ([orderModel.orderState isEqualToString:@"已生成预授信报告"])
        {
            self.callMediationBtn.hidden = NO;
            self.callApprovalBtn.hidden = NO;
            if (agentModel.canLoan.intValue == 1) {
                self.stateImageView.image = [UIImage imageNamed:@"list_completed_n"];
                self.stateLabel.text = [NSString stringWithFormat:@"%@-可贷款",orderModel.orderState];
            }
            else if (agentModel.canLoan.intValue == 2) {
                self.stateImageView.image = [UIImage imageNamed:@"list_nouploaded_n"];
                self.stateLabel.text = [NSString stringWithFormat:@"%@-不可贷款",orderModel.orderState];
            }
        }
        else
        {
            self.topBackgroundView.height = 50;
            self.tableView.frame = CGRectMake(0, self.topBackgroundView.bottom, ZSWIDTH, ZSHEIGHT - kNavigationBarHeight - self.topBackgroundView.height);
            self.stateLabel.text = [NSString stringWithFormat:@"%@",orderModel.orderState];
            if ([orderModel.orderState isEqualToString:@"已关闭"])
            {
                self.stateImageView.image = [UIImage imageNamed:@"list_closed_n"];
            }
            else if ([orderModel.orderState isEqualToString:@"暂存"])
            {
                self.stateLabel.text = @"待提交订单";
                self.stateImageView.image = [UIImage imageNamed:@"list_in approval_n"];
            }
        }
        
        //底部按钮
        [self configureBottomBtn];
    }
    
    //-------------------------------------列表相关数据-------------------------------------//
    self.dataArray = [[NSMutableArray alloc]init];
    self.dataTitleArray = [[NSMutableArray alloc]initWithObjects:@"人员信息",@"贷款信息",@"房产信息",@"订单信息", nil];
    NSMutableArray *personDatdArray = [[NSMutableArray alloc]init];
    NSMutableArray *loanDatdArray = [[NSMutableArray alloc]init];
    NSMutableArray *houseDatdArray = [[NSMutableArray alloc]init];
    NSMutableArray *reportDatdArray = [[NSMutableArray alloc]init];
//    NSMutableArray *sendDatdArray = [[NSMutableArray alloc]init];
    NSMutableArray *orderDatdArray = [[NSMutableArray alloc]init];
    
    //-------------------------------------预授信报告信息和派单信息-------------------------------------//
    if (agentModel)
    {
        [self.dataTitleArray insertObject:@"预授信报告" atIndex:0];
        //        if (global.pcOrderDetailModel.order.createBy) {
        //            [self.dataTitleArray insertObject:@"派单信息" atIndex:4];
        //        }
        
        if (agentModel.canLoan)
        {
            ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
            dataModel.leftName = @"是否可贷";
            dataModel.rightData = [ZSGlobalModel getCanLoanStateWithCode:agentModel.canLoan];
            [reportDatdArray addObject:dataModel];
            
            //可贷款显示相关信息
            if (agentModel.canLoan.intValue == 1)
            {
                if (agentModel.custQualification) {
                    ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
                    dataModel.leftName = @"用户资质";
                    dataModel.rightData = [ZSGlobalModel getCustomerQualificationStateWithCode:agentModel.custQualification];
                    [reportDatdArray addObject:dataModel];
                }
                
                if (agentModel.evaluationAmount) {
                    ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
                    dataModel.leftName = @"房产评估价";
                    dataModel.rightData = [NSString stringWithFormat:@"%@元",[NSString ReviseString:agentModel.evaluationAmount]];
                    [reportDatdArray addObject:dataModel];
                }
                
                if (agentModel.maxCreditLimit) {
                    ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
                    dataModel.leftName = @"最高贷款额";
                    dataModel.rightData = [NSString stringWithFormat:@"%@元",[NSString ReviseString:agentModel.maxCreditLimit]];
                    [reportDatdArray addObject:dataModel];
                }
                
                if (orderModel.loanBank2) {
                    ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
                    dataModel.leftName = @"贷款银行";
                    dataModel.rightData = [NSString stringWithFormat:@"%@",orderModel.loanBank2];
                    [reportDatdArray addObject:dataModel];
                }
                
                if (orderModel.loanRate) {
                    ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
                    dataModel.leftName = @"贷款利率";
                    dataModel.rightData = [NSString stringWithFormat:@"%@ %@",orderModel.loanRate,@"%"];
                    [reportDatdArray addObject:dataModel];
                }
                
                if (agentModel.remark) {
                    ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
                    dataModel.leftName = @"备注";
                    dataModel.rightData = [NSString stringWithFormat:@"%@",agentModel.remark];
                    [reportDatdArray addObject:dataModel];
                }
                
                if (orderModel.customerManagerName) {
                    ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
                    dataModel.leftName = @"专属客户经理";
                    dataModel.rightData = [NSString stringWithFormat:@"%@",orderModel.customerManagerName];
                    [reportDatdArray addObject:dataModel];
                }
                
                if (orderModel.preCreditUserName) {
                    ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
                    dataModel.leftName = @"操作人";
                    dataModel.rightData = [NSString stringWithFormat:@"%@",orderModel.preCreditUserName];
                    [reportDatdArray addObject:dataModel];
                }
                
                if (agentModel.createDate) {
                    ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
                    dataModel.leftName = @"操作时间";
                    dataModel.rightData = [NSString stringWithFormat:@"%@",agentModel.createDate];
                    [reportDatdArray addObject:dataModel];
                }
            }
        }
        
        //添加到主数据源数组
        if (reportDatdArray.count > 0){
            [self.dataArray addObject:reportDatdArray];
        }
        
        //        //-------------------------------------派单信息
        //        if (orderModel.createBy) {
        //            ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
        //            dataModel.leftName = @"派单给";
        //            dataModel.rightData = [NSString stringWithFormat:@"%@",orderModel.createBy];
        //            [sendDatdArray addObject:dataModel];
        //        }
        //
        //        if (orderModel.distributeUser) {
        //            ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
        //            dataModel.leftName = @"派单操作人";
        //            dataModel.rightData = [NSString stringWithFormat:@"%@",orderModel.distributeUser];
        //            [sendDatdArray addObject:dataModel];
        //        }
        //
        //        if (orderModel.distributeDate) {
        //            ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
        //            dataModel.leftName = @"派单时间";
        //            dataModel.rightData = [NSString stringWithFormat:@"%@",orderModel.distributeDate];
        //            [sendDatdArray addObject:dataModel];
        //        }
        //
        //        //添加到主数据源数组
        //        if (sendDatdArray.count > 0){
        //            [self.dataArray addObject:sendDatdArray];
        //        }
    }
    
    //-------------------------------------人员信息-------------------------------------//
    if (global.pcOrderDetailModel.customers.count) {
        personDatdArray = [[NSMutableArray alloc]initWithArray:global.pcOrderDetailModel.customers];
    }
    //添加到主数据源数组
    [self.dataArray addObject:personDatdArray];
    
    //-------------------------------------贷款信息-------------------------------------//
    //所在城市
    ZSOrderModel *cityModel = [[ZSOrderModel alloc]init];
    cityModel.leftName = @"所在城市";
    cityModel.rightData = orderModel.loanCity ? orderModel.loanCity : @"";
    [loanDatdArray addObject:cityModel];
    
    //合同总价
    //星速贷显示,抵押贷赎楼宝不展示
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        ZSOrderModel *contractAmountModel = [[ZSOrderModel alloc]init];
        contractAmountModel.leftName = @"合同总价";
        contractAmountModel.rightData = orderModel.contractAmount ? [NSString stringWithFormat:@"%@ 元",[NSString ReviseString:orderModel.contractAmount]] : @"";
        [loanDatdArray addObject:contractAmountModel];
    }
    
    //申请贷款金额
    ZSOrderModel *applyLoanAmountModel = [[ZSOrderModel alloc]init];
    applyLoanAmountModel.leftName = @"申请贷款金额";
    applyLoanAmountModel.rightData = orderModel.applyLoanAmount ? [NSString stringWithFormat:@"%@ 元",[NSString ReviseString:orderModel.applyLoanAmount]] : @"";
    [loanDatdArray addObject:applyLoanAmountModel];
    
    //贷款年限
    ZSOrderModel *loanLimitModel = [[ZSOrderModel alloc]init];
    loanLimitModel.leftName = @"贷款年限";
    loanLimitModel.rightData = orderModel.loanLimit ? [NSString stringWithFormat:@"%@ 年",orderModel.loanLimit] : @"";
    [loanDatdArray addObject:loanLimitModel];
    
    //添加到主数据源数组
    [self.dataArray addObject:loanDatdArray];
 
    //-------------------------------------房产信息-------------------------------------//
    //不动产权证
    ZSDynamicDataModel *realEstateModel = [[ZSDynamicDataModel alloc]init];
    realEstateModel.fieldMeaning = @"不动产权证";
    realEstateModel.isNecessary = @"0";
    if (global.pcOrderDetailModel.warrantImg.count){
        realEstateModel.rightData = [self getNeedUploadFilesString];
    }
    [houseDatdArray addObject:realEstateModel];
    
    //楼盘名称
    ZSOrderModel *nameModel = [[ZSOrderModel alloc]init];
    nameModel.leftName = @"楼盘名称";
    nameModel.rightData = orderModel.projName ? orderModel.projName : @"";
    [houseDatdArray addObject:nameModel];
    
    //楼盘地址
    ZSOrderModel *provinceModel = [[ZSOrderModel alloc]init];
    provinceModel.leftName = @"楼盘地址";
    NSString *addressString = @"";
    if (orderModel.province && orderModel.city && orderModel.area) {
        addressString = [NSString stringWithFormat:@"%@%@%@",orderModel.province,orderModel.city,orderModel.area];
    }
    if (orderModel.address) {
        addressString = [NSString stringWithFormat:@"%@%@",addressString,orderModel.address];
    }
    provinceModel.rightData = addressString;
    [houseDatdArray addObject:provinceModel];
    
    //楼栋房号
    ZSOrderModel *roomNumModel = [[ZSOrderModel alloc]init];
    roomNumModel.leftName = @"楼栋房号";
    roomNumModel.rightData = orderModel.houseNum ? orderModel.houseNum : @"";
    [houseDatdArray addObject:roomNumModel];
    
    //权证号
    ZSOrderModel *rightModel = [[ZSOrderModel alloc]init];
    rightModel.leftName = @"权证号";
    rightModel.rightData = orderModel.warrantNo ? orderModel.warrantNo : @"";
    [houseDatdArray addObject:rightModel];
    
    //房屋功能
    ZSOrderModel *houseModel = [[ZSOrderModel alloc]init];
    houseModel.leftName = @"房屋功能";
    houseModel.rightData = orderModel.housingFunction ? orderModel.housingFunction : @"";
    [houseDatdArray addObject:houseModel];
    
    //建筑面积
    ZSOrderModel *areaModel = [[ZSOrderModel alloc]init];
    areaModel.leftName = @"建筑面积";
    if (orderModel.coveredArea) {
        areaModel.rightData = [NSString stringWithFormat:@"%@ m²",[NSString ReviseString:orderModel.coveredArea]];
    }
    [houseDatdArray addObject:areaModel];
    
    //套内面积
    ZSOrderModel *areaModel2 = [[ZSOrderModel alloc]init];
    areaModel2.leftName = @"套内面积";
    if (orderModel.insideArea) {
        areaModel2.rightData = [NSString stringWithFormat:@"%@ m²",[NSString ReviseString:orderModel.insideArea]];
    }
    [houseDatdArray addObject:areaModel2];
    
    //添加到主数据源数组
    [self.dataArray addObject:houseDatdArray];
    
    //-------------------------------------订单信息-------------------------------------//
    //订单编号
    ZSOrderModel *orderNoModel = [[ZSOrderModel alloc]init];
    orderNoModel.leftName = @"订单编号";
    if (orderModel.orderNo) {
        orderNoModel.rightData = [NSString stringWithFormat:@"%@  |  复制",orderModel.orderNo];
    }
    [orderDatdArray addObject:orderNoModel];
    
    //创建时间
    ZSOrderModel *createDateModel = [[ZSOrderModel alloc]init];
    createDateModel.leftName = @"创建时间";
    createDateModel.rightData = orderModel.createDate ? orderModel.createDate : @"";
    [orderDatdArray addObject:createDateModel];
    
    //订单创建人
    ZSOrderModel *agentUserNameModel = [[ZSOrderModel alloc]init];
    agentUserNameModel.leftName = @"订单创建人";
    agentUserNameModel.rightData = orderModel.agentUserName ? orderModel.agentUserName : @"";
    [orderDatdArray addObject:agentUserNameModel];
    
    //所属中介
    ZSOrderModel *agencyNameModel = [[ZSOrderModel alloc]init];
    agencyNameModel.leftName = @"所属中介";
    agencyNameModel.rightData = orderModel.agencyName ? orderModel.agencyName : @"";
    [orderDatdArray addObject:agencyNameModel];
    
    //联系方式
    ZSOrderModel *agencyContactPhoneModel = [[ZSOrderModel alloc]init];
    agencyContactPhoneModel.leftName = @"联系方式";
    agencyContactPhoneModel.rightData = orderModel.agencyContactPhone ? orderModel.agencyContactPhone : @"";
    [orderDatdArray addObject:agencyContactPhoneModel];
    
    //添加到主数据源数组
    [self.dataArray addObject:orderDatdArray];
    
    //刷新tableview
    [self.tableView reloadData];
}

#pragma mark 获取不动产权证的数据
- (NSString *)getNeedUploadFilesString
{
    NSString *string;
    for (WarrantImg *imgModel in global.pcOrderDetailModel.warrantImg) {
        //直接拼接所有的url
        if (imgModel.dataUrl) {
            string = [NSString stringWithFormat:@"%@,%@",string,imgModel.dataUrl];
        }
    }
    string = [string stringByReplacingOccurrencesOfString:@"(null),"withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@",(null)"withString:@""];
    return SafeStr(string);
}

#pragma mark /*---------------------------------------顶部页面---------------------------------------*/
- (void)configureTopView
{
    [self setLeftBarButtonItem];//返回按钮

    //底色
    self.topBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 100)];
    self.topBackgroundView.backgroundColor = ZSColorRed;
    [self.view addSubview:self.topBackgroundView];
    
    //订单状态icon
    self.stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 20, 20)];
    [self.topBackgroundView addSubview:self.stateImageView];
    
    //订单状态
    self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.stateImageView.right+10, 0, ZSWIDTH-70, 50)];
    self.stateLabel.font = [UIFont boldSystemFontOfSize:20];
    self.stateLabel.textColor = ZSColorWhite;
    [self.topBackgroundView addSubview:self.stateLabel];
    
    //联系中介按钮
    self.callMediationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callMediationBtn.frame = CGRectMake(self.stateImageView.right+10, 55, 110, 30);
    if (self.lastVC == ZSPreliminaryCreditPageController) {
        [self.callMediationBtn setTitle:@"联系客户经理" forState:UIControlStateNormal];
    }
    else if (self.lastVC == ZSTheMediationViewController) {
        [self.callMediationBtn setTitle:@"联系中介" forState:UIControlStateNormal];
    }
    [self.callMediationBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    self.callMediationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.callMediationBtn.layer.borderWidth = 0.5;
    self.callMediationBtn.layer.borderColor = ZSColorWhite.CGColor;
    self.callMediationBtn.layer.masksToBounds = YES;
    self.callMediationBtn.layer.cornerRadius = 5;
    [self.callMediationBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.callMediationBtn.hidden = YES;
    [self.topBackgroundView addSubview:self.callMediationBtn];
    
    //联系审批员按钮
    self.callApprovalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callApprovalBtn.frame = CGRectMake(self.callMediationBtn.right+10, 55, 130, 30);
    [self.callApprovalBtn setTitle:@"联系审批员" forState:UIControlStateNormal];
    [self.callApprovalBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    self.callApprovalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.callApprovalBtn.layer.borderWidth = 0.5;
    self.callApprovalBtn.layer.borderColor = ZSColorWhite.CGColor;
    self.callApprovalBtn.layer.masksToBounds = YES;
    self.callApprovalBtn.layer.cornerRadius = 5;
    [self.callApprovalBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.callApprovalBtn.hidden = YES;
    [self.topBackgroundView addSubview:self.callApprovalBtn];
}

- (void)callBtnAction:(UIButton *)sender
{
    if (sender == self.callMediationBtn)
    {
        if (self.lastVC == ZSPreliminaryCreditPageController)
        {
            NSString *string = [NSString stringWithFormat:@"%@",SafeStr(global.pcOrderDetailModel.order.customerManagerPhone)];
            if (string.length > 0){
                [ZSTool callPhoneStr:string withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前客户经理未录入电话号码" withDuration:DefaultDuration];
            }
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"%@",SafeStr(global.pcOrderDetailModel.order.agencyContactPhone)];
            if (string.length > 0){
                [ZSTool callPhoneStr:string withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前中介未录入电话号码" withDuration:DefaultDuration];
            }
        }
    }
    else if (sender == self.callApprovalBtn)
    {
        NSString *string = [NSString stringWithFormat:@"%@",SafeStr(global.pcOrderDetailModel.order.preCreditUserPhone)];
        if (string.length > 0){
            [ZSTool callPhoneStr:string withVC:self];
        }
        else{
            [ZSTool showMessage:@"当前审批员未录入电话号码" withDuration:DefaultDuration];
        }
    }
}

#pragma mark /*---------------------------------------tableView---------------------------------------*/
- (void)configureTable
{
    [self configureTableView:CGRectMake(0, self.topBackgroundView.bottom, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight-self.topBackgroundView.height) withStyle:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = CellHeight;
    [self.tableView registerNib:[UINib nibWithNibName:KReuseZSWSNewLeftRightCellIdentifier bundle:nil] forCellReuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
}

#pragma mark tableViewCell代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataTitleArray[indexPath.section] isEqualToString:@"人员信息"])
    {
        return 95;
    }
    else if ([self.dataTitleArray[indexPath.section] isEqualToString:@"房产信息"])
    {
        if (indexPath.row == 0)
        {
            if (global.pcOrderDetailModel.warrantImg.count > 0)
            {
                NSArray<ZSDynamicDataModel *> *array = self.dataArray[indexPath.section];
                return array[0].cellHeight + 10;
            }
            else{
                return CellHeight;
            }
        }
        else
        {
            return UITableViewAutomaticDimension;
        }
    }
    else
    {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    view.backgroundColor = ZSViewBackgroundColor;
    ZSBaseSectionView *sectionView = [[ZSBaseSectionView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    sectionView.leftLab.text = self.dataTitleArray[section];
    sectionView.bottomLine.hidden = NO;
    //预授信报告 当前登录用户和上次生成预授信报告的人员相符合 才可以进行编辑
    if ([global.pcOrderDetailModel.order.orderState isEqualToString:@"已生成预授信报告"]
        &&[self.dataTitleArray[section] isEqualToString:@"预授信报告"]
        && [global.pcOrderDetailModel.order.preCreditUser isEqualToString:[ZSTool readUserInfo].tid])
    {
        sectionView.rightArrowImgV.hidden = NO;
        sectionView.rightLab.text = @"编辑";
        sectionView.delegate = self;
    }else{
        sectionView.rightArrowImgV.hidden = YES;
        sectionView.rightLab.text = @"";
        sectionView.delegate = nil;
    }
    [view addSubview:sectionView];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataTitleArray[indexPath.section] isEqualToString:@"人员信息"])
    {
        ZSOrderDetailPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[ZSOrderDetailPersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSArray<CustomersModel *> *array = self.dataArray[indexPath.section];
        if (array.count > 0) {
            cell.model = array[indexPath.row];
        }
        return cell;
    }
    else if ([self.dataTitleArray[indexPath.section] isEqualToString:@"房产信息"])
    {
        if (indexPath.row == 0)
        {
            //照片cell不复用
            ZSPCOrderDetailPhotoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell == nil) {
                cell = [[ZSPCOrderDetailPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextWithPhotosCellIdentifier];
                cell.delegate = self;
            }
            NSArray<ZSDynamicDataModel *> *array = self.dataArray[indexPath.section];
            cell.model = array[indexPath.row];
            cell.currentIndex = indexPath.row;
            return cell;
        }
        else
        {
            ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
            if (!cell) {
                cell = [[ZSWSNewLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
            }
            NSArray<ZSOrderModel *> *array = self.dataArray[indexPath.section];
            if (array.count > 0) {
                cell.model = array[indexPath.row];
            }
            return cell;
        }
    }
    else
    {
        ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        if (!cell) {
            cell = [[ZSWSNewLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        }
        NSArray<ZSOrderModel *> *array = self.dataArray[indexPath.section];
        if (array.count > 0) {
            cell.model = array[indexPath.row];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.dataTitleArray[indexPath.section] isEqualToString:@"人员信息"])
    {
        global.currentCustomer = global.pcOrderDetailModel.customers[indexPath.row];
        ZSPCOrderPersonDetailViewController *detailVC = [[ZSPCOrderPersonDetailViewController alloc]init];
        detailVC.prdType = self.prdType;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if ([self.dataTitleArray[indexPath.section] isEqualToString:@"订单信息"])
    {
        if (global.pcOrderDetailModel.order.orderNo)
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = global.pcOrderDetailModel.order.orderNo;
            [ZSTool showMessage:@"订单编号已复制到剪贴板" withDuration:DefaultDuration];
        }
    }
}

#pragma mark 清除sectionHeadr黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 54;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark /*--------------------------ZSCreditSectionViewDelegate 编辑预授信报告--------------------------*/
- (void)tapSection:(NSInteger)sectionIndex
{
    if (global.pcOrderDetailModel.agentPrecredit.canLoan.intValue == 1)
    {
        ZSCreditReportsPopView *reportView = [[ZSCreditReportsPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withType:YES];
        reportView.bankDataArray = self.bankDataArray;
        reportView.sendPersonArray = self.sendPersonArray;
        reportView.delegate = self;
        [reportView show];
    }
    else if (global.pcOrderDetailModel.agentPrecredit.canLoan.intValue == 2)
    {
        ZSCreditReportsPopView *reportView = [[ZSCreditReportsPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withType:NO];
        reportView.bankDataArray = self.bankDataArray;
        reportView.sendPersonArray = self.sendPersonArray;
        reportView.delegate = self;
        [reportView show];
    }
}

#pragma mark /*--------------------------ZSTextWithPhotosTableViewCellDelegate--------------------------*/
//当前cell的高度
- (void)sendCurrentCellHeight:(CGFloat)collectionHeight withIndex:(NSUInteger)currentIndex
{
    //获取房产信息所在的cell数据
    NSMutableArray<ZSDynamicDataModel*> *array;
    if ([self.dataTitleArray containsObject:@"房产信息"]) {
        NSInteger index = [self.dataTitleArray indexOfObject:@"房产信息"];
        array= self.dataArray[index];
    }
    
    //替换数据
    ZSDynamicDataModel *model = array[currentIndex];
    model.cellHeight = collectionHeight;
    [array replaceObjectAtIndex:currentIndex withObject:model];
    
    //刷新当前tableView(只刷新高度)
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark /*---------------------------------------底部按钮和弹窗---------------------------------------*/
- (void)configureBottomBtn
{
    //预授信报告列表过来,待生成预授信报告的
    if (self.lastVC == ZSPreliminaryCreditPageController)
    {
        if ([global.pcOrderDetailModel.order.orderState isEqualToString:@"待生成预授信报告"])
        {
            [self configuBottomBtnsWithTitles:@[@"可贷",@"不可贷"]];
        }
    }
    //中介端跟进列表过来,已生成预授信报告的
    else if (self.lastVC == ZSTheMediationViewController)
    {
        if ([global.pcOrderDetailModel.order.orderState isEqualToString:@"已生成预授信报告"])
        {
            [self configuBottomBtnsWithTitles:@[@"关闭",@"提交订单"]];
        }
    }
    
    //重设tablevIew的高度
    self.tableView.height = self.tableView.height - self.bottomView.height;
}

- (void)bottomClick:(UIButton *)sender
{
    if ([global.pcOrderDetailModel.order.orderState isEqualToString:@"待生成预授信报告"])
    {
        if (self.bankDataArray.count == 0)
        {
            [self getListPrecreditBank];
            [ZSTool showMessage:@"获取贷款银行失败,请稍后重试" withDuration:DefaultDuration];
        }
        else
        {
            if (sender.tag == 0)
            {
                ZSCreditReportsPopView *reportView = [[ZSCreditReportsPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withType:YES];
                reportView.bankDataArray = self.bankDataArray;
                reportView.sendPersonArray = self.sendPersonArray;
                reportView.delegate = self;
                [reportView show];
            }
            else
            {
                ZSCreditReportsPopView *reportView = [[ZSCreditReportsPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withType:NO];
                reportView.bankDataArray = self.bankDataArray;
                reportView.sendPersonArray = self.sendPersonArray;
                reportView.delegate = self;
                [reportView show];
            }
        }
    }
    else if ([global.pcOrderDetailModel.order.orderState isEqualToString:@"已生成预授信报告"])
    {
        if (sender.tag == 0)
        {
            ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"确定要关闭订单吗?" sureTitle:@"确定" cancelTitle:@"取消"];
            alert.delegate = self;
            [alert show];            
        }
        else
        {
            [self submitOrder];
        }
    }
//    else if ([global.pcOrderDetailModel.order.orderState isEqualToString:@"待派单"])
//    {
//        if (self.sendPersonArray.count == 0) {
//            [ZSTool showMessage:@"暂无可派单人员" withDuration:DefaultDuration];
//            return;
//        }
//        ZSSendOrderPopView *sendView = [[ZSSendOrderPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:self.sendPersonArray];
//        sendView.delegate = self;
//        [sendView show];
//    }
}

#pragma mark /*------------------------------------------提交预授信报告------------------------------------------*/
- (void)sendData:(ZSCreditReportModel *)model;
{
    [LSProgressHUD showToView:self.view message:@"请求中..."];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                  @"prdType":self.prdType,
                                  @"canLoan":model.canLoan,
                                  }.mutableCopy;
    if (model.custQualification) {
        [dict setObject:model.custQualification forKey:@"custQualification"];
    }
    if (model.evaluationAmount) {
        [dict setObject:model.evaluationAmount forKey:@"evaluationAmount"];
    }
    if (model.maxCreditLimit) {
        [dict setObject:model.maxCreditLimit forKey:@"maxCreditLimit"];
    }
    if (model.loanBankId) {
        [dict setObject:model.loanBankId forKey:@"loanBankId"];
    }
    if (model.loanRate) {
        [dict setObject:model.loanRate forKey:@"loanRate"];
    }
    if (model.remark) {
        [dict setObject:model.remark forKey:@"remark"];
    }
    if (model.customerManager) {
        [dict setObject:model.customerManager forKey:@"customerManager"];
    }
    
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager submitPrecredit] SuccessBlock:^(NSDictionary *dic) {
        [ZSTool showMessage:@"提交成功" withDuration:DefaultDuration];
        //首次生成预授信报告的返回上级页面,并刷新订单列表
        if ([global.pcOrderDetailModel.order.orderState isEqualToString:@"待生成预授信报告"])
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        }
        //编辑预授信报告就停留在该页面, 刷新数据即可
        else
        {
            [weakSelf requestData];
        }
        [LSProgressHUD hideForView:self.view];
    } ErrorBlock:^(NSError *error) {
        [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
        [LSProgressHUD hideForView:self.view];
    }];
}

#pragma mark /*------------------------------------------中介端跟进关闭/提交订单------------------------------------------*/
#pragma mark 关闭订单
- (void)AlertView:(ZSAlertView *)alert;//确认按钮响应的方法
{
    [LSProgressHUD showToView:self.view message:@"请求中..."];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                  @"prdType":self.prdType,
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager cancelPrecreditOrderURL] SuccessBlock:^(NSDictionary *dic) {
        [ZSTool showMessage:@"关闭成功" withDuration:DefaultDuration];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [LSProgressHUD hideForView:self.view];
    } ErrorBlock:^(NSError *error) {
        [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
        [LSProgressHUD hideForView:self.view];
    }];
}

#pragma mark 提交订单
- (void)submitOrder
{
    [LSProgressHUD showToView:self.view message:@"请求中..."];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                  @"prdType":self.prdType,
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager confirmPrecreditOrderURL] SuccessBlock:^(NSDictionary *dic) {
        [ZSTool showMessage:@"提交成功" withDuration:DefaultDuration];
        //进入到人员列表页
        ZSSLPersonListViewController *vc = [[ZSSLPersonListViewController alloc]init];
        vc.orderState = @"暂存";
        vc.orderIDString = weakSelf.orderIDString.length ? weakSelf.orderIDString : [ZSGlobalModel getOrderID:self.prdType];
        vc.prdType = self.prdType;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        //列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [LSProgressHUD hideForView:self.view];
    } ErrorBlock:^(NSError *error) {
        [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
        [LSProgressHUD hideForView:self.view];
    }];
}

//#pragma mark /*------------------------------------------提交派单------------------------------------------*/
//#pragma mark 提交派单
//- (void)selectWithData:(ZSSendOrderPersonModel *)model
//{
//    //存值
//    self.idString = model.tid;
//
//    //弹窗
//    CustomersModel *customerModel = global.pcOrderDetailModel.customers.firstObject;
//    NSString *string = [NSString stringWithFormat:@"是否确定把客户%@的订单派发给%@%@？",customerModel.name,model.rolename,model.username];
//    ZSNotificationDetailView *detailView = [[ZSNotificationDetailView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withTitle:@"派单确认" withContent:string withLeftBtnTitle:@"取消" withRightBtnTitle:@"确认"];
//    detailView.delegate = self;
//    [detailView show];
//}
//
//- (void)sureClick:(ZSNotificationDetailView *)noticeView;
//{
//    [LSProgressHUD showToView:self.view message:@"请求中..."];
//
//    __weak typeof(self) weakSelf = self;
//    NSMutableDictionary *dict = @{}.mutableCopy;
//    //接受派单的人员id
//    [dict setObject:self.idString forKey:@"receiveDistributeUserId"];
//    //订单信息
//    NSDictionary *infoDic = @{
//                              @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
//                              @"prdType":self.prdType,
//                              };
//    NSArray *infoArray = @[infoDic];
//    NSString *orderInfo = [NSString arrayToJsonString:infoArray];
//    [dict setValue:orderInfo forKey:@"orderInfo"];
//
//    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager submitDistributeBatch] SuccessBlock:^(NSDictionary *dic) {
//        [ZSTool showMessage:@"派单成功" withDuration:DefaultDuration];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//        //列表刷新
//        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
//    [LSProgressHUD hideForView:self.view];
//    } ErrorBlock:^(NSError *error) {
//        [ZSTool showMessage:@"请求失败,请重试" withDuration:DefaultDuration];
//    [LSProgressHUD hideForView:self.view];
//    }];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
