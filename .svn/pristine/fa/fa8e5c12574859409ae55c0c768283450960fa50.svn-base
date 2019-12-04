//
//  ZSBaseViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBaseViewController.h"

@interface ZSBaseViewController ()

@end

@implementation ZSBaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //页面背景色
    self.view.backgroundColor = ZSViewBackgroundColor;
    //导航栏标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:ZSColorWhite}];
    //导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forBarPosition:UIBarPositionAny  barMetrics:UIBarMetricsDefault];
    //导航栏分割线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark /*------------------------------------------手势相关-------------------------------------------*/
#pragma mark 开启返回手势(自定义返回按钮会导致手势失效)
- (void)openInteractivePopGestureRecognizerEnable
{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark 返回手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.transitionCoordinator)
    {
        return NO;
    }
    else if (self.navigationController.viewControllers.count == 1)
    {
        return NO;
    }
    return YES;
}

#pragma mark /*------------------------------------------导航栏-------------------------------------------*/
#pragma mark 返回按钮
- (void)setLeftBarButtonItem
{
    UIButton *backCustomView = [UIButton buttonWithType:UIButtonTypeCustom];
    backCustomView.frame = CGRectMake(0, 0, 54, 44);
    [backCustomView addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    backCustomView.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    self.imgView_left = [[UIImageView alloc] initWithFrame:CGRectMake(5, 11, 22 , 22)];
    self.imgView_left.image = [UIImage imageNamed:@"head_return_n"];
    [backCustomView addSubview:self.imgView_left];
    UIBarButtonItem *LeftCustomItem = [[UIBarButtonItem alloc] initWithCustomView:backCustomView];
    self.navigationItem.leftBarButtonItem = LeftCustomItem;
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 右侧导航栏(一个按钮)
- (void)configureRightNavItemWithTitle:(NSString*)title withNormalImg:(NSString*)norImg withHilightedImg:(NSString*)hilightedImg
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setFrame:CGRectMake(0, 0, 80, 40)];
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightBtn.tag = 0;
    if (title) {
        [self.rightBtn setTitle:title forState:UIControlStateNormal];
    }
    if (norImg) {
        [self.rightBtn setImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    }
    if (hilightedImg) {
        [self.rightBtn setImage:[UIImage imageNamed:hilightedImg] forState:UIControlStateHighlighted];
    }
    [self.rightBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(RightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

#pragma mark 右侧导航栏(两个按钮)
- (void)configureRightNavItemWithTitleArray:(NSArray*)titleArray withNormalImgArray:(NSArray*)norImgArray withHilightedImg:(NSArray*)hilightedImgArray
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = barBtnItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 2, 40, 40)];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.tag = 0;
    [rightBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(RightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:rightBtn];
    
    UIButton *rightBtn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn_r setFrame:CGRectMake(40, 2, 40, 40)];
    rightBtn_r.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn_r.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn_r.tag = 1;
    [rightBtn_r setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    [rightBtn_r addTarget:self action:@selector(RightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:rightBtn_r];
    
    if (titleArray) {
        [rightBtn setTitle:titleArray[0]   forState:UIControlStateNormal];
        [rightBtn_r setTitle:titleArray[1] forState:UIControlStateNormal];
    }
    if (norImgArray) {
        [rightBtn setImage:[UIImage imageNamed:norImgArray[0]]    forState:UIControlStateNormal];
        [rightBtn_r setImage:[UIImage imageNamed:norImgArray[1]]  forState:UIControlStateNormal];
    }
    if (hilightedImgArray) {
        [rightBtn setImage:[UIImage imageNamed:hilightedImgArray[0]]    forState:UIControlStateHighlighted];
        [rightBtn_r setImage:[UIImage imageNamed:hilightedImgArray[1]]  forState:UIControlStateHighlighted];
    }
}

//右侧导航栏点击事件,需重写
- (void)RightBtnAction:(UIButton*)sender
{
  
}

#pragma mark /*------------------------------------------底部按钮-------------------------------------------*/
#pragma mark 位置不固定
- (void)configuBottomButtonWithTitle:(NSString*)title OriginY:(CGFloat)Y
{
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtn.frame = CGRectMake(GapWidth, Y, ZSWIDTH-GapWidth*2, 44);
    [self.bottomBtn setTitle:title forState:UIControlStateNormal];
    self.bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtn.layer.cornerRadius = 22;
    self.bottomBtn.layer.masksToBounds = YES;
    [self.bottomBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRedHighlighted] forState:UIControlStateHighlighted];
    [self.view addSubview:self.bottomBtn];
}

#pragma mark 位置固定
- (void)configuBottomButtonWithTitle:(NSString *)title
{
    //底色
    CGFloat height = IS_iPhoneX ? 60 + SafeAreaBottomHeight : 60;
    if (self.bottomView == nil)
    {
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT - kNavigationBarHeight - 60, ZSWIDTH, height)];
        self.bottomView.backgroundColor = ZSColorWhite;
        [self.view addSubview:self.bottomView];
    }
    
    //按钮
    [self configuBottomButtonWithTitle:title OriginY:(60-44)/2];
    [self.bottomView addSubview:self.bottomBtn];
}

