//
//  ZSSLMaterialCollectViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/27.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLMaterialCollectViewController.h"
#import "ZSSLAddresourceViewController.h"
#import "ZSSLAddPayAmountViewController.h"
#import "ZSSLAddReceiveAmountViewController.h"
#import "ZSSLAddPaymentSureViewController.h"
#import "ZSSLPropertyRightViewController.h"
#import "ZSSLAddBankViewController.h"
#import "ZSSLAddDynamicResourceViewController.h"
#import "ZSBaseSearchViewController.h"
#import "ZSSLMaterialCollectCell.h"
#import "ZSBaseSectionView.h"
#import "ZSSLAddLoanMaterialViewController.h"
#import "ZSRFAddLoanMaterialViewController.h"
#import "ZSMLAddLoanMaterialViewController.h"
#import "ZSCHAddLoanMaterialViewController.h"
#import "ZSELAddLoanMaterialViewController.h"
#import "ZSSLAddHouseMaterialViewController.h"
#import "ZSCHAddHouseMaterialViewController.h"


@interface ZSSLMaterialCollectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *collectArray;//收集资料数组
@property(nonatomic,assign)NSInteger      count;
@property(nonatomic,assign)NSInteger      isFirstScroll;//是否是第一次滚动
@end

@implementation ZSSLMaterialCollectViewController

- (NSMutableArray *)collectArray
{
    if (_collectArray == nil){
        _collectArray = [[NSMutableArray alloc]init];
    }
    return _collectArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [USER_DEFALT setInteger:0 forKey:@"hasbeenUploadNum"];
    [USER_DEFALT setInteger:0 forKey:@"needUploadNum"];
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
    self.title = @"资料收集";
    [self setLeftBarButtonItem];
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight) withStyle:UITableViewStylePlain];
    self.glt_scrollView = self.tableView;
    [self resisterCell];
    [self addHeader];
    [self configureErrorViewWithStyle:ZSErrorSearchNoData];//搜索无数据
    //Data
    //赎楼宝
    if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if (global.rfMaterialCollectModel) {
            [self initDatas];//已经有数据了直接赋值
        }
        else {
            [self requestMaterialDetail];
        }
    }
    else
    {
        if (global.slMaterialCollectModel) {
            [self initDatas];//已经有数据了直接赋值
        }
        else {
            [self requestMaterialDetail];
        }
    }
    //刷新详情数据通知
    [NOTI_CENTER addObserver:self selector:@selector(requestMaterialDetail) name:kOrderDetailFreshMaterialDataNotification object:nil];
    //滚动到指定cell
    [NOTI_CENTER addObserver:self selector:@selector(scrollTableview:) name:kOrderDetailDatalistScrollNotification object:nil];
}

- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestMaterialDetail];
    }];
    if (weakSelf.count > 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    weakSelf.count = 1;
}

#pragma mark 查询资料详情的通知
- (void)requestMaterialDetail
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameter=  @{
                                       @"orderno":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"prdType":self.prdType,
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getOrderListOrderMateriaURL] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:nil];
        //赋值
        //赎楼宝
        if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
        {
            global.rfMaterialCollectModel = [ZSSLMaterialCollectModel yy_modelWithDictionary:dic[@"respData"]];
        }
        else
        {
            global.slMaterialCollectModel = [ZSSLMaterialCollectModel yy_modelWithDictionary:dic[@"respData"]];
        }
        //刷新tableview
        [weakSelf initDatas];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [weakSelf endRefresh:weakSelf.tableView array:nil];
        [LSProgressHUD hide];
    }];
}

