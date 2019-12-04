//
//  ZSWSPersonDetailViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSPersonDetailViewController.h"
#import "ZSBaseSectionView.h"
#import "ZSWSLoanMaterialViewController.h"
#import "ZSWSHouseMaterialViewController.h"
#import "ZSWSNewLeftRightCell.h"
#import "ZSPhotoContainerView.h"
#import "ZSWSPhotoShowCell.h"
#import "ZSWSAddCustomerViewController.h"
#import "ZSWSPhotoShowView.h"
#import "ZSSLPersonDetailBigDataCell.h"

@interface ZSWSPersonDetailViewController ()<ZSAlertViewDelegate,ZSCreditSectionViewDelegate>
@property(nonatomic,strong)NSMutableArray *sectionTitleArray;   //区头数组
@property(nonatomic,strong)NSMutableArray *personInfoArray;     //人员基本资料
@property(nonatomic,strong)NSMutableArray *rightPersonInfoArray;//右边人员基本资料
@property(nonatomic,strong)NSMutableArray *personImgViewArray;  //人员照片
@property(nonatomic,strong)NSMutableArray *creditInfoArray;     //征信结果
@property(nonatomic,strong)NSMutableArray *rightCreditInfoArray;//右边征信结果
@property(nonatomic,strong)NSMutableArray *creditImgViewArray;  //征信照片
@property(nonatomic,strong)UIView         *view_noData;         //大数据风控缺省页
@end

@implementation ZSWSPersonDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, self.view.height+10);
    //Data
    [self loadPersonDatasWithModel:global.wsCustInfo];//加载人员信息
    [self loadCreditDatas];//加载银行征信结果
    [self.tableView reloadData];
    //开启返回手势(自定义返回按钮会导致手势失效)
    [self openInteractivePopGestureRecognizerEnable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel getReleationStateWithCode:global.wsCustInfo.releation]];
    [self setLeftBarButtonItem];//返回按钮
    [self registerCell];
}

#pragma mark 加载人员基本信息
- (void)loadPersonDatasWithModel:(CustInfo *)model
{
    //分区
    if (global.wsCustInfo.creditResult.length == 0 || global.wsCustInfo.creditResult.intValue == 0){
        if (global.wsCustInfo.isRiskData.intValue == 1) {
            if (global.wsCustInfo.bizCreditCustomers.count > 0) {
                self.sectionTitleArray = @[@"基本资料",@"大数据风控"].mutableCopy;
            }else{
                self.sectionTitleArray = @[@"基本资料"].mutableCopy;
            }
        }else{
            self.sectionTitleArray = @[@"基本资料"].mutableCopy;
        }
    }
    else
    {
        if (global.wsCustInfo.isRiskData.intValue == 1) {
            if (global.wsCustInfo.bizCreditCustomers.count > 0) {
                self.sectionTitleArray = @[@"基本资料",@"央行征信反馈",@"大数据风控"].mutableCopy;
            }else{
                self.sectionTitleArray = @[@"基本资料",@"央行征信反馈"].mutableCopy;
            }
        }else{
            self.sectionTitleArray = @[@"基本资料",@"央行征信反馈"].mutableCopy;
        }
    }
    //身份证照片
    self.personImgViewArray = [[NSMutableArray alloc]init];
    if (model.identityPos) {
        [self.personImgViewArray addObject:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,SafeStr(model.identityPos)]];
    }
    if (model.identityBak) {
        [self.personImgViewArray addObject:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,SafeStr(model.identityBak)]];
    }
    if (model.authorizeImg) {
        [self.personImgViewArray addObject:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,SafeStr(model.authorizeImg)]];
    }
    //地区拼接
    NSString *area = [NSString stringWithFormat:@"%@ %@ %@",SafeStr(model.province),SafeStr(model.city),SafeStr(model.area)];
    //担保人配偶不显示
    if ([self.title isEqualToString:@"担保人配偶"]) {
        self.personInfoArray = @[@"姓名",@"身份证号",@"手机号",@"大数据风控",@"央行征信"].mutableCopy;
        self.rightPersonInfoArray = @[SafeStr(model.name),
                                      SafeStr(model.identityNo),SafeStr(model.cellphone),
                                      SafeStr([ZSGlobalModel getBigDataStateWithCode:model.isRiskData]),
                                      SafeStr([ZSGlobalModel getBigDataStateWithCode:model.isBankCredit])
                                      ].mutableCopy;
    }else{
        //只有贷款人展示省市区和详情
        if ([self.title isEqualToString:@"贷款人信息"]){
            self.personInfoArray = @[@"姓名",@"身份证号",@"手机号",[self setLeftRelationByTitle],@"大数据风控",@"央行征信",@"省市区",@"详情地址"].mutableCopy;
            self.rightPersonInfoArray = @[SafeStr(model.name),
                                          SafeStr(model.identityNo),
                                          SafeStr(model.cellphone),
                                          SafeStr([NSString setRelationByRelation:model]),
                                          SafeStr([ZSGlobalModel getBigDataStateWithCode:model.isRiskData]),
                                          SafeStr([ZSGlobalModel getBigDataStateWithCode:model.isBankCredit]),
                                          SafeStr(area),
                                          SafeStr(model.address)
                                          ].mutableCopy;
        }else {
            //不展示省市区和详情
            self.personInfoArray = @[@"姓名",@"身份证号",@"手机号",[self setLeftRelationByTitle],@"大数据风控",@"央行征信"].mutableCopy;
            self.rightPersonInfoArray = @[SafeStr(model.name),
                                          SafeStr(model.identityNo),
                                          SafeStr(model.cellphone),
                                          SafeStr([NSString setRelationByRelation:model]),
                                          SafeStr([ZSGlobalModel getBigDataStateWithCode:model.isRiskData]),
                                          SafeStr([ZSGlobalModel getBigDataStateWithCode:model.isBankCredit])
                                          ].mutableCopy;
        }
    }
    
    //征信照片
    NSMutableArray *creditImgArray = [[NSMutableArray alloc]init];
    for (ZSWSFileCollectionModel *model in global.wsCustInfo.docsDataList) {
        [creditImgArray addObject:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,SafeStr(model.dataUrl)]];
    }
    self.creditImgViewArray = [[NSMutableArray alloc]initWithArray:creditImgArray];
}

