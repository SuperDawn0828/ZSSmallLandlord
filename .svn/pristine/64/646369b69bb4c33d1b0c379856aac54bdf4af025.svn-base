//
//  ZSWSAddCustomerBankViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSAddCustomerBankViewController.h"
#import "ZSInputOrSelectView.h"
#import "ZSWitnessServerPageController.h"
#import "ZSHomeViewController.h"
#import "ZSWSPageController.h"

@interface ZSWSAddCustomerBankViewController ()<ZSInputOrSelectViewDelegate,ZSPickerViewDelegate>
@property (nonatomic,strong)ZSInputOrSelectView *view_product;
@property (nonatomic,strong)ZSInputOrSelectView *view_bank;
@property (nonatomic,strong)NSMutableArray *array_product;  //项目名称
@property (nonatomic,strong)NSMutableArray *array_productID;//项目id
@property (nonatomic,strong)NSMutableArray *array_bank;     //银行名称
@property (nonatomic,strong)NSMutableArray *array_bankID;   //银行id
@property (nonatomic,copy  )NSString *currentSelectProduct; //当前选中的项目id
@property (nonatomic,copy  )NSString *currentSelectBank;    //当前选中的银行id
@property (nonatomic,copy  )NSString *lastSelectProduct;    //上次选中的项目id

@end

@implementation ZSWSAddCustomerBankViewController

#pragma mark 懒加载
- (NSMutableArray *)array_product
{
    if (_array_product == nil) {
        _array_product = [NSMutableArray array];
    }
    return _array_product;
}

- (NSMutableArray *)array_productID
{
    if (_array_productID == nil) {
        _array_productID = [NSMutableArray array];
    }
    return _array_productID;
}

- (NSMutableArray *)array_bank
{
    if (_array_bank == nil) {
        _array_bank = [NSMutableArray array];
    }
    return _array_bank;
}

- (NSMutableArray *)array_bankID
{
    if (_array_bankID == nil) {
        _array_bankID = [NSMutableArray array];
    }
    return _array_bankID;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"征信查询";
    [self setLeftBarButtonItem];//返回按钮
    [self initViews];
    //Data
    [self requestProductList];//获取项名称
    [self fillinData];
}

- (void)fillinData
{
    NSLog(@"项目名称:%@",global.wsOrderDetail.projectInfo.projName);
    if (global.wsOrderDetail.projectInfo.projName.length) {
        self.view_product.rightLabel.text = global.wsOrderDetail.projectInfo.projName;
        self.view_product.rightLabel.textColor = ZSColorListRight;
        self.currentSelectProduct = global.wsOrderDetail.projectInfo.projId ? global.wsOrderDetail.projectInfo.projId : @"";
        self.lastSelectProduct = global.wsOrderDetail.projectInfo.projId ? global.wsOrderDetail.projectInfo.projId : @"";
    }
    if (global.wsOrderDetail.projectInfo.loanBank.length) {
        self.view_bank.rightLabel.text = global.wsOrderDetail.projectInfo.loanBank;
        self.view_bank.rightLabel.textColor = ZSColorListRight;
        self.currentSelectBank = global.wsOrderDetail.projectInfo.loanBankId ? global.wsOrderDetail.projectInfo.loanBankId : @"";
    }
    
    [self CheckBottomBtnClick];
}

#pragma mark 数据请求
- (void)requestProductList
{
    __weak typeof(self) weakSelf  = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getProductList] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                global.productlistModel = [ZSProductListModel yy_modelWithJSON:dict];
                [weakSelf.array_product addObject:global.productlistModel.projName];
                [weakSelf.array_productID addObject:global.productlistModel.tid];
            }
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

- (void)requestBankList
{
    //因为现在银行是跟着项目走的,所以请求之前要清空数组
    self.array_bank = [[NSMutableArray alloc]init];
    self.array_bankID = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf  = self;
    NSMutableDictionary *parameterDict = @{
                                           @"projId":self.currentSelectProduct
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getBankListWithProduct] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count == 0) {
            [ZSTool showMessage:@"该项目下暂无贷款银行" withDuration:DefaultDuration];
            return;
        }
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                global.banklistModel = [ZSBanklistModel yy_modelWithJSON:dict];
                [weakSelf.array_bank addObject:global.banklistModel.bankName];
                [weakSelf.array_bankID addObject:global.banklistModel.bankId];
            }
            //弹出actionsheet
            if (weakSelf.array_bank.count > 0) {
                ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
                pickerView.titleArray = weakSelf.array_bank;
                pickerView.tag = 1;
                pickerView.delegate = weakSelf;
                [pickerView show];
            }
        }
    } ErrorBlock:^(NSError *error) {
        [ZSTool showMessage:@"获取银行信息失败" withDuration:DefaultDuration];
    }];
}

