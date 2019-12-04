//
//  ZSBankHomeViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBankHomeViewController.h"
#import "ZSBankHomeOrderListViewController.h"
#import "ZSBaseSearchViewController.h"

@interface ZSBankHomeViewController ()

@end

@implementation ZSBankHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
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
    
    ZSBankHomeOrderListViewController *listVC1 = [[ZSBankHomeOrderListViewController alloc] init];
    listVC1.Orderstate = @"0";
    [testVCS addObject:listVC1];
    
    ZSBankHomeOrderListViewController *listVC2 = [[ZSBankHomeOrderListViewController alloc] init];
    listVC2.Orderstate = @"1";
    [testVCS addObject:listVC2];
    
    return testVCS.copy;
}

#pragma mark 搜索
- (void)RightBtnAction:(UIButton *)sender
{
    ZSBaseSearchViewController *searchVC = [[ZSBaseSearchViewController alloc]init];
    searchVC.filePathString = KBankHomeSearch;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
