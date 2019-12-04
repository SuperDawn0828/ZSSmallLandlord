//
//  ZSCustomReportListViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/27.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSCustomReportListViewController.h"
#import "ZSCustomReportListCell.h"
#import "ZSCustomReportDetailViewController.h"
#import "ZSCustomReportSettingViewController.h"
#import "ZSCustomReportEditViewController.h"
#import "ZSCustomReportListPopView.h"

@interface ZSCustomReportListViewController ()<ZSCustomReportListPopViewDelegate,ZSAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray          *arrayData;
@property(nonatomic,strong)ZSCustomReportListModel *needDeleteModel;
@property(nonatomic,assign)BOOL                    isDelete;//是否可以删除
@end

@implementation ZSCustomReportListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
    //导航栏标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:ZSColorBlack}];
    //导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[ZSTool createImageWithColor:ZSColor(249, 249, 249)] forBarPosition:UIBarPositionAny  barMetrics:UIBarMetricsDefault];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"选择报表";
    [self setLeftBarButtonItem];
    self.imgView_left.image = [UIImage imageNamed:@"tool_guanbi_n"];
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight-60) withStyle:UITableViewStylePlain];
    [self configuBottomButtonWithTitle:@"+ 添加报表"];//底部按钮
    [self configureRightNavItemWithTitle:@"管理" withNormalImg:nil withHilightedImg:nil];//右侧按钮
    [self.rightBtn setTitleColor:ZSColorRed forState:UIControlStateNormal];
    //Data
    [self getQueryAccListingsURL:1];//右侧按钮显隐 1隐藏 2显示编辑按钮
    [self configureErrorViewWithStyle:ZSErrorWithoutCustomReport];//无数据
    self.isDelete = NO;
}

#pragma mark 获取报表排列表
- (void)getQueryAccListingsURL:(NSInteger)rightBtnType//右侧按钮显隐 1隐藏 2显示编辑按钮 3显示排序按钮
{
    [LSProgressHUD show];
    self.arrayData = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getQueryAccListingsURL] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSCustomReportListModel *model = [ZSCustomReportListModel yy_modelWithDictionary:dict];
                model.editingType = rightBtnType;
                [weakSelf.arrayData addObject:model];
            }
        }
        //缺省页
        if (weakSelf.arrayData.count > 0 ) {
            weakSelf.errorView.hidden = YES;
            weakSelf.rightBtn.hidden = NO;
        }else{
            weakSelf.errorView.hidden = NO;
            weakSelf.rightBtn.hidden = YES;
        }
        [weakSelf.tableView reloadData];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark ZSCustomReportListPopViewDelegate + 添加报表
- (void)addReportModel:(ZSCustomReportListModel *)model
{
    [LSProgressHUD show];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"prdType":model.prdType,
                                  @"name":model.name,
                                  @"timeFrame":model.timeFrame,
                                  @"remark":model.remark
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getAddAccListingURL] SuccessBlock:^(NSDictionary *dic) {
        //刷新列表
        [weakSelf getQueryAccListingsURL:1];
        //跳转到设置报表页面
        [weakSelf gotoSettingVC:[ZSCustomReportListModel yy_modelWithDictionary:dic[@"respData"]]];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

- (void)gotoSettingVC:(ZSCustomReportListModel *)model
{
    ZSCustomReportSettingViewController *settingVC = [[ZSCustomReportSettingViewController alloc]init];
    settingVC.model = model;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSCustomReportListCell *cell = (ZSCustomReportListCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.explainLabel.bottom + 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSCustomReportListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    if (cell == nil) {
        cell = [[ZSCustomReportListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
    }
    if (self.arrayData.count > 0) {
        ZSCustomReportListModel *model = self.arrayData[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //报表详情
    ZSCustomReportDetailViewController *detailVC = [[ZSCustomReportDetailViewController alloc]init];
    detailVC.model = self.arrayData[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 管理报表
- (void)RightBtnAction:(UIButton*)sender
{
    __weak typeof(self) weakSelf = self;
    ZSCustomReportEditViewController *editVC = [[ZSCustomReportEditViewController alloc]init];
    editVC.arrayData = [[NSMutableArray alloc]initWithArray:self.arrayData];
    editVC.returnValueBlock = ^(NSArray *dataArray) {
        weakSelf.arrayData = [[NSMutableArray alloc]initWithArray:dataArray];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark 添加报表
- (void)bottomClick:(UIButton *)sender
{
    ZSCustomReportListPopView *popView = [[ZSCustomReportListPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withType:@"+ 添加报表"];
    popView.delegate = self;
    [popView show];
}

@end