#pragma mark 位置固定的多个按钮
- (void)configuBottomBtnsWithTitles:(NSArray *)titlesArray
{
    //底色
    CGFloat height = IS_iPhoneX ? 60 + SafeAreaBottomHeight : 60;
    if (self.bottomView == nil)
    {
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT - kNavigationBarHeight - 60, ZSWIDTH, height)];
        self.bottomView.backgroundColor = ZSColorWhite;
        [self.view addSubview:self.bottomView];
    }
    
    //顶部分割线
    UIView *lineViewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.8)];
    lineViewTop.backgroundColor = ZSColorLine;
    [self.bottomView addSubview:lineViewTop];
    
    //按钮
    for (int i = 0; i < titlesArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ZSWIDTH/titlesArray.count * i, 0, ZSWIDTH/titlesArray.count, height);
        [button setTitle:titlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:ZSColorRed forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.bottomView addSubview:button];
    }
    
    //按钮之间的分割线
    for (int i = 1; i < titlesArray.count; i++)
    {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(ZSWIDTH/titlesArray.count * i, (height-20)/2, 1, 20)];
        lineView.backgroundColor = ZSColorLine;
        [self.bottomView addSubview:lineView];
    }
}

//修改按钮样式(白色)
- (void)setBottomBtnBackgroundColorWithWhite
{
    self.bottomBtn.layer.borderWidth = 0.5;
    self.bottomBtn.layer.borderColor = UIColorFromRGB(0xFCA39D).CGColor;
    [self.bottomBtn setTitleColor:ZSColorRed forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorWhite] forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:UIColorFromRGB(0xFFEFEE)] forState:UIControlStateHighlighted];
}

//修改按钮样式(红色)
- (void)setBottomBtnBackgroundColorWithRed
{
    self.bottomBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.bottomBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRedHighlighted] forState:UIControlStateHighlighted];
}

//底部按钮是否可点击
- (void)setBottomBtnEnable:(BOOL)enable
{
    if (enable)
    {
        self.bottomBtn.userInteractionEnabled = YES;
        [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forState:UIControlStateNormal];
    }
    else
    {
        self.bottomBtn.userInteractionEnabled = NO;
        [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorCanNotClick] forState:UIControlStateNormal];
    }
}

//底部按钮触发,需重写
- (void)bottomClick:(UIButton *)sender
{
    
}

#pragma mark /*------------------------------------------tableview------------------------------------------*/
- (void)configureTableView:(CGRect)frame withStyle:(UITableViewStyle)style
{
    self.tableView = [[UITableView alloc]initWithFrame:frame style:style];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ZSViewBackgroundColor;
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark /*------------------------------------------键盘添加工具栏------------------------------------------*/
- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, 35)];
    toolbar.tintColor = ZSColor(0, 126, 229);
    toolbar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    bar.tintColor = ZSColorListRight;
    toolbar.items = @[nextButton, prevButton, space, bar];
    return toolbar;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark /*------------------------------------------上下拉刷新------------------------------------------*/
- (void)endRefresh:(UITableView *)myTableView array:(NSMutableArray *)myArray
{
    if ([myTableView.mj_header isRefreshing]) {
        [myArray removeAllObjects];
        [myTableView.mj_header endRefreshing];
    }
    if ([myTableView.mj_footer isRefreshing]) {
        [myTableView.mj_footer endRefreshing];
    }
}

//收到请求失败的通知
- (void)requestFail:(UITableView *)myTableView array:(NSMutableArray *)myArray
{
    if ([myTableView.mj_header isRefreshing]) {
        [myTableView.mj_header endRefreshing];
    }
    if ([myTableView.mj_footer isRefreshing]) {
        [myTableView.mj_footer endRefreshing];
    }
    [myArray removeAllObjects];
    [myTableView reloadData];
    self.errorView.hidden = NO;
}

