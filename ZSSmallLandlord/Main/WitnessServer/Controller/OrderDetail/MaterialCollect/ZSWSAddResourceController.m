//
//  ZSWSAddResourceController.m
//  ZSSmallLandlord
//
//  Created by 武 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSAddResourceController.h"
#import "ZSWSDataCollectionView.h"
#import "ZSWSAddResourceModel.h"

#define itemWidth  (ZSWIDTH- (1+4)*10)/4

@interface ZSWSAddResourceController ()<ZSWSDataCollectionViewDelegate,ZSAlertViewDelegate>
{
    UIImageView        *playImg;
    NSArray            *needUploadArray;//待上传的图片或视频对象）
    LSProgressHUD      *hud;
    BOOL               isShowHUD;
}

@property(nonatomic,assign)BOOL isFailure;           //是否有图片上传失败

@end

@implementation ZSWSAddResourceController

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
    self.title = [NSString stringWithFormat:@"%@%@",self.docInfoModel.docName,self.docInfoModel.docType];
    [self initScrollView];
    [self setLeftBarButtonItem];
    [self requestForUpdateCollecState];
    [self initScrollView];
    [self configureErrorViewWithStyle:ZSErrorWithoutUploadFiles];//无上传资料数据
}

#pragma mark 返回事件 判断当前页面是否有数据修改
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self getNeedUploadFilesArray].count > 0 || self.dataCollectionView.deletdataIDArray.count > 0)
    {
        [self leftAction];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)leftAction;
{
    //有新增图片或删除图片
    if ([self getNeedUploadFilesArray].count > 0 || self.dataCollectionView.deletdataIDArray.count > 0)
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
    [self bottomClick:nil];
}

- (void)AlertViewCanCleClick:(ZSAlertView *)alert;//取消按钮响应的方法
{
    //有图片上传到Zimg服务器了 进行删除
    if ([[self getNeedUploadFilesArray] count]) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            dispatch_apply([[self getNeedUploadFilesArray] count], queue, ^(size_t index) {
                [ZSRequestManager removeImageData:[self getNeedUploadFilesArray][index] SuccessBlock:^(NSDictionary *dic) {
                } ErrorBlock:^(NSError *error) {
                }];
            });
        });
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取资料收集详情url
- (NSString *)getMaterialsFilesURL
{
    return [ZSURLManager getQueryWitnessDocDataByDocIdURL];
}

#pragma mark 资料照片上传或删除url
- (NSString *)getUploadAndDeleteURL
{
    return [ZSURLManager getUpdateOrDelPhotoDataURL];
}

#pragma mark 只上传文本
- (void)TextMaterialsOnly
{
    if ([self.dataCollectionView.deletdataIDArray count]>0) {
        [self deletaDatas];
    }else {
        [self uploadAllDatas];
    }
}

#pragma mark initScrollView
- (void)initScrollView
{
    //滑动scrollView
    self.bgScrollView = [[UIScrollView alloc]init];
    self.bgScrollView.backgroundColor = ZSViewBackgroundColor;
    self.bgScrollView.frame = CGRectMake(0, 0, ZSHEIGHT, ZSHEIGHT - 64);
    self.bgScrollView.contentSize = CGSizeMake(ZSHEIGHT, ZSHEIGHT);
    [self.view addSubview:self.bgScrollView];
    
    //datacollectionView
    self.dataCollectionView = [[ZSWSDataCollectionView alloc]init];
    self.dataCollectionView.frame = CGRectMake(0, 0, ZSWIDTH,self.dataCollectionView.height);
    self.dataCollectionView.backgroundColor = ZSViewBackgroundColor;
    self.dataCollectionView.isShowTitle = YES;
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.bottomBtn.hidden = NO;
    self.dataCollectionView.myCollectionView.scrollEnabled = NO;
    self.dataCollectionView.addDataStyle = (ZSAddResourceDataStyle)self.addDataStyle;//资料类型
}

