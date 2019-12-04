//
//  ZSBaseCreatOrderViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/8/18.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBaseCreatOrderViewController.h"
@interface ZSBaseCreatOrderViewController ()<ZSAlertViewDelegate,ZSWSRightAlertViewDelegate>

@end

@implementation ZSBaseCreatOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarButtonItem];//返回
    [self configureTopView];
}

#pragma mark 顶部进度view
- (void)configureTopView
{
    if ([self.orderState isEqualToString:@"暂存"])
    {
        //头部视图
        [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64) withStyle:UITableViewStylePlain];
        self.view_top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, viewTopHeight)];
        self.tableView.tableHeaderView = self.view_top;
        //图片view
        self.view_progress = [ZSBaseCreatOrderHeaderView extractFromXib];
        [self.view_top addSubview:self.view_progress];
    }
    else
    {
        [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64) withStyle:UITableViewStyleGrouped];
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view_top.bottom, ZSWIDTH, 10)];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark /*--------------------------------右侧按钮-------------------------------------------*/
#pragma mark 右侧按钮点击事件
- (void)RightBtnAction:(UIButton *)sender
{
    ZSWSRightAlertView *alertView = [[ZSWSRightAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withArray:@[KDeleteBtnTitle]];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark ZSWSRightAlertViewDelegate
- (void)didSelectBtnClick:(NSInteger)tag
{
    //删除订单
    ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"删除订单后，该订单将不可进行任何操作，是否确认删除订单？" sureTitle:@"确定" cancelTitle:@"取消"];
    alertView.delegate = self;
    alertView.tag = 1001;
    [alertView show];
}

#pragma mark AlertViewDelegate
- (void)AlertView:(ZSAlertView *)alert
{
    [self requestForCloseOrderData];
}

#pragma mark 删除订单接口(子类复用)
- (void)requestForCloseOrderData
{

}

@end
