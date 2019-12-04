//
//  ZSSLAddCreditReportViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/9/18.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSSLAddCreditReportViewController.h"
#import "ZSTextWithPhotosTableViewCell.h"

@interface ZSSLAddCreditReportViewController ()<ZSTextWithPhotosTableViewCellDelegate>
{
    NSArray            *needUploadArray;//待上传的图片或视频对象）
    LSProgressHUD      *hud;
    BOOL               isShowHUD;
    BOOL               isCellProgress;
    dispatch_queue_t   queue;
    dispatch_group_t   group;
}

@property (nonatomic,strong) NSMutableArray         *allDataArray;
@property (nonatomic,strong) NSMutableArray         *listDataArray;
@property (nonatomic,assign) BOOL                   isFailure;           //是否有图片上传失败
@property (nonatomic,assign) BOOL                   isChanged;           //是否有改变值(用于返回按钮和底部按钮检测内容是否有变化)
@property (nonatomic,assign) BOOL                   isChangedPhotoCell;  //photocell是否有改变值(用于返回按钮和底部按钮检测内容是否有变化)
@end

@implementation ZSSLAddCreditReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    if (self.SLDocToModel) {
        self.title = [NSString stringWithFormat:@"%@",self.SLDocToModel.docname];
    }
    [self setLeftBarButtonItem];//返回按钮
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd) {//已完成和已操作的单子不能操作
        [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64-60) withStyle:UITableViewStylePlain];
        [self configuBottomButtonWithTitle:@"保存"];//创建底部按钮
    }
    else {
        [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64) withStyle:UITableViewStylePlain];
    }
    //Data
    [self configureErrorViewWithStyle:ZSErrorWithoutUploadFiles];//无上传资料数据
    [self requestForUpdateCollecState];//资料详情接口请求
}

#pragma mark /*--------------------------------请求数据-------------------------------------------*/
#pragma mark 获取资料详情接口
- (void)requestForUpdateCollecState
{
    self.allDataArray = [[NSMutableArray alloc]init];
    self.listDataArray = [[NSMutableArray alloc]init];
    
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showWithMessage:@"加载中"];
    [ZSRequestManager requestWithParameter:[self getMaterialsFilesParameter] url:[self getMaterialsFilesURL] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"][@"spdDocInfoVos"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSAddResourceModel *model = [ZSAddResourceModel yy_modelWithJSON:dict];
                [weakSelf.allDataArray addObject:model];
            }
        }
        //数据填充
        [weakSelf fillinData];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 获取资料状态参数
- (NSMutableDictionary *)getMaterialsFilesParameter
{
    NSMutableDictionary *parameter=  @{
                                       @"docId":self.SLDocToModel.docid,
                                       @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    return parameter;
}

#pragma mark 获取资料详情地址
- (NSString *)getMaterialsFilesURL
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        return [ZSURLManager getSpdQueryOrderDocURL];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        return [ZSURLManager getRedeemFloorQueryOrderDocURL];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        return [ZSURLManager getMortgageLoanQueryOrderDocURL];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        return [ZSURLManager getEasyLoanQueryOrderDocURL];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        return [ZSURLManager getCarHireQueryOrderDocURL];
    }
    //代办业务
    else
    {
        return [ZSURLManager getAngencyBusinessQueryOrderDocURL];
    }
}