#pragma mark initCollectionView
- (void)initCollectionView:(CGFloat)height
{
    self.dataCollectionView.frame = CGRectMake(0, height, ZSWIDTH,self.dataCollectionView.height);
    self.dataCollectionView.bottomBtn.hidden = NO;
    [self.dataCollectionView.bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview :self.dataCollectionView];
    self.dataCollectionView.docId = self.docInfoModel.tid;
    self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.dataCollectionView.bottomBtn.bottom + 20 + 15 + self.topSpace);
    self.isShowAdd = YES;
    //已完成和已操作的单子不能操作 加号不可以点击
    [self checkOrderCanEnabled];
}

#pragma mark 判断单子是否可以操作
- (void)checkOrderCanEnabled
{
    //已完成和已操作的单子不能操作 加号不可以点击
    if ([ZSTool  checkWitnessServerOrderIsCanEditing] && self.isShowAdd){
        self.dataCollectionView.userInteractionEnabled = YES;
        //    [self configuBottomButtonWithTitle:@"保存" OriginY:[self resetHight] +self.topSpace + 15];
        self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.dataCollectionView.bottomBtn.bottom + 20 + 15 + self.topSpace);
        //   [self.bgScrollView addSubview: self.bottomBtn];
    }else{
        self.dataCollectionView.userInteractionEnabled = YES;
        self.dataCollectionView.isShowAdd = NO;
        self.dataCollectionView.bottomBtn.hidden = YES;
        self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.dataCollectionView.bottomBtn.bottom + 20 + 15 + self.topSpace);
    }
}

#pragma mark /*--------------------------------请求数据-------------------------------------------*/
#pragma mark 获取资料收集详情
- (void)requestForUpdateCollecState
{
    __weak typeof(self) weakSelf = self;
    [self.fileArray removeAllObjects];
    [LSProgressHUD showToView:self.view message:@"加载中"];
    NSMutableDictionary *parameter = @{
                                       @"tid":self.docInfoModel.tid,
                                       @"docId":self.docInfoModel.docId,
                                       @"orderId":global.wsOrderDetail.projectInfo.tid,
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getQueryWitnessDocDataByDocIdURL] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSWSAddResourceModel *model = [ZSWSAddResourceModel yy_modelWithJSON:dict];
                [weakSelf.fileArray addObject:model];
            }
        }
        if ([ZSTool checkWitnessServerOrderIsCanEditing]){
            [weakSelf configureDataSource];
        }else{
            [weakSelf configCloseAndCompletedata];
        }
        [weakSelf.dataCollectionView layoutSubviews];
        [weakSelf initCollectionView:weakSelf.topSpace];
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark /*--------------------------------准备数据-------------------------------------------*/
#pragma mark 准备数据
- (void)configureDataSource
{
    [self.itemDataArray removeAllObjects];
    [self.itemNameArray removeAllObjects];
    NSMutableArray *categoryArray = @[].mutableCopy;//资料细分id数组
    //修整数据。把数据转换成  大数组装小数组，且以对象的形式添加
    for (ZSWSAddResourceModel *addModel in self.fileArray) {
        //区头显示
        [self.itemNameArray addObject:[self nameFromAddModel:addModel]];
        //有数据的时候赋值
        if (addModel.docDataList.count > 0){
            [self loadExitData:addModel];
        }else{
            [self loadNodata:addModel];
        }
    }
    //给collectionview赋值
    self.dataCollectionView.itemArray = self.itemDataArray;
    self.dataCollectionView.titleNameArray = self.itemNameArray;
    self.dataCollectionView.biztemplateItemidArray = categoryArray;
    [self.dataCollectionView.myCollectionView reloadData];
}

