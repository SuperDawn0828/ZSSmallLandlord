//
//  ZSWSMaterialCollectViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSMaterialCollectViewController.h"
#import "ZSWSMaterialCollectCell.h"
#import "ZSBaseSectionView.h"
#import "ZSWSAddResourceController.h"
#import "ZSMaterialCollectRecordViewController.h"

@interface ZSWSMaterialCollectViewController ()<ZSCreditSectionViewDelegate>
@property(nonatomic,strong)NSMutableArray *collecArray;   //选中数组
@property(nonatomic,strong)NSMutableArray *collecIDArray; //选中Id数组
@property(nonatomic,strong)NSMutableArray *editArray;     //编辑是否选中数组
//@property(nonatomic,assign)NSInteger      count;
@end

@implementation ZSWSMaterialCollectViewController

- (NSMutableArray *)collecArray
{
    if (_collecArray == nil){
        _collecArray = [[NSMutableArray alloc]init];
    }
    return _collecArray;
}

- (NSMutableArray *)collecIDArray
{
    if (_collecIDArray == nil){
        _collecIDArray = [[NSMutableArray alloc]init];
    }
    return _collecIDArray;
}

- (NSMutableArray *)editArray
{
    if (_editArray == nil){
        _editArray = [[NSMutableArray alloc]init];
    }
    return _editArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [USER_DEFALT setInteger:0 forKey:@"hasbeenUploadNum"];
    [USER_DEFALT setInteger:0 forKey:@"needUploadNum"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"资料收集";
    [self configureTableView:CGRectMake(0, 44, ZSWIDTH, ZSHEIGHT-64-44) withStyle:UITableViewStyleGrouped];
    self.glt_scrollView = self.tableView;
    [self resisterCell];
    [self setLeftBarButtonItem];//返回按钮
    [self initFooterView];//资料收集记录列表
//    [self addHeader];
    if (self.isEditing){
        [self initWithBottomBtn];
        [self setBottomBtnEnable:NO];
        self.tableView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64-58);
    }
    //刷新详情的通知
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

- (void)initDatas
{
    self.editArray = [[NSMutableArray alloc]initWithArray:global.wsOrderDetail.docInfo];
    [self judeBottomState];
    [self.collecArray removeAllObjects];
    for (DocInfo *model in global.wsOrderDetail.docInfo) {
        if (model.docFlag == 1){
            [self.collecArray addObject:model];
            [self.tableView reloadData];
        }
    }
}

#pragma mark 资料收集记录按钮 footer
- (void)initFooterView
{
    if (!self.isEditing) {
        UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        footerBtn.backgroundColor = ZSColorWhite;
        footerBtn.frame = CGRectMake(0, 0, ZSWIDTH, CellHeight);
        [footerBtn addTarget:self action:@selector(gotoCollectList) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableFooterView = footerBtn;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.5)];
        lineView.backgroundColor = ZSColorLine;
        [footerBtn addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ZSWIDTH-90-10)/2, 0, 90, CellHeight)];
        titleLabel.text = @"资料收集记录";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = ZSColorRed;
        [footerBtn addSubview:titleLabel];
        
        UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.right, 17, 10, 10)];
        titleImg.image = [UIImage imageNamed:@"list_more_n"];
        [footerBtn addSubview:titleImg];
    }
}

#pragma mark 底部按钮
- (void)initWithBottomBtn
{
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = ZSColorWhite;
    bottomView.frame = CGRectMake(0, ZSHEIGHT - 58 - 64 , ZSWIDTH, 60);
    [self.view addSubview:bottomView];
    [self configuBottomButtonWithTitle:@"保存" OriginY:7];
    [bottomView addSubview:self.bottomBtn];
}

