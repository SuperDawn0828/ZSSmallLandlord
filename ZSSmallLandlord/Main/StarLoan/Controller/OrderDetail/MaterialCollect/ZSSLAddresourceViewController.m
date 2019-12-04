//
//  ZSBaseAddResourceViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/9/13.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLAddresourceViewController.h"
#import "ZSAddResourceModel.h"
#import "TZImageManager.h"

@interface ZSSLAddresourceViewController ()<ZSSLDataCollectionViewDelegate,ZSAlertViewDelegate>
{
    UIImageView        *playImg;
    NSArray            *needUploadArray;//待上传的图片或视频对象）
}
@end

@implementation ZSSLAddresourceViewController

#pragma mark 懒加载
- (NSMutableArray *)fileArray
{
    if (_fileArray == nil){
        _fileArray = [[NSMutableArray alloc]init];
    }
    return _fileArray;
}

- (NSMutableArray *)itemDataArray
{
    if (_itemDataArray == nil){
        _itemDataArray = [[NSMutableArray alloc]init];
    }
    return _itemDataArray;
}

- (NSMutableArray *)itemNameArray
{
    if (_itemNameArray == nil){
        _itemNameArray = [[NSMutableArray alloc]init];
    }
    return _itemNameArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    if (self.SLDocToModel) {
        self.title = [NSString stringWithFormat:@"%@",self.SLDocToModel.docname];
    }
    [self setLeftBarButtonItem]; //返回按钮
    [self initScrollView]; //UI
    [self initWithBottomBtnWithTitle:@"保存"];//创建底部按钮
    [self configureErrorViewWithStyle:ZSErrorWithoutUploadFiles];//无上传资料数据
    //Data
    [self requestForUpdateCollecState];//资料详情接口请求
    isShowHUD = NO;
}