#pragma mark /*--------------------------------填充数据-------------------------------------------*/
- (void)fillinData
{
    //用于判断是否显示缺省页
    BOOL isHaveData = NO;

    //数据解析
    for (ZSAddResourceModel *addModel in self.allDataArray)
    {
        if (addModel.spdDocInfoVos.count > 0)
        {
            NSString *urlString;
            for (ZSWSFileCollectionModel *fileModel in addModel.spdDocInfoVos) {
                if (fileModel.dataUrl) {
                    urlString =  urlString.length ? [NSString stringWithFormat:@"%@,%@",urlString,fileModel.dataUrl] : [NSString stringWithFormat:@"%@",fileModel.dataUrl];
                    isHaveData = YES;
                }
            }
            //自己填数据吧
            ZSDynamicDataModel *model = [[ZSDynamicDataModel alloc]init];
            model.fieldType = @"3";
            model.fieldMeaning = [NSString stringWithFormat:@"%@(%@)",addModel.subCategory,addModel.custName];
            model.rightData = urlString;
            model.prdType = self.prdType;
            [self.listDataArray addObject:model];
        }
        else
        {
            //空数据也要填
            ZSDynamicDataModel *model = [[ZSDynamicDataModel alloc]init];
            model.fieldType = @"3";
            model.fieldMeaning = [NSString stringWithFormat:@"%@(%@)",addModel.subCategory,addModel.custName];
            model.prdType = self.prdType;
            [self.listDataArray addObject:model];
        }
    }
    
    //刷新tableView
    [self.tableView reloadData];
    
    //缺省页
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd)
    {
        self.tableView.hidden = NO;
        self.errorView.hidden = YES;
    }
    else
    {
        if (isHaveData == NO)
        {
            self.tableView.hidden = YES;
            self.errorView.hidden = NO;
        }
    }
}

#pragma mark /*----------------------------------UITableView----------------------------------*/
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSDynamicDataModel *model = self.listDataArray[indexPath.row];
    if (!model.cellHeight) {
        return CellHeight + photoWidth + 25;
    }
    else {
        return (CellHeight-30) + model.cellHeight + 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSTextWithPhotosTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ZSTextWithPhotosTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier3"];
        cell.delegate = self;
        cell.isShowAdd = self.isShowAdd;
    }
    cell.currentIndex = indexPath.row;
    ZSDynamicDataModel *model = self.listDataArray[indexPath.row];
    cell.model = model;
    if (model.imageDataArray) {
        cell.imageDataArray = model.imageDataArray;
    }
    return cell;
}

