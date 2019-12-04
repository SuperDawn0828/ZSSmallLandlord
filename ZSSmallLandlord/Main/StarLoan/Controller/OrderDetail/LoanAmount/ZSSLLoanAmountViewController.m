//
//  ZSSLLoanAmountViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/27.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLLoanAmountViewController.h"
#import "ZSSLAddLoanMaterialViewController.h"
#import "ZSSLAddHouseMaterialViewController.h"
#import "ZSCHAddHouseMaterialViewController.h"
#import "ZSRFAddLoanMaterialViewController.h"
#import "ZSMLAddLoanMaterialViewController.h"
#import "ZSELAddLoanMaterialViewController.h"
#import "ZSCHAddLoanMaterialViewController.h"
#import "ZSELAddLoanMaterialViewController.h"
#import "ZSBaseSectionView.h"
#import "ZSWSNewLeftRightCell.h"

@interface ZSSLLoanAmountViewController ()<ZSCreditSectionViewDelegate>
@property(nonatomic,strong)NSMutableArray *sectionTitleArray;        //区头数组
@property(nonatomic,strong)NSMutableArray *loanAmountArray;          //按揭贷款信息数组
@property(nonatomic,strong)NSMutableArray *houseInfomationArray;     //房产信息数组
@property(nonatomic,strong)NSMutableArray *rightLoanAmountArray;     //右边按揭贷款信息数组
@property(nonatomic,strong)NSMutableArray *rightHouseInfomationArray;//右边房产信息数组
@property(nonatomic,assign)NSInteger      count;
@end

@implementation ZSSLLoanAmountViewController

- (NSMutableArray *)loanAmountArray
{
    if (_loanAmountArray == nil){
        _loanAmountArray = [[NSMutableArray alloc]init];
    }
    return _loanAmountArray;
}

- (NSMutableArray *)houseInfomationArray
{
    if (_houseInfomationArray == nil){
        _houseInfomationArray = [[NSMutableArray alloc]init];
    }
    return _houseInfomationArray;
}

- (NSMutableArray *)rightLoanAmountArray
{
    if (_rightLoanAmountArray == nil){
        _rightLoanAmountArray = [[NSMutableArray alloc]init];
    }
    return _rightLoanAmountArray;
}

- (NSMutableArray *)rightHouseInfomationArray
{
    if (_rightHouseInfomationArray== nil){
        _rightHouseInfomationArray = [[NSMutableArray alloc]init];
    }
    return _rightHouseInfomationArray;
}

#pragma mark 禁止返回手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"贷款信息";
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight) withStyle:UITableViewStyleGrouped];
    self.glt_scrollView = self.tableView;
    [self registerCell];
    [self addHeader];
    //Data
    [self initDatas];
    //刷新详情数据通知
    [NOTI_CENTER addObserver:self selector:@selector(initDatas) name:kOrderDetailFreshDataNotification object:nil];
}

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
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        NSMutableDictionary *parameter=  @{
                                           @"orderNo":global.slOrderDetails.spdOrder.tid
                                           }.mutableCopy;
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
        NSMutableDictionary *parameter=  @{
                                            @"orderNo":global.rfOrderDetails.redeemOrder.tid,
                                            }.mutableCopy;
        [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getRedeemFloorQueryOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
            //赋值
            global.rfOrderDetails = [ZSRFOrderDetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //刷新tableview
            [weakSelf initDatas];
        } ErrorBlock:^(NSError *error) {
            [weakSelf endRefresh:weakSelf.tableView array:nil];
        }];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        NSMutableDictionary *parameter=  @{
                                           @"orderNo":global.mlOrderDetails.dydOrder.tid,
                                           }.mutableCopy;
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
        NSMutableDictionary *parameter=  @{
                                           @"orderNo":global.elOrderDetails.easyOrder.tid,
                                           }.mutableCopy;
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
        NSMutableDictionary *parameter=  @{
                                           @"orderNo":global.chOrderDetails.cwfqOrder.tid,
                                           }.mutableCopy;
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
}