#pragma mark /*--------------------------------返回事件-------------------------------------------*/
#pragma mark 判断当前页面是否有数据修改
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd)
    {
        //有新增图片或删除图片,或者文本资料有改动
        if ([self getNeedUploadFilesArray].count > 0 || self.dataCollectionView.deletdataIDArray.count > 0 || self.isChanged == YES)
        {
            [self leftAction];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

- (void)leftAction;
{
    //有新增图片或删除图片,或者文本资料有改动
    if ([self getNeedUploadFilesArray].count > 0 || self.dataCollectionView.deletdataIDArray.count > 0 || self.isChanged == YES)
    {
        ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"是否确认放弃保存本次编辑的内容?" cancelTitle:@"放弃" sureTitle:@"我要保存"];
        alertView.delegate = self;
        [alertView show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ZSAlertViewDelegate
- (void)AlertView:(ZSAlertView *)alert;//确认按钮响应的方法
{
    [self bottomClick:nil];
}

- (void)AlertViewCanCleClick:(ZSAlertView *)alert;//取消按钮响应的方法
{
//    //有图片上传到Zimg服务器了 进行删除
//    if ([[self getNeedUploadFilesArray] count]) {
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(queue, ^{
//            dispatch_apply([[self getNeedUploadFilesArray] count], queue, ^(size_t index) {
//                [ZSRequestManager removeImageData:[self getNeedUploadFilesArray][index] SuccessBlock:^(NSDictionary *dic) {
//                } ErrorBlock:^(NSError *error) {
//                }];
//            });
//        });
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark /*--------------------------------UI-------------------------------------------*/
#pragma mark initScrollView
- (void)initScrollView
{
    //滑动scrollView
    self.bgScrollView = [[UIScrollView alloc]init];
    self.bgScrollView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight);
    self.bgScrollView.backgroundColor = ZSViewBackgroundColor;
    self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, ZSHEIGHT);
    [self.view addSubview:self.bgScrollView];
    
    //datacollectionView
    self.dataCollectionView = [[ZSSLDataCollectionView alloc]init];
    self.dataCollectionView.frame = CGRectMake(0, 0, ZSWIDTH,self.dataCollectionView.height);
    self.dataCollectionView.backgroundColor = ZSViewBackgroundColor;
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.myCollectionView.scrollEnabled = NO;
    self.dataCollectionView.addDataStyle = (ZSAddResourceDataStyle)self.addDataStyle;
}

#pragma mark initCollectionView
- (void)initCollectionView:(CGFloat)height
{
    self.dataCollectionView.frame = CGRectMake(0, height, ZSWIDTH,self.dataCollectionView.height);
    self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.topSpace + self.dataCollectionView.bottom);
    [self.bgScrollView addSubview :self.dataCollectionView];
   
    //已完成和已操作的单子不能操作 加号不可以点击
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd)
    {
        self.dataCollectionView.userInteractionEnabled = YES;
        self.bgScrollView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight-60);
    }
    else
    {
        self.dataCollectionView.userInteractionEnabled = YES;
        self.dataCollectionView.isShowAdd = NO;
        self.bgScrollView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight);
    }
}

#pragma mark /*--------------------------------请求数据-------------------------------------------*/
#pragma mark 获取资料详情接口
- (void)requestForUpdateCollecState
{
    __weak typeof(self) weakSelf = self;
    [self.fileArray removeAllObjects];
    [LSProgressHUD showWithMessage:@"加载中"];
    [ZSRequestManager requestWithParameter:[self getMaterialsFilesParameter] url:[self getMaterialsFilesURL] SuccessBlock:^(NSDictionary *dic) {
        //1.户口本/央行征信报告
        if (self.addDataStyle == ZSAddResourceDataTwo ||
            (self.addDataStyle == ZSAddResourceDataCountless && [self.SLDocToModel.doccode isEqualToString:@"YHZXBG"]))
        {
            NSArray *array = dic[@"respData"][@"spdDocInfoVos"];
            if (array.count > 0) {
                for (NSDictionary *dict in array) {
                    ZSAddResourceModel *model = [ZSAddResourceModel yy_modelWithJSON:dict];
                    [weakSelf.fileArray addObject:model];
                }
            }
        }
        //2.其他资料
        else
        {
            ZSAddResourceModel *addResourceModel = [ZSAddResourceModel yy_modelWithJSON:dic[@"respData"]];
            if (addResourceModel.spdDocInfoVos.count > 0) {
                for (ZSWSFileCollectionModel *model in addResourceModel.spdDocInfoVos) {
                    //2.一个加号
                    if (weakSelf.addDataStyle == ZSAddResourceDataOne) {
                        [weakSelf.fileArray addObject:model];
                    }
                    //2.多个加号
                    else{
                        if (model.dataUrl.length > 0){
                            [weakSelf.fileArray addObject:model];
                        }
                    }
                }
            }
        }

        //是否可编辑
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd) {
            //可编辑加载数据
            [weakSelf configureDataSource];
        }else{
            //不可编辑加载数据
            [weakSelf configCloseAndCompletedata];
        }
        //更新坐标
        [weakSelf.dataCollectionView layoutSubviews];
        //顶部加文本UI
        [weakSelf initCollectionView:weakSelf.topSpace];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark /*--------------------------------准备数据-------------------------------------------*/
#pragma mark 准备数据
- (void)configureDataSource
{
    [self.itemDataArray removeAllObjects];
    [self.itemNameArray removeAllObjects];
    
    //1.户口本/央行征信报告
    if (self.addDataStyle == ZSAddResourceDataTwo)
    {
        for (ZSAddResourceModel *addModel in self.fileArray) {
            [self.itemNameArray addObject:[self nameFromSLAddModel:addModel]];
            NSMutableArray *dataArray = @[].mutableCopy;
            if (addModel.spdDocInfoVos.count > 0) {
                for (ZSWSFileCollectionModel *fileModel in addModel.spdDocInfoVos) {
                    [dataArray addObject:fileModel];
                }
            }
            [self.itemDataArray addObject:dataArray];
        }
    }
    //2.央行征信报告
    else if (self.addDataStyle == ZSAddResourceDataCountless && [self.SLDocToModel.doccode isEqualToString:@"YHZXBG"])
    {
        for (ZSAddResourceModel *addModel in self.fileArray) {
            [self.itemNameArray addObject:[self nameFromSLAddModel:addModel]];
            NSMutableArray *dataArray = @[].mutableCopy;
            if (addModel.spdDocInfoVos.count > 0) {
                for (ZSWSFileCollectionModel *fileModel in addModel.spdDocInfoVos) {
                    if (fileModel.dataUrl) {
                        [dataArray addObject:fileModel];
                    }
                }
                [self.itemDataArray addObject:dataArray];
            }
            else{
                [self.itemDataArray addObject:dataArray];
            }
        }
    }
    //3.其他资料
    else
    {
        [self.itemNameArray addObject:[self nameFromSLAddModel:nil]];
        [self.itemDataArray addObject:self.fileArray];
    }
    
    //给collectionview赋值
    self.dataCollectionView.itemArray      = self.itemDataArray;
    self.dataCollectionView.titleNameArray = self.itemNameArray;
    [self.dataCollectionView.myCollectionView reloadData];
}

#pragma mark 加载订单完成和关闭情况的数据
- (void)configCloseAndCompletedata
{
    [self.itemDataArray removeAllObjects];
    [self.itemNameArray removeAllObjects];
    
    //1.户口本/央行征信报告
    if (self.addDataStyle == ZSAddResourceDataTwo ||
        (self.addDataStyle == ZSAddResourceDataCountless && [self.SLDocToModel.doccode isEqualToString:@"YHZXBG"]))
    {
        for (ZSAddResourceModel *addModel in self.fileArray) {
            [self loadCloseAndCompleteData:addModel];
        }
    }
    //2.其他资料
    else
    {
        [self loadCloseAndCompleteData:nil];
    }

    //展示无图情况
    [self isShowErrorView];
    
    //给collectionview赋值
    self.dataCollectionView.itemArray      = self.itemDataArray;
    self.dataCollectionView.titleNameArray = self.itemNameArray;
    [self.dataCollectionView.myCollectionView reloadData];
}

#pragma mark 加载订单完成和关闭填充数据
- (void)loadCloseAndCompleteData:(ZSAddResourceModel *)addModel
{
    NSMutableArray *dataArray = @[].mutableCopy; //两个加号的时候
    NSMutableArray *itemArray = @[].mutableCopy; //不是两个加号的时候存储有数据的model
   
    //1.户口本/央行征信报告
    if (self.addDataStyle == ZSAddResourceDataTwo ||
        (self.addDataStyle == ZSAddResourceDataCountless && [self.SLDocToModel.doccode isEqualToString:@"YHZXBG"]))
    {
        [self.itemNameArray addObject:[self nameFromSLAddModel:addModel]];
        for (ZSWSFileCollectionModel *fileModel in addModel.spdDocInfoVos) {
            //2.1如果url存在放进数组中
            if (fileModel.dataUrl.length > 0) {
                [dataArray addObject:fileModel];
            }
        }
        //2.2如果数组大于0  赋值
        if (dataArray.count > 0) {
            if (dataArray.count == 1) {
                ZSWSFileCollectionModel *tempModel = [[ZSWSFileCollectionModel alloc]init];
                [dataArray addObject:tempModel];
            }
            [self.itemDataArray addObject:dataArray];
        }
    }
    //2.其他资料
    else
    {
        [self.itemNameArray addObject:[self nameFromSLAddModel:nil]];
        for (ZSWSFileCollectionModel *model in self.fileArray) {
            //1.1把有地址的图片放入数组中
            if (model.dataUrl.length > 0) {
                [itemArray addObject:model];
            }
        }
        //1.2如果数组大于0才赋值
        if (itemArray.count > 0){
            [self.itemDataArray addObject:itemArray];
        }
    }
}

#pragma mark 是否展示无数据的图片
- (void)isShowErrorView
{
    //当前没有数据,并且资料不是特殊资料
    if (self.itemDataArray.count == 0 && [NSString getErrorViewIsShowByDocName:self.SLDocToModel.doccode])
    {
        self.errorView.hidden = NO;
    }
}

#pragma mark 特殊资料区头标题展示(婚姻状况,户口本,征信报告)
- (NSString *)nameFromSLAddModel:(ZSAddResourceModel *)addModel
{
    NSString *string  = @"";
    
    //1.婚姻状况
    if ([self.SLDocToModel.doccode isEqualToString:@"HYZK"])
    {
        BizCustomers *customer;
        //星速贷
        if ([self.prdType isEqualToString:kProduceTypeStarLoan])
        {
            customer = [global.slOrderDetails.bizCustomers firstObject];
        }
        //赎楼宝
        else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
        {
            customer = [global.rfOrderDetails.bizCustomers firstObject];
        }
        //抵押贷
        else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
        {
            customer = [global.mlOrderDetails.bizCustomers firstObject];
        }
        //融易贷
        else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
        {
            customer = [global.elOrderDetails.bizCustomers firstObject];
        }
        //车位分期
        else if ([self.prdType isEqualToString:kProduceTypeCarHire])
        {
            customer = [global.chOrderDetails.bizCustomers firstObject];
        }
        //代办业务
        else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
        {
            customer = [global.abOrderDetails.bizCustomers firstObject];
        }
        
        if ([customer.beMarrage isEqualToString:@"1"] || [customer.beMarrage isEqualToString:@"4"]){
            string = @"未婚声明书";
        }
        else if ([customer.beMarrage isEqualToString:@"2"]){
            string = [NSString stringWithFormat:@"%@",@"结婚证"];
        }
        else if ([customer.beMarrage isEqualToString:@"3"]){
            string = [NSString stringWithFormat:@"%@",@"离婚证"];
        }
    }
    //2.户口本/征信报告
    else if ([self.SLDocToModel.doccode isEqualToString:@"HKB"] || [self.SLDocToModel.doccode isEqualToString:@"YHZXBG"])
    {
        NSString *name = addModel.subCategory;
        string = [NSString stringWithFormat:@"%@(%@)",SafeStr(name),SafeStr(addModel.custName)];
    }
    //3.其他
    else
    {
        string = self.SLDocToModel.docname;
    }
    
    return string;
}


#pragma mark /*--------------------------------上传/删除数据-------------------------------------------*/
#pragma mark 只上传文本
- (void)TextMaterialsOnly
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[weakSelf getUploadOnlyTextParameter] url:[weakSelf getUploadOnlyTextURL] SuccessBlock:^(NSDictionary *dic) {
        [LSProgressHUD hide];
        if ([weakSelf.dataCollectionView.deletdataIDArray count] == 0 && [[weakSelf getNeedUploadFilesArray] count] == 0) {
            //通知名称
            [weakSelf postNotificationForProductType];
            //上传成功并返回
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            //1.1有图片要删除 先删除再上传
            if ([weakSelf.dataCollectionView.deletdataIDArray count] > 0) {
                [weakSelf deletaDatas];
            }
            //1.2无删除直接上传
            else {
                [weakSelf uploadAllDatas];
            }
        }
    }ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
        [ZSTool showMessage:@"上传失败" withDuration:DefaultDuration];
    }];
}

