//
//  ZSSLAddPropertyRightStatementViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/9/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLAddPropertyRightViewController.h"
#import "ZSInputOrSelectView.h"
#import "ZSWSYearMonthDayPicker.h"
#import "WSDatePickerView.h"

@interface ZSSLAddPropertyRightViewController ()<UITextFieldDelegate,ZSSLDataCollectionViewDelegate,ZSInputOrSelectViewDelegate>
@property (nonatomic,strong)ZSInputOrSelectView   *payTimeView;    //日期
@property (nonatomic,copy  )NSString              *selectStr;      //选择时间

@end

@implementation ZSSLAddPropertyRightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self initCollectionView:self.topSpace];
    self.dataCollectionView.titleNameArray = @[self.SLDocToModel.docname].mutableCopy;
}

#pragma mark initViews
- (void)initViews
{
    //选择时间
    self.payTimeView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withClickAction:@"获取时间 *"];
    self.payTimeView.delegate = self;
    [self.bgScrollView addSubview:self.payTimeView];
   
    //dataconllectionView的起始高度
    self.topSpace = self.payTimeView.bottom;
}

#pragma mark 先上传时间把时间上传之后再上传图片
- (void)requestForTimeData
{
    //时间或图片为空不请求数据
    NSMutableDictionary *dict = [self getAllMaterialsParameterWithFileModel:nil];
    NSString *timestr = [NSString stringWithFormat:@"%@",dict[@"timestr"]];
    NSString *photoUrl = [NSString stringWithFormat:@"%@",dict[@"photoUrl"]];
    if (!timestr.length || !photoUrl.length) {
        return;
    }
    
    //请求数据
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[weakSelf getAllMaterialsParameterWithFileModel:nil] url:[weakSelf getUploadAndDeleteURL] SuccessBlock:^(NSDictionary *dic) {
        weakSelf.selectStr = dic[@"respData"];
        [weakSelf uploadAllDatas];
    } ErrorBlock:^(NSError *error) {
        [ZSTool showMessage:@"请选择回款日期" withDuration:DefaultDuration];
    }];
}

#pragma mark /*--------------------------------请求参数-------------------------------------------*/
#pragma mark 资料图片(视频)上传参数
- (NSMutableDictionary *)getAllMaterialsParameterWithFileModel:(ZSWSFileCollectionModel*)fileModel
{
    NSMutableDictionary *dic = @{
                                 @"productType":self.prdType,
                                 @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                 }.mutableCopy;
    //资料类型Id
    if (self.SLDocToModel.docid > 0){
        [dic setObject:self.SLDocToModel.docid forKey:@"docId"];
    }
    //不是两个加号 custno 主贷人的
    if (self.addDataStyle != ZSAddResourceDataTwo)
    {
        //星速贷
        if ([self.prdType isEqualToString:kProduceTypeStarLoan])
        {
            [dic setObject:[global.slOrderDetails.bizCustomers firstObject].tid forKey:@"custNo"];
        }
        //赎楼宝
        else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
        {
            [dic setObject:[global.rfOrderDetails.bizCustomers firstObject].tid forKey:@"custNo"];
        }
        //抵押贷
        else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
        {
            [dic setObject:[global.mlOrderDetails.bizCustomers firstObject].tid forKey:@"custNo"];
        }
        //融易贷
        else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
        {
            [dic setObject:[global.elOrderDetails.bizCustomers firstObject].tid forKey:@"custNo"];
        }
        //车位分期
        else if ([self.prdType isEqualToString:kProduceTypeCarHire])
        {
            [dic setObject:[global.chOrderDetails.bizCustomers firstObject].tid forKey:@"custNo"];
        }
        //代办业务
        else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
        {
            [dic setObject:[global.abOrderDetails.bizCustomers firstObject].tid forKey:@"custNo"];
        }
    }
    else
    {
        //人员Id
        if (fileModel.custNo.length > 0){
            [dic setObject:fileModel.custNo forKey:@"custNo"];
        }
    }
    //个人页或者户主页
    if (fileModel.leafCategory.length > 0){
        [dic setObject:fileModel.leafCategory forKey:@"subType"];
    }
    //贷款人还是配偶
    if (fileModel.subCategory.length > 0){
        [dic setObject:fileModel.subCategory forKey:@"docType"];
    }
    //资料类型
    if (self.SLDocToModel.docname > 0){
        [dic setObject:self.SLDocToModel.docname forKey:@"catagory"];
    }
    //选择时间
    if (![self.payTimeView.rightLabel.text isEqualToString:KPlaceholderChoose]){
        [dic setObject:self.payTimeView.rightLabel.text forKey:@"timestr"];
    }
    //选择时间
    if (self.selectStr){
        [dic setObject:self.selectStr forKey:@"timeid"];
    }
    //照片url
    if (fileModel.dataUrl.length > 0) {
        [dic setObject:fileModel.dataUrl forKey:@"photoUrl"];
    }
    return dic;
}

#pragma mark /*--------------------------------请求URL-------------------------------------------*/
#pragma mark 上传和删除图片接口地址
- (NSString *)getUploadAndDeleteURL
{
    return [ZSURLManager getuploadOrDelPhotoDataForPropertyRightURL];
}

#pragma mark ZSInputOrSelectViewDelegate
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    [self hideKeyboard];
    if (view == self.payTimeView){
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            view.rightLabel.text = date;
            view.rightLabel.textColor = ZSColorListRight;
        }];
        datepicker.dateLabelColor = [UIColor orangeColor];//年-月-日-时-分 颜色
        datepicker.datePickerColor = ZSColorBlack;//滚轮日期颜色
        datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
        [datepicker show];
    }
}

#pragma mark /*--------------------------------底部按钮------------------------------------------*/
#pragma mark 底部按钮点击事件
- (void)bottomClick:(UIButton *)btn
{
    if ([self.payTimeView.rightLabel.text isEqualToString:KPlaceholderChoose]){
        [ZSTool showMessage:@"请选择时间" withDuration:DefaultDuration];
        return;
    }
    
    if (!self.rightBtn.titleLabel.text.length || !([self getNeedUploadFilesArray].count > 0)) {
        [ZSTool showMessage:@"请至少选择一张图片" withDuration:DefaultDuration];
        return;
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
    //请求接口
    [self requestForTimeData];
}

#pragma mark /*-------------------------------ZSSLDataCollectionViewDelegate-------------------------------------------*/
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
        else
        {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:self.view];
            [self configureRightNavItemWithTitle:@"" withNormalImg:nil withHilightedImg:nil];
            //请求接口
            [self requestForTimeData];
        }
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