#pragma mark /*------------------------------------------缺省页------------------------------------------*/
- (void)configureErrorViewWithStyle:(NSInteger)style
{
    self.errorView = [[ZSErrorView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSWIDTH)];
    self.errorView.center = self.view.center;
    self.errorView.hidden = YES;
    [self.view addSubview:self.errorView];
    switch (style) {
        case ZSErrorWithoutOrder:{//订单列表无订单
            self.errorView.imagView.image = [UIImage imageNamed:@"blankpage_order_n"];
            self.errorView.titleLab.text  = @"空空如也，快去新增订单吧";
        }
            break;
        case ZSErrorCompletedOrder:{//订单列表已完成订单
            self.errorView.imagView.image = [UIImage imageNamed:@"blankpage_order_n"];
            self.errorView.titleLab.text  = @"没有已完成订单，加油喔！";
        }
            break;
        case ZSErrorClosedOrder:{//订单列表已关闭订单
            self.errorView.imagView.image = [UIImage imageNamed:@"blankpage_order_n"];
            self.errorView.titleLab.text  = @"非常棒！没有关闭任何订单";
        }
            break;
        case ZSErrorSearchNoData:{//搜索无数据
            self.errorView.imagView.image = [UIImage imageNamed:@"blankpage_searchr_n"];
            self.errorView.titleLab.text  = @"空空如也，啥也没找到";
        }
            break;
        case ZSErrorNotificationNoData:{//通知无数据
            self.errorView.imagView.image = [UIImage imageNamed:@"bar_notice"];
            self.errorView.titleLab.text  = @"暂无通知";
        }
            break;
        case ZSErrorWithoutOrderOfBank:{//银行后勤首页列表无订单
            self.errorView.imagView.image = [UIImage imageNamed:@"blankpage_order_n"];
            self.errorView.titleLab.text  = @"暂无订单哦";
        }
            break;
        case ZSErrorWithoutUploadFiles:{//上传图片界面没数据
            self.errorView.imagView.image = [UIImage imageNamed:@"bar_picture_n"];
            self.errorView.titleLab.text  = @"暂无可查看资料";
        }
            break;
        case ZSErrorWithoutrecords:{//新房见证资料收集记录没数据
            self.errorView.imagView.image = [UIImage imageNamed:@"bar_picture_n"];
            self.errorView.titleLab.text  = @"暂无记录哦";
        }
            break;
        case ZSErrorWithoutDelete:{//已删除的订单详情
            self.errorView.imagView.image = [UIImage imageNamed:@"bar_picture_n"];
            self.errorView.titleLab.text  = @"订单已删除";
        }
            break;
        case ZSErrorWithoutCustomReport:{//报表列表
            self.errorView.imagView.image = [UIImage imageNamed:@"customreport_nodata"];
            self.errorView.titleLab.text  = @"";
        }
            break;
        default:
            break;
    }
}

#pragma mark /*------------------------------------------订单详情页tableView的高度------------------------------------------*/
- (void)resetTableViewHeight
{
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType])
        {
            if ([global.slOrderDetails.approvalState isEqualToString:@"1"] || [global.slOrderDetails.approvalState isEqualToString:@"2"])
            {
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight-60;
            }
            else{
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
            }
        }
        else{
            self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
        }
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType])
        {
            if ([global.rfOrderDetails.approvalState isEqualToString:@"1"] || [global.rfOrderDetails.approvalState isEqualToString:@"2"])
            {
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight-60;
            }
            else{
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
            }
        }
        else{
            self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
        }
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType])
        {
            if ([global.mlOrderDetails.approvalState isEqualToString:@"1"] || [global.mlOrderDetails.approvalState isEqualToString:@"2"])
            {
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight-60;
            }
            else{
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
            }
        }
        else{
            self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
        }
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType])
        {
            if ([global.elOrderDetails.approvalState isEqualToString:@"1"] || [global.elOrderDetails.approvalState isEqualToString:@"2"])
            {
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight-60;
            }
            else{
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
            }
        }
        else{
            self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
        }
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType])
        {
            if ([global.chOrderDetails.approvalState isEqualToString:@"1"] || [global.chOrderDetails.approvalState isEqualToString:@"2"])
            {
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight-60;
            }
            else{
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
            }
        }
        else{
            self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
        }
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        if ([ZSTool checkStarLoanOrderIsCanEditingWithType:self.prdType])
        {
            if ([global.abOrderDetails.approvalState isEqualToString:@"1"] || [global.abOrderDetails.approvalState isEqualToString:@"2"])
            {
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight-60;
            }
            else{
                self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
            }
        }
        else{
            self.tableView.height = ZSHEIGHT-kNavigationBarHeight;
        }
    }
}

@end
