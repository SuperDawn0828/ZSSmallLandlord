//
//  ZSBaseOrderDetailPageViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/30.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSBaseOrderDetailPageViewController.h"

@interface ZSBaseOrderDetailPageViewController ()
@property(strong, nonatomic) LTLayout                 *layout;
@property(copy,   nonatomic) NSArray                  *titleArray;
@property(copy,   nonatomic) NSArray                  *viewControllersArray;
@end

@implementation ZSBaseOrderDetailPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];
    [self setupSubViews];
}

#pragma mark 页面初始化
- (void)setupSubViews
{
    [self.view addSubview:self.managerView];
    
//    __weak typeof(self) weakSelf = self;
//    [self.managerView setAdvancedDidSelectIndexHandle:^(NSInteger index) {
//        //进入到二级页面后再返回,人员列表的headerview和_managerView的位置都不对
//        if (index == 0) {
//            
//        }
//    }];
}

- (LTAdvancedManager *)managerView
{
    if (!_managerView) {
        _managerView = [[LTAdvancedManager alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)
                                                viewControllers:self.viewControllersArray
                                                         titles:self.titleArray
                                          currentViewController:self
                                                         layout:self.layout
                                               headerViewHandle:^UIView * _Nonnull{return [self myHeaderView];}];
    }
    return _managerView;
}

- (LTLayout *)layout
{
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.titleViewBgColor = ZSColor(255, 255, 255);
        _layout.bottomLineColor = ZSColor(253, 114, 114);
        _layout.titleSelectColor = ZSColor(253, 114, 114);
        _layout.titleColor = ZSColor(168, 168, 168);
        _layout.pageBottomLineColor = ZSColor(248, 248, 248);
        _layout.sliderWidth = 60;
    }
    return _layout;
}
- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"基本信息", @"贷款信息", @"资料收集", @"订单进度"];
    }
    return _titleArray;
}

- (NSArray *)viewControllersArray
{
    if (!_viewControllersArray) {
        _viewControllersArray = [self setupViewControllers];
    }
    return _viewControllersArray;
}

#pragma mark 初始化的控制器(子类需要重写)
- (NSArray *)setupViewControllers
{
    NSMutableArray *testVCS = [NSMutableArray arrayWithCapacity:0];
    return testVCS.copy;
}

#pragma mark headerView
- (ZSOrderDetailHeaderView *)myHeaderView
{
    if (!_myHeaderView) {
        _myHeaderView = [[ZSOrderDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 90)];
        _myHeaderView.delegate = self;
        _myHeaderView.userInteractionEnabled = YES;
    }
    return _myHeaderView;
}

#pragma mark rightAlertViewDelegate(子类需要重写)
- (void)didSelectBtnClick:(NSInteger)tag
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
