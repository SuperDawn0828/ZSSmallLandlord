//
//  ZSCustomReportDetailViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/27.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSCustomReportDetailViewController.h"
#import "ZSCustomReportSettingViewController.h"
#import "ZSCustomReportDetailLeftCell.h"
#import "ZSCustomReportDetailRightCell.h"
#import "ZSSLPersonListViewController.h"
#import "ZSSLPageController.h"

@interface ZSCustomReportDetailViewController ()<ZSGridTitleViewDelegate>
@property(nonatomic,strong)UITableView    *leftTableView;
@property(nonatomic,strong)UIScrollView   *rightScroll;
@property(nonatomic,assign)CGFloat        rightWidth;      //用于横竖屏适配
@property(nonatomic,assign)CGFloat        tableHeight;     //用于横竖屏适配
@property(nonatomic,strong)NSMutableArray *listDataArray;  //列表对应的数据
@property(nonatomic,strong)NSMutableArray *listTitleArray; //表头字段名
@property(nonatomic,assign)BOOL           isScrolling;
@end

@implementation ZSCustomReportDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
    //导航栏标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:ZSColorBlack}];
    //导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[ZSTool createImageWithColor:ZSColor(249, 249, 249)] forBarPosition:UIBarPositionAny  barMetrics:UIBarMetricsDefault];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //可以根据手机感应开启横屏
    [self begainFullScreen];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //导航栏标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:ZSColorWhite}];
    //导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forBarPosition:UIBarPositionAny  barMetrics:UIBarMetricsDefault];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //强制退出横屏
    [self endFullScreen];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = self.model.name;
    [self setLeftBarButtonItem];
    self.imgView_left.image = [UIImage imageNamed:@"tool_guanbi_n"];
    [self configureTable];
    //Data
    [self getQueryAccListingDataForAppURL];
    [self configureErrorViewWithStyle:ZSErrorWithoutCustomReport];//无数据
    [NOTI_CENTER addObserver:self selector:@selector(changeColor:) name:@"changeCellBackgroundColor" object:nil];
}

#pragma mark 查询报表详情
- (void)getQueryAccListingDataForAppURL
{
    [LSProgressHUD show];
    self.listDataArray = [[NSMutableArray alloc]init];
    self.listTitleArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{@"accListingId":self.model.tid}.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getQueryAccListingDataForAppURL] SuccessBlock:^(NSDictionary *dic) {
        if (dic[@"respData"][@"dataList"]) {
            NSArray *dataList = dic[@"respData"][@"dataList"];
            for (NSDictionary *dict in dataList) {
                [weakSelf.listDataArray addObject:dict];
            }
        }
        if (dic[@"respData"][@"titleList"]) {
            NSArray *titleList = dic[@"respData"][@"titleList"];
            for (NSDictionary *dict in titleList) {
                ZSCustomReportSettingModel *model = [ZSCustomReportSettingModel yy_modelWithDictionary:dict];
                //列表里面踢掉客户姓名
                if (![model.fieldAlias isEqualToString:@"user_name"]) {
                    model.orderType = 1;//是否排序 1未排序 2升序 3降序 (本地数据)
                    [weakSelf.listTitleArray addObject:model];
                }
            }
        }
        //缺省页
        if (weakSelf.listDataArray.count > 0) {
            weakSelf.errorView.hidden = YES;
            weakSelf.leftTableView.hidden = NO;
            weakSelf.tableView.hidden = NO;
        }else{
            weakSelf.errorView.hidden = NO;
            weakSelf.leftTableView.hidden = YES;
            weakSelf.tableView.hidden = YES;
        }
        //刷新
        [weakSelf reloadData];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark ZSGridTitleViewDelegate 重新排序
- (void)reOrderWithType:(NSString *)upOrDown withModel:(ZSCustomReportSettingModel *)model;
{
    //1. 数据源排序
    // Key: 按照排序的key; ascending: YES为升序, NO为降序。
    BOOL isUp = [upOrDown isEqualToString:@"up"] ? YES : NO;
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:model.fieldAlias ascending:isUp];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortedArray = [self.listDataArray sortedArrayUsingDescriptors:sortDescriptors];
    //从小到大的时候空值放后面, 从大到小空值放前面
    NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:sortedArray];
    NSMutableArray *nullArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in sortedArray) {
        if (!dict[model.fieldAlias])
        {
            [nullArray addObject:dict];//添加到空数组
            [dataArray removeObject:dict];//数据源删除空数据
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"%@",dict[model.fieldAlias]];
            if ([string isEqualToString:@""]) {
                [nullArray addObject:dict];//添加到空数组
                [dataArray removeObject:dict];//数据源删除空数据
            }
        }
    }
    self.listDataArray = [[NSMutableArray alloc]initWithArray:dataArray];
    if (isUp == YES) {
        //再把空值添加到数据源数组最后面
        [self.listDataArray addObjectsFromArray:nullArray];
    }
    else {
        //再把空值插入到数据源数组最前面
        [self.listDataArray insertObjects:nullArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [nullArray count])]];
    }
    
    //2. 更换一下title排序标识
    [self.listTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZSCustomReportSettingModel *newModel = self.listTitleArray[idx];
        if ([newModel.columnNameCn isEqualToString:model.columnNameCn]) {
            [self.listTitleArray replaceObjectAtIndex:idx withObject:model];
        }
        else
        {
            newModel.orderType = 1;//其他列恢复排序标识
            [self.listTitleArray replaceObjectAtIndex:idx withObject:newModel];
        }
    }];
    
    //3. 刷新table
    [self reloadData];
}