#pragma mark 加载已有数据
- (void)loadExitData:(ZSWSAddResourceModel *)addModel
{
    //当是两个加号并且相应的区的行数个数为1
    if (self.addDataStyle == ZSAddResourceDataTwo && addModel.docDataList.count == 1) {
        ZSWSFileCollectionModel *fileModel1 = [[ZSWSFileCollectionModel alloc]init];
        ZSWSFileCollectionModel *model = [addModel.docDataList firstObject];
        fileModel1.custNo = addModel.custNo;
        model.custNo = addModel.custNo;
        model.thumbnailUrl = [NSString stringWithFormat:@"%@?w=200",model.dataUrl];//如果是图片,生成缩略图
        if ([model.subCategory isEqualToString:@"户主页"]){
            [self.itemDataArray addObject:@[model,fileModel1].mutableCopy];
            fileModel1.subCategory = @"个人页";
        }else{
            [self.itemDataArray addObject:@[fileModel1,model].mutableCopy];
            fileModel1.subCategory = @"户主页";
        }
    }
    else {
        //有数据时加载两个加号且都有值时  另外两种情况有值
        NSMutableArray *dataArray = @[].mutableCopy;
        for (ZSWSFileCollectionModel *fileModel in addModel.docDataList ) {
            [dataArray addObject:fileModel];
            //把custNo赋值给假的model
            fileModel.custNo = addModel.custNo;
            fileModel.thumbnailUrl = [NSString stringWithFormat:@"%@?w=200",fileModel.dataUrl];//如果是图片,生成缩略图
        }
        if (self.addDataStyle == ZSAddResourceDataCountless){
            self.otherCustNo = addModel.custNo;
        }
        [self.itemDataArray addObject:dataArray];
    }
}

#pragma mark 加载无数据情况
- (void)loadNodata:(ZSWSAddResourceModel *)addModel
{
    //没有数据的时候
    ZSWSFileCollectionModel *fileModel1=[[ZSWSFileCollectionModel alloc]init];
    fileModel1.custNo=addModel.custNo;
    //为两个加号的时候
    if (self.addDataStyle == ZSAddResourceDataTwo){
        //把subCategory赋值给假的model
        fileModel1.subCategory = @"户主页";
        ZSWSFileCollectionModel *fileModel2 = [[ZSWSFileCollectionModel alloc]init];
        fileModel2.subCategory = @"个人页";
        fileModel2.custNo = addModel.custNo;
        [self.itemDataArray addObject:@[fileModel1,fileModel2].mutableCopy];
        //为一个加号的时候
    }
    else if (self.addDataStyle == ZSAddResourceDataOne) {
        [self.itemDataArray addObject:@[fileModel1].mutableCopy];
    }
    //可以添加多张图片
    else if (self.addDataStyle == ZSAddResourceDataCountless) {
        [self.itemDataArray addObject:@[].mutableCopy];
        if (self.addDataStyle == ZSAddResourceDataCountless){
            self.otherCustNo = addModel.custNo;
        }
    }
}

#pragma mark 加载订单完成和关闭情况的数据
- (void)configCloseAndCompletedata
{
    NSMutableArray *categoryArray=@[].mutableCopy;//资料细分id数组
    //修整数据。把数据转换成  大数组装小数组，且以对象的形式添加
    for (ZSWSAddResourceModel *addModel in self.fileArray) {
        //区头显示
        //有数据的时候赋值
        if (addModel.docDataList.count > 0){
            [self loadCloseAndCompleteData:addModel];
            [self.itemNameArray addObject:[self nameFromAddModel:addModel]];
        }
    }
    if (self.itemDataArray.count == 0){
        self.errorView.hidden = NO;
    }
    //给collectionview赋值
    self.dataCollectionView.itemArray = self.itemDataArray;
    self.dataCollectionView.titleNameArray = self.itemNameArray;
    self.dataCollectionView.biztemplateItemidArray = categoryArray;
    [self.dataCollectionView.myCollectionView reloadData];
}

