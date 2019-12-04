//
//  ZSStarLoanAddCustomerViewController.h.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/27.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSStarLoanAddCustomerViewController.h"
#import "ZSStarLoanPageController.h"
#import "ZSSLPageController.h"
#import "ZSSLPersonListViewController.h"

@interface ZSStarLoanAddCustomerViewController ()

@end

@implementation ZSStarLoanAddCustomerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势(自定义返回按钮会导致手势失效)
    [self openInteractivePopGestureRecognizerEnable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark /*--------------------------------数据处理-------------------------------------------*/
#pragma mark 编辑人员信息的时候是有数据的--数据填充
- (void)fillInData
{
    if (self.isFromEditor && global.slBizCustomers.name.length)
    {
        //订单提交之前可以修改任何信息,提交之后姓名和身份证号不允许修改
        if ([global.slOrderDetails.isOrder isEqualToString:@"1"] && [global.slOrderDetails.spdOrder.orderState isEqualToString:@"暂存"])
        {
            self.nameView.inputTextFeild.userInteractionEnabled = YES;
            self.IDcardView.inputTextFeild.userInteractionEnabled = YES;
        }
        else{
            self.nameView.inputTextFeild.userInteractionEnabled = NO;
            self.IDcardView.inputTextFeild.userInteractionEnabled = NO;
        }
        //titles
        if (global.slBizCustomers.releation) {
            [self setTitleStringWithRelation:global.slBizCustomers.releation];
        }
        //身份证正面
        if (global.slBizCustomers.identityPos) {
            [self.imageArray replaceObjectAtIndex:0 withObject:[self imageWithData:global.slBizCustomers.identityPos]];
            self.urlFront = global.slBizCustomers.identityPos;
        }
        //身份证反面照
        if (global.slBizCustomers.identityBak) {
            [self.imageArray replaceObjectAtIndex:1 withObject:[self imageWithData:global.slBizCustomers.identityBak]];
            self.urlBack = global.slBizCustomers.identityBak;
        }
        [self.pageFlowView reloadData];
        //姓名
        if (global.slBizCustomers.name) {
            self.nameView.inputTextFeild.text = global.slBizCustomers.name;
        }
        //身份证号
        if (global.slBizCustomers.identityNo) {
            self.IDcardView.inputTextFeild.text = global.slBizCustomers.identityNo;
        }
        //手机号
        if (global.slBizCustomers.cellphone) {
            if (global.slBizCustomers.cellphone.length) {
                self.phoneNumView.inputTextFeild.text = [ZSTool addTheBlankSpace:global.slBizCustomers.cellphone];
            }
        }
        //婚姻状况/与贷款人关系
        self.marryView.leftLabel.attributedText = [self.marryLabelNotice addStar];
        if ([self.marryView.leftLabel.text containsString:@"婚姻状况"]) {
            if (global.slBizCustomers.beMarrage) {
                self.marryView.rightLabel.textColor = ZSColorListRight;
                self.marryView.rightLabel.text = [NSString setMarrayState:global.slBizCustomers.beMarrage];
                self.currentMarrayState = [NSString setMarrayState:global.slBizCustomers.beMarrage];
            }
        }
        else{
            if (global.slBizCustomers.lenderReleation.intValue == 1) {
                self.marryView.rightLabel.textColor = ZSColorListRight;
                self.marryView.rightLabel.text = @"朋友";
            }
            else if (global.slBizCustomers.lenderReleation.intValue == 2) {
                self.marryView.rightLabel.textColor = ZSColorListRight;
                self.marryView.rightLabel.text = @"直系亲属";
            }
        }
        //大数据风控
        if (global.slBizCustomers.isRiskData) {
            if (global.slBizCustomers.isRiskData.length) {
                self.bigDataView.rightLabel.text = [NSString setBigDataByState:global.slBizCustomers.isRiskData];
                self.bigDataView.rightLabel.textColor = ZSColorListRight;
                //1.订单创建人在提交订单之前(暂存状态)是可以随意更改大数据风控的（提交订单之后查询不能更改，不查询可以改为查询）
                //1.1(订单创建人）并且（非暂存状态）
                if ([global.slOrderDetails.isOrder isEqualToString:@"1"] && ![global.slOrderDetails.spdOrder.orderState isEqualToString:@"暂存"]){
                    //不查询大数据风控可以改为查询,查询大数据风控不可以更改
                    self.bigDataView.delegate = [global.slBizCustomers.isRiskData isEqualToString:@"1"] ? nil : self;
                }
            }
        }
        //检测底部按钮点击
        [self CheckBottomBtnClick];
    }
}

#pragma mark 有值设置title
- (void)setTitleStringWithRelation:(NSString *)releation
{
    if ([global.wsCustInfo.releation intValue] == 1) {
        self.title = @"本人信息";
    }else if ([global.wsCustInfo.releation intValue] == 2) {
        self.title = @"配偶信息";
    }else if ([global.wsCustInfo.releation intValue] == 4) {
        self.title = @"共有人信息";
    }else if ([global.wsCustInfo.releation intValue] == 7) {
        self.title = @"卖方信息";
    }else if ([global.wsCustInfo.releation intValue] == 8) {
        self.title = @"卖方配偶信息";
    }
}

#pragma mark 线上申请列表数据填充
- (void)fillInDataWithOnline
{
    if (self.isFromWeiXin || self.isFromOfficial) {
        //姓名
        if (global.slBizCustomers.name) {
            self.nameView.inputTextFeild.text = global.slBizCustomers.name;
        }
        //身份证号
        if (global.slBizCustomers.identityNo) {
            self.IDcardView.inputTextFeild.text = global.slBizCustomers.identityNo;
        }
        //手机号
        if (global.slBizCustomers.cellphone) {
            if (global.slBizCustomers.cellphone.length) {
                self.phoneNumView.inputTextFeild.text = [ZSTool addTheBlankSpace:global.slBizCustomers.cellphone];
            }
        }
    }
}

#pragma mark 检测列表中是否有配偶
- (BOOL)checkMyMate
{
//    if (global.slOrderDetails.bizCustomers.count == 2) {
//        return NO;
//    }
//    return YES;
    return NO;
}

#pragma mark ZSAlertViewDelegate -- 确认按钮响应
- (void)AlertView:(ZSAlertView *)alert
{
    if (alert.tag == openCameraFailTag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    else if (alert.tag == deletePersonTag){//删除人员信息接口调用
        NSMutableDictionary *parameterDict = @{@"userId":[ZSTool readUserInfo].tid,
                                               @"orderId":self.orderIDString,
                                               @"custId":global.slBizCustomers.tid,
                                               @"prdType":kProduceTypeStarLoan
                                               }.mutableCopy;
        [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getDeleteMate] SuccessBlock:^(NSDictionary *dic) {
            //通知星速贷订单详情刷新(提交订单之前)
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
            //通知星速贷订单详情刷新(已提交订单)
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
            //通知所有列表刷新
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
            //删除成功返回订单详情
            [self backActionOfDeletePerson];
        } ErrorBlock:^(NSError *error) {
        }];
    }
    else if (alert.tag == changeMarryTag){//修改婚姻状况
        [self createOrder];
    }
    else if (alert.tag == noticeTag){//返回信息不回保存
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alert.tag == scanTag){//扫描失败
        [self imagePicker];
    }
}

#pragma mark 删除人员成功后返回相应页面
- (void)backActionOfDeletePerson
{
    NSArray *array = self.navigationController.viewControllers;
    if ([global.slOrderDetails.spdOrder.orderState isEqualToString:@"暂存"]) {
        //上上个页面为订单详情列表
        if (array.count > 3){
            if ([array[array.count-3] isKindOfClass:[ZSSLPersonListViewController class]]){
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-3] animated:YES];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
     
    }else {
        //上上个页面为订单详情列表
        if ([array[array.count-3] isKindOfClass:[ZSSLPageController class]]){
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-3] animated:YES];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark 创建订单
- (void)createOrder
{
    [LSProgressHUD showToView:self.view message:@"提交中"];
    [ZSRequestManager requestWithParameter:[self getCreateUserParamter] url:[ZSURLManager getStarLoanAddOrEditorCustomer] SuccessBlock:^(NSDictionary *dic)
    {
        //通知星速贷订单详情刷新(提交订单之前)
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailForNoSumbitNotification object:nil];
        //通知星速贷订单详情刷新(已提交订单)
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //页面跳转
        [self backActionOfCreateOrder];
        [LSProgressHUD hideForView:self.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:self.view];
    }];
}

#pragma mark 创建订单/编辑成功后返回相应页面
- (void)backActionOfCreateOrder
{
//    NSLog(@"子控制器:%@",self.navigationController.viewControllers);
    NSArray *array = self.navigationController.viewControllers;
    //1.创建
    if (self.isFromAdd) {
        //如果是(暂存状态)并且是创建人是(主贷人)情况下
        if ([global.slOrderDetails.spdOrder.orderState isEqualToString:@"暂存"]) {
            if ([global.slOrderDetails.bizCustomers count] == 1){
                ZSSLPersonListViewController *vc = [[ZSSLPersonListViewController alloc]init];
                vc.orderState = @"暂存";
                vc.orderIDString = global.slOrderDetails.spdOrder.tid;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            //上个页面为订单详情列表
            if ([array[array.count-2] isKindOfClass:[ZSSLPageController class]]){
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-2] animated:YES];
            }
            //上上个控制器为星速贷订单列表
            else if ([array[array.count-3] isKindOfClass:[ZSStarLoanPageController class]]){
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-3] animated:YES];
            }
            else if (array.count > 4){
                //上上上个控制器为星速贷订单列表
                 if ([array[array.count-4] isKindOfClass:[ZSStarLoanPageController class]]){
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-4] animated:YES];
                }
            }
            else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    //2.编辑
    if (self.isFromEditor) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 创建订单请求的参数