- (void)reloadData
{
    [self.leftTableView reloadData];
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate
- (void)configureTable
{
    //默认竖屏
    self.rightWidth = ZSWIDTH-100;
    self.tableHeight = ZSHEIGHT-kNavigationBarHeight;
    
    //左边的table
    self.leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, self.tableHeight) style:UITableViewStylePlain];
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableView.backgroundColor = ZSViewBackgroundColor;
    self.leftTableView.showsVerticalScrollIndicator = NO;
    self.leftTableView.rowHeight = gridHeight;
    [self.view addSubview:self.leftTableView];
    
    //右侧
    self.rightScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(100, 0, self.rightWidth, self.tableHeight)];
    self.rightScroll.delegate = nil;
    [self.view addSubview:self.rightScroll];
    
    //右边的table
    [self configureTableView:CGRectMake(0, 0, self.rightWidth, self.tableHeight) withStyle:UITableViewStylePlain];
    self.tableView.rowHeight = gridHeight;
    [self.rightScroll addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return gridHeight;
}

#pragma mark 区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.leftTableView)
    {
        UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, gridHeight)];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 70, gridHeight)];
        nameLabel.textColor = ZSColorBlack;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:nameLabel];
        //有数据了再渲染
        if (self.listDataArray.count > 0) {
            view.backgroundColor = ZSColorWhite;
            nameLabel.text = @"姓名";
        }
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.rightWidth, gridHeight)];
        //有数据了再渲染
        if (self.listDataArray.count > 0 && self.listTitleArray.count > 0)
        {
            view.backgroundColor = ZSColorWhite;
            for (int i = 0; i < self.listTitleArray.count; i++)
            {
                ZSGridTitleView *gridView = [[ZSGridTitleView alloc]initWithFrame:CGRectMake([self getNewGridWidth]*i, 0, [self getNewGridWidth], gridHeight)];
                gridView.delegate = self;
                [view addSubview:gridView];
                ZSCustomReportSettingModel *model = self.listTitleArray[i];
                //字段赋值
                gridView.nameLabel.text = model.columnNameCn;
                //字段类型
                if (model.fieldType.intValue == 4 || model.fieldType.intValue == 5 || model.fieldType.intValue == 6) {
                    [gridView showRightImage:YES withModel:model];
                }
                else{
                    [gridView showRightImage:NO withModel:model];
                }
            }
            //重设frame
            self.rightScroll.contentSize = CGSizeMake([self getNewGridWidth]*self.listTitleArray.count, 0);
            self.rightScroll.width = self.rightWidth;
            view.width = [self getNewGridWidth]*self.listTitleArray.count;
            self.leftTableView.height = self.tableHeight;
            self.tableView.frame = CGRectMake(0, 0, [self getNewGridWidth]*self.listTitleArray.count, self.tableHeight);
        }
        else if (self.listDataArray.count > 0 && self.listTitleArray.count == 0)
        {
            view.backgroundColor = ZSColorWhite;
        }
        return view;
    }
}

