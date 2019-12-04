//
//  ZSBaseOrderListPageViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/6/11.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSBaseOrderListPageViewController.h"

@interface ZSBaseOrderListPageViewController ()
@property(strong, nonatomic) NSArray                  *viewtitleArray;      //segment的title
@property(strong, nonatomic) NSArray                  *viewControllersArray;//segment的Controller
@property(strong, nonatomic) UIView                   *myHeaderView;
@end

@implementation ZSBaseOrderListPageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self setLeftBarButtonItem];
    [self setupSubViews];
}

#pragma mark /*---------------------------------页面初始化---------------------------------*/
- (void)setupSubViews
{
    [self.view addSubview:self.managerView];
}

- (LTAdvancedManager *)managerView
{
    if (!_managerView) {
        _managerView = [[LTAdvancedManager alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)
                                                viewControllers:self.viewControllersArray
                                                         titles:self.viewtitleArray
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

#pragma mark 初始化title
- (NSArray *)viewtitleArray
{
    if (!_viewtitleArray) {
        _viewtitleArray = [self setupViewTitle];
    }
    return _viewtitleArray;
}

#pragma mark 初始化的控制器
- (NSArray *)viewControllersArray
{
    if (!_viewControllersArray) {
        _viewControllersArray = [self setupViewControllers];
    }
    return _viewControllersArray;
}

#pragma mark headerView
- (UIView *)myHeaderView
{
    if (!_myHeaderView) {
        _myHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0)];
    }
    return _myHeaderView;
}

#pragma mark 初始化title(子类需要重写)
- (NSArray *)setupViewTitle
{
    NSMutableArray *testVCS = [NSMutableArray arrayWithCapacity:0];
    return testVCS.copy;
}

#pragma mark 初始化的控制器(子类需要重写)
- (NSArray *)setupViewControllers
{
    NSMutableArray *testVCS = [NSMutableArray arrayWithCapacity:0];
    return testVCS.copy;
}

#pragma mark /*---------------------------------中间的titleView---------------------------------*/
- (void)leftAction
{
    //移除弹窗
    [NOTI_CENTER postNotificationName:@"removeSelectView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTitleView:(CGFloat)titleWidth
{
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 0, 150, 44);
    [titleBtn addTarget:self action:@selector(showSelectView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((150-titleWidth-12)/2, 0, titleWidth, 44)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = ZSColorWhite;
    [titleBtn addSubview:self.titleLabel];
    
    self.titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.titleLabel.right+2, 17, 10, 10)];
    self.titleImg.image = [UIImage imageNamed:@"home_dropdown_n"];
    [titleBtn addSubview:self.titleImg];
}

- (void)showSelectView
{
    if ([UIImagePNGRepresentation(self.titleImg.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"home_dropdown_n"])])
    {
        //更换图片
        self.titleImg.image = [UIImage imageNamed:@"home_dropup_n"];
        //展示弹窗
        if ([self.titleLabel.text isEqualToString:self.titleArrayShow[0]])
        {
            ZSSelectView *selectView = [[ZSSelectView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, ZSHEIGHT) withArray:self.titleArray withCurrentIndex:0];
            selectView.delegate = self;
            [selectView show:2];
        }
        else {
            ZSSelectView *selectView  = [[ZSSelectView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, ZSHEIGHT) withArray:self.titleArray withCurrentIndex:1];
            selectView.delegate = self;
            [selectView show:2];
        }
        return;
    }
    else
    {
        //更换图片
        self.titleImg.image = [UIImage imageNamed:@"home_dropdown_n"];
        //移除弹窗
        [NOTI_CENTER postNotificationName:@"removeSelectView" object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