#pragma mark 检测列表中的人员是否需要查询央行征信
- (BOOL)checkTheBankCredit
{
    for (int i = 0; i<global.wsOrderDetail.custInfo.count; i++) {
        CustInfo *info = global.wsOrderDetail.custInfo[i];
        if (info.isBankCredit.intValue == 1) {
            return YES;
        }
    }
    return NO;
}

#pragma mark UI
- (void)initViews
{
    //项目名称
    self.view_product = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withClickAction:@"项目名称 *"];
    self.view_product.delegate = self;
    [self.view addSubview:self.view_product];
    
    //贷款银行
    NSString *string;
    if (self.checkTheBankCredit) {
        string = @"贷款银行 *";
    }else {
        string = @"贷款银行";
    }
    self.view_bank = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, CellHeight, ZSWIDTH, CellHeight) withClickAction:string];
    self.view_bank.delegate = self;
    [self.view addSubview:self.view_bank];
    
    //提交按钮
    [self configuBottomButtonWithTitle:@"提交" OriginY:88+15];
    [self setBottomBtnEnable:NO];
}

#pragma mark ZSInputOrSelectViewDelegate
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    if (view == self.view_product) {
        if (self.array_product.count > 0) {
            ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
            pickerView.titleArray = self.array_product;
            pickerView.tag = 0;
            pickerView.delegate = self;
            [pickerView show];
        }else{
            [ZSTool showMessage:@"获取项目信息失败" withDuration:DefaultDuration];
            [self requestProductList];//获取项名称
        }
    }
    else
    {
        //根据现有的项目id请求接口
        if ([self.view_product.rightLabel.text isEqualToString:KPlaceholderChoose]) {
            [ZSTool showMessage:@"请先选择项目" withDuration:DefaultDuration];
            return;
        }
        [self requestBankList];
    }
}

#pragma mark ZSPickerViewDelegate
- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index;//按钮触发的方法
{
    if (pickerView.tag == 0) {
        self.view_product.rightLabel.text = self.array_product[index];
        self.view_product.rightLabel.textColor = ZSColorListRight;
        self.currentSelectProduct = self.array_productID[index];
        //如果上次选的项目跟本次不一样, 清空银行信息
        if (self.lastSelectProduct) {
            if (![self.currentSelectProduct isEqualToString:self.lastSelectProduct]) {
                self.view_bank.rightLabel.text = @"请选择";
                self.view_bank.rightLabel.textColor = ZSColorAllNotice;
                self.currentSelectBank = nil;
            }
        }
        //赋值
        self.lastSelectProduct = self.currentSelectProduct;
    }
    else
    {
        self.view_bank.rightLabel.text = self.array_bank[index];
        self.view_bank.rightLabel.textColor = ZSColorListRight;
        self.currentSelectBank = self.array_bankID[index];
    }
    
    [self CheckBottomBtnClick];
}

#pragma mark 提交
- (void)bottomClick:(UIButton *)sender
{
    [LSProgressHUD showToView:self.view message:@"提交中"];
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":self.orderIDString,
                                           @"projId":self.currentSelectProduct}.mutableCopy;
    if (self.currentSelectBank) {
        [parameterDict setObject:self.currentSelectBank forKey:@"bankId"];
    }else{
        [parameterDict setObject:@"" forKey:@"bankId"];
    }
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getChangeOrderBankAndProduct] SuccessBlock:^(NSDictionary *dic) {
        [ZSTool showMessage:@"提交成功" withDuration:DefaultDuration];
        [self backAction];
        //通知所有列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [LSProgressHUD hideForView:self.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:self.view];
    }];
}

- (void)backAction
{
    NSLog(@"子控制器:%@",self.navigationController.viewControllers);
    NSArray *array = self.navigationController.viewControllers;
    if ([array[1] isKindOfClass:[ZSWitnessServerPageController class]]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else if ([array[1] isKindOfClass:[ZSWSPageController class]]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
}

#pragma mark 根据情况判断底部按钮可否点击
- (void)CheckBottomBtnClick
{
    if (self.checkTheBankCredit) {
        if (![self.view_product.rightLabel.text isEqualToString:KPlaceholderChoose] && ![self.view_bank.rightLabel.text isEqualToString:KPlaceholderChoose]) {
            [self setBottomBtnEnable:YES];//恢复点击
        }
    }else {
        if (![self.view_product.rightLabel.text isEqualToString:KPlaceholderChoose]) {
            [self setBottomBtnEnable:YES];//恢复点击
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
