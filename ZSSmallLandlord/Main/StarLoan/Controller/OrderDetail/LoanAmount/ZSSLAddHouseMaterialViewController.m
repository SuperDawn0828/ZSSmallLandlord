//
//  ZSSLAddHouseMaterialViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLAddHouseMaterialViewController.h"
#import "ZSStarLoanPageController.h"
#import "ZSSLPageController.h"
#import "ZSProvincesPopView.h"

@interface ZSSLAddHouseMaterialViewController ()<ZSActionSheetViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *BuildingNameField;       //楼盘名称
@property (weak, nonatomic) IBOutlet UIButton    *BuildingProvice;         //楼盘地址-省市区
@property (weak, nonatomic) IBOutlet UITextField *BuildingAddressField;    //楼盘地址-详细地址
@property (weak, nonatomic) IBOutlet UITextField *houseNumberField;        //楼栋房号
@property (weak, nonatomic) IBOutlet UITextField *certificateField;        //权证号
@property (weak, nonatomic) IBOutlet UIButton    *houseFunctionBtn;        //房屋功能
@property (weak, nonatomic) IBOutlet UITextField *buildingAreaField;       //建筑面积
@property (weak, nonatomic) IBOutlet UITextField *indoorAreaField;         //套内面积
//@property (weak, nonatomic) IBOutlet UITextField *unitPriceField;          //评估单价
//@property (weak, nonatomic) IBOutlet UITextField *allPriceField;           //评估总价
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopContraint; //距上高度
@property (nonatomic,strong)NSMutableArray       *houseFunctionArray;      //房屋功能数组
@property (nonatomic,copy  )NSString       *currentProID;                  //当前选中的省id,用于接口请求
@property (nonatomic,copy  )NSString       *currentCitID;                  //当前选中的城市id,用于接口请求
@property (nonatomic,copy  )NSString       *currentAreID;                  //当前选中的区id,用于接口请求
@end

@implementation ZSSLAddHouseMaterialViewController

- (NSMutableArray *)houseFunctionArray
{
    if (_houseFunctionArray == nil){
        _houseFunctionArray = [[NSMutableArray alloc]initWithObjects:@"住宅",@"商铺",@"车位",@"写字楼",@"公寓", nil];
    }
    return _houseFunctionArray;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
   
    //添加完成按钮
    self.BuildingNameField.inputAccessoryView    = [self addToolbar];
    self.BuildingAddressField.inputAccessoryView = [self addToolbar];
    self.houseNumberField.inputAccessoryView     = [self addToolbar];
    self.certificateField.inputAccessoryView     = [self addToolbar];
    self.buildingAreaField.inputAccessoryView    = [self addToolbar];
    self.indoorAreaField.inputAccessoryView      = [self addToolbar];
//    self.unitPriceField.inputAccessoryView       = [self addToolbar];
//    self.allPriceField.inputAccessoryView        = [self addToolbar];
   
    //颜色
    self.BuildingNameField.textColor     = ZSColorListRight;
    self.BuildingAddressField.textColor  = ZSColorListRight;
    self.houseNumberField.textColor      = ZSColorListRight;
    self.certificateField.textColor      = ZSColorListRight;
    self.buildingAreaField.textColor     = ZSColorListRight;
    self.indoorAreaField.textColor       = ZSColorListRight;
//    self.unitPriceField.textColor        = ZSColorListRight;
//    self.allPriceField.textColor         = ZSColorListRight;
  
    //改变placeholder颜色
    [self.BuildingNameField    changePlaceholderColor];
    [self.BuildingAddressField changePlaceholderColor];
    [self.houseNumberField     changePlaceholderColor];
    [self.certificateField     changePlaceholderColor];
    [self.buildingAreaField    changePlaceholderColor];
    [self.indoorAreaField      changePlaceholderColor];
//    [self.unitPriceField       changePlaceholderColor];
//    [self.allPriceField        changePlaceholderColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarButtonItem];
    [self reSetBottomBtnFrameByFormType];//根据来源展示底部按钮
    [self displayContent]; //填充数据
}

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

