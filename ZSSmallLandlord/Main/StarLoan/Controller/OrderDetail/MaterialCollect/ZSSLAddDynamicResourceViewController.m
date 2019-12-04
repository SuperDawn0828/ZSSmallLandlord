//
//  ZSSLAddDynamicResourceViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/15.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSSLAddDynamicResourceViewController.h"
#import "ZSSingleLineTextTableViewCell.h"
#import "ZSMoreLineTextTableViewCell.h"
#import "ZSTextWithPhotosTableViewCell.h"
#import "ZSSLDataCollectionView.h"
#import "ZSDynamicResourcePhotoCellModel.h"

@interface ZSSLAddDynamicResourceViewController ()<ZSSingleLineTextTableViewCellDelegate,ZSMoreLineTextTableViewCellDelegate,ZSTextWithPhotosTableViewCellDelegate,ZSSLDataCollectionViewDelegate,ZSAlertViewDelegate>
{
    NSArray            *needUploadArray;//待上传的图片或视频对象）
    LSProgressHUD      *hud;
    BOOL               isShowHUD;
    BOOL               isCellProgress;
    dispatch_queue_t   queue;
    dispatch_group_t   group;
}
@property (nonatomic,assign) BOOL                   isFailure;           //是否有图片上传失败
@property (nonatomic,strong) NSMutableArray         *listDataArray;      //左侧需要展示的数据列表
@property (nonatomic,strong) ZSSLDataCollectionView *dataCollectionView; //footer
@property (nonatomic,strong) NSMutableArray         *itemDataArray;      //值数组
@property (nonatomic,strong) NSMutableArray         *fileArray;          //请求数据数组
@property (nonatomic,assign) BOOL                   isChanged;           //是否有改变值(用于返回按钮和底部按钮检测内容是否有变化)
@property (nonatomic,assign) BOOL                   isChangedPhotoCell;  //photocell是否有改变值(用于返回按钮和底部按钮检测内容是否有变化)
@property (nonatomic,strong) NSMutableDictionary    *rightDataDict;
@end

@implementation ZSSLAddDynamicResourceViewController

#pragma mark 懒加载
- (NSMutableArray *)listDataArray
{
    if (_listDataArray == nil) {
        _listDataArray = [[NSMutableArray alloc]init];
    }
    return _listDataArray;
}

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

- (NSMutableDictionary *)rightDataDict
{
    if (_rightDataDict == nil){
        _rightDataDict = [[NSMutableDictionary alloc]init];
    }
    return _rightDataDict;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = [self setTitleString:NO];
    [self setLeftBarButtonItem];
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd) {//已完成和已操作的单子不能操作
        [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64-60) withStyle:UITableViewStylePlain];
        [self initWithBottomBtnWithTitle:@"保存"];//创建底部按钮
    }
    else {
        [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64) withStyle:UITableViewStylePlain];
    }
    //Data
    [self configureErrorViewWithStyle:ZSErrorWithoutUploadFiles];//无上传资料数据
    [self requestDynamicList];
    isShowHUD = NO;
}

- (NSString *)setTitleString:(BOOL)isTableFooter//顶部标题直接显示资料名称, 尾视图也就是老资料需要根据婚姻状况显示
{
    NSString *string = @"";
    if ([self.SLDocToModel.doccode isEqualToString:@"HYZK"])
    {
        //星速贷
        if ([self.prdType isEqualToString:kProduceTypeStarLoan])
        {
            string = isTableFooter ? [self marryString:[global.slOrderDetails.bizCustomers firstObject].beMarrage] : [NSString stringWithFormat:@"%@",self.SLDocToModel.docname];
        }
        //赎楼宝
        else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
        {
            string = isTableFooter ? [self marryString:[global.rfOrderDetails.bizCustomers firstObject].beMarrage] : [NSString stringWithFormat:@"%@",self.SLDocToModel.docname];
        }
        //抵押贷
        else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
        {
            string = isTableFooter ? [self marryString:[global.mlOrderDetails.bizCustomers firstObject].beMarrage] : [NSString stringWithFormat:@"%@",self.SLDocToModel.docname];
        }
        //融易贷
        else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
        {
            string = isTableFooter ? [self marryString:[global.elOrderDetails.bizCustomers firstObject].beMarrage] : [NSString stringWithFormat:@"%@",self.SLDocToModel.docname];
        }
        //车位分期
        else if ([self.prdType isEqualToString:kProduceTypeCarHire])
        {
            string = isTableFooter ? [self marryString:[global.chOrderDetails.bizCustomers firstObject].beMarrage] : [NSString stringWithFormat:@"%@",self.SLDocToModel.docname];
        }
        //代办业务
        else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
        {
            string = isTableFooter ? [self marryString:[global.abOrderDetails.bizCustomers firstObject].beMarrage] : [NSString stringWithFormat:@"%@",self.SLDocToModel.docname];
        }
    }
    else
    {
        string = [NSString stringWithFormat:@"%@",self.SLDocToModel.docname];
    }
    return string;
}

