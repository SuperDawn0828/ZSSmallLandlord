//
//  ZSSLPersonDetailViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLPersonDetailViewController.h"
#import "ZSBaseAddCustomerViewController.h"
#import "ZSSLNewLeftRightCell.h"
#import "ZSWSPhotoShowCell.h"
#import "ZSSLPersonDetailBigDataCell.h"
#import "ZSWSPhotoShowView.h"
#import "ZSBaseSectionView.h"
#import "ZSSLPersonDetailBigDataCell.h"

@interface ZSSLPersonDetailViewController ()<ZSCreditSectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIView         *view_noData;         //大数据风控缺省页
@property(nonatomic,strong)NSMutableArray *sectionTitleArray;   //区头数组
@property(nonatomic,strong)NSMutableArray *personInfoArray;     //贷款人基本资料
@property(nonatomic,strong)NSMutableArray *rightPersonInfoArray;//右边基本资料
@property(nonatomic,strong)NSMutableArray *personImgViewArray;  //人员基本照片
@end

@implementation ZSSLPersonDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势(自定义返回按钮会导致手势失效)
    [self openInteractivePopGestureRecognizerEnable];
    //获取人员详情
    [self requestCustomerDetail];
}

- (void)viewDidLoad
{
    self.style = UITableViewStyleGrouped;
    [super viewDidLoad];
    //UI
    
    [self setLeftBarButtonItem];//返回
    self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, ZSHEIGHT+10);
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.1)];
}

#pragma mark 获取人员详情接口
- (void)requestCustomerDetail
{
    __weak typeof(self) weakSelf  = self;
    NSMutableDictionary *parameter=  @{
                                       @"prdType":self.prdType,
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       @"custId":self.personIDString,
                                       }.mutableCopy;
    
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getCustomerInfoURL] SuccessBlock:^(NSDictionary *dic) {
        //人员数据赋值
        global.bizCustomers = [BizCustomers yy_modelWithDictionary:dic[@"respData"]];
        [weakSelf loadPersonDatasWithModel:global.bizCustomers];
    } ErrorBlock:^(NSError *error) {
    }];
}

- (BizCustomers *)chooseModel:(NSArray *)array
{
    for (int i = 0 ; i < array.count ; i++) {
        BizCustomers *info = array[i];
        if ([info.tid isEqualToString:self.personIDString]) {
            return info;
        }
    }
    return nil;
}

#pragma mark 加载数据
- (void)loadPersonDatasWithModel:(BizCustomers *)model
{
    //分区
    if (global.bizCustomers.isRiskData.intValue == 1) {
        if (global.bizCustomers.bizCreditCustomers.count > 0) {
            self.sectionTitleArray = @[@"基本资料",@"大数据风控"].mutableCopy;
        }else{
            self.sectionTitleArray = @[@"基本资料"].mutableCopy;
        }
    }else{
        self.sectionTitleArray = @[@"基本资料"].mutableCopy;
    }
    //人员信息
    if ([self.title isEqualToString:@"贷款人信息"] ||
        [self.title isEqualToString:@"卖方信息"] ||
        [self.title isEqualToString:@"买方信息"] ||
        [self.title isEqualToString:@"担保人信息"]
        )
    {
        self.personInfoArray = @[@"姓名",@"身份证号",@"手机号",@"婚姻状况",@"大数据风控"].mutableCopy;
        self.rightPersonInfoArray = @[SafeStr(model.name),
                                      SafeStr(global.bizCustomers.identityNo),
                                      SafeStr(model.cellphone),
                                      SafeStr([ZSGlobalModel getMarrayStateWithCode:model.beMarrage]),
                                      SafeStr([ZSGlobalModel getBigDataStateWithCode:model.isRiskData])
                                      ].mutableCopy;
    }
    else if ([self.title isEqualToString:@"共有人信息"])
    {
        self.personInfoArray = @[@"姓名",@"身份证号",@"手机号",@"与贷款人关系",@"大数据风控"].mutableCopy;
        self.rightPersonInfoArray = @[SafeStr(model.name),
                                      SafeStr(model.identityNo),
                                      SafeStr(model.cellphone),
                                      SafeStr([ZSGlobalModel getRelationshipStateWithCode:model.lenderReleation]),
                                      SafeStr([ZSGlobalModel getBigDataStateWithCode:model.isRiskData])
                                      ].mutableCopy;
    }
    else
    {
        self.personInfoArray = @[@"姓名",@"身份证号",@"手机号",@"大数据风控"].mutableCopy;
        self.rightPersonInfoArray = @[SafeStr(model.name),
                                      SafeStr(model.identityNo),
                                      SafeStr(model.cellphone),
                                      SafeStr([ZSGlobalModel getBigDataStateWithCode:model.isRiskData])
                                      ].mutableCopy;
    }
    //清空数据
    [self.personImgViewArray removeAllObjects];
    //身份证正面
    if (model.identityPos.length > 0) {
        [self.personImgViewArray addObject:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,SafeStr(model.identityPos)]];
    }
    //身份证反面
    if (model.identityBak) {
        [self.personImgViewArray addObject:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,SafeStr(model.identityBak)]];
    }
    
    //刷新tableview
    [self.tableView reloadData];
}

