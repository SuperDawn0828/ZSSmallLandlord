//
//  ZSPreliminaryCreditPageController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/7/5.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSPreliminaryCreditPageController.h"
#import "ZSPCOrderListController.h"
#import "ZSBaseSearchViewController.h"

@interface ZSPreliminaryCreditPageController ()

@end

@implementation ZSPreliminaryCreditPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预授评估列表";
    [self setLeftBarButtonItem];//返回按钮
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
    
    ZSPCOrderListController *listVC1 = [[ZSPCOrderListController alloc] init];
    listVC1.Orderstate = @"1";
    [testVCS addObject:listVC1];
    
    ZSPCOrderListController *listVC2 = [[ZSPCOrderListController alloc] init];
    listVC2.Orderstate = @"2";
    [testVCS addObject:listVC2];
    
    return testVCS.copy;
}

#pragma mark 搜索
- (void)RightBtnAction:(UIButton *)sender
{
    ZSBaseSearchViewController *searchVC = [[ZSBaseSearchViewController alloc]init];
    searchVC.filePathString = KPreliminaryCreditSearch;
    searchVC.prdType = self.prdType;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
