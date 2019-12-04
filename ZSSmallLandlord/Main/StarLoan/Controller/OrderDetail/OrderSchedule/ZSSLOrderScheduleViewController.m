//
//  ZSSLOrderScheduleViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/27.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLOrderScheduleViewController.h"
#import "ZSSLOrderScheduleCell.h"

@interface ZSSLOrderScheduleViewController ()<ZSSLOrderScheduleCellDelegate>
@property(nonatomic,assign)NSInteger      count;
@end

@implementation ZSSLOrderScheduleViewController

#pragma mark 禁止返回手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"订单进度";
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight) withStyle:UITableViewStylePlain];
    self.glt_scrollView = self.tableView;
    [self resisterCell];
    [self addHeader];
    //Data
    if (global.slOrderDetails || global.rfOrderDetails || global.mlOrderDetails || global.chOrderDetails || global.abOrderDetails) {
        [self initDatas];//已经有数据了直接赋值
    }
    else {
        [self requestOrderDetail];
    }
    //刷新详情数据通知
    [NOTI_CENTER addObserver:self selector:@selector(requestOrderDetail) name:kOrderDetailFreshDataNotification object:nil];
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
    NSMutableDictionary *parameter = @{@"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],}.mutableCopy;
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

#pragma mark 刷新详情数据通知
- (void)initDatas
{    
    //刷新tableview
    [self resetTableViewHeight];
    [self.tableView reloadData];
}

#pragma mark 注册单元格
- (void)resisterCell
{
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    self.tableView.estimatedRowHeight = 98;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpdOrderStates *model;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        model = global.slOrderDetails.spdOrderStates[indexPath.row];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        model = global.rfOrderDetails.redeemOrderStates[indexPath.row];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        model = global.mlOrderDetails.dydOrderStates[indexPath.row];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        model = global.elOrderDetails.easyOrderStates[indexPath.row];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        model = global.chOrderDetails.cwfqOrderStates[indexPath.row];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        model = global.abOrderDetails.insteadOrderStates[indexPath.row];
    }
    
    //提交资料类/添加备注类
    if ([SafeStr(model.note_type) isEqualToString:@"DOC"] || [SafeStr(model.note_type) isEqualToString:@"ADD"])
    {
        return UITableViewAutomaticDimension;
    }
    //审批类
    else if ([SafeStr(model.note_type) isEqualToString:@"AUD"])
    {
        if (model.remark.length > 0 && model.isOpen){
            return UITableViewAutomaticDimension;
        }else if (model.result.length > 0){
            return 98;
        }else{
            return 72;
        }
    }
    else
    {
        if ([model.node containsString:@"已关闭"])
        {
            //已关闭订单
            if (model.remark.length > 0 && model.isOpen){
                return UITableViewAutomaticDimension;
            }else if (model.result.length > 0){
                return 98;
            }else{
                return 72;
            }
        }
        else
        {
            //其他
            return 70;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan]) {
        return global.slOrderDetails.spdOrderStates.count;
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        return global.rfOrderDetails.redeemOrderStates.count;
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        return global.mlOrderDetails.dydOrderStates.count;
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        return global.elOrderDetails.easyOrderStates.count;
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        return global.chOrderDetails.cwfqOrderStates.count;
    }
    //代办业务
    else
    {
        return global.abOrderDetails.insteadOrderStates.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSSLOrderScheduleCell  *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil){
        cell = [[NSBundle mainBundle]loadNibNamed:KReuseZSSLOrderScheduleCellIdentifier owner:self options:nil][0];
    }
    
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan]) {
        SpdOrderStates *model = global.slOrderDetails.spdOrderStates[indexPath.row];
        cell.model = model;
        cell.delegate = self;
        cell.userInteractionEnabled = YES;
        [cell setCellDataWithModelWithindexth:indexPath model:model];
        //最下面一行
        if (global.slOrderDetails.spdOrderStates.count > 0) {
            if (indexPath.row == global.slOrderDetails.spdOrderStates.count - 1) {
                cell.bottomView.hidden = YES;
            }
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        SpdOrderStates *model = global.rfOrderDetails.redeemOrderStates[indexPath.row];
        cell.model = model;
        cell.delegate = self;
        [cell setCellDataWithModelWithindexth:indexPath model:model];
        //最下面一行
        if (global.rfOrderDetails.redeemOrderStates.count > 0){
            if (indexPath.row == global.rfOrderDetails.redeemOrderStates.count - 1) {
                cell.bottomView.hidden = YES;
            }
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        SpdOrderStates *model = global.mlOrderDetails.dydOrderStates[indexPath.row];
        cell.model = model;
        cell.delegate = self;
        [cell setCellDataWithModelWithindexth:indexPath model:model];
        //最下面一行
        if (global.mlOrderDetails.dydOrderStates.count > 0){
            if (indexPath.row == global.mlOrderDetails.dydOrderStates.count - 1) {
                cell.bottomView.hidden = YES;
            }
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        SpdOrderStates *model = global.elOrderDetails.easyOrderStates[indexPath.row];
        cell.model = model;
        cell.delegate = self;
        [cell setCellDataWithModelWithindexth:indexPath model:model];
        //最下面一行
        if (global.elOrderDetails.easyOrderStates.count > 0){
            if (indexPath.row == global.elOrderDetails.easyOrderStates.count - 1) {
                cell.bottomView.hidden = YES;
            }
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        SpdOrderStates *model = global.chOrderDetails.cwfqOrderStates[indexPath.row];
        cell.model = model;
        cell.delegate = self;
        [cell setCellDataWithModelWithindexth:indexPath model:model];
        //最下面一行
        if (global.chOrderDetails.cwfqOrderStates.count > 0){
            if (indexPath.row == global.chOrderDetails.cwfqOrderStates.count - 1) {
                cell.bottomView.hidden = YES;
            }
        }
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        SpdOrderStates *model = global.abOrderDetails.insteadOrderStates[indexPath.row];
        cell.model = model;
        cell.delegate = self;
        [cell setCellDataWithModelWithindexth:indexPath model:model];
        //最下面一行
        if (global.chOrderDetails.cwfqOrderStates.count > 0){
            if (indexPath.row == global.abOrderDetails.insteadOrderStates.count - 1) {
                cell.bottomView.hidden = YES;
            }
        }
    }
    
    return cell;
}

#pragma mark 展开隐藏按钮点击事件
- (void)currentOpenAndCloseBtnClick:(NSInteger)tag
{
    SpdOrderStates *model;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        model = global.slOrderDetails.spdOrderStates[tag];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        model = global.rfOrderDetails.redeemOrderStates[tag];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        model = global.mlOrderDetails.dydOrderStates[tag];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        model = global.elOrderDetails.easyOrderStates[tag];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        model = global.chOrderDetails.cwfqOrderStates[tag];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        model = global.abOrderDetails.insteadOrderStates[tag];
    }
    
    NSIndexPath *inpath         = [NSIndexPath indexPathForRow:tag inSection:0];
    ZSSLOrderScheduleCell *cell = [self.tableView cellForRowAtIndexPath:inpath];
    cell.isOpen  = !cell.isOpen;
    model.isOpen = cell.isOpen;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:inpath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 点击名字打电话
- (void)currentNameBtnClick:(NSInteger)tag
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan]) {
        SpdOrderStates *model = global.slOrderDetails.spdOrderStates[tag];
        [ZSTool callPhoneStr:model.operator_tel withVC:self];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        SpdOrderStates *model = global.rfOrderDetails.redeemOrderStates[tag];
        [ZSTool callPhoneStr:model.operator_tel withVC:self];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        SpdOrderStates *model = global.mlOrderDetails.dydOrderStates[tag];
        [ZSTool callPhoneStr:model.operator_tel withVC:self];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        SpdOrderStates *model = global.elOrderDetails.easyOrderStates[tag];
        [ZSTool callPhoneStr:model.operator_tel withVC:self];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        SpdOrderStates *model = global.chOrderDetails.cwfqOrderStates[tag];
        [ZSTool callPhoneStr:model.operator_tel withVC:self];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        SpdOrderStates *model = global.abOrderDetails.insteadOrderStates[tag];
        [ZSTool callPhoneStr:model.operator_tel withVC:self];
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
