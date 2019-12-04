//
//  ZSBankHomePersonListViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBankHomePersonListViewController.h"
#import "ZSBankHomePersonListCell.h"
#import "ZSBankReferenceEditorViewController.h"

@interface ZSBankHomePersonListViewController ()<ZSAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *arrayData;
@end

@implementation ZSBankHomePersonListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"人员列表";
    [self setLeftBarButtonItem];//返回
    [self initFooterView];//底部按钮
    //先清空历史数据,再进行请求,避免UI被绘制了
    global.wsOrderDetail = nil;
    [self addHeader];
    [NOTI_CENTER addObserver:self selector:@selector(addHeader) name:KSUpdateAllOrderListNotification object:nil];
}

- (void)addHeader {
    __weak typeof(self) weakSelf  = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.arrayData = [[NSMutableArray alloc]init];
        [weakSelf requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    global.wsOrderDetail.custInfo = nil;
    [LSProgressHUD showToView:self.view message:@"加载中"];
    NSMutableDictionary *parameter=  @{
                                       @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                       }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getQueryWitnessOrderDetails] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:nil];
        NSArray *array = dic[@"respData"][@"custInfo"];
        if (array.count > 0) {
            //整体赋值
            global.wsOrderDetail = [ZSWSOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
            //人员列表添加本地属性
            for (NSDictionary *dict in array) {
                CustInfo *custor = [CustInfo yy_modelWithDictionary:dict];
                custor.isNotFeedback = weakSelf.isNotFeedback;
                [weakSelf.arrayData addObject:custor];
            }
            //检测一下列表中是否有未反馈的人员
            [weakSelf checkList];
            [weakSelf.tableView reloadData];
        }
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 检测一下列表中是否有未反馈的人员(修改底部按钮样式)
- (void)checkList
{
    int number = 0;
    for (int i = 0; i < global.wsOrderDetail.custInfo.count; i++) {
        CustInfo *model = global.wsOrderDetail.custInfo[i];
        if (model.creditResult && model.creditResult.intValue == 0) {
            number++;
        }
    }
}

- (void)initFooterView//银行后勤页面底部按钮
{
    UIView *view_footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 64)];
    view_footer.backgroundColor = [UIColor clearColor];
    if (self.isNotFeedback) {
        [self configuBottomButtonWithTitle:@"提交反馈" OriginY:15];
        [view_footer addSubview:self.bottomBtn];
    }
    self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, self.view.height+10);
    self.tableView.tableFooterView = view_footer;
}

#pragma mark 银行后勤进行反馈
- (void)bottomClick:(UIButton *)sender
{
    //银行后勤,直接调接口
    //先判断人员列表中是否有人员的征信未反馈
    NSString *string_notice = @"";
    for (int i = 0; i < global.wsOrderDetail.custInfo.count; i++) {
        CustInfo *model = global.wsOrderDetail.custInfo[i];
        if (model.creditResult && model.creditResult.intValue == 0) {
            if (string_notice.length > 0) {
                string_notice = [NSString stringWithFormat:@"%@、%@",string_notice,model.name];
            }else{
                string_notice = [NSString stringWithFormat:@"%@%@",string_notice,model.name];
            }
        }
        //便利到最后一个了
        if (i == global.wsOrderDetail.custInfo.count-1) {
            if (string_notice.length > 0) {
                string_notice = [NSString stringWithFormat:@"%@的征信还未反馈,是否提交?",string_notice];
                ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:string_notice sureTitle:@"确认" cancelTitle:@"取消"];
                alert.delegate = self;
                [alert show];
            }
            else{
                [self changeOrderFeedbackState];
            }
        }
    }
}

#pragma mark ZSAlertViewDelegate
- (void)AlertView:(ZSAlertView *)alert;//按钮触发的方法
{
    [self changeOrderFeedbackState];
}

#pragma mark 修改订单反馈状态
- (void)changeOrderFeedbackState
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@"反馈中"];
    NSMutableDictionary *parameterDict = @{
                                           @"orderId":self.orderIDString.length ? self.orderIDString : [ZSGlobalModel getOrderID:self.prdType],
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getUpdateOrderFedbackState] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //通知银行后勤首页列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //提示
        [ZSTool showMessage:@"反馈成功" withDuration:DefaultDuration];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSBankHomePersonListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSBankHomePersonListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (self.arrayData.count > 0) {
        cell.detailModel = self.arrayData[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //银行后勤,待处理--编辑人员的征信,已处理--查看人员征信
    ZSBankReferenceEditorViewController *editorlVC = [[ZSBankReferenceEditorViewController alloc]init];
    editorlVC.isNotFeedback = self.isNotFeedback;
    editorlVC.orderIDString = self.orderIDString;
    global.wsCustInfo = self.arrayData[indexPath.row];
    [self.navigationController pushViewController:editorlVC animated:YES];
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