#pragma mark 加载订单完成和关闭赋值
- (void)loadCloseAndCompleteData:(ZSWSAddResourceModel *)addModel
{
    //当是两个加号并且相应的区的行数个数为1
    if (self.addDataStyle == ZSAddResourceDataTwo && addModel.docDataList.count == 1)
    {
        ZSWSFileCollectionModel *fileModel1 = [[ZSWSFileCollectionModel alloc]init];
        ZSWSFileCollectionModel *model = [addModel.docDataList firstObject];
        fileModel1.custNo = addModel.custNo;
        model.custNo = addModel.custNo;
        model.thumbnailUrl = [NSString stringWithFormat:@"%@?w=200",model.dataUrl];//如果是图片,生成缩略图
        if ([model.subCategory isEqualToString:@"户主页"]){
            [self.itemDataArray addObject:@[model,fileModel1].mutableCopy];
            fileModel1.subCategory = @"个人页";
        }else{
            [self.itemDataArray addObject:@[model,fileModel1].mutableCopy];
            fileModel1.subCategory = @"户主页";
        }
    }
    else {
        //有数据时加载两个加号且都有值时  另外两种情况有值
        NSMutableArray *dataArray = @[].mutableCopy;
        for (ZSWSFileCollectionModel *fileModel in addModel.docDataList ) {
            [dataArray addObject:fileModel];
            //把custNo赋值给假的model
            fileModel.custNo = addModel.custNo;
        }
        if (self.addDataStyle == ZSAddResourceDataCountless){
            self.otherCustNo = addModel.custNo;
        }
        [self.itemDataArray addObject:dataArray];
    }
}

#pragma mark /*--------------------------------上传数据-------------------------------------------*/
#pragma mark 获取所要上传数据
- (NSMutableArray*)getNeedUploadFilesArray
{
    NSMutableArray *upArray = @[].mutableCopy;
    if ([self.dataCollectionView.itemArray count]) {
        for (NSMutableArray *array in self.dataCollectionView.itemArray ) {
            if ([array count]) {
                for (ZSWSFileCollectionModel *colletionModel in array) {
                    if (colletionModel.image) {//如果是本地拍的图片或视频.
                        [upArray addObject:colletionModel];
                    }
                }
            }
        }
    }
    return upArray;
}

#pragma mark 线上的个数
- (NSInteger )getOnlineUploadFilesCount
{
    NSMutableArray *upArray = @[].mutableCopy;
    if ([self.dataCollectionView.itemArray count]) {
        for (NSMutableArray *array in self.dataCollectionView.itemArray) {
            if ([array count]) {
                for (ZSWSFileCollectionModel *colletionModel in array) {
                    if (colletionModel.dataUrl.length > 0) {
                        [upArray addObject:colletionModel];
                    }
                }
            }
        }
    }
    return upArray.count;
}