#pragma mark 刷新详情数据通知(赋值)
- (void)initDatas
{
    //星速贷和代办业务
    if ([self.prdType isEqualToString:kProduceTypeStarLoan] || [self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        self.sectionTitleArray = @[@"按揭贷款信息",@"房产信息"].mutableCopy;
        self.loanAmountArray = @[@"贷款银行",@"合同总价",@"贷款金额",@"首付金额",@"贷款年限",@"贷款利率",@"还款方式",@"贷款种类"].mutableCopy;
        self.houseInfomationArray = @[@"楼盘名称",@"楼盘地址",@"楼栋房号",@"权证号",@"房屋功能",@"建筑面积",@"套内面积"].mutableCopy;
//        self.houseInfomationArray = @[@"楼盘名称",@"楼盘地址",@"楼栋房号",@"权证号",@"房屋功能",@"建筑面积",@"套内面积",@"评估单价",@"评估总价"].mutableCopy;

        //贷款信息model
        SpdOrder *model = [self.prdType isEqualToString:kProduceTypeStarLoan] ? global.slOrderDetails.spdOrder : global.abOrderDetails.insteadOrder;
        //合同总价
        NSString *contractAmount = model.contractAmount.length > 0 ? [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.contractAmount]]: @"元";
        //贷款金额
        NSString *loanAmount = model.loanAmount.length > 0 ? [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.loanAmount]] : @"元";
        //首付金额
        NSString *payAmount = @"";
        if (model.contractAmount.length > 0 && model.loanAmount.length > 0){
            NSString *payString = [ZSTool calculateNumWithTheNum:model.contractAmount ortherNum:model.loanAmount];
            payAmount =  payString.length > 0 ? [NSString stringWithFormat:@"%@元",[NSString ReviseString:payString]]: @"元";
        }
        //贷款利率
        NSString *rateAmount = model.loanRate.length > 0 ? [NSString stringWithFormat:@"%@%@",[NSString ReviseString:model.loanRate WithDigits:4],@"%"] : @"%";
        //楼盘地址
        NSString *addressDetail = [NSString stringWithFormat:@"%@%@%@%@",model.province.length > 0 ? model.province : @""
                                   ,model.city.length > 0 ? model.city : @""
                                   ,model.area.length > 0 ? model.area : @""
                                   ,model.address.length > 0 ? model.address : @""];
        //贷款信息右边赋值
        self.rightLoanAmountArray = @[
                                      [NSString stringWithFormat:@"%@",SafeStr(model.loanBank2)], //贷款银行
                                      contractAmount,           //合同总价
                                      loanAmount,               //贷款金额
                                      payAmount,                //首付金额
                                      [NSString stringWithFormat:@"%@年",SafeStr(model.loanLimit)],//贷款年限
                                      rateAmount,                //贷款利率
                                      [NSString stringWithFormat:@"%@",SafeStr(model.loanType)],   //还款方式
                                      [NSString stringWithFormat:@"%@",SafeStr(model.loanCategory)]//贷款种类
                                      ].mutableCopy;
        //房产信息右边赋值
        self.rightHouseInfomationArray = @[
                                           [NSString stringWithFormat:@"%@",SafeStr(model.projName)],         //楼盘名称
                                           [NSString stringWithFormat:@"%@",addressDetail],                   //楼盘地址
                                           [NSString stringWithFormat:@"%@",SafeStr(model.houseNum)],         //楼栋房号
                                           [NSString stringWithFormat:@"%@",SafeStr(model.warrantNo)],        //权证号
                                           [NSString stringWithFormat:@"%@",SafeStr(model.housingFunction)],  //房屋功能
                                           [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.coveredArea])],    //建筑面积
                                           [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.insideArea])],     //套内面积
//                                           [NSString stringWithFormat:@"%@元/㎡",SafeStr([NSString ReviseString:model.evaluePrice])], //评估单价
//                                           [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.evalueTotalPrice])]//评估总价
                                           ].mutableCopy;
        
        //刷新
        [self resetTableViewHeight];
        [self.tableView reloadData];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        self.sectionTitleArray = @[@"贷款信息",@"房产信息"].mutableCopy;
        self.loanAmountArray = @[@"资金来源",@"贷款金额",@"贷款利率",@"还款方式",@"原按揭银行",@"按揭剩余应还"].mutableCopy;
        self.houseInfomationArray = @[@"楼盘名称",@"楼盘地址",@"楼栋房号",@"权证号",@"房屋功能",@"建筑面积",@"套内面积"].mutableCopy;