#pragma mark 获取所要上传数据
- (NSMutableArray *)getNeedUploadFilesArray
{
    NSMutableArray *upArray = @[].mutableCopy;
    if ([self.dataCollectionView.itemArray count]) {
        for (NSMutableArray *array in self.dataCollectionView.itemArray) {
            if ([array count]) {
                for (ZSWSFileCollectionModel *colletionModel in array) {
                    if (colletionModel.dataUrl.length > 0 && colletionModel.isNewImage == YES) {
                        [upArray addObject:colletionModel];
                    }
                }
            }
        }
    }
    return upArray;
}

//#pragma mark 线上的个数
//- (NSInteger )getOnlineUploadFilesCount
//{
//    NSMutableArray *upArray = @[].mutableCopy;
//    if ([self.dataCollectionView.itemArray count]) {
//        for (NSMutableArray *array in self.dataCollectionView.itemArray) {
//            if ([array count]) {
//                for (ZSWSFileCollectionModel *colletionModel in array) {
//                    if (colletionModel.dataUrl.length > 0) {//线上的
//                        [upArray addObject:colletionModel];
//                    }
//                }
//            }
//        }
//    }
//    return upArray.count;
//}

#pragma mark 上传所有资料
- (void)uploadAllDatas
{
    //通知图片们设置下标,便于上传排序
    [NOTI_CENTER postNotificationName:@"setPhotoIndex" object:nil];
    
    //圆形进度条
    needUploadArray = [self getNeedUploadFilesArray];
    if (needUploadArray.count > 0){
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [needUploadArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self uploadDataWithUploadFileCache:idx];
                }];
            });