#pragma mark 刷新详情数据通知(赋值)
- (void)initDatas
{
    [self.collectArray removeAllObjects];
    ZSSLMaterialCollectModel *materialCollectModel = [[ZSSLMaterialCollectModel alloc]init];
    //赎楼宝
    if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        materialCollectModel = global.rfMaterialCollectModel;
    }
    else
    {
        materialCollectModel = global.slMaterialCollectModel;
    }
    
    //1.可编辑订单（可以上传照片)
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType])
    {
        //1.1 订单创建人是当前节点显示*号
        if ([ZSTool checkFinancialOrderMasterWithType:self.prdType])
        {
            for (Handles *model in materialCollectModel.handle) {
                model.canDo = 1;
                model.isHandle = YES;
                if (self.searchKeyWord) {
                    if ([model.docname containsString:self.searchKeyWord]) {
                        [self.collectArray addObject:model];
                    }
                }
                else{
                    [self.collectArray addObject:model];
                }
            }
            for (Handles *model in materialCollectModel.laterTodo) {
                model.canDo = 1;
                model.need  = 0;
                model.isHandle = NO;
                if (self.searchKeyWord) {
                    if ([model.docname containsString:self.searchKeyWord]) {
                        [self.collectArray addObject:model];
                    }
                }
                else{
                    [self.collectArray addObject:model];
                }
            }
            for (Handles *model in materialCollectModel.other) {
                model.canDo = 1;
                model.need  = 0;
                model.isHandle = NO;
                if (self.searchKeyWord) {
                    if ([model.docname containsString:self.searchKeyWord]) {
                        [self.collectArray addObject:model];
                    }
                }
                else{
                    [self.collectArray addObject:model];
                }
            }
        }
        else
        {
            //1.2除去订单创建人别的角色
            //可编辑的数组取数据
            for (Handles *model in materialCollectModel.handle) {
                model.canDo = 1;
                model.isHandle = YES;
                if (self.searchKeyWord) {
                    if ([model.docname containsString:self.searchKeyWord]) {
                        [self.collectArray addObject:model];
                    }
                }
                else{
                    [self.collectArray addObject:model];
                }
            }
            for (Handles *model in materialCollectModel.laterTodo) {
                model.canDo = 1;
                model.isHandle = NO;
                if (self.searchKeyWord) {
                    if ([model.docname containsString:self.searchKeyWord]) {
                        [self.collectArray addObject:model];
                    }
                }
                else{
                    [self.collectArray addObject:model];
                }
            }
            for (Handles *model in materialCollectModel.other) {
                model.canDo = 0;
                model.isHandle = NO;
                if (self.searchKeyWord) {
                    if ([model.docname containsString:self.searchKeyWord]) {
                        [self.collectArray addObject:model];
                    }
                }
                else{
                    [self.collectArray addObject:model];
                }
            }
        }
    }
    //2.不可编辑订单 (订单已关闭)
    else
    {
        //可编辑的数组取数据(给本地所需数据赋值,用来判断是否可以编辑（是否展示保存按钮))
        for (Handles *model in materialCollectModel.handle) {
            model.canDo = 0;
            model.need  = 0;
            if (self.searchKeyWord) {
                if ([model.docname containsString:self.searchKeyWord]) {
                    [self.collectArray addObject:model];
                }
            }
            else{
                [self.collectArray addObject:model];
            }
        }
        for (Handles *model in materialCollectModel.laterTodo) {
            model.canDo = 0;
            model.need  = 0;
            if (self.searchKeyWord) {
                if ([model.docname containsString:self.searchKeyWord]) {
                    [self.collectArray addObject:model];
                }
            }
            else{
                [self.collectArray addObject:model];
            }
        }
        for (Handles *model in materialCollectModel.other) {
            model.canDo = 0;
            model.need  = 0;
            if (self.searchKeyWord) {
                if ([model.docname containsString:self.searchKeyWord]) {
                    [self.collectArray addObject:model];
                }
            }
            else{
                [self.collectArray addObject:model];
            }
        }
    }
    
    //设置tableview的高度
    [self resetTableViewHeight];
    
    //刷新
    [self.tableView reloadData];
    
    //显示缺省页
    if (self.searchKeyWord) {
        self.errorView.hidden = self.collectArray.count == 0 ? NO : YES;
    }
}