#pragma mark ZSTextWithPhotosTableViewCellDelegate
//当前cell的高度
- (void)sendCurrentCellHeight:(CGFloat)collectionHeight withIndex:(NSUInteger)currentIndex
{
    //保存数据
    ZSDynamicDataModel *model = self.listDataArray[currentIndex];
    model.cellHeight = collectionHeight;
    [self.listDataArray replaceObjectAtIndex:currentIndex withObject:model];
   
    //刷新当前tableView(只刷新高度)
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

//本地图片数组
- (void)sendImageArrayData:(NSArray *)imageDataArray WithIndex:(NSUInteger)currentIndex;
{
    //保存数据
    ZSDynamicDataModel *model = self.listDataArray[currentIndex];
    if (imageDataArray.count > 0) {
        model.imageDataArray = imageDataArray;
        model.rightData = @" ";
        [self.listDataArray replaceObjectAtIndex:currentIndex withObject:model];
    }
}

//已上传的照片
- (void)sendProcessOfPhototWithData:(NSString *)string WithIndex:(NSUInteger)currentIndex;
{
    //保存数据
    ZSDynamicDataModel *model = self.listDataArray[currentIndex];
    model.rightData = string ? string : model.rightData;
    [self.listDataArray replaceObjectAtIndex:currentIndex withObject:model];

    //上传进度
    NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:@"hasbeenUploadNum"];
    NSUInteger needUploadNum = [USER_DEFALT integerForKey:@"needUploadNum"];

    //右侧按钮,用于显示上传进度
    if (hasbeenUploadNum > needUploadNum) {
        hasbeenUploadNum = needUploadNum;
    }
    if (needUploadNum > 0 && hasbeenUploadNum <= needUploadNum) {
        [self configureRightNavItemWithTitle:[NSString stringWithFormat:@"已上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum] withNormalImg:nil withHilightedImg:nil];
    }
    else{
        [self configureRightNavItemWithTitle:@"" withNormalImg:nil withHilightedImg:nil];
    }

    //点击了底部保存按钮,此时图片未上传完
    if (isShowHUD == YES)
    {
        if (hasbeenUploadNum < needUploadNum) {
            hud = [LSProgressHUD showWithMessage:[NSString stringWithFormat:@"正在上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum]];
            //如果有图片未上传成功,需要发送通知
            if (self.isFailure) {
                [NOTI_CENTER postNotificationName:@"reUploadImage" object:nil];
                self.isFailure = NO;
                isShowHUD = NO;
            }
        }
        else {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:self.view];
            //资料上传
            [self bottomClick:nil];
        }
    }
}

//图片有增删或修改,都需要请求网络
- (void)checkPhototCellChangeState:(BOOL)isChange
{
    self.isChangedPhotoCell = isChange;
}

//判断是否有图片上传失败
- (void)sendPictureUploadingFailureWithIndex:(BOOL)isFailure
{
    self.isFailure = isFailure;
}

#pragma mark /*----------------------------------底部按钮/保存资料----------------------------------*/
#pragma mark 点击底部按钮(保存资料)
- (void)bottomClick:(UIButton *)sender
{
    //如果有图片未上传成功,需要发送通知
    if (self.isFailure) {
        [NOTI_CENTER postNotificationName:@"reUploadImage" object:nil];
        self.isFailure = NO;
    }
    
    //有上传的资料
    NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:@"hasbeenUploadNum"];
    NSUInteger needUploadNum = [USER_DEFALT integerForKey:@"needUploadNum"];
    if (hasbeenUploadNum < needUploadNum) {
        hud = [LSProgressHUD showWithMessage:[NSString stringWithFormat:@"正在上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum]];
        isShowHUD = YES;
        return;
    }
    
    //没有任何修改
    if (!self.isChanged && !self.isChangedPhotoCell)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //资料上传
}

//#pragma mark 删除资料参数
//- (NSMutableDictionary*)getDeleteIdParameter
//{
//    NSMutableDictionary *dict = @{@"productType":self.prdType}.mutableCopy;
//    //订单id
//    [dict setObject:self.orderIDString ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType] forKey:@"orderNo"];
//    //资料类型Id
//    if (self.SLDocToModel.docid > 0){
//        [dict setObject:self.SLDocToModel.docid forKey:@"docId"];
//    }
//    //资料类别
//    if (self.SLDocToModel.docname) {
//        [dict setObject:self.SLDocToModel.docname forKey:@"catagory"];
//    }
//    NSString *deleteIDStr = [self.dataCollectionView.deletdataIDArray componentsJoinedByString:@","];
//    [dict setObject:deleteIDStr forKey:@"photoIds"];//删除图片id集合
//    return dict;
//}

#pragma mark 资料图片(视频)上传参数
- (NSMutableDictionary*)getAllMaterialsParameterWithFileModel:(ZSWSFileCollectionModel*)fileModel
{
    NSMutableDictionary *dic = @{@"productType":self.prdType}.mutableCopy;
    
    //订单id
    if (self.orderIDString.length > 0) {
        [dic setObject:self.orderIDString forKey:@"orderNo"];
    }else{
        [dic setObject:[ZSGlobalModel getOrderID:self.prdType] forKey:@"orderNo"];
    }
    //资料类型Id
    if (self.SLDocToModel.docid > 0){
        [dic setObject:self.SLDocToModel.docid forKey:@"docId"];
    }
    //资料类型
    if (self.SLDocToModel.docname > 0){
        [dic setObject:self.SLDocToModel.docname forKey:@"catagory"];
    }
    //照片url
    if (fileModel.dataUrl.length > 0) {
        [dic setObject:fileModel.dataUrl forKey:@"photoUrl"];
    }
    
    if (fileModel.currentSectionIndex) {
        ZSAddResourceModel *model = self.allDataArray[fileModel.currentSectionIndex];
        //人员Id
        if (model.custNo.length > 0){
            [dic setObject:model.custNo forKey:@"custNo"];
        }
        //人员角色:贷款人,配偶,共有人等
        if (model.subCategory.length > 0){
            [dic setObject:model.subCategory forKey:@"docType"];
        }
    }
    //默认给贷款人
    else
    {
        ZSAddResourceModel *model = self.allDataArray[0];
        //人员Id
        if (model.custNo.length > 0){
            [dic setObject:model.custNo forKey:@"custNo"];
        }
        //人员角色:贷款人,配偶,共有人等
        if (model.subCategory.length > 0){
            [dic setObject:model.subCategory forKey:@"docType"];
        }
    }
    
    return dic;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
