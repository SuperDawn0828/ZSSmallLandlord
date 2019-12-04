//
//  ZSWSHouseMaterialViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//



#import "ZSWSHouseMaterialViewController.h"
@interface ZSWSHouseMaterialViewController ()<ZSActionSheetViewDelegate,ZSPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel     *projectNameLabel;   //项目名称
@property (weak, nonatomic) IBOutlet UIButton    *projectNameBtn;     //项目名称
@property (weak, nonatomic) IBOutlet UITextField *buildingAreaField;  //预售建筑面积
@property (weak, nonatomic) IBOutlet UITextField *indooAreaField;     //预售套内面积
@property (weak, nonatomic) IBOutlet UIButton    *houseFunctionBtn;   //房屋功能
@property (weak, nonatomic) IBOutlet UITextField *houseNumberField;   //楼栋房号
@property (nonatomic,strong) NSMutableArray       *projectNameArray;  //项目名称数组
@property (nonatomic,strong) NSMutableArray       *projectIDArray;    //项目id数组
@property (nonatomic,strong) NSMutableArray       *houseFunctionArray;//房屋功能数组
@property (nonatomic,strong) ProjectInfo *projeftInfo;                //贷款信息model
@property (nonatomic,copy  ) NSString *currentSelectProjectID;        //当前选中的项目id

@end

@implementation ZSWSHouseMaterialViewController

- (NSMutableArray *)projectNameArray
{
    if (_projectNameArray == nil){
        _projectNameArray = [[NSMutableArray alloc]init];
    }
    return _projectNameArray;
}

- (NSMutableArray *)projectIDArray
{
    if (_projectIDArray == nil){
        _projectIDArray = [[NSMutableArray alloc]init];
    }
    return _projectIDArray;
}

- (NSMutableArray *)houseFunctionArray
{
    if (_houseFunctionArray == nil){
        _houseFunctionArray = [[NSMutableArray alloc]init];
    }
    return _houseFunctionArray;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.projectNameLabel.attributedText = [@"项目名称" addStar];
    self.buildingAreaField.inputAccessoryView = [self addToolbar];
    self.indooAreaField.inputAccessoryView = [self addToolbar];
    self.houseNumberField.inputAccessoryView = [self addToolbar];
    [self.buildingAreaField changePlaceholderColor];
    [self.indooAreaField changePlaceholderColor];
    [self.houseNumberField changePlaceholderColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"房产信息";
    [self setLeftBarButtonItem];
    [self configuBottomButtonWithTitle:@"保存" OriginY:CellHeight*5 + 15];
    [self setBottomBtnEnable:NO];
    [self initDatas];
    [self displayContent];
}

- (void)initDatas
{
    self.houseFunctionArray = @[@"住宅",@"商铺",@"车位",@"写字楼",@"公寓"].yy_modelCopy;
}

#pragma mark 赋值
- (void)displayContent
{
    self.projeftInfo = global.wsOrderDetail.projectInfo;
   
    if (self.projeftInfo.projName.length > 0){
        [self.projectNameBtn setTitle:self.projeftInfo.projName forState:UIControlStateNormal];
        [self.projectNameBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }
    if (self.projeftInfo.projId) {
        self.currentSelectProjectID = self.projeftInfo.projId.length > 0 ? self.projeftInfo.projId : @"";
    }
   
    if (self.projeftInfo.housingFunction.length > 0){
        [self.houseFunctionBtn setTitle:self.projeftInfo.housingFunction forState:UIControlStateNormal];
        [self.houseFunctionBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    }
    
    if (self.projeftInfo.coveredArea.length > 0){
        self.buildingAreaField.text = [NSString ReviseString:self.projeftInfo.coveredArea];
    }
  
    if (self.projeftInfo.insideArea.length > 0){
        self.indooAreaField.text = [NSString ReviseString:self.projeftInfo.insideArea];
    }
  
    if (self.projeftInfo.houseNum.length > 0){
        self.houseNumberField.text = self.projeftInfo.houseNum;
    }
    
    //底部按钮判断
    [self checkBottomBtnEnabled];
}

#pragma mark /*--------------------------------数据请求-------------------------------------------*/
#pragma mark 产品列表
- (void)requestProductList
{
    [self.projectNameArray removeAllObjects];
    [self.projectIDArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getProductList] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                global.productlistModel = [ZSProductListModel yy_modelWithJSON:dict];
                [weakSelf.projectNameArray addObject:global.productlistModel.projName];
                [weakSelf.projectIDArray addObject:global.productlistModel.tid];
            }
            [weakSelf pickerViewShow];
        }
        
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 编辑房产信息
- (void)requestEditHouseData
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[self getEditHouseParameter] url:[ZSURLManager getUpdateHouseDataURL] SuccessBlock:^(NSDictionary *dic) {
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } ErrorBlock:^(NSError *error) {
    }];
}