#pragma mark 滚动到指定cell
- (void)scrollTableview:(NSNotification *)info
{
    //资料是否是必填
    NSString *string = info.userInfo[@"isNeed"];
    ZSSLMaterialCollectModel *materialCollectModel = [[ZSSLMaterialCollectModel alloc]init];
    //赎楼宝
    if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        materialCollectModel = global.rfMaterialCollectModel;
    }
    else
    {
        materialCollectModel = global.slMaterialCollectModel;
    }
    
    //必填的
    if ([string isEqualToString:@"YES"]) {
        for (int i = 0; i < materialCollectModel.handle.count; i++) {
            Handles *model = materialCollectModel.handle[i];
            if (model.need == 1 && model.finish == 0) {
                if (i > 0) {
                    [self.glt_scrollView scrollRectToVisible:CGRectMake(0, i * 70 - 34, ZSWIDTH, self.glt_scrollView.height) animated:YES];
                }
                return;
            }
        }
    }
    //非必填的
    else
    {
        for (int i = 0; i < materialCollectModel.handle.count; i++) {
            Handles *model = materialCollectModel.handle[i];
            if (model.need == 0 && model.finish == 0) {
                if (i > 0) {
                    [self.glt_scrollView scrollRectToVisible:CGRectMake(0, i * 70 - 34, ZSWIDTH, self.glt_scrollView.height) animated:YES];
                }
                return;
            }
        }
    }
}

#pragma mark 初测单元格
- (void)resisterCell
{
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    [self.tableView registerNib:[UINib nibWithNibName:KReuseZSSLMaterialCollectCellIdentifier bundle:nil] forCellReuseIdentifier:KReuseZSSLMaterialCollectCellIdentifier];
    [self configureHeaderView];
}

