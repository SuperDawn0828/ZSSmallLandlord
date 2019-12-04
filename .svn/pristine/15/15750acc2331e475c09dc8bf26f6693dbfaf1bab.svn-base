//
//  ZSWitnessServerPageController.m
//  ZSSmallLandlord
//
//  Created by 武 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWitnessServerPageController.h"
#import "ZSWitnessServerOrderListViewController.h"
#import "ZSWSAddCustomerViewController.h"
#import "ZSBaseSearchViewController.h"

@interface ZSWitnessServerPageController ()

@end

@implementation ZSWitnessServerPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureRightNavItemWithTitleArray:nil withNormalImgArray:@[@"head_search_n",@"head_add_n"] withHilightedImg:nil];//右侧按钮
    //Data
    [self loadData];
}

#pragma mark 初始化title(子类需要重写)
- (NSArray *)setupViewTitle
{
    return @[@"未完成订单",@"已完成订单",@"已关闭订单"].copy;
}

#pragma mark 初始化的控制器(子类需要重写)
- (NSArray *)setupViewControllers
{
    NSMutableArray *testVCS = [NSMutableArray arrayWithCapacity:0];
    
    ZSWitnessServerOrderListViewController *listVC1 = [[ZSWitnessServerOrderListViewController alloc] init];
    listVC1.Orderstate = @"1";
    [testVCS addObject:listVC1];
    
    ZSWitnessServerOrderListViewController *listVC2 = [[ZSWitnessServerOrderListViewController alloc] init];
    listVC2.Orderstate = @"2";
    [testVCS addObject:listVC2];
    
    ZSWitnessServerOrderListViewController *listVC3 = [[ZSWitnessServerOrderListViewController alloc] init];
    listVC3.Orderstate = @"3";
    [testVCS addObject:listVC3];
    
    return testVCS.copy;
}

#pragma mark 右侧按钮--搜索--添加
- (void)RightBtnAction:(UIButton *)sender
{
    //移除弹窗
    [NOTI_CENTER postNotificationName:@"removeSelectView" object:nil];
    
    if (sender.tag == 0) {
        ZSBaseSearchViewController *searchVC = [[ZSBaseSearchViewController alloc]init];
        searchVC.filePathString = KWitnessServerSearch;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    else
    {
        //清空人员信息
        global.wsCustInfo = nil;
        ZSWSAddCustomerViewController *addVC = [[ZSWSAddCustomerViewController alloc]init];
        addVC.isFromAdd = YES;
        addVC.title = @"贷款人信息";
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

#pragma mark 获取列表数据权限
//1贷款人订单 2所在部门 3所在层级 4所有订单
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"prdType":kProduceTypeWitnessServer
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getAllOrderListDataPermission] SuccessBlock:^(NSDictionary *dic) {
        NSString *string = dic[@"respData"];
        if (string.intValue == 1) {
            weakSelf.title = @"新房见证";
        }
        if (string.intValue == 2) {
            [weakSelf initTitleView:110];
            weakSelf.titleArray = @[@"我创建的订单",@"所在部门订单"];
            weakSelf.titleLabel.text = @"新房见证-我的";
            weakSelf.titleArrayShow = @[@"新房见证-我的",@"新房见证-部门"];
        }
        if (string.intValue == 3) {
            [weakSelf initTitleView:110];
            weakSelf.titleArray = @[@"我创建的订单",@"所在层级订单"];
            weakSelf.titleLabel.text = @"新房见证-我的";
            weakSelf.titleArrayShow = @[@"新房见证-我的",@"新房见证-层级"];
        }
        if (string.intValue == 4) {
            [weakSelf initTitleView:110];
            weakSelf.titleArray = @[@"我创建的订单",@"平台所有订单"];
            weakSelf.titleLabel.text = @"新房见证-我的";
            weakSelf.titleArrayShow = @[@"新房见证-我的",@"新房见证-公司"];
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark ZSSelectViewDelegate
- (void)currentSelectIndex:(NSInteger)index currentSelectTitle:(NSString*)string withSecectView:(ZSSelectView *)alert;
{    
    //改标题
    self.titleLabel.text = self.titleArrayShow[index];
    //存值
    [USER_DEFALT setObject:string forKey:KWitnessServer];
    //发通知,掉接口
    [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
}

- (void)changeImage
{
    self.titleImg.image = [UIImage imageNamed:@"home_dropdown_n"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
