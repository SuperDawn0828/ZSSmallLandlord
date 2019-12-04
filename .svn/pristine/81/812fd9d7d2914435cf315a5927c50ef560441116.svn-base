//
//  ZSSendOrderPageViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/7/16.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSSendOrderPageViewController.h"
#import "ZSSOListViewController.h"

@interface ZSSendOrderPageViewController ()

@end

@implementation ZSSendOrderPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"派单列表";
    //返回按钮
    [self setLeftBarButtonItem];
    //右侧按钮
    [self configureRightNavItemWithTitle:@"批量操作" withNormalImg:nil withHilightedImg:nil];
    //滑动代理(已处理列表隐藏右侧按钮)
    __weak typeof(self) weakSelf  = self;
    [self.managerView setAdvancedDidSelectIndexHandle:^(NSInteger index) {
        if (index == 0) {
            weakSelf.rightBtn.hidden = NO;
            if ([weakSelf.rightBtn.titleLabel.text isEqualToString:@"取消"]){
                weakSelf.managerView.frame = CGRectMake(0, -CellHeight, ZSWIDTH, ZSHEIGHT);
            }
        }
        else{
            weakSelf.rightBtn.hidden = YES;
            weakSelf.managerView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT);
        }
    }];
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
    
    ZSSOListViewController *listVC1 = [[ZSSOListViewController alloc] init];
    listVC1.Orderstate = @"1";
    [testVCS addObject:listVC1];
    
    ZSSOListViewController *listVC2 = [[ZSSOListViewController alloc] init];
    listVC2.Orderstate = @"2";
    [testVCS addObject:listVC2];
    
    return testVCS.copy;
}

#pragma mark 批量操作
- (void)RightBtnAction:(UIButton *)sender
{
    if ([self.rightBtn.titleLabel.text isEqualToString:@"批量操作"])
    {
        //修改button的标题
        [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        //隐藏header
        self.managerView.frame = CGRectMake(0, -CellHeight, ZSWIDTH, ZSHEIGHT);
        //通知tableview刷新UI
        [NOTI_CENTER postNotificationName:@"theBatch0peration" object:nil userInfo:@{@"showSelect":@"0"}];
    }
    else if ([self.rightBtn.titleLabel.text isEqualToString:@"取消"])
    {
        //修改button的标题
        [self.rightBtn setTitle:@"批量操作" forState:UIControlStateNormal];
        //显示header
        self.managerView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT);
        //通知tableview刷新UI
        [NOTI_CENTER postNotificationName:@"theBatch0peration" object:nil userInfo:@{@"showSelect":@"1"}];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