- (NSMutableDictionary *)getEditHouseParameter
{
    NSMutableDictionary *parameterDict = @{
                                           @"orderNo":global.wsOrderDetail.projectInfo.tid,
                                           @"projId":self.currentSelectProjectID ? self.currentSelectProjectID : @"",
                                           }.mutableCopy;
    if (self.buildingAreaField.text.length > 0){
        [parameterDict setValue:self.buildingAreaField.text forKey:@"coveredArea"];
    }
    if (self.indooAreaField.text.length > 0){
        [parameterDict setValue:self.indooAreaField.text forKey:@"insideArea"];
    }
    if (![[self.houseFunctionBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]){
        [parameterDict setValue:[self.houseFunctionBtn titleForState:UIControlStateNormal] forKey:@"housingFunction"];
    }
    if (self.houseNumberField.text.length > 0){
        [parameterDict setValue:self.houseNumberField.text forKey:@"houseNum"];
    }
    
    return parameterDict;
}

#pragma mark /*--------------------------------textfield-------------------------------------------*/
#pragma mark TextfieldDelegate
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
    //楼栋房号大于20则不让输入
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
    if (textField == self.houseNumberField){
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    //建筑面积限制输入10000.00,最多两位小数
    if (textField == self.buildingAreaField || textField == self.indooAreaField){
        if (toBeString.length > 0) {
            if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"10000.00" alert:YES]){
                [ZSTool showMessage:@"面积超过最大限制了！" withDuration:DefaultDuration];
                return NO;
            }
            if ([toBeString length] > 8) {
                textField.text = [toBeString substringToIndex:8];
                return NO;
            }
        }
    }
    //建筑面积保留2位小数
    if (textField == self.buildingAreaField || textField == self.indooAreaField) {//建筑面积(只允许保留2位小数)
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }
    return YES;
}

#pragma mark 判断预售套内面积不高于建筑面积
- (BOOL)judeAreaValue:(BOOL)isAlert
{
    if ([self.buildingAreaField.text floatValue] > 0 && [self.indooAreaField.text floatValue] > 0){
        NSDecimalNumber *numberBaseRate = [NSDecimalNumber decimalNumberWithString:self.buildingAreaField.text];
        NSDecimalNumber *numberRateEnd = [NSDecimalNumber decimalNumberWithString:self.indooAreaField.text];
        /// 这里不仅包含Multiply还有加 减 除。
        NSDecimalNumber *numResult = [numberBaseRate decimalNumberBySubtracting:numberRateEnd];
        NSString *endStr = [numResult stringValue];
        if (isAlert){
            if (endStr.floatValue < 0){
                [ZSTool showMessage:@"预售套内面积必须小于等于预售建筑面积" withDuration:DefaultDuration];
                return NO;
            }
        }else{
            return YES;
        }
       
    }
    return YES;
}

#pragma mark /*--------------------------------点击事件-------------------------------------------*/
#pragma mark 项目名称点击事件
- (IBAction)peojectNameBtnClick:(UIButton *)sender
{
    [self hideKeyboard];
    [self requestProductList];
}

- (void)pickerViewShow
{
    if (self.projectNameArray.count > 0){
        ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        pickerView.titleArray = self.projectNameArray;
        pickerView.tag = 101;
        pickerView.delegate = self;
        [pickerView show];
    }
}

- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index
{
    [self.projectNameBtn setTitle:self.projectNameArray[index] forState:UIControlStateNormal];//显示
    self.currentSelectProjectID = self.projectIDArray[index];
    [self checkBottomBtnEnabled];
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
    if (sheetView.tag == 102){
        [self.houseFunctionBtn setTitle:self.houseFunctionArray[tag] forState:UIControlStateNormal];
    }
}

#pragma mark /*--------------------------------底部按钮-------------------------------------------*/
#pragma mark 底部按钮点击
- (void)bottomClick:(UIButton *)sender
{
    if (self.buildingAreaField.text.floatValue == 0 && self.buildingAreaField.text.length > 0){
        [ZSTool showMessage:@"预售建筑面积不能为0" withDuration:DefaultDuration];
        return;
    }
    if (self.indooAreaField.text.floatValue == 0 && self.indooAreaField.text.length > 0){
        [ZSTool showMessage:@"预售套内面积不能为0" withDuration:DefaultDuration];
        return;
    }
    if (![self judeAreaValue:YES]){
        return;
    }
    [self requestEditHouseData];
}

#pragma mark 判断底部按钮是否可以点击
- (void)checkBottomBtnEnabled
{
    if (![[self.projectNameBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]) {
        [self setBottomBtnEnable:YES];
    }else {
        [self setBottomBtnEnable:NO];
    }
}

@end
