//
//  ZSCustomReportListPopView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/27.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSCustomReportListPopView.h"
#import "ZSInputOrSelectView.h"

@interface ZSCustomReportListPopView ()<ZSInputOrSelectViewDelegate,ZSPickerViewDelegate>
@property (nonatomic,strong)UIScrollView        *backgroundScroll;
@property (nonatomic,strong)ZSInputOrSelectView *reportNameView;  //报表名称
@property (nonatomic,strong)ZSInputOrSelectView *prdTypeView;     //选择产品
@property (nonatomic,strong)ZSInputOrSelectView *timeHorizonView; //时间范围
@property (nonatomic,copy  )NSString            *prdTye;
@property (nonatomic,copy  )NSString            *timeHorizon;
@end

@implementation ZSCustomReportListPopView

- (id)initWithFrame:(CGRect)frame withType:(NSString *)type
{
    if (self = [super initWithFrame:frame])
    {
        //UI
        [self configureViews];
        [self creatBaseUIwithType:type];
    }
    return self;
}

#pragma mark 数据填充
- (void)initData:(ZSCustomReportListModel *)model;
{
    _model = model;
    
    if (model.name) {
        self.reportNameView.inputTextFeild.text = SafeStr(model.name);
    }
    
    if (model.prdType) {
        self.prdTypeView.userInteractionEnabled = NO;
        self.prdTypeView.rightLabel.textColor = ZSColorListRight;
        self.prdTypeView.rightLabel.text = [ZSGlobalModel getProductStateWithCode:model.prdType];
        self.prdTye = model.prdType;
    }
    
    if (model.timeFrame) {
        self.timeHorizonView.rightLabel.textColor = ZSColorListRight;
        self.timeHorizonView.rightLabel.text = [ZSGlobalModel getCustomReportTimeHorizonStateWithCode:model.timeFrame];
        self.timeHorizon = model.timeFrame;
    }
    
    if (model.remark) {
        self.inputTextView.text = model.remark.length ? model.remark : nil;
        self.placeholderLabel.hidden = model.remark.length ? YES : NO;
    }
}

#pragma mark /*------------------------------------------------黑底白底----------------------------------------------------*/
- (void)creatBaseUIwithType:(NSString *)type
{
    //表设置
    self.titleLabel.text = type;
    
    //背景ScrollView
    self.backgroundScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom, ZSWIDTH, self.whiteBackgroundView.height-110-SafeAreaBottomHeight)];
    [self.whiteBackgroundView addSubview:self.backgroundScroll];
    
    //报表名称(必填)
    self.reportNameView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:@"报表名称 *" withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
    [self.backgroundScroll addSubview:self.reportNameView];
    
    //选择产品(必填)
    self.prdTypeView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.reportNameView.bottom, ZSWIDTH, CellHeight) withClickAction:@"选择产品 *"];
    self.prdTypeView.delegate = self;
    [self.backgroundScroll addSubview:self.prdTypeView];
    
    //时间范围(必填)
    self.timeHorizonView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.prdTypeView.bottom, ZSWIDTH, CellHeight) withClickAction:@"时间范围 *"];
    self.timeHorizonView.delegate = self;
    [self.backgroundScroll addSubview:self.timeHorizonView];
    
    //输入框
    [self configureInputViewWithFrame:CGRectMake(0, self.timeHorizonView.bottom, ZSWIDTH, 244) withString:@"报表说明"];
    [self.backgroundScroll addSubview:self.inputBgScroll];
    self.inputBgScroll.scrollEnabled = NO;
    
    //重新设置scrollview的滑动范围
    self.backgroundScroll.contentSize = CGSizeMake(0, CellHeight*3 + 244);
    
    //底部按钮
    [self configureSubmitBtn:@"前往设置字段"];
}

#pragma mark 选择产品/时间范围
- (void)clickBtnAction:(ZSInputOrSelectView *)view
{
    //键盘回收
    [self hideKeyboard];
    
    //选择产品
    if (view == self.prdTypeView)
    {
        ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
        pickerView.titleArray = [ZSGlobalModel getProductArray].mutableCopy;
        pickerView.delegate = self;
        pickerView.tag = 0;
        [pickerView show];
    }
    //时间范围
    else if (view == self.timeHorizonView)
    {
        ZSPickerView *pickerView = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
        pickerView.titleArray = [ZSGlobalModel getCustomReportTimeHorizonArray].mutableCopy;
        pickerView.delegate = self;
        pickerView.tag = 1;
        [pickerView show];
    }
}

- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index;
{
    if (pickerView.tag == 0)
    {
        self.prdTypeView.rightLabel.textColor = ZSColorListRight;
        self.prdTypeView.rightLabel.text = [ZSGlobalModel getProductArray][index];
        self.prdTye = [ZSGlobalModel getProductCodeWithState:[ZSGlobalModel getProductArray][index]];
    }
    else if (pickerView.tag == 1)
    {
        self.timeHorizonView.rightLabel.textColor = ZSColorListRight;
        self.timeHorizonView.rightLabel.text = [ZSGlobalModel getCustomReportTimeHorizonArray][index];
        self.timeHorizon = [ZSGlobalModel getCustomReportTimeHorizonCodeWithState:[ZSGlobalModel getCustomReportTimeHorizonArray][index]];
    }
}

#pragma mark /*-------------------------------------------------底部按钮-----------------------------------------------------*/
- (void)submitBtnAction
{
    if (self.reportNameView.inputTextFeild.text.length == 0) {
        [ZSTool showMessage:@"请输入报表名称" withDuration:DefaultDuration];
        return;
    }
    
    if (self.prdTye == nil) {
        [ZSTool showMessage:@"请选择产品类型" withDuration:DefaultDuration];
        return;
    }
    
    if (self.timeHorizon == nil) {
        [ZSTool showMessage:@"请选择时间范围" withDuration:DefaultDuration];
        return;
    }
    
    ZSCustomReportListModel *model = [[ZSCustomReportListModel alloc]init];
    if (_model) {
        model = _model;
    }
    model.name = self.reportNameView.inputTextFeild.text;
    model.prdType = self.prdTye;
    model.timeFrame = self.timeHorizon;
    model.remark = self.inputTextView.text.length > 0 ? self.inputTextView.text : @"";

    //代理传值
    if (_delegate && [_delegate respondsToSelector:@selector(addReportModel:)]) {
        [_delegate addReportModel:model];
    }
    
    [self dismiss];
}

@end
