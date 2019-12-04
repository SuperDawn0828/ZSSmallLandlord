//
//  ZSCustomReportSettingViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/28.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSCustomReportSettingViewController.h"
#import "ZSCustomReportSettingCell.h"

@interface ZSCustomReportSettingViewController ()<ZSCustomReportSettingCellDelegate>
@property(nonatomic,strong)UIView         *footerView;
@property(nonatomic,strong)UITableView    *footerTableView;
@property(nonatomic,strong)NSMutableArray *selectedArray;
@property(nonatomic,strong)NSMutableArray *unSelectedArray;
@end

@implementation ZSCustomReportSettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[ZSTool createImageWithColor:ZSColor(249, 249, 249)] forBarPosition:UIBarPositionAny  barMetrics:UIBarMetricsDefault];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavBar];
    //Data
    [self getQueryAccListingColsURL];
}

#pragma mark 查询报表字段
- (void)getQueryAccListingColsURL
{
    [LSProgressHUD show];
    self.selectedArray = [[NSMutableArray alloc]init];
    self.unSelectedArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{@"accListingId":self.model.tid}.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getQueryAccListingColsURL] SuccessBlock:^(NSDictionary *dic) {
        if (dic[@"respData"][@"selected"]) {
            NSArray *select = dic[@"respData"][@"selected"];
            for (NSDictionary *dict in select) {
                ZSCustomReportSettingModel *model = [ZSCustomReportSettingModel yy_modelWithDictionary:dict];
                model.selectedType = 1;
                [weakSelf.selectedArray addObject:model];
            }
        }
        if (dic[@"respData"][@"unselected"]) {
            NSArray *unselect = dic[@"respData"][@"unselected"];
            for (NSDictionary *dict in unselect) {
                ZSCustomReportSettingModel *model = [ZSCustomReportSettingModel yy_modelWithDictionary:dict];
                model.selectedType = 2;
                [weakSelf.unSelectedArray addObject:model];
            }
        }
        [weakSelf reladTableView];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 设置报表字段
- (void)getUpdateAccListingColsURL
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    for (ZSCustomReportSettingModel *model in self.selectedArray)
    {
        NSDictionary *dataDic = @{@"tid":model.tid};
        [dataArr addObject:dataDic];
    }
    NSString *listInfo = [NSString arrayToJsonString:dataArr];
    NSMutableDictionary *dict = @{
                                  @"accListingId":self.model.tid,
                                  @"selectedCols":listInfo
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getUpdateAccListingColsURL] SuccessBlock:^(NSDictionary *dic) {
        //返回上级页面
        [weakSelf leftAction];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 自定义导航栏
- (void)configureNavBar
{
    //导航栏
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, kStatusBarHeight+100)];
    navView.backgroundColor = ZSColor(249, 249, 249);
    [self.view addSubview:navView];
    
    //取消按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, kStatusBarHeight, 44, 44);
    [leftButton setTitleColor:ZSColorBlack forState:UIControlStateNormal];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftButton];
    
    //保存按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(ZSWIDTH-44, kStatusBarHeight, 44, 44);
    [saveButton setTitleColor:ZSColorRed forState:UIControlStateNormal];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [saveButton addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:saveButton];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, kStatusBarHeight, ZSWIDTH-88, 44)];
    titleLabel.textColor = ZSColorBlack;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"报表设置";
    [navView addSubview:titleLabel];
    
    //提示
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, titleLabel.bottom, ZSWIDTH-60, 44)];
    noticeLabel.textColor = ZSColorBlack;
    noticeLabel.font = [UIFont systemFontOfSize:14];
    noticeLabel.numberOfLines = 0;
    noticeLabel.text = @"选择你想要的字段生成自定义报表，拖动右侧可排列改变展示顺序喔～";
    [navView addSubview:noticeLabel];
    
    //table
    [self configureTableView:CGRectMake(0, navView.bottom, ZSWIDTH, ZSHEIGHT-navView.height) withStyle:UITableViewStyleGrouped];
    //设置tableview编辑状态
    [self.tableView setEditing:YES animated:YES];
    
    //footerView
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight)];
    self.footerView.backgroundColor = ZSColorWhite;
    self.tableView.tableFooterView = self.footerView;
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight)];
    view.backgroundColor = ZSViewBackgroundColor;
    [self.footerView addSubview:view];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(GapWidth, 10, ZSWIDTH-GapWidth, 30)];
    nameLabel.textColor = ZSColorAllNotice;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = @"更多字段";
    [view addSubview:nameLabel];
    //table
    self.footerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CellHeight, ZSWIDTH, 0) style:UITableViewStylePlain];
    self.footerTableView.dataSource = self;
    self.footerTableView.delegate = self;
    self.footerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.footerTableView.scrollEnabled = NO;//不允许滑动
    self.footerTableView.showsVerticalScrollIndicator = NO;
    [self.footerView addSubview:self.footerTableView];
}

- (void)reladTableView
{
    self.footerView.height = self.unSelectedArray.count * CellHeight + CellHeight;
    self.footerTableView.height = self.unSelectedArray.count * CellHeight;
    [self.tableView reloadData];
    [self.footerTableView reloadData];
}

#pragma mark 取消
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 保存
- (void)saveBtnAction
{
    [self getUpdateAccListingColsURL];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.selectedArray.count;
    }
    else
    {
        return self.unSelectedArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return CellHeight;
    }
    else
    {
        return 0.1;
    }
}

#pragma mark 区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight)];
        view.backgroundColor = ZSViewBackgroundColor;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(GapWidth, 10, ZSWIDTH-GapWidth, 30)];
        nameLabel.textColor = ZSColorAllNotice;
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.text = @"已选字段";
        [view addSubview:nameLabel];
        return view;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSCustomReportSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    if (cell == nil) {
        cell = [[ZSCustomReportSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
        cell.delegate = self;
    }
    if (tableView == self.tableView)
    {
        if (self.selectedArray.count > 0) {
            ZSCustomReportSettingModel *model = self.selectedArray[indexPath.row];
            cell.model = model;
        }
    }
    else
    {
        if (self.unSelectedArray.count > 0) {
            ZSCustomReportSettingModel *model = self.unSelectedArray[indexPath.row];
            cell.model = model;
        }
    }
    return cell;
}

#pragma mark ZSCustomReportSettingCellDelegate 添加/删除
- (void)selectCell:(ZSCustomReportSettingModel *)model;
{
    if (model.selectedType == 1)
    {
        [self.selectedArray removeObject:model];
        model.selectedType = 2;
        [self.unSelectedArray insertObject:model atIndex:0];
    }
    else if (model.selectedType == 2)
    {
        [self.unSelectedArray removeObject:model];
        model.selectedType = 1;
        [self.selectedArray addObject:model];
    }
    //刷新tableView
    [self reladTableView];
}

#pragma mark 排序
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //取出要拖动的模型数据
    ZSCustomReportSettingModel *model = self.selectedArray[sourceIndexPath.row];
    //删除之前行的数据
    [self.selectedArray removeObject:model];
    //插入数据到新的位置
    [self.selectedArray insertObject:model atIndex:destinationIndexPath.row];
    //刷新tableView
    [self reladTableView];
}

@end
