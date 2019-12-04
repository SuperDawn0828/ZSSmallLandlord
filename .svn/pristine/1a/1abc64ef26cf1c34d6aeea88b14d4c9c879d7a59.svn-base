//
//  ZSApplyForOnlinePageController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSApplyForOnlinePageController.h"
#import "ZSAFOOrderListViewController.h"
#import "ZSBaseSearchViewController.h"

@interface ZSApplyForOnlinePageController ()

@end

@implementation ZSApplyForOnlinePageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"微信申请列表";
    [self configureRightNavItemWithTitle:nil withNormalImg:@"head_search_n" withHilightedImg:nil];//右侧搜索按钮
}

#pragma mark 初始化title(子类需要重写)
- (NSArray *)setupViewTitle
{
    return @[@"待处理",@"已处理"].copy;
}

#pragma mark 初始化的控制器(子类需要重写)
- (NSArray *)setupViewControllers
{
    NSMutableArray *testVCS = [NSMutableArray arrayWithCapacity:0];
    
    ZSAFOOrderListViewController *listVC1 = [[ZSAFOOrderListViewController alloc] init];
    listVC1.Orderstate = @"1";
    [testVCS addObject:listVC1];
    
    ZSAFOOrderListViewController *listVC2 = [[ZSAFOOrderListViewController alloc] init];
    listVC2.Orderstate = @"2";
    [testVCS addObject:listVC2];
    
    return testVCS.copy;
}

#pragma mark 返回事件
- (void)leftAction
{
    //如果来自订单创建 不直接返回上一页 返回到首页
    if (self.isFromSubmiOrder){
        NSArray *array = self.navigationController.viewControllers;
        [self.navigationController popToViewController:array[0] animated:YES];
    }
    else
    {
        //返回到上一页
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 搜索
- (void)RightBtnAction:(UIButton *)sender
{
    ZSBaseSearchViewController *searchVC = [[ZSBaseSearchViewController alloc]init];
    searchVC.filePathString = KApplyforOnlineSearch;
    searchVC.prdType = self.prdType;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
