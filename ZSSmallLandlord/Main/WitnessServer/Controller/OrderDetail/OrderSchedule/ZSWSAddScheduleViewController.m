//
//  ZSWSAddScheduleViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSAddScheduleViewController.h"
#import "FSTextView.h"
#import "ZSWSYearMonthDayPicker.h"
#import "ZSPickerView.h"
#import "ZSWSProgramMatterModel.h"

@interface ZSWSAddScheduleViewController ()<UITextViewDelegate,ZSActionSheetViewDelegate,ZSPickerViewDelegate>
@property (weak, nonatomic) IBOutlet FSTextView *txtView;
@property (weak, nonatomic) IBOutlet UILabel    *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIButton   *projectNameBtn;//项目名称
@property (weak, nonatomic) IBOutlet UILabel    *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton   *timeBtn;
//时间
@property(nonatomic,strong)NSMutableArray *projectNameArray;//项目数组
@property(nonatomic,copy)NSString *selectName;//选中的项目名称
@end

@implementation ZSWSAddScheduleViewController

- (NSMutableArray *)projectNameArray
{
    if (_projectNameArray == nil){
        _projectNameArray = [[NSMutableArray alloc]init];
    }
    return _projectNameArray;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.projectNameLabel.attributedText = [@"事项" addStar];
    self.timeLabel.attributedText = [@"日期" addStar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新增进度";
    [self setLeftBarButtonItem];
    [self initTxtViews];
    [self configuBottomButtonWithTitle:@"保存" OriginY:CellHeight*2 + 200 + 15];
    [self setBottomBtnEnable:NO];
    self.projectNameArray = @[@"商业住房贷",@"商用贷",@"纯公积金",@"组合贷（公积金+商业贷款)",@"装修贷"].mutableCopy;
}

#pragma mark requestProjectNameData
- (void)requestProjectNameData
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSMutableDictionary * parameter = @{
                                        @"category":@"programMatter"
                                        }.mutableCopy;
    [LSProgressHUD showToView:self.view message:@"加载中"];
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getListProgramMattersURL] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0){
            for (NSDictionary*orderDic in array) {
                ZSWSProgramMatterModel *model = [ZSWSProgramMatterModel yy_modelWithDictionary:orderDic];
                [dataArray addObject:model.name];
            }
            weakSelf.projectNameArray = dataArray;
            //贷款银行不存在的时候不能有银行放款选项
            if (!(global.wsOrderDetail.projectInfo.loanBank.length > 0)){
                [weakSelf.projectNameArray removeObject:@"银行放款"];
            }
            for (ScheduleInfo *scheduleInfo in global.wsOrderDetail.scheduleInfo) {
                //如果存在银行放款或者贷款银行不存在的时候不能有银行放款选项
                if ([scheduleInfo.item isEqualToString:@"银行放款"]){
                    [weakSelf.projectNameArray removeObject:@"银行放款"];
                }
                if ([scheduleInfo.item isEqualToString:@"完成"]){
                    [weakSelf.projectNameArray removeObject:@"完成"];
                }
            }
            [weakSelf pickerViewShow];
        }
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark requestProjectNameData
- (void)requestAddOrderSchedule
{
    NSMutableDictionary * parameter = @{
                                        @"category":@"programMatter",
                                        @"orderId":global.wsOrderDetail.projectInfo.tid,
                                        @"itemDate":[self.timeBtn titleForState:UIControlStateNormal],
                                        @"item":self.selectName,
                                        }.mutableCopy;
    if (self.txtView.text.length > 0){
        [parameter setValue:self.txtView.text forKey:@"remark"];
    }
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"加载中"];
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getAddOrderScheduleURL] SuccessBlock:^(NSDictionary *dic) {
        //通知新房见证详情接口
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark initTxtViews
- (void)initTxtViews
{
    self.txtView.delegate                = self;
    self.txtView.textContainerInset      = UIEdgeInsetsMake(10, 10, 10, 5);//top left
    self.txtView.inputAccessoryView      = [self addToolbar];
    self.txtView.textColor               = ZSColorListRight;
    self.txtView.font                    = [UIFont systemFontOfSize:15];
    self.txtView.placeholder             = @" 请输入要备注的信息";
    self.txtView.maxLength               = 500;
}

#pragma mark textView--输入限制
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //限制输入表情
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
        return NO;
    }
    //判断键盘是不是九宫格键盘
    if ([ZSTool isNineKeyBoard:text] ){
        return YES;
    }else{
        //限制输入表情
        if ([ZSTool stringContainsEmoji:text]) {
            return NO;
        }
    }
    
    //得到输入框的内容
    NSString *toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    //不允许输入空格
    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![text isEqualToString:tem]) {
        return NO;
    }
    
    //最多只能输入500个子
    if (range.location > 500) {
        [ZSTool showMessage:@"最多只能输入500字" withDuration:DefaultDuration];
        textView.text = [toBeString substringToIndex:500];
        return NO;
    }
    return YES;
}

#pragma mark textView--delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if ([ZSTool stringContainsEmoji:textView.text]) {
        textView.text = [textView.text substringToIndex:textView.text.length -2];
    }
    if (textView.text.length >= 500) {
        textView.text = [textView.text substringToIndex:500];
        [ZSTool showMessage:@"最多只能输入500个字符" withDuration:DefaultDuration];
    }
}

#pragma mark 事项点击事件
- (IBAction)projectNameBtnClick:(UIButton *)sender
{
    [self hideKeyboard];
    [self requestProjectNameData];
}

#pragma mark 日期点击事件
- (IBAction)timeBtnClick:(UIButton *)sender
{
    [self hideKeyboard];
    ZSWSYearMonthDayPicker *datePicker=[[ZSWSYearMonthDayPicker alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 250)];
    datePicker.datePickerBlock = ^(NSString *selectDate) {
        [sender setTitle:selectDate forState:UIControlStateNormal];
        [sender setTitleColor:ZSColorListRight forState:UIControlStateNormal];
        [self judeBottomBtnEnabled];
    };
    [self.view addSubview:datePicker];
}

#pragma mark pickerView 弹框
- (void)pickerViewShow
{
    ZSPickerView *actionsheet = [[ZSPickerView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    actionsheet.titleArray = self.projectNameArray;
    actionsheet.delegate = self;
    [actionsheet show];
}

#pragma mark ZSPickerViewDelegate
- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index
{
    [self.projectNameBtn setTitle:self.projectNameArray[index] forState:UIControlStateNormal];
    [self.projectNameBtn setTitleColor:ZSColorListRight forState:UIControlStateNormal];
    self.selectName = self.projectNameArray[index];
    [self judeBottomBtnEnabled];
}

#pragma mark 底部按钮点击
- (void)bottomClick:(UIButton *)sender
{
    [self requestAddOrderSchedule];
}

#pragma mark 判断底部按钮是否可以点击
- (void)judeBottomBtnEnabled
{
    if (![[self.projectNameBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose] && ![[self.timeBtn titleForState:UIControlStateNormal] isEqualToString:KPlaceholderChoose]) {
        [self setBottomBtnEnable:YES];
    }else {
        [self setBottomBtnEnable:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
