//
//  ZSCustomReportEditViewController.m
//  ZSSmallLandlord
//
//  Created by 邵菡怡 on 2018/12/5.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSCustomReportEditViewController.h"
#import "ZSCustomReportSettingViewController.h"
#import "ZSCustomReportListCell.h"
#import "ZSCustomReportListPopView.h"

@interface ZSCustomReportEditViewController ()<ZSCustomReportListPopViewDelegate,ZSAlertViewDelegate>
@property(nonatomic,strong)ZSCustomReportListModel *needDeleteModel;
@property(nonatomic,assign)BOOL                    isSorting;
@end

@implementation ZSCustomReportEditViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //禁止返回手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
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
    self.title = @"报表管理";
    [self setLeftBarButtonItem];
    self.leftBtn.userInteractionEnabled = YES;
    self.imgView_left = nil;
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight-60) withStyle:UITableViewStylePlain];
    [self.tableView setEditing:YES animated:YES];//设置tableview编辑状态
    self.tableView.allowsSelectionDuringEditing = YES;//在编辑模式下也可以调用点击方法
    [self configuBottomButtonWithTitle:@"+ 添加报表"];//底部按钮
    [self configureRightNavItemWithTitle:@"完成" withNormalImg:nil withHilightedImg:nil];//右侧按钮
    [self.rightBtn setTitleColor:ZSColorRed forState:UIControlStateNormal];
    //Data
    [self refreshArrayData:2];
    self.isSorting = NO;
}

#pragma mark 更改数据源,用于刷新列表
- (void)refreshArrayData:(NSInteger)editingType
{
    NSArray *newArray = self.arrayData;
    [newArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZSCustomReportListModel *model = newArray[idx];
        model.editingType = editingType;
        [self.arrayData replaceObjectAtIndex:idx withObject:model];
    }];
    [self.tableView reloadData];
}

#pragma mark 获取报表排列表
- (void)getQueryAccListingsURL:(NSInteger)editingType
{
    [LSProgressHUD show];
    self.arrayData = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getQueryAccListingsURL] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSCustomReportListModel *model = [ZSCustomReportListModel yy_modelWithDictionary:dict];
                model.editingType = editingType;
                [weakSelf.arrayData addObject:model];
            }
        }
        //刷新
        [weakSelf.tableView reloadData];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 报表重新排序
- (void)refreshReportList
{
    [LSProgressHUD show];
    __weak typeof(self) weakSelf = self;
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    for (ZSCustomReportListModel *model in self.arrayData)
    {
        NSDictionary *dataDic = @{@"tid":model.tid};
        [dataArr addObject:dataDic];
    }
    NSString *listInfo = [NSString arrayToJsonString:dataArr];
    NSMutableDictionary *dict = @{@"accListings":listInfo}.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getUpdateAccListingSequenceURL] SuccessBlock:^(NSDictionary *dic) {
        //返回
        if (weakSelf.returnValueBlock) {
            [weakSelf refreshArrayData:1];
            weakSelf.returnValueBlock(weakSelf.arrayData);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 删除报表
- (void)deleteReport:(ZSCustomReportListModel *)model
{
    [LSProgressHUD show];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{@"accListingId":model.tid}.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getDeleteAccListingURL] SuccessBlock:^(NSDictionary *dic) {
        //刷新列表(不请求接口)
        [weakSelf.arrayData removeObject:model];
        [weakSelf.tableView reloadData];
        //缺省页
        if (weakSelf.arrayData.count > 0 ) {
            weakSelf.errorView.hidden = YES;
            weakSelf.rightBtn.hidden = NO;
        }else{
            weakSelf.errorView.hidden = NO;
            weakSelf.rightBtn.hidden = YES;
        }
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
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
    ZSCustomReportListPopView *popView = [[ZSCustomReportListPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withType:@"+ 添加报表"];
    popView.delegate = self;
    [popView show];
    //数据
    [popView initData:self.arrayData[indexPath.row]];
}

#pragma mark ZSCustomReportListPopViewDelegate + 添加报表/编辑报表
- (void)addReportModel:(ZSCustomReportListModel *)model
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"prdType":model.prdType,
                                  @"name":model.name,
                                  @"timeFrame":model.timeFrame,
                                  @"remark":model.remark
                                  }.mutableCopy;
    //编辑报表
    if (model.tid)
    {
        [LSProgressHUD show];
        [dict setObject:model.tid forKey:@"accListingId"];
        [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getUpdateAccListingURL] SuccessBlock:^(NSDictionary *dic) {
            //刷新列表
            [weakSelf getQueryAccListingsURL:2];
            //跳转到设置报表页面
            [weakSelf gotoSettingVC:model];
            [LSProgressHUD hide];
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hide];
        }];
    }
    //+ 添加报表
    else
    {
        [LSProgressHUD show];
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
}

- (void)gotoSettingVC:(ZSCustomReportListModel *)model;
{
    ZSCustomReportSettingViewController *settingVC = [[ZSCustomReportSettingViewController alloc]init];
    settingVC.model = model;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark 报表排序
//当移动了某一行时候会调用
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //取出要拖动的模型数据
    ZSCustomReportListModel *model = self.arrayData[sourceIndexPath.row];
    //删除之前行的数据
    [self.arrayData removeObject:model];
    //插入数据到新的位置
    [self.arrayData insertObject:model atIndex:destinationIndexPath.row];
    //给个标记
    self.isSorting = YES;
}

#pragma mark 删除报表
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //在此处自定义删除行为
    ZSCustomReportListModel *model = self.arrayData[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"是否确认删除%@，删除后无法恢复需要重新设置！",model.name];
    ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:string];
    alert.delegate = self;
    [alert show];
    self.needDeleteModel = model;
}

- (void)AlertView:(ZSAlertView *)alert;
{
    [self deleteReport:self.needDeleteModel];
}

#pragma mark 完成设置
- (void)RightBtnAction:(UIButton*)sender
{
    if (self.isSorting == YES)
    {
        [self refreshReportList];
    }
    else
    {
        if (self.returnValueBlock) {
            [self refreshArrayData:1];
            self.returnValueBlock(self.arrayData);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 添加报表
- (void)bottomClick:(UIButton *)sender
{
    ZSCustomReportListPopView *popView = [[ZSCustomReportListPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withType:@"+ 添加报表"];
    popView.delegate = self;
    [popView show];
}

@end