#pragma mark 加载征信结果的数据
- (void)loadCreditDatas
{
    CustInfo *model = global.wsCustInfo;
    self.creditInfoArray = @[@"征信说明",@"房贷",@"信用卡",@"消费贷",@"其他"].mutableCopy;
    //征信赋值信息
    self.rightCreditInfoArray = @[SafeStr(model.remark),
                                  SafeStr(model.houseloanInf),
                                  SafeStr(model.creditcardInf),
                                  SafeStr(model.consumeInf),
                                  SafeStr(model.otherInf)
                                  ].mutableCopy;
}

#pragma mark 根据角色返回与主贷人关系左边显示
- (NSString *)setLeftRelationByTitle
{
    NSString *relationString = @"";
    if ([self.title isEqualToString:@"贷款人信息"] || [self.title isEqualToString:@"担保人信息"]) {
        relationString = @"婚姻状况";
    }else if ([self.title isEqualToString:@"贷款人配偶信息"]) {
        relationString = @"是否为共有人";
    }else if ([self.title isEqualToString:@"共有人信息"]) {
        relationString = @"与贷款人的关系";
    }
    return relationString;
}

#pragma mark 注册单元格
- (void)registerCell
{
    self.tableView.estimatedRowHeight = CellHeight;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.1)];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:KReuseZSWSNewLeftRightCellIdentifier bundle:nil] forCellReuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
    [self.tableView registerClass:[ZSWSPhotoShowCell class] forCellReuseIdentifier:KReuseZSWSPhotoShowCellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (global.wsCustInfo.creditResult.length == 0 || global.wsCustInfo.creditResult.intValue == 0){
        if (global.wsCustInfo.isRiskData.intValue == 1) {
            if (global.wsCustInfo.bizCreditCustomers.count > 0) {
                return 2;
            }else{
                return 1;
            }
        }else{
            return 1;
        }
    }
    else
    {
        if (global.wsCustInfo.isRiskData.intValue == 1) {
            if (global.wsCustInfo.bizCreditCustomers.count > 0) {
                return 3;
            }else{
                return 2;
            }
        }else{
            return 2;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return self.personInfoArray.count + 1;
    }
    else
    {
        if (global.wsCustInfo.creditResult.length == 0 || global.wsCustInfo.creditResult.intValue == 0){
            return global.wsCustInfo.bizCreditCustomers.count;
        }
        else
        {
            if (section == 1) {
                return self.creditInfoArray.count + 1;
            }
            else
            {
                return global.wsCustInfo.bizCreditCustomers.count;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return 54;
    }
    else
    {
        if (global.wsCustInfo.creditResult.length == 0 || global.wsCustInfo.creditResult.intValue == 0){
            return global.wsCustInfo.isRiskData.intValue == 0 ? 0 : 54;
        }
        else
        {
            if (section == 1) {
                return (global.wsCustInfo.creditResult.length == 0 || global.wsCustInfo.creditResult.intValue == 0) ? 0 : 54;
            }else{
                return global.wsCustInfo.isRiskData.intValue == 0 ? 0 : 54;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return indexPath.row == self.personInfoArray.count ? [ZSWSPhotoShowView heightWithPicturesCount:self.personImgViewArray.count] :UITableViewAutomaticDimension;
    }
    else
    {
        if (global.wsCustInfo.creditResult.length == 0 || global.wsCustInfo.creditResult.intValue == 0){
            //重设cell的高度
            if (global.wsCustInfo.bizCreditCustomers.count > 0) {
                BizCreditCustomers *CreditCustomers = global.wsCustInfo.bizCreditCustomers[indexPath.row];
                return [ZSSLPersonDetailBigDataCell resetCellHeight:CreditCustomers];
            }else{
                return 0;
            }
        }
        else
        {
            if (indexPath.section == 1) {
                return indexPath.row == self.creditInfoArray.count ? [ZSWSPhotoShowView heightWithPicturesCount:global.wsCustInfo.docsDataList.count] : UITableViewAutomaticDimension;
            }
            else
            {
                //重设cell的高度
                if (global.wsCustInfo.bizCreditCustomers.count > 0) {
                    BizCreditCustomers *CreditCustomers = global.wsCustInfo.bizCreditCustomers[indexPath.row];
                    return [ZSSLPersonDetailBigDataCell resetCellHeight:CreditCustomers];
                }else{
                    return 0;
                }
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //普通cell
    ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
    cell.rightTextField.userInteractionEnabled = NO;
    cell.rightTextField.hidden = YES;
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell:ZSColorWhite;
    //加载图片的cell
    ZSWSPhotoShowCell *photoCell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSPhotoShowCellIdentifier];
    //大数据风控cell
    ZSSLPersonDetailBigDataCell *cell_data = [tableView dequeueReusableCellWithIdentifier:@"identifydata"];
    if (cell_data == nil) {
        cell_data = [[ZSSLPersonDetailBigDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifydata"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0)
    {
        //人员信息
        if (indexPath.row < self.personInfoArray.count){
            cell.leftLab.text = self.personInfoArray[indexPath.row];
            cell.rightLab.text = self.rightPersonInfoArray[indexPath.row];
        }else {
            //图片添加
            photoCell.photoView = [[ZSWSPhotoShowView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH,  [ZSWSPhotoShowView heightWithPicturesCount:self.personImgViewArray.count]) withArray:self.personImgViewArray];
            [photoCell.contentView addSubview:photoCell.photoView];
            photoCell.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell:ZSColorWhite;
            return photoCell;
        }
    }
    else
    {
        if (global.wsCustInfo.creditResult.length == 0 || global.wsCustInfo.creditResult.intValue == 0){
            //大数据风控
            if (global.wsCustInfo.bizCreditCustomers.count > 0) {
                cell_data.detailModel = global.wsCustInfo.bizCreditCustomers[indexPath.row];
            }
            cell_data.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell:ZSColorWhite;
            return cell_data;
        }
        else
        {
            if (indexPath.section == 1) {
                //征信信息
                if (indexPath.row < self.creditInfoArray.count){
                    cell.leftLab.text = self.creditInfoArray[indexPath.row];
                    cell.rightLab.text = self.rightCreditInfoArray[indexPath.row];
                }else{
                    //图片添加
                    photoCell.photoView = [[ZSWSPhotoShowView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH,  [ZSWSPhotoShowView heightWithPicturesCount:self.creditImgViewArray.count]) withArray:(NSMutableArray *)self.creditImgViewArray];
                    [photoCell.contentView addSubview:photoCell.photoView];
                    if (self.creditImgViewArray.count  > 0){
                        photoCell.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell:ZSColorWhite;
                    }else{
                        photoCell.contentView.backgroundColor =  ZSViewBackgroundColor;
                    }
                    return photoCell;
                }
            }
            else
            {
                //大数据风控
                if (global.wsCustInfo.bizCreditCustomers.count > 0) {
                    cell_data.detailModel = global.wsCustInfo.bizCreditCustomers[indexPath.row];
                }
                cell_data.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell:ZSColorWhite;
                return cell_data;
            }
        }
    }
    
    return cell;
}

#pragma mark 区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    view.backgroundColor = ZSViewBackgroundColor;
    ZSBaseSectionView *sectionView = [[ZSBaseSectionView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    sectionView.backgroundColor = ZSColorWhite;
    sectionView.bottomLine.hidden = NO;
    [view addSubview:sectionView];
    sectionView.tag = section;
    sectionView.leftLab.text = self.sectionTitleArray[section];
    sectionView.rightLab.hidden = YES;
    sectionView.rightArrowImgV.hidden = YES;
    //已完成和已关闭的单子不能操作 编辑按钮隐藏
    if (section == 0){
        if ([ZSTool checkWitnessServerOrderIsCanEditing]) {
//            //只有订单创建人才能编辑人员信息
//            if ([global.wsOrderDetail.projectInfo.createBy isEqualToString:[ZSTool readUserInfo].tid]) {
                sectionView.rightArrowImgV.hidden = NO;
                sectionView.rightLab.hidden = NO;
                sectionView.rightLab.text = @"编辑";
                sectionView.delegate = self;
//            }
        }
    }
    //征信结果显示
    if (section == 1) {
        if ([self.sectionTitleArray[section] isEqualToString:@"央行征信反馈"]) {
            sectionView.rightLab.hidden = NO;
            if (global.wsCustInfo.creditResult.intValue == 1){
                sectionView.rightLab.text = @"已反馈-通过";
            }else if(global.wsCustInfo.creditResult.intValue == 2){
                sectionView.rightLab.text = @"已反馈-不通过";
            }else{
                sectionView.rightLab.text = @"未反馈";
            }
        }
        else{
            //限制是否订单可以操作 不限制是否是订单创建人
            if ([ZSTool checkWitnessServerOrderIsCanEditing]) {
                if (global.wsCustInfo.fail_serviceCodes) {
                    if (global.wsCustInfo.fail_serviceCodes.length) {
                        sectionView.view_refesh.hidden = NO;
                        sectionView.delegate = self;
                    }
                }
            }
        }
    }
    if (section == 2) {
        //限制是否订单可以操作 不限制是否是订单创建人
        if ([ZSTool checkWitnessServerOrderIsCanEditing]) {
            if (global.wsCustInfo.fail_serviceCodes) {
                if (global.wsCustInfo.fail_serviceCodes.length) {
                    sectionView.view_refesh.hidden = NO;
                    sectionView.delegate = self;
                }
            }
        }
    }
    return view;
}

#pragma mark 区头代理
- (void)tapSection:(NSInteger)sectionIndex
{
    if (sectionIndex==0)
    {
        ZSWSAddCustomerViewController *addVC = [[ZSWSAddCustomerViewController alloc]init];
        addVC.isFromEditor = YES;
        addVC.orderIDString = global.wsCustInfo.orderId;
        addVC.title = self.title;
        [self.navigationController pushViewController:addVC animated:YES];
    }
    //征信结果显示
    else if (sectionIndex == 1)
    {
        if ([self.sectionTitleArray[sectionIndex] isEqualToString:@"大数据风控"]) {
            if (global.wsCustInfo.fail_serviceCodes) {
                if (global.wsCustInfo.fail_serviceCodes.length) {
                    [self reloadBigData];
                }
            }
        }
    }
    else if (sectionIndex == 2)
    {
        if (global.wsCustInfo.fail_serviceCodes) {
            if (global.wsCustInfo.fail_serviceCodes.length) {
                [self reloadBigData];
            }
        }
    }
}

#pragma mark 大数据风控重查
- (void)reloadBigData
{
    __weak typeof(self) weakSelf  = self;
    [LSProgressHUD showWithMessage:@"加载中..."];
    NSMutableDictionary *parameter=  @{
                                       @"serialNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"custNo":global.wsCustInfo.tid,
                                       @"serviceCodes":global.wsCustInfo.fail_serviceCodes
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getReloadBigDataURL] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf performSelector:@selector(loading) withObject:nil afterDelay:5.0f];
    } ErrorBlock:^(NSError *error) {
        [weakSelf performSelector:@selector(loading) withObject:nil afterDelay:5.0f];
    }];
}

- (void)loading
{
    [LSProgressHUD hide];
    //重新请求订单详情
    [self requestOrderDetail];
}

#pragma mark 获取订单详情接口
- (void)requestOrderDetail
{
    __weak typeof(self) weakSelf  = self;
    [LSProgressHUD showWithMessage:@"加载中"];
    NSMutableDictionary *parameter=  @{
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getQueryWitnessOrderDetails] SuccessBlock:^(NSDictionary *dic) {
        global.wsOrderDetail = [ZSWSOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
        //人员数据赋值
        global.wsCustInfo = [weakSelf chooseModel:global.wsOrderDetail.custInfo];
        [weakSelf loadPersonDatasWithModel:global.wsCustInfo];
        [weakSelf.tableView reloadData];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

- (CustInfo *)chooseModel:(NSArray *)array
{
    for (int i = 0 ; i < array.count ; i++) {
        CustInfo *info = array[i];
        if ([info.tid isEqualToString:self.personIDString]) {
            return info;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