//            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//                [ZSTool showMessage:@"上传成功" withDuration:DefaultDuration];
//            });
        });
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 上传单个资料
- (void)uploadDataWithUploadFileCache:(NSInteger)selectIndex
{
    //参数
    ZSWSFileCollectionModel *fileCache = needUploadArray[selectIndex];
    NSMutableDictionary *dict = [self getAllMaterialsParameterWithFileModel:fileCache].mutableCopy;
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)fileCache.currentIndex] forKey:@"orderBy"];//图片添加角标,传到服务器的图片排序
    //数据上传
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:dict url:[self getUploadAndDeleteURL] SuccessBlock:^(NSDictionary *dic) {
        if (selectIndex == needUploadArray.count-1)
        {
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf postNotificationForProductType];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [ZSTool showMessage:@"上传成功" withDuration:DefaultDuration];
            });
        }
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [weakSelf.dataCollectionView setBottomBtnEnable:YES];//上传时，禁止交互. 上传失败，回复交互性
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 根据不同的产品发不同的通知
- (void)postNotificationForProductType
{
    //订单详情
    [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
    //产权情况表
    [NOTI_CENTER postNotificationName:kOrderDetailFreshPropertyData object:nil];
}

#pragma mark 删除数据
- (void)deletaDatas
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[weakSelf getDeleteIdParameter] url:[weakSelf getUploadAndDeleteURL] SuccessBlock:^(NSDictionary *dic) {
        [LSProgressHUD hide];
        //如果有可上传的资料,则调上传资料的接口，没有课上传的话，则上传成功,返回
        if ([[weakSelf getNeedUploadFilesArray] count]>0) {
            [weakSelf uploadAllDatas];//上传资料
        }else{
            //根据不同的产品发不同的通知
            [weakSelf postNotificationForProductType];
            [weakSelf showSuccessWith:@"删除成功"];//上传成功并返回
        }
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
        [ZSTool showMessage:@"上传失败" withDuration:DefaultDuration];
    }];
}