#pragma mark 返回
- (void)goBackAntion
{
    NSArray *array = self.navigationController.viewControllers;
    //第二个页面是星速贷订单列表页
    if ([array[1] isKindOfClass:[ZSStarLoanPageController class]]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else {
        //首页
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
}

#pragma mark 根据来源展示底部按钮
- (void)reSetBottomBtnFrameByFormType
{
    [self.tableView removeFromSuperview];
    if ([self.orderState isEqualToString:@"暂存"])
    {
        self.title = @"创建订单";
        //顶部试图不隐藏
        self.view_top.hidden = NO;
        //判断顶部图片展示
        [self.view_progress setImgViewWithProduct:self.prdType withIndex:ZSCreatOrderStyleHouse];
        [self.view addSubview:self.view_top];
        //居上高度
        self.viewTopContraint.constant = viewTopHeight;
        [self configuBottomButtonWithTitle:@"提交订单"];//底部按钮
    }
    else
    {
        self.title = @"房产信息";
        self.view_top.hidden = YES;
        [self configuBottomButtonWithTitle:@"保存"];//底部按钮
    }
}

#pragma mark 填充数据
- (void)displayContent
{
    SpdOrder *model;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        model = global.slOrderDetails.spdOrder;
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        model = global.rfOrderDetails.redeemOrder;
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        model = global.mlOrderDetails.dydOrder;
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        model = global.elOrderDetails.easyOrder;
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        model = global.abOrderDetails.insteadOrder;
    }
    
    //楼盘名称
    if (model.projName.length > 0){
        self.BuildingNameField.text = model.projName;
    }
    
    //省市区
    if (model.province || model.city || model.area) {
        [self.BuildingProvice setTitle:[NSString stringWithFormat:@"%@ %@ %@",model.province,model.city,model.area] forState:UIControlStateNormal];
        [self.BuildingProvice setTitleColor:ZSColorListRight forState:UIControlStateNormal];
        self.currentProID = model.provinceId ? model.provinceId : nil;
        self.currentCitID = model.cityId ? model.cityId : nil;
        self.currentAreID = model.areaId ? model.areaId : nil;
    }
    //详细地址
    if (model.address) {
        self.BuildingAddressField.text = model.address;
    }
    //楼栋房号
    if (model.houseNum.length > 0){
        self.houseNumberField.text = model.houseNum;
    }
    //权证号
    if (model.warrantNo.length > 0){
        self.certificateField.text = model.warrantNo;
    }
    //房屋功能
    if (model.housingFunction.length > 0){
        [self.houseFunctionBtn setTitle:model.housingFunction forState:UIControlStateNormal];
        [self.houseFunctionBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }
    //建筑面积
    if (model.coveredArea.length > 0){
        self.buildingAreaField.text = [NSString ReviseString:model.coveredArea];
    }
    //套内面积
    if (model.insideArea.length > 0){
        self.indoorAreaField.text = [NSString ReviseString:model.insideArea];
    }
//    //评估单价
//    if (model.evaluePrice.length > 0){
//        self.unitPriceField.text = [NSString ReviseString:model.evaluePrice];
//    }
//    //评价总价
//    if (model.evalueTotalPrice.length > 0){
//        self.allPriceField.text = [NSString ReviseString:model.evalueTotalPrice];
//    }
}

#pragma mark 删除订单接口
- (void)requestForCloseOrderData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                           @"prdType":self.prdType
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getDeleteOrderOfNoSubmitURL] SuccessBlock:^(NSDictionary *dic) {
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //提示
        [ZSTool showMessage:@"删除成功" withDuration:DefaultDuration];
        [weakSelf goBackAntion]; //返回
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 编辑房产信息接口
//是否来自创建订单返回上一界面（goBack是）
- (void)requestEditHouseData:(BOOL)isGoBack
{
    __weak typeof(self) weakSelf = self;
    //点击返回按钮不转圈 点击下一步转圈
    if (!isGoBack){
        [LSProgressHUD showToView:self.view message:@"提交中"];
    }
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        [ZSRequestManager requestWithParameter:[weakSelf getEditHouseParameter] url:[ZSURLManager getSpdUpdateHouseInfoURL] SuccessBlock:^(NSDictionary *dic) {
            //如果来自创建订单则调提交订单接口，若来自详情则返回上一页面
            if ([weakSelf.orderState isEqualToString:@"暂存"]) {
                //存值
                global.slOrderDetails = [ZSSLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
                if (isGoBack) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else {
                    //提交订单接口
                    [weakSelf requestForSubmitOrderData];
                }
            }else {
                //刷新订单详情
                [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
                //刷新订单列表
                [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [LSProgressHUD hideForView:weakSelf.view];
            }
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        [ZSRequestManager requestWithParameter:[weakSelf getEditHouseParameter] url:[ZSURLManager getRedeemFloorUpdateHouseInfoURL] SuccessBlock:^(NSDictionary *dic) {
            //如果来自创建订单则调提交订单接口
            if ([weakSelf.orderState isEqualToString:@"暂存"]) {
                //存值
                global.rfOrderDetails = [ZSRFOrderDetailsModel yy_modelWithDictionary:dic[@"respData"]];
                if (isGoBack) {
                    //（返回按钮）返回上一界面
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else {
                    //提交订单接口
                    [weakSelf requestForSubmitOrderData];
                }
            }else {
                //刷新订单详情
                [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
                //刷新订单列表
                [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];//若来自详情则返回上一页面
                [LSProgressHUD hideForView:weakSelf.view];
            }
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        [ZSRequestManager requestWithParameter:[weakSelf getEditHouseParameter] url:[ZSURLManager getMortgageLoanUpdateHouseInfoURL] SuccessBlock:^(NSDictionary *dic) {
            //如果来自创建订单则调提交订单接口，若来自详情则返回上一页面
            if ([weakSelf.orderState isEqualToString:@"暂存"]) {
                //存值
                global.mlOrderDetails = [ZSMLOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
                if (isGoBack){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else {
                    //提交订单接口
                    [weakSelf requestForSubmitOrderData];
                }
            }else {
                //刷新订单详情
                [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
                //刷新订单列表
                [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [LSProgressHUD hideForView:weakSelf.view];
            }
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        [ZSRequestManager requestWithParameter:[weakSelf getEditHouseParameter] url:[ZSURLManager getEasyLoanUpdateHouseInfoURL] SuccessBlock:^(NSDictionary *dic) {
            //如果来自创建订单则调提交订单接口，若来自详情则返回上一页面
            if ([weakSelf.orderState isEqualToString:@"暂存"]) {
                //存值
                global.elOrderDetails = [ZSELOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
                if (isGoBack){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else {
                    //提交订单接口
                    [weakSelf requestForSubmitOrderData];
                }
            }else {
                //刷新订单详情
                [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
                //刷新订单列表
                [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [LSProgressHUD hideForView:weakSelf.view];
            }
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        [ZSRequestManager requestWithParameter:[weakSelf getEditHouseParameter] url:[ZSURLManager getAngencyBusinessUpdateHouseInfoURL] SuccessBlock:^(NSDictionary *dic) {
            //如果来自创建订单则调提交订单接口，若来自详情则返回上一页面
            if ([weakSelf.orderState isEqualToString:@"暂存"]) {
                //存值
                global.abOrderDetails = [ZSABOrderdetailsModel yy_modelWithDictionary:dic[@"respData"]];
                //（返回按钮）返回上一界面
                if (isGoBack){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else {
                    //提交订单接口
                    [weakSelf requestForSubmitOrderData];
                }
            }else {
                //刷新订单详情
                [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
                //刷新订单列表
                [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [LSProgressHUD hideForView:weakSelf.view];
            }
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
}

#pragma mark 提交订单接口
- (void)requestForSubmitOrderData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                           @"prdType":self.prdType
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getCommitOrderURL] SuccessBlock:^(NSDictionary *dic) {
        //跳详情页面
        [weakSelf goToOrderDetailPageControler];
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 跳转订单详情
- (void)goToOrderDetailPageControler
{
    ZSSLPageController *detailVC = [[ZSSLPageController alloc]init];
    detailVC.isFromCreatOrder    = YES;
    detailVC.orderIDString       = self.orderIDString;
    detailVC.prdType             = self.prdType;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 编辑房产信息接口参数
- (NSMutableDictionary *)getEditHouseParameter
{
    NSMutableDictionary *parameterDict = @{
                                           @"orderNo":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType]
                                           }.mutableCopy;
    //楼盘名称
    if (self.BuildingNameField.text.length > 0){
        [parameterDict setValue:self.BuildingNameField.text forKey:@"building"];
    }
    //省份ID
    if (self.currentProID) {
        [parameterDict setValue:self.currentProID forKey:@"provinceId"];
    }
    //城市ID
    if (self.currentCitID) {
        [parameterDict setValue:self.currentCitID forKey:@"cityId"];
    }
    //区ID
    if (self.currentAreID) {
        [parameterDict setValue:self.currentAreID forKey:@"areaId"];
    }
    //详细地址
    if (self.BuildingAddressField.text.length > 0) {
        [parameterDict setValue:self.BuildingAddressField.text forKey:@"address"];
    }
    //楼栋房号
    if (self.houseNumberField.text.length > 0){
        [parameterDict setValue:self.houseNumberField.text forKey:@"houseNo"];
    }
    //权证号
    if (self.certificateField.text.length > 0){
        [parameterDict setValue:self.certificateField.text forKey:@"warrantNo"];
    }
    //房屋功能
    if (![[self.houseFunctionBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
        [parameterDict setValue:[self.houseFunctionBtn titleForState:UIControlStateNormal] forKey:@"housingFunction"];
    }
    //建筑面积
    if (self.buildingAreaField.text.length > 0){
        [parameterDict setValue:self.buildingAreaField.text forKey:@"coveredArea"];
    }
    //套内面积
    if (self.indoorAreaField.text.length > 0){
        [parameterDict setValue:self.indoorAreaField.text forKey:@"insideArea"];
    }
//    //评估单价
//    if (self.unitPriceField.text.length > 0){
//        [parameterDict setValue:self.unitPriceField.text forKey:@"evaluePrice"];
//    }
//    //评估总价
//    if (self.allPriceField.text.length > 0){
//        [parameterDict setValue:self.allPriceField.text forKey:@"evalueTotalPrice"];
//    }
    
    return parameterDict;
}

#pragma mark TextfieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.buildingAreaField) {
        if (textField.text.length == 0){
//            self.unitPriceField.text = @"";
        }
        return  [self calculateAllPrice:YES];//计算评估总价
    }
//    if (textField == self.buildingAreaField || textField == self.unitPriceField) {
//        if (textField.text.length == 0){
//            self.unitPriceField.text = @"";
//        }
//        return  [self calculateAllPrice:YES];//计算评估总价
//    }
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
    //如果楼盘名称、楼盘详细地址、权证号大于40则不让输入
    if (textField == self.BuildingNameField || textField == self.certificateField || textField == self.BuildingAddressField){
        if ([toBeString length] > 40) {
            textField.text = [toBeString substringToIndex:40];
            return NO;
        }
    }
    //如果楼栋房号大于20则不让输入
    if (textField == self.houseNumberField) {
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    //建筑面积和套内面积限制输入10000.00,最多两位小数
    if (textField == self.buildingAreaField || textField == self.indoorAreaField) {
        if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"10000.00" alert:YES]){
            [ZSTool showMessage:@"面积超过最大限制了！" withDuration:DefaultDuration];
            return NO;
        }
    }
    //建筑面积和套内面积(只允许保留2位小数)
    if (textField == self.buildingAreaField || textField == self.indoorAreaField) {
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }
//    //评估单价限制输入1000000.00,最多两位小数
//    if (textField == self.unitPriceField) {
//        if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"1000000.00" alert:YES]){
//            [ZSTool showMessage:@"超过最大限制了！" withDuration:DefaultDuration];
//            return NO;
//        }
//    }
    return YES;
}

#pragma mark 楼盘地址点击事件
- (IBAction)buildingProviceBtnClick:(UIButton *)sender
{
    [self hideKeyboard];
    ZSProvincesPopView *provincesView = [[ZSProvincesPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    provincesView.addressID = self.currentProID ? [NSString stringWithFormat:@"%@-%@-%@",self.currentProID,self.currentCitID,self.currentAreID] : @"";
    if (![self.BuildingProvice.titleLabel.text containsString:@"选择"]) {
        provincesView.addressName = self.BuildingProvice.titleLabel.text;
    }
    [provincesView show];
    //省市区页返回的数据
    __block NSString *stringName;
    __block NSString *stringID;
    __weak typeof(self) weakSelf = self;
    provincesView.addressArray = ^(NSArray * _Nonnull modelArray)
    {
        for (int i = 0 ; i < modelArray.count; i++)
        {
            ZSProvinceModel *model = modelArray[i];
            stringName = stringName.length ? [NSString stringWithFormat:@"%@ %@",stringName,model.name] : [NSString stringWithFormat:@"%@",model.name];
            stringID = stringID.length ? [NSString stringWithFormat:@"%@-%@",stringID,model.ID] : [NSString stringWithFormat:@"%@",model.ID];
            [weakSelf.BuildingProvice setTitle:stringName forState:UIControlStateNormal];
            [weakSelf.BuildingProvice setTitleColor:ZSColorListRight forState:UIControlStateNormal];
            //用于接口请求
            if (i == 0) {
                weakSelf.currentProID = model.ID;//用于接口请求
            }
            if (i == 1) {
                weakSelf.currentCitID = model.ID;//用于接口请求
            }
            if (i == 2) {
                weakSelf.currentAreID = model.ID;//用于接口请求
            }
        }
    };
}

#pragma mark 房屋功能点击事件
- (IBAction)houseFunctionBtnClick:(UIButton *)sender
{
    [self hideKeyboard];
    ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:self.houseFunctionArray];
    actionsheet.tag = 102;
    actionsheet.delegate = self;
    [actionsheet show:self.houseFunctionArray.count];
}

#pragma mark ZSActionSheetViewDelegate
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag
{
    [self.houseFunctionBtn setTitle:self.houseFunctionArray[tag] forState:UIControlStateNormal];
    [self.houseFunctionBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
}

#pragma mark 底部按钮点击
- (void)bottomClick:(UIButton *)sender
{
    //建筑面积和套内面积的判断
    if (self.buildingAreaField.text.floatValue == 0 && self.buildingAreaField.text.length > 0){
        [ZSTool showMessage:@"建筑面积不能为0" withDuration:DefaultDuration];
        return;
    }
    if (self.indoorAreaField.text.floatValue == 0 && self.indoorAreaField.text.length > 0){
        [ZSTool showMessage:@"套内面积不能为0" withDuration:DefaultDuration];
        return;
    }
    SpdOrder *model;
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        model = global.slOrderDetails.spdOrder;
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        model = global.rfOrderDetails.redeemOrder;
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        model = global.mlOrderDetails.dydOrder;
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        model = global.elOrderDetails.easyOrder;
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        model = global.abOrderDetails.insteadOrder;
    }
    
    if ([ZSTool checkMaxNumWithInputNum:self.indoorAreaField.text MaxNum:self.buildingAreaField.text alert:YES] ||
        [ZSTool checkMaxNumWithInputNum:model.coveredArea MaxNum:model.coveredArea alert:YES]) {
        [ZSTool showMessage:@"套内面积必须小于等于建筑面积" withDuration:DefaultDuration];
        return;
    }

//    //评估单价和评估总价的判断
//    if (self.unitPriceField.text.floatValue == 0 && self.unitPriceField.text.length > 0){
//        [ZSTool showMessage:@"评估单价不能为0" withDuration:DefaultDuration];
//        return;
//    }
//    if (self.allPriceField.text.floatValue == 0 && self.allPriceField.text.length > 0){
//        [ZSTool showMessage:@"评估总价不能为0" withDuration:DefaultDuration];
//        return;
//    }
//    //计算评估总价
//    if (![self calculateAllPrice:NO]) {
//        return;
//    }
    //请求数据
    [self requestEditHouseData:NO];
}

#pragma mark 计算评估总价
- (BOOL)calculateAllPrice:(BOOL)isAlert
{
//    if ([self.buildingAreaField.text floatValue] >= 0 &&self.buildingAreaField.text.length > 0 &&
//        [self.unitPriceField.text floatValue] >= 0 && self.unitPriceField.text.length > 0)
//    {
//        NSDecimalNumber *numberBaseRate = [NSDecimalNumber decimalNumberWithString:self.buildingAreaField.text];
//        NSDecimalNumber *numberRateEnd = [NSDecimalNumber decimalNumberWithString:self.unitPriceField.text];
//        /// 这里的运算方法有加减乘除比较。
//        NSDecimalNumber *numResult = [numberBaseRate decimalNumberByMultiplyingBy:numberRateEnd];
//        NSString *endStr = [numResult stringValue];
//        if (endStr.floatValue < 0){
//            self.allPriceField.text = [NSString stringWithFormat:@"%@",endStr];
//            if (isAlert){
//                return YES;
//            }else{
//                [ZSTool showMessage:@"评估单价不得高于评估总价" withDuration:DefaultDuration];
//                return NO;
//            }
//        }else{
//            self.allPriceField.text = [NSString stringWithFormat:@"%@",endStr];
//            return YES;
//        }
//    }
    return YES;
}

@end