#pragma mark tableview--delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  section == 0 ? self.personInfoArray.count + 1: global.bizCustomers.bizCreditCustomers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            return [ZSSLNewLeftRightCell resetHeight:self.rightPersonInfoArray.firstObject];
        }
        else if (indexPath.row == self.personInfoArray.count) {
            return [ZSWSPhotoShowView heightWithPicturesCount:self.personImgViewArray.count];
        }
        else {
            return CellHeight;
        }
    }
    else
    {
        //重设cell的高度
        if (global.bizCustomers.isRiskData.intValue == 1) {
            if (global.bizCustomers.bizCreditCustomers.count > 0) {
                BizCreditCustomers *CreditCustomers = global.bizCustomers.bizCreditCustomers[indexPath.row];
                return [ZSSLPersonDetailBigDataCell resetCellHeight:CreditCustomers];
            }else{
                return 0;
            }

        }else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //人员基本信息cell
    ZSSLNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    if (cell == nil) {
        cell = [[ZSSLNewLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
    }
    //身份证照片cell
    ZSWSPhotoShowCell *cell_photo = [tableView dequeueReusableCellWithIdentifier:@"identifyphoto"];
    if (cell_photo == nil) {
        cell_photo = [[ZSWSPhotoShowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifyphoto"];
    }
    //大数据风控cell
    ZSSLPersonDetailBigDataCell *cell_data = [tableView dequeueReusableCellWithIdentifier:@"identifydata"];
    if (cell_data == nil) {
        cell_data = [[ZSSLPersonDetailBigDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifydata"];
    }
    
    if (indexPath.section == 0) {
        //人员基本信息
        if (indexPath.row < self.personInfoArray.count) {
            cell.leftLabel.text = self.personInfoArray[indexPath.row];
            cell.rightLabel.text = self.rightPersonInfoArray[indexPath.row];
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell:ZSColorWhite;
            return cell;
        }
        //身份证照片
        else{
            cell_photo.photoView = [[ZSWSPhotoShowView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH,  [ZSWSPhotoShowView heightWithPicturesCount:self.personImgViewArray.count])withArray:self.personImgViewArray];
            [cell_photo.contentView addSubview:cell_photo.photoView];
            cell_photo.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell:ZSColorWhite;
            return cell_photo;
        }
    }
    else
    {        
        //大数据风控
        if (global.bizCustomers.isRiskData.intValue == 1) {
            if (global.bizCustomers.bizCreditCustomers.count > 0) {
                cell_data.detailModel = global.bizCustomers.bizCreditCustomers[indexPath.row];
            }
        }
        cell_data.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell:ZSColorWhite;
        return cell_data;
    }
}

#pragma mark 区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    view.backgroundColor = ZSViewBackgroundColor;
    ZSBaseSectionView *sectionView = [[ZSBaseSectionView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    sectionView.backgroundColor = ZSColorWhite;
    sectionView.tag = section;
    sectionView.bottomLine.hidden = NO;
    sectionView.leftLab.text = self.sectionTitleArray[section];
    sectionView.rightLab.hidden = YES;
    sectionView.rightArrowImgV.hidden = YES;
    [view addSubview:sectionView];
    //已完成和已关闭的单子不能操作 编辑按钮隐藏
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType]) {
        //刷新不限制是否是订单创建人
        if (section == 1) {
            if (global.bizCustomers.fail_serviceCodes) {
                if (global.bizCustomers.fail_serviceCodes.length) {
                    sectionView.view_refesh.hidden = NO;
                    sectionView.delegate = self;
                }
            }
        }
        //只有订单创建人才能编辑人员信息
        //星速贷
        if ([self.prdType isEqualToString:kProduceTypeStarLoan]) {
            if (global.slOrderDetails.isOrder.intValue == 1) {
                if (section == 0) {
                    sectionView.rightLab.hidden = NO;
                    sectionView.rightArrowImgV.hidden = NO;
                    sectionView.rightLab.text = @"编辑";
                    sectionView.delegate = self;
                }
            }
        }
        //赎楼宝
        else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor]) {
            if (global.rfOrderDetails.isOrder.intValue == 1) {
                if (section == 0) {
                    sectionView.rightLab.hidden = NO;
                    sectionView.rightArrowImgV.hidden = NO;
                    sectionView.rightLab.text = @"编辑";
                    sectionView.delegate = self;
                }
            }
        }
        //抵押贷
        else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan]) {
            if (global.mlOrderDetails.isOrder.intValue == 1) {
                if (section == 0) {
                    sectionView.rightLab.hidden = NO;
                    sectionView.rightArrowImgV.hidden = NO;
                    sectionView.rightLab.text = @"编辑";
                    sectionView.delegate = self;
                }
            }
        }
        //融易贷
        else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
        {
            if (global.elOrderDetails.isOrder.intValue == 1) {
                if (section == 0) {
                    sectionView.rightLab.hidden = NO;
                    sectionView.rightArrowImgV.hidden = NO;
                    sectionView.rightLab.text = @"编辑";
                    sectionView.delegate = self;
                }
            }
        }
        //车位分期
        else if ([self.prdType isEqualToString:kProduceTypeCarHire]) {
            if (global.chOrderDetails.isOrder.intValue == 1) {
                if (section == 0) {
                    sectionView.rightLab.hidden = NO;
                    sectionView.rightArrowImgV.hidden = NO;
                    sectionView.rightLab.text = @"编辑";
                    sectionView.delegate = self;
                }
            }
        }
        //代办业务
        else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness]) {
            if (global.abOrderDetails.isOrder.intValue == 1) {
                if (section == 0) {
                    sectionView.rightLab.hidden = NO;
                    sectionView.rightArrowImgV.hidden = NO;
                    sectionView.rightLab.text = @"编辑";
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
        ZSBaseAddCustomerViewController *addVC = [[ZSBaseAddCustomerViewController alloc]init];
        addVC.title = self.title;
        addVC.isFromEditor = YES;
        addVC.orderIDString = self.orderIDString;
        addVC.prdType = self.prdType;
        [self.navigationController pushViewController:addVC animated:YES];
    }
    else
    {
        if (global.bizCustomers.fail_serviceCodes) {
            if (global.bizCustomers.fail_serviceCodes.length) {
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
                                       @"custNo":global.bizCustomers.tid,
                                       @"serviceCodes":global.bizCustomers.fail_serviceCodes
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
    //重新获取人员详情
    [self requestCustomerDetail];
}

#pragma mark 懒加载
- (NSMutableArray *)personImgViewArray {
    if (_personImgViewArray == nil) {
        _personImgViewArray = [[NSMutableArray alloc]init];
    }
    return _personImgViewArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
