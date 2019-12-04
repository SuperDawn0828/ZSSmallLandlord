//
//  ZSTheMediationViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/9/12.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSTheMediationViewController.h"
#import "ZSTHOrderListViewController.h"
#import "ZSBaseSearchViewController.h"

@interface ZSTheMediationViewController ()
@end

@implementation ZSTheMediationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"中介端跟进";
    [self setLeftBarButtonItem];//返回按钮
    [self configureRightNavItemWithTitle:nil withNormalImg:@"head_search_n" withHilightedImg:nil];//右侧搜索按钮
}

#pragma mark 初始化title(子类需要重写)
- (NSArray *)setupViewTitle
{
    return @[@"待跟进",@"已处理"].copy;
}

#pragma mark 初始化的控制器(子类需要重写)
- (NSArray *)setupViewControllers
{
    NSMutableArray *testVCS = [NSMutableArray arrayWithCapacity:0];
    
    ZSTHOrderListViewController *listVC1 = [[ZSTHOrderListViewController alloc] init];
    listVC1.Orderstate = @"1";
    [testVCS addObject:listVC1];
    
    ZSTHOrderListViewController *listVC2 = [[ZSTHOrderListViewController alloc] init];
    listVC2.Orderstate = @"2";
    [testVCS addObject:listVC2];
    
    return testVCS.copy;
}

#pragma mark 搜索
- (void)RightBtnAction:(UIButton *)sender
{
    ZSBaseSearchViewController *searchVC = [[ZSBaseSearchViewController alloc]init];
    searchVC.filePathString = KTheMediationSearch;
    searchVC.prdType = self.prdType;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