//        self.houseInfomationArray = @[@"楼盘名称",@"楼盘地址",@"楼栋房号",@"权证号",@"房屋功能",@"建筑面积",@"套内面积",@"评估单价",@"评估总价"].mutableCopy;
        
        //贷款信息model
        SpdOrder *model = global.rfOrderDetails.redeemOrder;
        //资金来源(自有资金的时候不显示贷款银行)
        NSString *fundSource;
        if ([SafeStr(model.fundSource) isEqualToString:@"1"]) {
            fundSource = @"银行资金";
            [self.loanAmountArray insertObject:@"贷款银行" atIndex:1];
        }
        else{
            fundSource = @"自有资金";
        }
        //贷款金额
        NSString *loanAmount = model.advanceAmount ? [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.advanceAmount]] : @"元";
        //贷款利率
        NSString *loanRate = model.loanRate ? [NSString stringWithFormat:@"%@%@",[NSString ReviseString:model.loanRate WithDigits:4],@"%"] : @"%";
        //还款方式
        NSString *loanType = model.loanType ? [NSString stringWithFormat:@"%@",SafeStr(model.loanType)] : @"";
        //原按揭银行
        NSString *repayBank = model.repayBank ? [NSString stringWithFormat:@"%@",SafeStr(model.repayBank)] : @"";
        //按揭剩余应还
        NSString *contractAmount = model.loanleftAmount ? [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.loanleftAmount]] : @"元";
        //楼盘地址
        NSString *addressDetail = [NSString stringWithFormat:@"%@%@%@%@",model.province.length > 0 ? model.province : @""
                                   ,model.city.length > 0 ? model.city : @""
                                   ,model.area.length > 0 ? model.area : @""
                                   ,model.address.length > 0 ? model.address : @""];
        //贷款信息右边赋值
        self.rightLoanAmountArray = @[
                                      fundSource,
                                      loanAmount,
                                      loanRate,
                                      loanType,
                                      repayBank,
                                      contractAmount
                                      ].mutableCopy;
        if ([fundSource isEqualToString:@"银行资金"]) {
            [self.rightLoanAmountArray insertObject:[NSString stringWithFormat:@"%@",SafeStr(model.loanBank)] atIndex:1];
        }
        //房产信息右边赋值
        self.rightHouseInfomationArray = @[
                                           [NSString stringWithFormat:@"%@",SafeStr(model.projName)],          //楼盘名称
                                           [NSString stringWithFormat:@"%@",addressDetail],                    //楼盘地址
                                           [NSString stringWithFormat:@"%@",SafeStr(model.houseNum)],          //楼栋房号
                                           [NSString stringWithFormat:@"%@",SafeStr(model.warrantNo)],         //权证号
                                           [NSString stringWithFormat:@"%@",SafeStr(model.housingFunction)],   //房屋功能
                                           [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.coveredArea])],     //建筑面积
                                           [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.insideArea])],      //套内面积
//                                           [NSString stringWithFormat:@"%@元/㎡",SafeStr([NSString ReviseString:model.evaluePrice])],  //评估单价
//                                           [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.evalueTotalPrice])] //评估总价
                                           ].mutableCopy;
        
        //刷新
        [self resetTableViewHeight];
        [self.tableView reloadData];
    }
    //抵押贷或融易贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan] || [self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        self.sectionTitleArray = @[@"按揭贷款信息",@"房产信息"].mutableCopy;
        self.loanAmountArray = @[@"贷款银行",@"贷款金额",@"贷款年限",@"贷款利率",@"还款方式"].mutableCopy;
        self.houseInfomationArray = @[@"楼盘名称",@"楼盘地址",@"楼栋房号",@"权证号",@"房屋功能",@"建筑面积",@"套内面积"].mutableCopy;
