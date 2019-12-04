//
//  ZSWSProjrctMaterialViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSProjrctMaterialViewController.h"
#import "ZSBaseSectionView.h"
#import "ZSWSLoanMaterialViewController.h"
#import "ZSWSHouseMaterialViewController.h"
#import "ZSWSNewLeftRightCell.h"
@interface ZSWSProjrctMaterialViewController ()<ZSCreditSectionViewDelegate>
@property(nonatomic,strong)NSMutableArray *sectionTitleArray;        //区头数组
@property(nonatomic,strong)NSMutableArray *loanAmountArray;          //按揭贷款信息数组
@property(nonatomic,strong)NSMutableArray *houseInfomationArray;     //房产信息数组
@property(nonatomic,strong)NSMutableArray *rightLoanAmountArray;     //右边按揭贷款信息数组
@property(nonatomic,strong)NSMutableArray *rightHouseInfomationArray;//右边房产信息数组
//@property(nonatomic,assign)NSInteger      count;
@end

@implementation ZSWSProjrctMaterialViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"项目资料";
    [self configureTableView:CGRectMake(0, 44, ZSWIDTH, ZSHEIGHT-64-44) withStyle:UITableViewStyleGrouped];
    self.glt_scrollView = self.tableView;
    [self registerCell];
//    [self addHeader];
    //Data
    [self initDatas];
    [NOTI_CENTER addObserver:self selector:@selector(initDatas) name:kOrderDetailFreshDataNotification object:nil];
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

#pragma mark 填充数据
- (void)initDatas
{
    //区头
    self.sectionTitleArray = @[@"按揭贷款资料",@"房产信息"].mutableCopy;
    //按揭贷款信息
    self.loanAmountArray   = @[@"合同总价",@"贷款金额",@"首付金额",@"贷款年限",@"贷款利率",@"还款方式",@"贷款种类",@"贷款银行"].mutableCopy;
    //房产信息
    self.houseInfomationArray = @[@"项目名称",@"预售建筑面积",@"预售套内面积",@"房屋功能",@"楼栋房号"].mutableCopy;
    
    ProjectInfo *model = global.wsOrderDetail.projectInfo;
    //合同总价
    NSString *contractAmount = model.contractAmount.length > 0 ? [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.contractAmount]] : @"元";
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
    //按揭贷款信息右边赋值
    self.rightLoanAmountArray = @[contractAmount,
                                  loanAmount,
                                  payAmount,
                                  [NSString stringWithFormat:@"%@年",SafeStr(model.loanLimit)],
                                  rateAmount,
                                  SafeStr(model.loanType),
                                  SafeStr(model.loanCategory),
                                  SafeStr(model.loanBank)
                                  ].mutableCopy;
    //房产信息右边赋值
    self.rightHouseInfomationArray = @[SafeStr(model.projName),
                                       [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.coveredArea])],
                                       [NSString stringWithFormat:@"%@㎡",SafeStr([NSString ReviseString:model.insideArea])],
                                       SafeStr(model.housingFunction),
                                       SafeStr(model.houseNum)
                                       ].mutableCopy;
    
    [self.tableView reloadData];
}

#pragma mark 注册单元格
- (void)registerCell
{
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.1)];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:KReuseZSWSNewLeftRightCellIdentifier bundle:nil] forCellReuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  section == 0 ? self.loanAmountArray.count:self.houseInfomationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
    cell.rightTextField.userInteractionEnabled = NO;
    cell.rightTextField.hidden = YES;
    if (indexPath.section == 0){
        cell.leftLab.text = self.loanAmountArray[indexPath.row];
        cell.rightLab.text = self.rightLoanAmountArray[indexPath.row];
    }else{
        cell.leftLab.text = self.houseInfomationArray[indexPath.row];
        cell.rightLab.text = self.rightHouseInfomationArray[indexPath.row];
    }
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell : ZSColorWhite;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

#pragma mark 区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    view.backgroundColor = ZSViewBackgroundColor;
    ZSBaseSectionView *sectionView = [[ZSBaseSectionView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    sectionView.backgroundColor = ZSColorWhite;
    sectionView.bottomLine.hidden = NO;
    sectionView.bottomLine.left = 0;
    sectionView.bottomLine.width = ZSWIDTH;
    [view addSubview:sectionView];
    sectionView.tag = section;
    NSArray *leftSectionArr = @[@"按揭贷款资料",@"房产信息"].copy;
    sectionView.leftLab.text = leftSectionArr[section];
    sectionView.rightLab.text = @"编辑";
    //已完成和已操作的单子不能操作
    if ([ZSTool checkWitnessServerOrderIsCanEditing]){
        sectionView.delegate = self;
        sectionView.rightLab.hidden = NO;
        sectionView.rightArrowImgV.hidden = NO;
    }else{
        sectionView.rightLab.hidden = YES;
        sectionView.rightArrowImgV.hidden = YES;
    }
    return view;
}

#pragma mark 区头代理
- (void)tapSection:(NSInteger)sectionIndex
{
        if (sectionIndex==0) {
        ZSWSLoanMaterialViewController *vc = [[ZSWSLoanMaterialViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {//查看银行征信
        ZSWSHouseMaterialViewController *vc = [[ZSWSHouseMaterialViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

@end
