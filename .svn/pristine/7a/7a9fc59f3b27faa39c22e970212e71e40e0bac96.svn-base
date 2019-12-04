//
//  ZSSLPropertyRightStatementViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/9/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLPropertyRightViewController.h"
#import "ZSSLAddPropertyRightViewController.h"

@interface ZSSLPropertyRightViewController ()

@end

@implementation ZSSLPropertyRightViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [USER_DEFALT setInteger:0 forKey:@"hasbeenUploadNum"];
    [USER_DEFALT setInteger:0 forKey:@"needUploadNum"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.errorView.hidden = YES;
    //底部按钮是否展示
    if (self.isShowBottomBtn){
        [self configuBottomButtonWithTitle:@"新增"];
    }else{
        [self.bottomView removeFromSuperview];
    }
    //查询资料详情的通知
    [NOTI_CENTER addObserver:self selector:@selector(requestForUpdateCollecState) name:kOrderDetailFreshPropertyData object:nil];
}

#pragma mark 获取资料状态接口
- (void)requestForUpdateCollecState
{
    NSMutableDictionary *parameter = @{
                                       @"docId":self.SLDocToModel.docid,
                                       @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    NSString *urlString;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        urlString = [ZSURLManager getSpdQueryOrderDocURL];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        urlString = [ZSURLManager getRedeemFloorQueryOrderDocURL];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        urlString = [ZSURLManager getMortgageLoanQueryOrderDocURL];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        urlString = [ZSURLManager getEasyLoanQueryOrderDocURL];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        urlString = [ZSURLManager getCarHireQueryOrderDocURL];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        urlString = [ZSURLManager getAngencyBusinessQueryOrderDocURL];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.fileArray removeAllObjects];
    [LSProgressHUD showWithMessage:@"加载中"];
    [ZSRequestManager requestWithParameter:parameter url:urlString SuccessBlock:^(NSDictionary *dic) {
        //不是两个加号
        if (self.addDataStyle != ZSAddResourceDataTwo){
            NSArray *array = dic[@"respData"][@"propitems"];
            if (array.count > 0) {
                for (NSDictionary *dict in array) {
                    Propitems *model = [Propitems yy_modelWithJSON:dict];
                    [weakSelf.fileArray addObject:model];
                }
            }
        }
        [weakSelf configCloseAndCompletedata];
        [weakSelf initCollectionView:weakSelf.topSpace];
        [weakSelf initCollectionView];
        [weakSelf.dataCollectionView layoutSubviews];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 加载订单完成和关闭情况的数据
- (void)configCloseAndCompletedata
{
    [self.itemDataArray removeAllObjects];
    [self.itemNameArray removeAllObjects];
    //不是两个加号
    if (self.addDataStyle != ZSAddResourceDataTwo) {
        for (Propitems *model in self.fileArray) {
            if (model.itemtitle.collectTime) {
                [self.itemNameArray addObject:model.itemtitle.collectTime];//把有地址的图片放入数组中
            }
            [self loadCloseAndCompleteData:model];
        }
    }
    //展示无图情况
    [self isShowErrorView];
    //给collectionview赋值
    self.dataCollectionView.itemArray      = self.itemDataArray;
    self.dataCollectionView.titleNameArray = self.itemNameArray;
    [self.dataCollectionView.myCollectionView reloadData];
}

#pragma mark 是否展示无数据的图片
- (void)isShowErrorView
{
    if (self.fileArray.count == 0){
        self.errorView.hidden = NO;
    }else{
        self.errorView.hidden = YES;
    }
}

#pragma mark 加载订单完成和关闭赋值
- (void)loadCloseAndCompleteData:(Propitems *)addModel
{
    //有数据时加载两个加号且都有值时  另外两种情况有值
    NSMutableArray *itemArray = @[].mutableCopy; //不是两个加号的时候存储有数据的model
    if (self.addDataStyle != ZSAddResourceDataTwo){
        //有数据时加载两个加号且都有值时  另外两种情况有值
        for (ZSWSFileCollectionModel *fileModel in addModel.fileList) {
            [itemArray addObject:fileModel];
        }
        [self.itemDataArray addObject:itemArray];
    }
}

#pragma mark initCollectionView
- (void)initCollectionView
{
    self.addDataStyle = ZSAddResourceDataCountless;
    self.dataCollectionView.userInteractionEnabled = YES;
    self.dataCollectionView.myCollectionView.scrollEnabled = YES;
    self.dataCollectionView.addDataStyle = (ZSAddResourceDataStyle)self.addDataStyle;
    self.dataCollectionView.isRightLabelShow = YES;
    [self.dataCollectionView layoutSubviews];
    if (self.isShowBottomBtn){
        self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.dataCollectionView.myCollectionView.bottom + 58 + self.topSpace);
    }else {
        self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.dataCollectionView.myCollectionView.bottom + self.topSpace);
    }
}

- (void)bottomClick:(UIButton *)sender
{
    ZSSLAddPropertyRightViewController *receiveVC = [[ZSSLAddPropertyRightViewController alloc]init];
    receiveVC.SLDocToModel   = self.SLDocToModel;
    receiveVC.orderIDString  = self.orderIDString;
    receiveVC.addDataStyle   = ZSAddResourceDataCountless;
    receiveVC.isShowAdd      = YES;
    receiveVC.prdType        = self.prdType;
    [self.navigationController pushViewController:receiveVC animated:YES];
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