//        self.houseInfomationArray = @[@"楼盘名称",@"楼盘地址",@"楼栋房号",@"权证号",@"房屋功能",@"建筑面积",@"套内面积",@"评估单价",@"评估总价"].mutableCopy;
        
        //贷款信息model
        SpdOrder *model = global.mlOrderDetails.dydOrder;
        //贷款银行
        NSString *loanBank = model.loanBank2.length > 0 ? model.loanBank2 : @"";
        //贷款金额
        NSString *loanAmount = model.loanAmount.length > 0 ? [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.loanAmount]] : @"元";
        //贷款利率
        NSString *rateAmount = model.loanRate.length > 0 ? [NSString stringWithFormat:@"%@%@",[NSString ReviseString:model.loanRate WithDigits:4],@"%"] : @"%";
        //楼盘地址
        NSString *addressDetail = [NSString stringWithFormat:@"%@%@%@%@",model.province.length > 0 ? model.province : @""
                                   ,model.city.length > 0 ? model.city : @""
                                   ,model.area.length > 0 ? model.area : @""
                                   ,model.address.length > 0 ? model.address : @""];
        //贷款信息右边赋值
        self.rightLoanAmountArray = @[loanBank,
                                      loanAmount,
                                      [NSString stringWithFormat:@"%@年",SafeStr(model.loanLimit)],//贷款年限
                                      rateAmount,
                                      [NSString stringWithFormat:@"%@",SafeStr(model.loanType)],//还款方式
                                      ].mutableCopy;
        //房产信息右边赋值
        self.rightHouseInfomationArray = @[
                                           [NSString stringWithFormat:@"%@",SafeStr(model.projName)],          //楼盘名称
                                           [NSString stringWithFormat:@"%@",addressDetail],                    //楼盘地址
                                           [NSString stringWithFormat:@"%@",SafeStr(model.houseNum)],          //楼栋房号
                                           [NSString stringWithFormat:@"%@",SafeStr(model.warrantNo)],         //权证号
                                           [NSString stringWithFormat:@"%@",SafeStr(model.housingFunction)],   //房屋功能
                                           [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.coveredArea])],     //建筑面积
                                           [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.insideArea])],      //套内面积
//                                           [NSString stringWithFormat:@"%@元/㎡",SafeStr([NSString ReviseString:model.evaluePrice])],  //评估单价
//                                           [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.evalueTotalPrice])] //评估总价
                                           ].mutableCopy;
        
        //刷新
        [self resetTableViewHeight];
        [self.tableView reloadData];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        self.sectionTitleArray = @[@"按揭贷款信息",@"车位信息"].mutableCopy;
        self.loanAmountArray = @[@"贷款银行",@"合同总价",@"贷款金额",@"首付金额",@"贷款年限",@"贷款利率",@"还款方式",@"贷款种类"].mutableCopy;
        self.houseInfomationArray = @[@"楼盘名称",@"车位面积"].mutableCopy;

        //贷款信息model
        SpdOrder *model = global.chOrderDetails.cwfqOrder;
        //合同总价
        NSString *contractAmount = model.contractAmount.length > 0 ? [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.contractAmount ]]: @"元";
        //贷款金额
        NSString *loanAmount = model.loanAmount.length > 0 ? [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.loanAmount]] : @"元";
        //首付金额
        NSString *payAmount = model.downpayAmount.doubleValue > 0 ? [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.downpayAmount]] : @"元";
        //贷款利率
        NSString *rateAmount = model.loanRate.length > 0 ? [NSString stringWithFormat:@"%@%@",[NSString ReviseString:model.loanRate WithDigits:4],@"%"] : @"%";
        //贷款信息右边赋值
        self.rightLoanAmountArray = @[
                                      [NSString stringWithFormat:@"%@",SafeStr(model.loanBank2)],
                                      contractAmount,
                                      loanAmount,
                                      payAmount,
                                      [NSString stringWithFormat:@"%@年",SafeStr(model.loanLimit)],
                                      rateAmount,
                                      [NSString stringWithFormat:@"%@",SafeStr(model.loanType)],
                                      [NSString stringWithFormat:@"%@",SafeStr(model.loanCategory)]
                                      ].mutableCopy;
        //车位信息右边赋值
        self.rightHouseInfomationArray = @[
                                           [NSString stringWithFormat:@"%@",SafeStr(model.projName)],
                                           [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.parkArea])]
                                           ].mutableCopy;
        
        //刷新
        [self resetTableViewHeight];
        [self.tableView reloadData];
    }
}

#pragma mark 注册单元格
- (void)registerCell
{
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.1)];
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerNib:[UINib nibWithNibName:KReuseZSWSNewLeftRightCellIdentifier bundle:nil] forCellReuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  section == 0 ? self.loanAmountArray.count : self.houseInfomationArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell : ZSColorWhite;
    cell.rightTextField.userInteractionEnabled = NO;
    if (indexPath.section == 0)
    {
        cell.leftLab.text = self.loanAmountArray[indexPath.row];
        cell.rightLab.text = self.rightLoanAmountArray[indexPath.row];
    }
    else
    {
        cell.leftLab.text = self.houseInfomationArray[indexPath.row];
        cell.rightLab.text = self.rightHouseInfomationArray[indexPath.row];
    }
    return cell;
}