#pragma mark tableview -- delegate
- (void)resisterCell
{
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.1)];
    [self.tableView registerNib:[UINib nibWithNibName:KReUseZSWSMaterialCollectCellIndentifier bundle:nil] forCellReuseIdentifier:KReUseZSWSMaterialCollectCellIndentifier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.isEditing ? 0: 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isEditing ? global.wsOrderDetail.docInfo.count : self.collecArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSWSMaterialCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:KReUseZSWSMaterialCollectCellIndentifier];
    DocInfo *model = self.isEditing ? global.wsOrderDetail.docInfo[indexPath.row]:self.collecArray[indexPath.row];
    if (self.isEditing){
        cell.leftSeclectBtn.tag = indexPath.row + 100;
        [cell.clickBtn addTarget:self action:@selector(leftSeclectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.clickBtn.tag = indexPath.row;
    }
    cell.model = model;
    [cell.rightBtn addTarget:self action:@selector(addResourceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightBtn.tag = indexPath.row;
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell : ZSColorWhite;
    
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
    sectionView.leftLab.text = @"已收集资料";
    sectionView.rightLab.text = @"编辑";
    sectionView.rightLab.hidden = YES;
    sectionView.rightArrowImgV.hidden = YES;
    //已完成和已操作的单子不能操作
    if ([ZSTool checkWitnessServerOrderIsCanEditing]){
        sectionView.delegate = self;
        sectionView.rightLab.hidden = NO;
        sectionView.rightArrowImgV.hidden = NO;
    }
    return view;
}

#pragma mark 区头代理
- (void)tapSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0) {
        ZSWSMaterialCollectViewController *vc = [[ZSWSMaterialCollectViewController alloc]init];
        vc.isEditing = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 跳转上传资料页面
- (void)addResourceBtnClick:(UIButton *)btn
{
    DocInfo *model = self.isEditing ? self.editArray[btn.tag] : self.collecArray[btn.tag];
    ZSWSAddResourceController *vc = [[ZSWSAddResourceController alloc]init];
    vc.docInfoModel = model;
    if ([model.docName containsString:@"户口本"]){
        vc.addDataStyle = ZSAddResourceDataTwo;
    }else if ([model.docName containsString:@"身份证"] || [model.docName containsString:@"征信授权书"]){
        vc.addDataStyle = ZSAddResourceDataOne;
    }else{
        vc.addDataStyle = ZSAddResourceDataCountless;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 跳转资料收集记录页面
- (void)gotoCollectList
{
    ZSMaterialCollectRecordViewController *recordVC = [[ZSMaterialCollectRecordViewController alloc]init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark 底部按钮点击
- (void)bottomClick:(UIButton *)sender
{
    for (DocInfo *model in self.editArray) {
        if (model.docFlag == 1){
            [self.collecIDArray addObject:model.docId];
        }
    }
   NSString *jsonStr = [self.collecIDArray componentsJoinedByString:@","];
//    ZSLOG(@"-----------%@",jsonStr);
    [self requestForUpdateCollecState:jsonStr];
}

#pragma mark 更新状态接口
- (void)requestForUpdateCollecState:(NSString *)jsonStr
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"加载中"];
    NSMutableDictionary *parameter=  @{
                                       @"orderNo":global.wsOrderDetail.projectInfo.tid,
                                       @"orderDocsIds":jsonStr
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getUploadBeCollectURL] SuccessBlock:^(NSDictionary *dic) {
        //通知订单详情刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 左侧勾选按钮
- (void)leftSeclectBtnClick:(UIButton *)btn
{
    NSIndexPath *inpath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    ZSWSMaterialCollectCell *cell = [self.tableView cellForRowAtIndexPath:inpath];
    UIButton *selectBtn = [cell.contentView viewWithTag:btn.tag + 100];
    DocInfo *model = global.wsOrderDetail.docInfo[btn.tag];
    if (btn.selected){
        btn.selected = NO;
        model.docFlag = 0;
    }else{
        btn.selected = YES;
        model.docFlag = 1;
    }
    selectBtn.selected = btn.selected;

    [self.editArray replaceObjectAtIndex:btn.tag withObject:model];
    [self judeBottomState];
}

- (void)judeBottomState
{
    if (self.editArray.count > 0){
        for (DocInfo *info in self.editArray) {
            if (info.docFlag == 1){
                [self setBottomBtnEnable:YES];
                return;
            }else{
                [self setBottomBtnEnable:NO];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