#pragma mark 单元格宽度适配
- (CGFloat)getNewGridWidth
{
    CGFloat newGridWidth = 0;
    if (gridWidth * self.listTitleArray.count < self.rightWidth)
    {
        newGridWidth = self.rightWidth/self.listTitleArray.count;
    }
    else
    {
        newGridWidth = gridWidth;
    }
    return newGridWidth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView)
    {
        ZSCustomReportDetailLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSCustomReportDetailLeftCell"];
        if (cell == nil) {
            cell = [[ZSCustomReportDetailLeftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZSCustomReportDetailLeftCell"];
        }
        if (self.listDataArray.count > 0)
        {
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell : ZSColorWhite;
            cell.indexLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            NSDictionary *dict = self.listDataArray[indexPath.row];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"user_name"]];
        }
        return cell;
    }
    else
    {
        ZSCustomReportDetailRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSCustomReportDetailRightCell"];
        if (cell == nil) {
            cell = [[ZSCustomReportDetailRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZSCustomReportDetailRightCell"];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        //赋值
        if (self.listDataArray.count > 0 && self.listTitleArray.count > 0)
        {
            cell.indxPath = indexPath;
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell : ZSColorWhite;
            [cell setDataWithArray:self.listTitleArray withDic:self.listDataArray[indexPath.row]];
            [cell layoutSubviews];
        }
        else if (self.listDataArray.count > 0 && self.listTitleArray.count == 0)
        {
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? ZSColorCutCell : ZSColorWhite;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView)
    {
        NSDictionary *dict = self.listDataArray[indexPath.row];
        NSString *orderID = [NSString stringWithFormat:@"%@",dict[@"tid"]];//订单id
        NSString *orderState = [NSString stringWithFormat:@"%@",dict[@"o_state"]];//订单状态
        NSString *prdType = self.model.prdType; //产品类型
        //进入订单详情
        if ([orderState isEqualToString:@"暂存"])
        {
            ZSSLPersonListViewController *detailVC = [[ZSSLPersonListViewController alloc]init];
            detailVC.orderState = @"暂存";
            detailVC.orderIDString = orderID;
            detailVC.prdType = prdType;
            [self.navigationController pushViewController:detailVC animated:NO];
        }
        else
        {
            ZSSLPageController *detailVC = [[ZSSLPageController alloc]init];
            detailVC.orderIDString = orderID;
            detailVC.prdType = prdType;
            [self.navigationController pushViewController:detailVC animated:NO];
        }
        //改变cell背景色
        [self changeColor2:indexPath];
    }
}

#pragma mark 改变cell背景色
- (void)changeColor:(NSNotification *)info
{
    NSIndexPath *indexPath = info.userInfo[@"index"];
    [self changeColor2:indexPath];
}

//改变cell背景色
- (void)changeColor2:(NSIndexPath *)indexPath
{
    for (int i = 0; i<self.listDataArray.count; i++)
    {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ZSCustomReportDetailLeftCell *leftCell = (ZSCustomReportDetailLeftCell *)[self.leftTableView cellForRowAtIndexPath:newIndexPath];
         ZSCustomReportDetailRightCell *rightCell = (ZSCustomReportDetailRightCell *)[self.tableView cellForRowAtIndexPath:newIndexPath];
        if (newIndexPath == indexPath)
        {
            leftCell.contentView.backgroundColor = ZSColor(181, 181, 181);
            rightCell.contentView.backgroundColor = ZSColor(181, 181, 181);
        }
        else
        {
            leftCell.contentView.backgroundColor = ZSColorWhite;
            rightCell.contentView.backgroundColor = ZSColorWhite;
        }
    }
}

#pragma mark tableView联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.leftTableView)
    {
        [self.tableView setContentOffset:scrollView.contentOffset];
    }
    else
    {
        [self.leftTableView setContentOffset:scrollView.contentOffset];
    }
}

- (void)tableView:(UITableView *)tableView scrollFollowTheOther:(UITableView *)other
{
    CGFloat offsetY = other.contentOffset.y;
    CGPoint offset = tableView.contentOffset;
    offset.y = offsetY;
    tableView.contentOffset = offset;
}

#pragma mark 横竖屏切换
- (void)begainFullScreen
{
    APPDELEGATE.allowRotation = YES;
}

- (void)endFullScreen
{
    APPDELEGATE.allowRotation = NO;
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    // 通过状态栏电池图标来判断屏幕方向
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationMaskPortrait)
    {
        self.rightWidth = ZSWIDTH-100;
        self.tableHeight = ZSHEIGHT-kNavigationBarHeight;
    }
    else
    {
        self.rightWidth = ZSHEIGHT-100;
        self.tableHeight = ZSWIDTH-44;
    }
    [self.tableView reloadData];
}

#pragma mark 移除通知
- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}
                
@end