#pragma mark 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark 区头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    view.backgroundColor = ZSViewBackgroundColor;
    ZSBaseSectionView *sectionView = [[ZSBaseSectionView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    sectionView.backgroundColor = ZSColorWhite;
    sectionView.bottomLine.hidden = NO;
    sectionView.bottomLine.left = 0;
    sectionView.bottomLine.width = ZSWIDTH;
    sectionView.leftLab.text = self.sectionTitleArray[section];
    sectionView.tag = section;
    sectionView.rightLab.text = @"编辑";
    sectionView.rightLab.hidden = YES;
    sectionView.rightArrowImgV.hidden = YES;
    [view addSubview:sectionView];
    
    //只有订单创建人才可以编辑
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType])
    {
        //星速贷
        if ([self.prdType isEqualToString:kProduceTypeStarLoan])
        {
            if (global.slOrderDetails.isOrder.intValue == 1){
                sectionView.delegate = self;
                sectionView.rightLab.hidden = NO;
                sectionView.rightArrowImgV.hidden = NO;
            }
        }
        //赎楼宝
        else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
        {
            if (global.rfOrderDetails.isOrder.intValue == 1){
                sectionView.delegate = self;
                sectionView.rightLab.hidden = NO;
                sectionView.rightArrowImgV.hidden = NO;
            }
        }
        //抵押贷
        else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
        {
            if (global.mlOrderDetails.isOrder.intValue == 1){
                sectionView.delegate = self;
                sectionView.rightLab.hidden = NO;
                sectionView.rightArrowImgV.hidden = NO;
            }
        }
        //融易贷
        else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
        {
            if (global.elOrderDetails.isOrder.intValue == 1){
                sectionView.delegate = self;
                sectionView.rightLab.hidden = NO;
                sectionView.rightArrowImgV.hidden = NO;
            }
        }
        //车位分期
        else if ([self.prdType isEqualToString:kProduceTypeCarHire])
        {
            if (global.chOrderDetails.isOrder.intValue == 1){
                sectionView.delegate = self;
                sectionView.rightLab.hidden = NO;
                sectionView.rightArrowImgV.hidden = NO;
            }
        }
        //代办业务
        else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
        {
            if (global.abOrderDetails.isOrder.intValue == 1){
                sectionView.delegate = self;
                sectionView.rightLab.hidden = NO;
                sectionView.rightArrowImgV.hidden = NO;
            }
        }
    }
    return view;
}

#pragma mark 区头代理
- (void)tapSection:(NSInteger)sectionIndex
{
    //按揭贷款资料编辑
    if (sectionIndex == 0)
    {
        //星速贷和代办业务
        if ([self.prdType isEqualToString:kProduceTypeStarLoan] || [self.prdType isEqualToString:kProduceTypeAgencyBusiness])
        {
            ZSSLAddLoanMaterialViewController *vc = [[ZSSLAddLoanMaterialViewController alloc]init];
            vc.prdType = self.prdType;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //赎楼宝
        else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
        {
            ZSRFAddLoanMaterialViewController *vc = [[ZSRFAddLoanMaterialViewController alloc]init];
            vc.prdType = self.prdType;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //抵押贷
        else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
        {
            ZSMLAddLoanMaterialViewController *vc = [[ZSMLAddLoanMaterialViewController alloc]init];
            vc.prdType = self.prdType;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //融易贷
        else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
        {
            ZSELAddLoanMaterialViewController *vc = [[ZSELAddLoanMaterialViewController alloc]init];
            vc.prdType = self.prdType;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //车位分期
        else if ([self.prdType isEqualToString:kProduceTypeCarHire])
        {
            ZSCHAddLoanMaterialViewController *vc = [[ZSCHAddLoanMaterialViewController alloc]init];
            vc.prdType = self.prdType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        //车位分期
        if ([self.prdType isEqualToString:kProduceTypeCarHire])
        {
            //车位信息
            ZSCHAddHouseMaterialViewController *vc = [[ZSCHAddHouseMaterialViewController alloc]init];
            vc.prdType = self.prdType;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //房产信息编辑
            ZSSLAddHouseMaterialViewController *vc = [[ZSSLAddHouseMaterialViewController alloc]init];
            vc.prdType = self.prdType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

@end