- (NSString *)marryString:(NSString *)beMarrage
{
    NSString *string = @"";
    if (beMarrage.intValue == 1 || beMarrage.intValue == 4){
        string = @"未婚声明书";
    }
    else if (beMarrage.intValue == 2){
        string = @"结婚证";
    }
    else if (beMarrage.intValue == 3){
        string = @"离婚证";
    }
    return string;
}

#pragma mark /*----------------------------------返回事件----------------------------------*/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd)
    {
        //有新增图片或删除图片,以及文本资料
        if ([self getNeedUploadFilesArray].count > 0
            || self.dataCollectionView.deletdataIDArray.count > 0
            || self.isChanged == YES
            || self.isChangedPhotoCell == YES)
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

#pragma mark 判断当前页面是否有数据修改
- (void)leftAction;
{
    //有新增图片或删除图片,以及文本资料
    if ([self getNeedUploadFilesArray].count > 0
        || self.dataCollectionView.deletdataIDArray.count > 0
        || self.isChanged == YES
        || self.isChangedPhotoCell == YES)
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

- (void)AlertView:(ZSAlertView *)alert;//确认按钮响应的方法
{
    //必填资料没填完
    if (self.bottomBtn.userInteractionEnabled == NO) {
        [ZSTool showMessage:@"请继续完善资料" withDuration:DefaultDuration];
        return;
    }
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

#pragma mark /*----------------------------------获取数据----------------------------------*/
#pragma mark 获取资料动态列表
- (void)requestDynamicList
{
    __weak typeof(self) weakSelf = self;
    [weakSelf.listDataArray removeAllObjects];
    [LSProgressHUD showWithMessage:@"加载中"];
    [ZSRequestManager requestWithParameter:[weakSelf getDynamicListParameter] url:[ZSURLManager getDynamicListURL] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSDynamicDataModel *model = [ZSDynamicDataModel yy_modelWithJSON:dict];
                model.prdType = self.prdType;
                [weakSelf.listDataArray addObject:model];
            }
        }
//        [weakSelf.tableView reloadData];
        [weakSelf fillDynamicListData];//数据请求
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 获取动态资料list参数
- (NSMutableDictionary *)getDynamicListParameter
{
    NSMutableDictionary *parameter = @{@"prdDocsId":self.SLDocToModel.docid}.mutableCopy;
    return parameter;
}

#pragma mark 请求接口资料
- (void)fillDynamicListData
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[self getDynamicListDataParameter] url:[self getMaterialsFilesURL] SuccessBlock:^(NSDictionary *dic) {
        //数据填充
        NSDictionary *newDic = dic[@"respMap"];
        if (newDic.count) {
            [newDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *string = [NSString stringWithFormat:@"%@",key];
                if ([string containsString:@"ext"]) {
                    [weakSelf fillInDataWithKey:string withObject:obj];
                }
            }];
        }
        //是否显示尾视图
        [weakSelf configureFooterView:dic[@"respData"][@"remark"]];
//        //数据刷新
//        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

- (void)fillInDataWithKey:(NSString *)keyName withObject:(NSString *)object
{
    [self.listDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZSDynamicDataModel *model = self.listDataArray[idx];
        if ([model.fieldName isEqualToString:keyName]) {
            if (object.length && ![object isEqualToString:keyName]) {//有数据并且数据跟key名不一样就可以保存这个值了
                model.rightData = object;
            }
            [self.listDataArray replaceObjectAtIndex:idx withObject:model];
            return;
        }
    }];
}

#pragma mark 获取动态资料list填充值参数
- (NSMutableDictionary *)getDynamicListDataParameter
{
    NSMutableDictionary *parameter = @{
                                       @"docId":self.SLDocToModel.docid,
                                       @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    return parameter;
}

#pragma mark 获取照片资料详情接口
- (void)requestForUpdateCollecState
{
    __weak typeof(self) weakSelf = self;
    [self.fileArray removeAllObjects];
    [LSProgressHUD showWithMessage:@"加载中"];
    [ZSRequestManager requestWithParameter:[weakSelf getDynamicListDataParameter] url:[weakSelf getMaterialsFilesURL] SuccessBlock:^(NSDictionary *dic) {
        ZSAddResourceModel *addResourceModel = [ZSAddResourceModel yy_modelWithJSON:dic[@"respData"]];
        if (addResourceModel.spdDocInfoVos.count > 0) {
            //显示老资料
            self.tableView.tableFooterView = self.dataCollectionView;
            if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd) {
            }else{
                self.dataCollectionView.isShowAdd = NO;
            }
            
            //资料存储model
            for (ZSWSFileCollectionModel *model in addResourceModel.spdDocInfoVos) {
                if (model.dataUrl.length > 0){
                    [weakSelf.fileArray addObject:model];
                }
            }
            //是否可编辑
            if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && weakSelf.isShowAdd) {
                //可编辑加载数据
                [weakSelf configureDataSource];
                weakSelf.tableView.height = ZSHEIGHT-kNavigationBarHeight-60;//table的高度
            }
            else {
                //不可编辑加载数据
                [weakSelf configCloseAndCompletedata];
                weakSelf.tableView.height = ZSHEIGHT-kNavigationBarHeight;//table的高度
                [weakSelf.bottomView removeFromSuperview];//底部按钮
                //原来的图片资料木有, 动态资料也没有, 就显示缺省页
                if (weakSelf.fileArray.count == 0 && [[self dynamicResourceIsEmpty] isEqualToString:@"YES"]) {
                    weakSelf.errorView.hidden = NO;
                }else{
                    weakSelf.errorView.hidden = YES;
                }
            }
            //更新坐标
            [weakSelf.dataCollectionView layoutSubviews];
            weakSelf.dataCollectionView.height = weakSelf.dataCollectionView.myCollectionView.height;
            //更新tableView
            [weakSelf.tableView reloadData];
        }
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

- (void)configureDataSource
{
    [self.itemDataArray removeAllObjects];
    //不是两个加号
    [self loadExitData:nil];
    //给collectionview赋值
    self.dataCollectionView.itemArray = self.itemDataArray;
    [self.dataCollectionView.myCollectionView reloadData];
}

#pragma mark 加载订单完成和关闭情况的数据
- (void)configCloseAndCompletedata
{
    [self.itemDataArray removeAllObjects];
    //不是两个加号
    [self loadCloseAndCompleteData:nil];
    //给collectionview赋值
    self.dataCollectionView.itemArray = self.itemDataArray;
    [self.dataCollectionView.myCollectionView reloadData];
}

- (void)loadExitData:(ZSAddResourceModel *)addModel
{
    [self.itemDataArray addObject:self.fileArray];
}

- (void)loadCloseAndCompleteData:(ZSAddResourceModel *)addModel
{
    NSMutableArray *itemArray = @[].mutableCopy; //不是两个加号的时候存储有数据的model
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

#pragma mark 获取资料详情地址
- (NSString *)getMaterialsFilesURL
{
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
    return urlString;
}

#pragma mark /*----------------------------------上传数据----------------------------------*/
#pragma mark 上传动态资料list的数据
- (void)uploadDynamicListData:(BOOL)isShowNotice
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[weakSelf getDynamicListUploadParameter] url:[ZSURLManager getDynamicListDataUploadURL] SuccessBlock:^(NSDictionary *dic)
    {
        if (isShowNotice == YES) {
            [ZSTool showMessage:@"保存成功" withDuration:DefaultDuration];
        }else{
            [ZSTool showMessage:@"删除成功" withDuration:DefaultDuration];
        }
        [weakSelf postNotificationForProductType];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 上传动态资料list参数
- (NSMutableDictionary *)getDynamicListUploadParameter
{
    NSMutableDictionary *parameter = @{
                                       @"prdType":self.prdType,
                                       @"docId":self.SLDocToModel.docid,
                                       @"serialNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType]
                                       }.mutableCopy;
    [self.listDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZSDynamicDataModel *model = self.listDataArray[idx];
        if (model.rightData.length > 0) {
            [parameter setObject:model.rightData forKey:model.fieldName];
        }else{
            [parameter setObject:@"" forKey:model.fieldName];
        }
    }];
    return parameter;
}

#pragma mark /*--------------------------------删除/上传照片-------------------------------------------*/
#pragma mark 上传已删除的资料
- (void)deletaDatas
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[weakSelf getDeleteIdParameter] url:[weakSelf getUploadAndDeleteURL] SuccessBlock:^(NSDictionary *dic) {
        [LSProgressHUD hide];
        if ([[weakSelf getNeedUploadFilesArray] count]>0) {
            //上传资料
            [weakSelf uploadAllDatas];
        }
        else{
            //要等老的接口资料上传成功才能调用新的
            //动态列表资料
            [weakSelf uploadDynamicListData:NO];
        }
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
        [ZSTool showMessage:@"上传失败" withDuration:DefaultDuration];
    }];
}

#pragma mark 删除资料参数
- (NSMutableDictionary*)getDeleteIdParameter
{
    NSMutableDictionary *parameter = @{
                                       @"productType":self.prdType,
                                       @"docId":self.SLDocToModel.docid,
                                       @"catagory":self.SLDocToModel.docname,
                                       @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                      }.mutableCopy;
    NSString *deleteIDStr = [self.dataCollectionView.deletdataIDArray componentsJoinedByString:@","];
    [parameter setObject:deleteIDStr forKey:@"photoIds"];//删除图片id集合
    return parameter;
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
                //主线程,上传成功提示
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    [ZSTool showMessage:@"上传成功" withDuration:DefaultDuration];
                });
            });
        });
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 上传单个资料
- (void)uploadDataWithUploadFileCache:(NSInteger)selectIndex
{
    __weak typeof(self) weakSelf = self;
    //参数
    ZSWSFileCollectionModel *fileCache = needUploadArray[selectIndex];
    NSMutableDictionary *dict = [weakSelf getAllMaterialsParameterWithFileModel:fileCache].mutableCopy;
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)fileCache.currentIndex] forKey:@"orderBy"];//图片添加角标,传到服务器的图片排序
    //数据上传
    [ZSRequestManager requestWithParameter:dict url:[weakSelf getUploadAndDeleteURL] SuccessBlock:^(NSDictionary *dic) {
        //根据不同的产品发不同的通知
        if (selectIndex == needUploadArray.count-1) {
            //要等老的接口资料上传成功才能调用新的
            //动态列表资料
            [weakSelf uploadDynamicListData:YES];
        }
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 资料图片(视频)上传参数
- (NSMutableDictionary*)getAllMaterialsParameterWithFileModel:(ZSWSFileCollectionModel*)fileModel
{
    NSMutableDictionary *dic = @{
                                 @"productType":self.prdType,
                                 @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                 }.mutableCopy;
    //照片url
    if (fileModel.dataUrl.length > 0) {
        [dic setObject:fileModel.dataUrl forKey:@"photoUrl"];
    }
    //资料类型Id
    if (self.SLDocToModel.docid > 0){
        [dic setObject:self.SLDocToModel.docid forKey:@"docId"];
    }
    //资料类型
    if (self.SLDocToModel.docname > 0){
        [dic setObject:self.SLDocToModel.docname forKey:@"catagory"];
    }
    return dic;
}

#pragma mark 上传和删除图片接口地址
- (NSString *)getUploadAndDeleteURL
{
    return [ZSURLManager getuploadOrDelPhotoDataForPropertyRightURL];;
}

#pragma mark 根据不同的产品发不同的通知
- (void)postNotificationForProductType
{
    //刷新订单详情
    [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
}

#pragma mark /*----------------------------------UITableView----------------------------------*/
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSDynamicDataModel *model = self.listDataArray[indexPath.row];
    //多行文本
    if (model.fieldType.intValue == 2 )
    {
        if (model.rightData.length > 0) {
            if (!model.cellHeight) {
                CGFloat height = [ZSTool getStringHeight:model.rightData withframe:CGSizeMake(ZSWIDTH-30-32, 1000) withSizeFont:[UIFont systemFontOfSize:15]];
                if (height < CellHeight) {
                    model.cellHeight = CellHeight;
                }else{
                    model.cellHeight = height + 16;
                }
            }
            return CellHeight + model.cellHeight + 10;
        }else{
            return CellHeight*2 + 10;
        }
    }
    //照片
    else if (model.fieldType.intValue == 3)
    {
        if (!model.cellHeight) {
            return CellHeight + photoWidth + 25;
        }
        else {
            return (CellHeight-30) + model.cellHeight + 5;
        }
    }
    //单行文本
    else {
        return CellHeight + 10;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSDynamicDataModel *model = self.listDataArray[indexPath.row];
    //多行文本
    if (model.fieldType.intValue == 2 )
    {
        ZSMoreLineTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier2"];
        if (cell == nil) {
            cell = [[ZSMoreLineTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier2"];
            cell.delegate = self;
            cell.isShowAdd = self.isShowAdd;
        }
        cell.currentIndex = indexPath.row;
        cell.model = model;
        return cell;
    }
    //图片
    else if (model.fieldType.intValue == 3)
    {
        ZSTextWithPhotosTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ZSTextWithPhotosTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier3"];
            cell.delegate = self;
            cell.isShowAdd = self.isShowAdd;
        }
        cell.currentIndex = indexPath.row;
        cell.model = model;
        if (model.imageDataArray) {
            cell.imageDataArray = model.imageDataArray;
        }
        return cell;
    }
    //单行文本
    else
    {
        ZSSingleLineTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
        if (cell == nil) {
            cell = [[ZSSingleLineTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.isShowAdd = self.isShowAdd;
        }
        cell.currentIndex = indexPath.row;
        cell.model = model;
        return cell;
    }
}

#pragma mark ZSSingleLineTextTableViewCellDelegate
- (void)sendCurrentCellData:(NSString *)string withIndex:(NSUInteger)currentIndex;//传递输入框的值或者"请选择"按钮选择成功以后的值
{
    ZSDynamicDataModel *model = self.listDataArray[currentIndex];
    model.rightData = string;
    [self.listDataArray replaceObjectAtIndex:currentIndex withObject:model];
    //刷新当前cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.isChanged = YES;
}

#pragma mark ZSMoreLineTextTableViewCellDelegate
- (void)sendCurrentCellData:(NSString *)string withIndex:(NSUInteger)currentIndex withHeight:(CGFloat)textHeight;//传递输入框的值或者和值得高度
{
    ZSDynamicDataModel *model = self.listDataArray[currentIndex];
    model.rightData = string;
    model.cellHeight = textHeight;
    [self.listDataArray replaceObjectAtIndex:currentIndex withObject:model];
    //刷新当前cell
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.isChanged = YES;
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

#pragma mark /*----------------------------------尾视图----------------------------------*/
#pragma mark 是否显示尾视图
- (void)configureFooterView:(NSString *)remarkString
{
    //datacollectionView
    self.dataCollectionView = [[ZSSLDataCollectionView alloc]init];
    self.dataCollectionView.frame = CGRectMake(0, 0, ZSWIDTH, photoWidth+20);
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.myCollectionView.scrollEnabled = NO;
    self.dataCollectionView.addDataStyle = ZSAddResourceDataCountless;//添加照片的形式
    self.dataCollectionView.titleNameArray = [[NSMutableArray alloc]initWithObjects:[self setTitleString:YES], nil];
    
    //prdDocs remark备注字段为“NEW”时，界面不显示原来的图片控件
    if ([remarkString isEqualToString:@"NEW"])
    {
        self.tableView.tableFooterView = nil;
        //原来的图片资料木有, 动态资料也没有, 就显示缺省页
        if ([[self dynamicResourceIsEmpty] isEqualToString:@"YES"]) {
            self.errorView.hidden = NO;
        }
    }
    else {
        //原来的资料详情接口请求(请求成功之后再根据是否有资料显示collectionview,所以将以下代码挪到请求成功之后)
        [self requestForUpdateCollecState];
//        self.tableView.tableFooterView = self.dataCollectionView;
//        //已完成和已操作的单子不能操作
//        if ([ZSTool checkStarLoanOrderIsCanEditingWithType] && self.isShowAdd) {
//        }else{
//            self.dataCollectionView.isShowAdd = NO;
//        }
    }
    
    [self.tableView reloadData];
}

#pragma mark 不是当前处理人,动态资料字段全部为空,就不要显示table了
- (NSString *)dynamicResourceIsEmpty
{
    NSString *isEmpty;
    NSUInteger count = 0;
    if (self.isShowAdd == NO) {
        NSArray *array = [NSArray arrayWithArray:self.listDataArray];
        //动态资料没有需要填写的数据,直接设置isEmpty为yes
        if (array.count ==  0) {
            isEmpty = @"YES";
        }
        //动态资料有需要填写的数据,但是都没有填,设置isEmpty为yes
        else
        {
            for (ZSDynamicDataModel *model in array) {
                if (model.rightData.length == 0 || [model.rightData isKindOfClass:[NSNull class]]) {
                    count = count + 1;
                }
            }
            if (count == array.count) {
                isEmpty = @"YES";
                self.listDataArray = [[NSMutableArray alloc]init];
            }
            else{
                isEmpty = @"NO";
                [self.tableView reloadData];
            }
        }
    }
    else{
        [self.tableView reloadData];
    }
    return isEmpty;
}

#pragma mark /*-------------------------------ZSSLDataCollectionViewDelegate----------------------------*/
//重置collview高度代理
- (void)refershDataCollectionViewHegiht
{
    //多张的时候更新坐标
    [self.dataCollectionView layoutSubviews];
    self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
    self.tableView.tableFooterView = self.dataCollectionView;
}

//显示上传进度
- (void)showProgress:(NSString *)progressString;
{
    NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:@"hasbeenUploadNum"];
    NSUInteger needUploadNum = [USER_DEFALT integerForKey:@"needUploadNum"];
    if (hasbeenUploadNum > needUploadNum) {
        hasbeenUploadNum = needUploadNum;
    }
    //右侧按钮,用于显示上传进度
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
        }
        else {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:self.view];
            [self configureRightNavItemWithTitle:@"" withNormalImg:nil withHilightedImg:nil];
            //数据上传
            [self bottomClick:nil];
        }
    }
}

//判断是否有图片上传失败
- (void)judePictureUploadingFailure:(BOOL)isFailure;
{
    self.isFailure = isFailure;
}

#pragma mark /*----------------------------------底部按钮----------------------------------*/
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
- (void)bottomClick:(UIButton *)sender
{
    //有必填项没有填
    for (ZSDynamicDataModel *model in self.listDataArray) {
        if (model.isNecessary.intValue == 1) {
            //如果是照片cell,有可能有照片但是照片未上传成功
            if (model.fieldType.intValue == 3) {
                if (!model.imageDataArray || [model.imageDataArray isEqual:@[@[]]]) {
                    if (model.rightData.length == 0 || [model.rightData isKindOfClass:[NSNull class]]) {
                        [ZSTool showMessage:[NSString stringWithFormat:@"%@资料未上传",model.fieldMeaning] withDuration:DefaultDuration];
                        return;
                    }
                }
                if (model.rightData.length == 0 || [model.rightData isKindOfClass:[NSNull class]]) {
                    if (!model.imageDataArray || [model.imageDataArray isEqual:@[@[]]]) {
                        [ZSTool showMessage:[NSString stringWithFormat:@"%@资料未上传",model.fieldMeaning] withDuration:DefaultDuration];
                        return;
                    }
                }
            }
            //其他的只需要看数据就好了
            else {
                if (model.rightData.length == 0 || [model.rightData isKindOfClass:[NSNull class]]) {
                    [ZSTool showMessage:[NSString stringWithFormat:@"%@资料未上传",model.fieldMeaning] withDuration:DefaultDuration];
                    return;
                }
            }
        }
    }
    
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
    if ([self getNeedUploadFilesArray].count == 0
        && self.dataCollectionView.deletdataIDArray.count == 0
        && !self.isChanged
        && !self.isChangedPhotoCell)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //没有老资料就直接请求动态资料接口
    if (self.tableView.tableFooterView == nil)
    {
        //动态列表资料
        [self uploadDynamicListData:YES];
    }
    else
    {
    //有老资料就等老资料上传再请求动态资料
        if (self.dataCollectionView.deletdataIDArray.count > 0 || [self getNeedUploadFilesArray].count > 0)
        {
            //有图片要删除 先删除再上传
            if ([self.dataCollectionView.deletdataIDArray count]>0) {
                [self deletaDatas];
            }
            //无删除直接上传
            else {
                [self uploadAllDatas];
            }
        }
        else
        {
            //动态列表资料
            [self uploadDynamicListData:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