- (NSMutableDictionary *)getCreateUserParamter
{
    NSMutableDictionary *parameter = @{@"userId":[ZSTool readUserInfo].tid,
                                       @"name":self.nameView.inputTextFeild.text,
                                       @"identityNo":self.IDcardView.inputTextFeild.text,
                                       @"identityPosUrl":self.urlFront,
                                       @"identityBakUrl":self.urlBack}.mutableCopy;
    //订单号
    [parameter setObject:self.orderIDString ? self.orderIDString : @"" forKey:@"serialNo"];
    //人员id
    if (self.isFromAdd) {
        [parameter setObject:@"" forKey:@"custNo"];
    }else{
        [parameter setObject:global.slBizCustomers.tid ? global.slBizCustomers.tid : @"" forKey:@"custNo"];
    }
    //人员角色
    if ([self.title isEqualToString:@"本人信息"]) {
        [parameter setObject:@"1" forKey:@"releation"];
    }else if ([self.title isEqualToString:@"配偶信息"]) {
        [parameter setObject:@"2" forKey:@"releation"];
    }else if ([self.title isEqualToString:@"共有人信息"]) {
        [parameter setObject:@"4" forKey:@"releation"];
    }else if ([self.title isEqualToString:@"卖方信息"]) {
        [parameter setObject:@"7" forKey:@"releation"];
    }else if ([self.title isEqualToString:@"卖方配偶信息"]) {
        [parameter setObject:@"8" forKey:@"releation"];
    }
    //与贷款人关系
    if ([self.title isEqualToString:@"共有人信息"]) {
        if ([self.marryView.rightLabel.text isEqualToString:@"朋友"]) {
            [parameter setObject:@"1" forKey:@"lenderReleation"];
        }else if ([self.marryView.rightLabel.text isEqualToString:@"直系亲属"]){
            [parameter setObject:@"2" forKey:@"lenderReleation"];
        }
    }
    //手机号
    if (![self.phoneNumView.inputTextFeild.text isEqualToString:KPlaceholderInput]) {
        [parameter setObject:[ZSTool filteringTheBlankSpace:self.phoneNumView.inputTextFeild.text] forKey:@"cellphone"];
    }
    //婚姻状况 1未婚 2已婚 3离异 4丧偶 与共有人关系 1朋友 2直系亲属
    if ([self.title isEqualToString:@"本人信息"] || [self.title isEqualToString:@"卖方信息"]) {
        NSString *beMarry = [NSString setBeMarrage:self.marryView.rightLabel.text];
        [parameter setObject:beMarry forKey:@"beMarrage"];
    }else if ([self.title isEqualToString:@"共有人信息"]){
        if ([self.marryView.rightLabel.text isEqualToString:@"朋友"]) {
            [parameter setObject:@"1" forKey:@"beMarrage"];
        }else{
            [parameter setObject:@"2" forKey:@"beMarrage"];
        }
    }else{
        [parameter setObject:@"" forKey:@"beMarrage"];
    }
    //订单来源 1中介 2线下 3微信 4官网
    if (self.orderIDString) {
        [parameter setObject:@"" forKey:@"dataSrc"];
        [parameter setObject:@"" forKey:@"agencyId"];//中介id
        [parameter setObject:@"" forKey:@"applyId"];//申请id
    }
    else if (self.onlineOrderIDString)
    {
        if (self.isFromWeiXin) {
            [parameter setObject:@"3" forKey:@"dataSrc"];
        }else if (self.isFromOfficial) {
            [parameter setObject:@"4" forKey:@"dataSrc"];
        }
        [parameter setObject:self.onlineOrderIDString forKey:@"applyId"];
        [parameter setObject:@"" forKey:@"agencyId"];
    }
    else
    {
        if (self.mediumID) {
            [parameter setObject:@"1" forKey:@"dataSrc"];
            [parameter setObject:self.mediumID forKey:@"agencyId"];
        }else{
            [parameter setObject:@"2" forKey:@"dataSrc"];
            [parameter setObject:@"" forKey:@"agencyId"];
        }
        [parameter setObject:@"" forKey:@"applyId"];
    }
    //中介联系人名字
    if (self.mediumName) {
        [parameter setObject:self.mediumName forKey:@"agencyContact"];
    }else{
        [parameter setObject:@"" forKey:@"agencyContact"];
    }
    //中介联系人方式
    if (self.mediumPhone) {
        [parameter setObject:self.mediumPhone forKey:@"agencyContactPhone"];
    }else{
        [parameter setObject:@"" forKey:@"agencyContactPhone"];
    }
    //是否查询大数据风控 0不查询 1查询
    if ([self.bigDataView.rightLabel.text isEqualToString:@"查询"]) {
        [parameter setObject:@"1" forKey:@"isBigDataCreditInfo"];
    }else if ([self.bigDataView.rightLabel.text isEqualToString:@"不查询"]){
        [parameter setObject:@"0" forKey:@"isBigDataCreditInfo"];
    }
    //身份证有效期时间
    if (self.string_iDcardVaild) {
        [parameter setObject:self.string_iDcardVaild forKey:@"identityExpiredDate"];
    }else{
        [parameter setObject:@"" forKey:@"identityExpiredDate"];
    }
    return parameter;
}