#pragma mark headerView--搜索框
- (void)configureHeaderView
{
    if (self.searchKeyWord == nil)
    {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight)];
        headerView.backgroundColor = ZSViewBackgroundColor;
        self.tableView.tableHeaderView = headerView;
        
        //按钮
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(GapWidth, 7, ZSWIDTH-GapWidth*2, 30);
        searchBtn.backgroundColor = ZSColorWhite;
        searchBtn.layer.cornerRadius = 15;
        searchBtn.layer.masksToBounds = YES;
        [searchBtn addTarget:self action:@selector(goToSearchCtrl) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:searchBtn];
        
        //搜索图片
        UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, (30-15)/2, 15, 15)];
        searchImage.image = [UIImage imageNamed:@"head_search_1_n"];
        [searchBtn addSubview:searchImage];
        
        //搜索提示文字
        UILabel *searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 200, 30)];
        searchLabel.font = [UIFont systemFontOfSize:14];
        searchLabel.textColor = ZSColorAllNotice;
        searchLabel.text = @"搜索";
        [searchBtn addSubview:searchLabel];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSSLMaterialCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSSLMaterialCollectCellIdentifier];
    cell.leftSpaceIng.constant = 15;
    if (self.collectArray.count  > 0){
        Handles *model = self.collectArray[indexPath.row];
        cell.model = model;
        if (indexPath.row == self.collectArray.count - 1){
            cell.leftSpaceIng.constant = 0;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Handles *model = self.collectArray[indexPath.row];
    //放款凭证界面
    if ([model.doccode containsString:@"DKPZ"])
    {
        ZSSLAddPayAmountViewController *payVC = [[ZSSLAddPayAmountViewController alloc]init];
        payVC.SLDocToModel   = model;
        payVC.addDataStyle   = ZSAddResourceDataCountless;
        payVC.isShowAdd      = model.canDo == 1 ? YES : NO;
        payVC.orderIDString  = self.orderIDString;
        payVC.prdType        = self.prdType;
        [self.navigationController pushViewController:payVC animated:YES];
    }
    //收款凭证界面
    else if ([model.doccode containsString:@"SKPZ"])
    {
        ZSSLAddReceiveAmountViewController *receiveVC = [[ZSSLAddReceiveAmountViewController alloc]init];
        receiveVC.SLDocToModel    = model;
        receiveVC.addDataStyle    = ZSAddResourceDataCountless;
        receiveVC.isShowAdd       = model.canDo == 1 ? YES : NO;
        receiveVC.orderIDString   = self.orderIDString;
        receiveVC.prdType         = self.prdType;
        [self.navigationController pushViewController:receiveVC animated:YES];
    }
    //产权情况表界面
    else if ([model.doccode containsString:@"CQQKB"])
    {
        ZSSLPropertyRightViewController *receiveVC = [[ZSSLPropertyRightViewController alloc]init];
        receiveVC.SLDocToModel    = model;
        receiveVC.addDataStyle    = ZSAddResourceDataCountless;
        receiveVC.isShowAdd       = NO;
        receiveVC.isShowBottomBtn = model.canDo == 1 ? YES : NO; //是否展示底部按钮
        receiveVC.orderIDString   = self.orderIDString;
        receiveVC.prdType         = self.prdType;
        [self.navigationController pushViewController:receiveVC animated:YES];
    }
    //回款确认
    else if ([model.doccode containsString:@"HKQR"])
    {
        ZSSLAddPaymentSureViewController *receiveVC = [[ZSSLAddPaymentSureViewController alloc]init];
        receiveVC.SLDocToModel    = model;
        receiveVC.addDataStyle    = ZSAddResourceDataCountless;
        receiveVC.isShowAdd       = model.canDo == 1 ? YES : NO;
        receiveVC.orderIDString   = self.orderIDString;
        receiveVC.prdType         = self.prdType;
        [self.navigationController pushViewController:receiveVC animated:YES];
    }
    //收款银行卡/还款银行卡/结清账户信息
    else if ([model.doccode containsString:@"BANK_REPAY"] || [model.doccode containsString:@"BANK_GATHER"] || [model.doccode containsString:@"CLEAR_ACCOUNT"])
    {
        ZSSLAddBankViewController *receiveVC = [[ZSSLAddBankViewController alloc]init];
        receiveVC.SLDocToModel    = model;
        receiveVC.addDataStyle    = ZSAddResourceDataCountless;
        receiveVC.isShowAdd       = model.canDo == 1 ? YES : NO;
        receiveVC.orderIDString   = self.orderIDString;
        receiveVC.prdType         = self.prdType;
        [self.navigationController pushViewController:receiveVC animated:YES];
    }
    //户口本
    else if ([model.doccode containsString:@"HKB"])
    {
        ZSSLAddresourceViewController *receiveVC = [[ZSSLAddresourceViewController alloc]init];
        receiveVC.SLDocToModel    = model;
        receiveVC.addDataStyle    = ZSAddResourceDataTwo; //户口本两个加号
        receiveVC.isShowAdd       = model.canDo == 1 ? YES : NO;
        receiveVC.orderIDString   = self.orderIDString;
        receiveVC.prdType         = self.prdType;
        [self.navigationController pushViewController:receiveVC animated:YES];
    }
    //央行征信报告
    else if ([model.doccode isEqualToString:@"YHZXBG"])
    {
        ZSSLAddresourceViewController *receiveVC = [[ZSSLAddresourceViewController alloc]init];
        receiveVC.SLDocToModel    = model;
        receiveVC.addDataStyle    = ZSAddResourceDataCountless;//能添加无数张照片
        receiveVC.isShowAdd       = model.canDo == 1 ? YES : NO;
        receiveVC.orderIDString   = self.orderIDString;
        receiveVC.prdType         = self.prdType;
        [self.navigationController pushViewController:receiveVC animated:YES];
    }
    //贷款信息
    else if ([model.doccode isEqualToString:@"LOAN_INFO"])
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
    //房产信息
    else if ([model.doccode isEqualToString:@"HOUSE_INFO"])
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
    //其他的资料
    else
    {
        ZSSLAddDynamicResourceViewController *dynamicResourceVC = [[ZSSLAddDynamicResourceViewController alloc]init];
        dynamicResourceVC.SLDocToModel    = model;
        dynamicResourceVC.isShowAdd       = model.canDo == 1 ? YES : NO;
        dynamicResourceVC.orderIDString   = self.orderIDString;
        dynamicResourceVC.prdType         = self.prdType;
        [self.navigationController pushViewController:dynamicResourceVC animated:YES];
    }
}

#pragma mark 跳转到搜索页面
- (void)goToSearchCtrl
{
    ZSBaseSearchViewController *searchVC = [[ZSBaseSearchViewController alloc]init];
    searchVC.filePathString = KOrderDetailDataSearch;
    searchVC.prdType = self.prdType;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

@end