#pragma mark 上传所有资料
- (void)uploadAllDatas
{
    //通知图片们设置下标,便于上传排序
    [NOTI_CENTER postNotificationName:@"setPhotoIndex" object:nil];
    
    //圆形进度条
    needUploadArray = [self getNeedUploadFilesArray];
    if (needUploadArray.count > 0)
    {
        [self.dataCollectionView setBottomBtnEnable:NO];//上传时，禁止交互. 上传失败，恢复交互性
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
    else {
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
    //开始请求
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getUpdateOrDelPhotoDataURL] SuccessBlock:^(NSDictionary *dic) {
        if (selectIndex == needUploadArray.count-1) {
            //通知订单详情刷新
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } ErrorBlock:^(NSError *error) {
        [weakSelf.dataCollectionView setBottomBtnEnable:YES];
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 资料图片(视频)上传参数
- (NSMutableDictionary *)getAllMaterialsParameterWithFileModel:(ZSWSFileCollectionModel*)fileModel
{
    NSMutableDictionary *dic = @{
                                 @"orderNo":global.wsOrderDetail.projectInfo.tid,
                                 }.mutableCopy;
    
    if (self.addDataStyle == ZSAddResourceDataCountless){
        [dic setObject:self.otherCustNo forKey:@"custNo"];
    }else{
        if (fileModel.custNo.length > 0){
            [dic setObject:fileModel.custNo forKey:@"custNo"];
        }
    }
    if (fileModel.docId.length > 0){
        [dic setObject:fileModel.docId forKey:@"docId"];
    }
    if (fileModel.subCategory.length > 0){
        [dic setObject:fileModel.subCategory forKey:@"docType"];
    }
    //照片url
    if (fileModel.dataUrl.length > 0 && fileModel.tid == 0) {//只有新房见证用的tid,其他全部用的docId
        [dic setObject:fileModel.dataUrl forKey:@"photoUrl"];
    }
    return dic;
}

#pragma mark 上传成功并返回
- (void)showSuccessWith:(NSString*)str
{
    [ZSTool showMessage:str withDuration:DefaultDuration];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark /*--------------------------------删除数据-------------------------------------------*/
#pragma mark 上传已删除的资料
- (void)deletaDatas
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[self getDeleteIdParameter] url:[ZSURLManager getUpdateOrDelPhotoDataURL] SuccessBlock:^(NSDictionary *dic) {
        //如果有可上传的资料,则调上传资料的接口，没有课上传的话，则上传成功,返回
        if ([[weakSelf getNeedUploadFilesArray] count]>0) {
            [weakSelf uploadAllDatas];//上传资料
        }else{
            [weakSelf showSuccessWith:@"删除成功"];//上传成功并返回
            //通知订单详情刷新
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        }
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
        [LSProgressHUD hideForView:weakSelf.view];
        [ZSTool showMessage:@"上传失败" withDuration:DefaultDuration];
    }];
}

#pragma mark 删除资料参数
- (NSMutableDictionary *)getDeleteIdParameter
{
    NSMutableDictionary*dict = @{
                                 @"orderNo":global.wsOrderDetail.projectInfo.tid
                                 }.mutableCopy;
    if (self.docInfoModel.tid > 0){
        [dict setObject:self.docInfoModel.tid forKey:@"docId"];
    }
    NSString *deleteIDStr = [self.dataCollectionView.deletdataIDArray componentsJoinedByString:@","];
    [dict setObject:deleteIDStr forKey:@"photoIds"];//删除图片id集合
    return dict;
}

#pragma mark /*-------------------------------ZSWSDataCollectionViewDelegate-------------------------------------------*/
//重置collview高度代理
- (void)refershDataCollectionViewHegiht
{
    if (self.addDataStyle == ZSAddResourceDataCountless) {
        [self.dataCollectionView layoutSubviews];
        self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
        self.bottomBtn.frame = CGRectMake(15, self.dataCollectionView.myCollectionView.bottom + 15 + self.topSpace, ZSWIDTH - 30, 44);
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

#pragma mark 底部按钮点击事件
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

- (void)uploadTextDataAndImageData
{
    if ([self.dataCollectionView.deletdataIDArray count] > 0)
    {
        [self deletaDatas];
    }
    else {
        [self uploadAllDatas];
    }
}

#pragma mark 区头显示问题
- (NSString *)nameFromAddModel:(ZSWSAddResourceModel *)addModel
{
    NSString *name = @"";
    NSString *string  = @"";
        switch (addModel.releation.intValue) {
        case 1:
            name = @"贷款人";
            break;
        case 2:
            name = @"贷款人配偶";
            break;
        case 3:
            name = @"配偶&共有人";
            break;
        case 4:
            name = @"共有人";
            break;
        case 5:
            name = @"担保人";
            break;
        case 6:
            name = @"担保人配偶";
            break;
        default:
            break;
    }
    //根据婚姻状况来判定1.婚姻为“已婚”，显示“结婚证复印件”；2.婚姻状况为“离异”，显示“离婚证复印件”；3.婚姻状况为“未婚”“丧偶”，显示“未婚声明书”。
    if ([self.docInfoModel.docName isEqualToString:@"婚姻状况"]){
        if ([global.wsOrderDetail.custInfo firstObject].beMarrage == 1 || [global.wsOrderDetail.custInfo firstObject].beMarrage == 4){
            string = @"未婚声明书";
        }else if ([global.wsOrderDetail.custInfo firstObject].beMarrage == 2){
            string = [NSString stringWithFormat:@"%@",@"结婚证"];
        }else if ([global.wsOrderDetail.custInfo firstObject].beMarrage == 3){
            string = [NSString stringWithFormat:@"%@",@"离婚证"];
        }
    }else if ([self.docInfoModel.docName containsString:@"户口本"] || [self.docInfoModel.docName containsString:@"征信授权书"] || [self.docInfoModel.docName containsString:@"身份证"]){
        string = [NSString stringWithFormat:@"%@(%@)",name,SafeStr(addModel.custName)];
    }else{
        string = [NSString stringWithFormat:@"%@%@",self.docInfoModel.docName,self.docInfoModel.docType];
    }
    return string;
}

@end