#pragma mark /*--------------------------------顶部身份证相关-------------------------------------------*/
#pragma mark 选择要输入的身份证图片--第几页
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    self.currentTapView = subView;//用于显示大图
    [self.view endEditing:YES];
    self.buttonInteger = subIndex;
    if (!self.isFromAdd && global.slBizCustomers.name.length)
    {
        //订单提交之前可以修改任何信息,提交之后不允许修改照片,只能查看大图
        if ([global.slOrderDetails.isOrder isEqualToString:@"1"] && [global.slOrderDetails.spdOrder.orderState isEqualToString:@"暂存"])
        {
            [self setArrayWithAction:subIndex];
        }
        else{
            [self showBigImage];
        }
    }else{
        [self setArrayWithAction:subIndex];
    }
}

#pragma mark 查看大图
- (void)showBigImage
{
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    // 2. 根据图片url传递数组
    if (global.slBizCustomers.identityPos.length && global.slBizCustomers.identityBak.length) {
        photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,global.slBizCustomers.identityPos],[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,global.slBizCustomers.identityBak]].mutableCopy;
    }else{
        if (self.urlFront && self.urlBack) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlFront],[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlBack]].mutableCopy;
        }
        if (self.urlFront && !self.urlBack) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlFront]].mutableCopy;
        }
        if (!self.urlFront && self.urlBack) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlBack]].mutableCopy;
        }
    }
    photoBroseView.showFromView = self.currentTapView;
    photoBroseView.hiddenToView = self.currentTapView;
    //当前点击的index和数组个数及图片位置做个匹配
    if (self.buttonInteger == 0)
    {
        photoBroseView.currentIndex = 0;
    }
    else if (self.buttonInteger == 1)
    {
        if (photoBroseView.imagesURL.count == 1){
            photoBroseView.currentIndex = 0;
        }else{
            photoBroseView.currentIndex = 1;
        }
    }
    // 3.显示(浏览)
    [photoBroseView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
