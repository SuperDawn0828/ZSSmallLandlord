//
//  ZSSLAddreceiveAmountViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLAddReceiveAmountViewController.h"
#import "ZSInputOrSelectView.h"

@interface ZSSLAddReceiveAmountViewController ()<UITextFieldDelegate,ZSSLDataCollectionViewDelegate>

@end

@implementation  ZSSLAddReceiveAmountViewController

- (NSMutableArray *)doctextVocsArray
{
    if (_doctextVocsArray == nil){
        _doctextVocsArray = [[NSMutableArray alloc]init];
    }
    return _doctextVocsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isOnlyText = YES;
}

#pragma mark 创建collectionView
- (void)initCollectionView
{
    self.addDataStyle = ZSAddResourceDataCountless;
    self.dataCollectionView.userInteractionEnabled = YES;
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.addDataStyle = (ZSAddResourceDataStyle)self.addDataStyle;
}

#pragma mark 获取资料状态接口
- (void)requestForUpdateCollecState
{
    __weak typeof(self) weakSelf = self;
    [self.fileArray removeAllObjects];
    [LSProgressHUD showWithMessage:@"加载中"];
    [ZSRequestManager requestWithParameter:[weakSelf getMaterialsFilesParameter] url:[weakSelf getMaterialsFilesURL] SuccessBlock:^(NSDictionary *dic) {
        //文本信息解析
        if ([weakSelf.SLDocToModel.docname isEqualToString:@"收款凭证"]){
            NSArray *array = dic[@"respData"][@"docTextVos"];
            if (array.count > 0) {
                for (NSDictionary *dict in array) {
                    SpdDocdocTextVos *model = [SpdDocdocTextVos yy_modelWithJSON:dict];
                    model.id = model.textId;
                    model.value = SafeStr(model.text);
                    [weakSelf.doctextVocsArray addObject:model];
                }
            }
        }
        //不是两个加号
        NSArray *array = dic[@"respData"][@"spdDocInfoVos"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSWSFileCollectionModel *model = [ZSWSFileCollectionModel yy_modelWithJSON:dict];
                if (model.dataUrl.length > 0){
                    [weakSelf.fileArray addObject:model];
                }
            }
        }
        //是否可编辑
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && weakSelf.isShowAdd)
        {
            [weakSelf configureDataSource];
        }
        else
        {
            [weakSelf configCloseAndCompletedata];
        }
        [weakSelf initViews];
        [weakSelf.dataCollectionView layoutSubviews];
        [weakSelf initCollectionView:weakSelf.topSpace];
        [weakSelf initCollectionView];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 创建顶部视图(输入框)
- (void)initViews
{
    // 放款金额
    if (self.doctextVocsArray.count > 0)
    {
        NSString *string = @"";
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd){
            string = KPlaceholderInput;
        }else{
            string = @"";
        }
       //创建文本
        for (int i = 0; i < self.doctextVocsArray.count; i++ )
        {
            SpdDocdocTextVos *model = self.doctextVocsArray[i];
            ZSInputOrSelectView *view = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, i * CellHeight, ZSWIDTH, CellHeight) withInputAction:model.textType withRightTitle:string withKeyboardType:UIKeyboardTypeDecimalPad withElement:@"元"];
            [view.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            view.inputTextFeild.enabled = [ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] ? YES : NO;//如果是已关闭和已完成订单 不可编辑
            view.inputTextFeild.delegate = self;
            view.inputTextFeild.tag = i;
            if ([model.text containsString:@"null"]){
                view.inputTextFeild.text = @"";
            }else{
                view.inputTextFeild.text = SafeStr(model.text);
            }
            [self.bgScrollView addSubview:view];
            if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd){
                view.userInteractionEnabled = YES;
            }else{
                view.userInteractionEnabled = NO;
            }
        }
        //dataconllectionView的起始高度
        self.topSpace = CellHeight * self.doctextVocsArray.count;
    }

    //判断是否可编辑
    [self checkTheViewCanEditing];
}

#pragma mark 判断界面是否可编辑
- (void)checkTheViewCanEditing
{
    if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType] && self.isShowAdd){
        self.dataCollectionView.isShowAdd = YES;
    }
    else
    {
        self.dataCollectionView.isShowAdd = NO;
    }
}

#pragma mark 是否展示无数据的图片
- (void)isShowErrorView
{
    if (self.itemDataArray.count == 0 && self.doctextVocsArray.count == 0)
    {
        self.errorView.hidden = NO;
    }
}

#pragma mark textfieldDelagate
- (void)textFieldTextChange:(UITextField *)textField
{
    SpdDocdocTextVos *model = self.doctextVocsArray[textField.tag];
    model.id = model.textId;
    if (![textField.text isEqualToString:model.text]) {
        self.isChanged = YES;
    }
    model.text = textField.text;
    model.value = model.text;
    [self.doctextVocsArray replaceObjectAtIndex:textField.tag withObject:model];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    SpdDocdocTextVos *model = self.doctextVocsArray[textField.tag];
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
    //1是% 2是元   //贷款利率限制最大100.0000%,最多4位小数
    if ([model.textUnit isEqualToString:@"1"]){
//        if (toBeString.length > 0) {
//            if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"100.00" alert:YES]){
//                [ZSTool showMessage:@"超过最大限制了！" withDuration:DefaultDuration];
//                return NO;
//            }
//            if ([toBeString length] > 8) {
//                textField.text = [toBeString substringToIndex:8];
//                return NO;
//            }
//        }
//        return [textField checkTextField:textField WithString:string Range:range numInt:4];
        //金额限制最大100000000.00元，最多两位小数
        if (toBeString.length > 0){
            if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:KMaxAmount alert:YES]){
                [ZSTool showMessage:@"金额太大了! " withDuration:DefaultDuration];
                return NO;
            }
            if ([toBeString length] > 12) {
                textField.text = [toBeString substringToIndex:12];
                return NO;
            }
        }
        
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }else{
        //金额限制最大100000000.00元，最多两位小数
        if (toBeString.length > 0){
            if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:KMaxAmount alert:YES]){
                [ZSTool showMessage:@"金额太大了! " withDuration:DefaultDuration];
                return NO;
            }
            if ([toBeString length] > 12) {
                textField.text = [toBeString substringToIndex:12];
                return NO;
            }
        }
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }

    return YES;
}

#pragma mark /*--------------------------------请求参数-------------------------------------------*/
#pragma mark 上传文本参数
- (NSMutableDictionary *)getUploadOnlyTextParameter
{
    NSMutableDictionary *parameter =  @{
                                        @"maType":@"SKPZ",
                                        @"prdType":self.prdType,
                                        @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                        }.mutableCopy;
    NSString *deleteIDStr = [NSString StingByJson:[ZSTool getModelArrayWithArray:self.doctextVocsArray]];
    [parameter setObject:deleteIDStr forKey:@"data"];//文本数据
    return parameter;
}

@end