#pragma mark 上传成功并返回
- (void)showSuccessWith:(NSString*)str
{
    [ZSTool showMessage:str withDuration:DefaultDuration];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark /*--------------------------------请求参数-------------------------------------------*/
#pragma mark 获取资料状态参数
- (NSMutableDictionary *)getMaterialsFilesParameter
{
    NSMutableDictionary *parameter=  @{
                                       @"docId":self.SLDocToModel.docid,
                                       @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    return parameter;
}

#pragma mark 上传文本参数(子类需重写)
- (NSMutableDictionary *)getUploadOnlyTextParameter
{
    NSMutableDictionary *parameter=  @{}.mutableCopy;
    return parameter;
}

#pragma mark 删除资料参数
- (NSMutableDictionary*)getDeleteIdParameter
{
    NSMutableDictionary *dict = @{@"productType":self.prdType}.mutableCopy;
    //订单id
    [dict setObject:self.orderIDString ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType] forKey:@"orderNo"];
    //资料类型Id
    if (self.SLDocToModel.docid > 0){
        [dict setObject:self.SLDocToModel.docid forKey:@"docId"];
    }
    //资料类别
    if (self.SLDocToModel.docname) {
        [dict setObject:self.SLDocToModel.docname forKey:@"catagory"];
    }
    NSString *deleteIDStr = [self.dataCollectionView.deletdataIDArray componentsJoinedByString:@","];
    [dict setObject:deleteIDStr forKey:@"photoIds"];//删除图片id集合
    return dict;
}

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
    
    //户口本
    if ([self.SLDocToModel.doccode isEqualToString:@"HKB"])
    {
        //人员Id
        if (fileModel.custNo.length > 0){
            [dic setObject:fileModel.custNo forKey:@"custNo"];
        }
        //人员角色:贷款人,配偶,共有人等
        if (fileModel.subCategory.length > 0){
            [dic setObject:fileModel.subCategory forKey:@"docType"];
        }
        //个人页或者户主页
        if (fileModel.leafCategory.length > 0){
            [dic setObject:fileModel.leafCategory forKey:@"subType"];
        }
    }
    //央行征信报告
    else if ([self.SLDocToModel.doccode isEqualToString:@"YHZXBG"])
    {
        if (fileModel.currentSectionIndex) {
            ZSAddResourceModel *model = self.fileArray[fileModel.currentSectionIndex];
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
            ZSAddResourceModel *model = self.fileArray[0];
            //人员Id
            if (model.custNo.length > 0){
                [dic setObject:model.custNo forKey:@"custNo"];
            }
            //人员角色:贷款人,配偶,共有人等
            if (model.subCategory.length > 0){
                [dic setObject:model.subCategory forKey:@"docType"];
            }
        }
    }

    return dic;
}

