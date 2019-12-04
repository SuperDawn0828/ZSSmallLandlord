//
//  ZSCHAddHouseMaterialViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/10/12.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSCHAddHouseMaterialViewController.h"
#import "ZSStarLoanPageController.h"
#import "ZSSLPageController.h"

@interface ZSCHAddHouseMaterialViewController ()<ZSActionSheetViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel     *owneBuildingLabel;  //楼盘名称
@property (weak, nonatomic) IBOutlet UITextField *BuildingName;  //楼盘名称
@property (weak, nonatomic) IBOutlet UITextField *carField;          //车位面积
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopContraint;//距上高度

@end

@implementation ZSCHAddHouseMaterialViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //添加完成按钮
    self.BuildingName.inputAccessoryView = [self addToolbar];
    self.carField.inputAccessoryView          = [self addToolbar];
    //颜色
    self.BuildingName.textColor = ZSColorListRight;
    self.carField.textColor          = ZSColorListRight;
    //改变placeholder颜色
    [self.BuildingName changePlaceholderColor];
    [self.carField  changePlaceholderColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarButtonItem];
    [self reSetBottomBtnFrameByFormType]; //根据来源展示底部按钮
    [self displayContent]; //填充数据
}

#pragma mark 返回按钮点击事件
- (void)leftAction
{
    //如果来自创建订单则返回的时候保存数据
    if ([self.orderState isEqualToString:@"暂存"])
    {
        [self requestEditHouseData:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 根据来源展示底部按钮
- (void)reSetBottomBtnFrameByFormType
{
    [self.tableView removeFromSuperview];
    //来自创建订单则展示顶部视图，否则不展示
    //是否来自订单创建
    if ([self.orderState isEqualToString:@"暂存"])
    {
        self.title = @"创建订单";
        self.view_top.hidden = NO;
        //判断顶部图片展示
        [self.view_progress setImgViewWithProduct:kProduceTypeCarHire withIndex:ZSCreatOrderStyleHouse];
        [self.view addSubview:self.view_top];
        //居上高度
        self.viewTopContraint.constant = viewTopHeight;
//        [self configuBottomButtonWithTitle:@"提交订单" OriginY:CellHeight*2 + 15 + viewTopHeight];
        [self configuBottomButtonWithTitle:@"提交订单"];//底部按钮
    }
    else
    {
        self.title = @"车位信息";
        self.view_top.hidden = YES;
//        [self configuBottomButtonWithTitle:@"保存" OriginY:CellHeight*2 + 15];
        [self configuBottomButtonWithTitle:@"保存"];//底部按钮
    }
}

#pragma mark 赋值
- (void)displayContent
{
    SpdOrder *model = global.chOrderDetails.cwfqOrder;
   
    //楼盘名称
    if (model.projName.length > 0){
        self.BuildingName.text = model.projName;
    }
  
    //车位面积
    if (model.parkArea.length > 0){
        self.carField.text = [NSString ReviseString:model.parkArea];
    }
}

#pragma mark 删除订单接口
- (void)requestForCloseOrderData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":global.chOrderDetails.cwfqOrder.tid,
                                           @"prdType":kProduceTypeCarHire
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getDeleteOrderOfNoSubmitURL] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //提示
        [ZSTool showMessage:@"删除成功" withDuration:DefaultDuration];
        [weakSelf goBackAntion];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 返回
- (void)goBackAntion
{
    NSArray *array = self.navigationController.viewControllers;
    //第二个页面是车位分期订单列表页
    if ([array[1] isKindOfClass:[ZSStarLoanPageController class]]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else {
        //首页
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
}

#pragma mark 编辑车位资料接口
//是否来自创建订单返回上一界面（goBack是）
- (void)requestEditHouseData:(BOOL)isGoBack
{
    __weak typeof(self) weakSelf = self;
    //点击返回按钮不转圈 点击下一步转圈
    if (!isGoBack){
        [LSProgressHUD showToView:self.view message:@"提交订单"];
    }
    [ZSRequestManager requestWithParameter:[weakSelf getEditHouseParameter] url:[ZSURLManager getCarHireUpdateCarInfoURL] SuccessBlock:^(NSDictionary *dic) {
        //如果来自创建订单则调提交订单接口，若来自详情则返回上一页面
        if ([weakSelf.orderState isEqualToString:@"暂存"]) {
            //存值
            global.chOrderDetails = [ZSCHOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
            //（返回按钮）返回上一界面
            if (isGoBack){
                [LSProgressHUD hideForView:weakSelf.view];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                //提交订单接口
                [weakSelf requestForSubmitOrderData];
            }
        }else {
            //来自订单详情 返回上一页面
            //刷新赎楼宝订单详情通知
            [LSProgressHUD hideForView:weakSelf.view];
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
//        ZSLOG(@"成功");
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 提交订单接口
- (void)requestForSubmitOrderData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":global.chOrderDetails.cwfqOrder.tid,
                                           @"prdType":kProduceTypeCarHire
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getCommitOrderURL] SuccessBlock:^(NSDictionary *dic) {
        [LSProgressHUD hideForView:weakSelf.view];
//        ZSLOG(@"成功");
        //跳详情页面
        [weakSelf goToOrderDetailPageControler];
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 跳转订单详情
- (void)goToOrderDetailPageControler
{
    ZSSLPageController     *detailVC = [[ZSSLPageController alloc]init];
    detailVC.orderIDString           = global.chOrderDetails.cwfqOrder.tid;
    detailVC.isFromCreatOrder        = YES;
    detailVC.prdType                 = self.prdType;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 编辑车位信息接口参数
- (NSMutableDictionary *)getEditHouseParameter
{
    NSMutableDictionary *parameterDict = @{
                                           @"orderNo":global.chOrderDetails.cwfqOrder.tid,
                                           }.mutableCopy;
    //楼盘名称
    if (self.BuildingName.text.length > 0){
        [parameterDict setValue:self.BuildingName.text forKey:@"building"];
    }
    //车位面积
    if (self.carField.text.length > 0){
        [parameterDict setValue:self.carField.text forKey:@"parkArea"];
    }
    return parameterDict;
}

#pragma mark -----------TextfieldDelegate-----------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]){ return YES;}
    
    //限制输入表情
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    //判断键盘是不是九宫格键盘
    if ([ZSTool isNineKeyBoard:string] ){
        return YES;
    }else{
        //限制输入表情
        if ([ZSTool stringContainsEmoji:string]) {
            return NO;
        }
    }
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
    //如果楼盘名称、楼栋房号、权证号大于40则不让输入
    if (textField == self.BuildingName){
        if ([toBeString length] > 40) {
            textField.text = [toBeString substringToIndex:40];
            return NO;
        }
    }
    //建筑面积限制输入10000.00,最多两位小数
    if (textField == self.carField) {
        if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"10000.00" alert:YES]){
            [ZSTool showMessage:@"面积超过最大限制了！" withDuration:DefaultDuration];
            return NO;
        }
    }
    //车位面积(只允许保留2位小数)
    if (textField == self.carField) {
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }
    return YES;
}

#pragma mark 底部按钮点击
- (void)bottomClick:(UIButton *)sender
{
    if (self.carField.text.floatValue == 0 && self.carField.text.length > 0){
        [ZSTool showMessage:@"车位面积不能为0" withDuration:DefaultDuration];
        return;
    }
    //请求接口
    [self requestEditHouseData:NO];
}

@end
