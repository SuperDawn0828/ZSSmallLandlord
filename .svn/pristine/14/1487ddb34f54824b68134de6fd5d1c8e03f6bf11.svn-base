//
//  ZSMoreActionSheetView.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/7.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSPickerView.h"

@interface ZSPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIView                   *backgroundView_black;
@property(nonatomic,strong)UIView                   *backgroundView_white;
@property(nonatomic,strong)UIPickerView             *picker;
@property(nonatomic,assign)NSInteger                selectRow;          //当前选中的行
@end

@implementation ZSPickerView

#pragma mark 懒加载
- (NSMutableArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatPickView];
    }
    return self;
}

- (void)creatPickView
{
    //黑底
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0;
    [self addSubview:self.backgroundView_black];
  
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnAction)];
    [self addGestureRecognizer:tap];
 
    //白底
    self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT_PopupWindow-250, ZSWIDTH, 250)];
    self.backgroundView_white.backgroundColor = ZSColorWhite;
    self.backgroundView_white.layer.cornerRadius = 3;
    self.backgroundView_white.alpha = 0;
    [self addSubview:self.backgroundView_white];
   
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 50, 50);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ZSPageItemColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:cancelBtn];
   
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(ZSWIDTH-50, 0, 50, 50);
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView_white addSubview:sureBtn];
   
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ZSWIDTH, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [self.backgroundView_white addSubview:lineView];
 
    //picker
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, ZSWIDTH,220)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.showsSelectionIndicator = YES;
    [self.picker selectedRowInComponent:0];//默认选择第0行
    [self.backgroundView_white addSubview:self.picker];
  
    //给默认值
    self.selectRow = 0;
}

#pragma mark 显示自己
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView_black.alpha = 0.5;
        self.backgroundView_white.alpha = 1;
    }];
}

#pragma mark 按钮响应事件
- (void)sureBtnAction
{
    [self removeFromSuperview];
    if([_delegate respondsToSelector:@selector(pickerView:didSelectIndex:)]){
        [_delegate pickerView:self didSelectIndex:self.selectRow];
    }
}

- (void)cancelBtnAction
{
    [self removeFromSuperview];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return CellHeight;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.titleArray.count;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",self.titleArray[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectRow = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end