#pragma mark /*--------------------------------请求网址-------------------------------------------*/
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

#pragma mark 上传和删除图片接口地址
- (NSString *)getUploadAndDeleteURL
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        return [ZSURLManager getSpdUploadOrDelPhotoDataURL];
    }
    //赎楼宝
    //抵押贷
    //车位分期
    //代办业务
    else
    {
        return [ZSURLManager getRedeemFloorUploadOrDelPhotoDataURL];
    }
}

#pragma mark 上传文本地址
- (NSString *)getUploadOnlyTextURL
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        return [ZSURLManager getSpdSaveMateriaTxtURL];
    }
    //赎楼宝
    //抵押贷
    //车位分期
    //代办业务
    else
    {
        return [ZSURLManager getRedeemFloorSaveMateriaTxtURL];
    }
}

#pragma mark /*-------------------------------ZSSLDataCollectionViewDelegate------------------------*/
//重置collview高度代理
- (void)refershDataCollectionViewHegiht
{
    self.isChanged = YES;
    
    //多张的时候更新坐标
    if (self.addDataStyle == ZSAddResourceDataCountless)
    {
        [self.dataCollectionView layoutSubviews];
        self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
        self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.dataCollectionView.myCollectionView.bottom + 120 + self.topSpace);
    }
}

//显示上传进度
- (void)showProgress:(NSString *)progressString;
{
    NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:@"hasbeenUploadNum"];
    NSUInteger needUploadNum = [USER_DEFALT integerForKey:@"needUploadNum"];
    if (hasbeenUploadNum > needUploadNum) {
        hasbeenUploadNum = needUploadNum;
    }
    if (needUploadNum > 0 && hasbeenUploadNum <=needUploadNum) {
        //右侧按钮,用于显示上传进度
        [self configureRightNavItemWithTitle:[NSString stringWithFormat:@"已上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum] withNormalImg:nil withHilightedImg:nil];
    }
    else{
        //右侧按钮,用于显示上传进度
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
            }
        }
        else {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:self.view];
            [self configureRightNavItemWithTitle:@"" withNormalImg:nil withHilightedImg:nil];
            //数据上传
            [self uploadTextDataAndImageData];
        }
    }
}

- (void)judePictureUploadingFailure:(BOOL)isFailure;//判断是否有图片上传失败
{
    self.isFailure = isFailure;
}

#pragma mark /*--------------------------------底部按钮------------------------------------------*/
#pragma mark 底部按钮
- (void)initWithBottomBtnWithTitle:(NSString *)title
{
    //已完成和已操作的单子不能操作
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd)
    {
        [self configuBottomButtonWithTitle:title];
    }
}

#pragma mark 点击底部按钮(保存资料)
- (void)bottomClick:(UIButton *)btn
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
    
    //数据上传
    [self uploadTextDataAndImageData];
}

#pragma mark /*--------------------------------子类重写------------------------------------------*/
#pragma mark 资料上传
- (void)uploadTextDataAndImageData
{
    if (self.isOnlyText) {
        [self TextMaterialsOnly];
    }
    else
    {
        //1.1有图片要删除 先删除再上传
        if ([self.dataCollectionView.deletdataIDArray count] > 0) {
            [self deletaDatas];
        }
        //1.2无删除直接上传
        else {
            [self uploadAllDatas];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
