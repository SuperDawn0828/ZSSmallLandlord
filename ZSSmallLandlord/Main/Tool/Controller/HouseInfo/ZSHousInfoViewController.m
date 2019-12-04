//
//  ZSHousInfoViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/6/4.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSHousInfoViewController.h"
#import "ZSHomeAuditCell.h"
#import "ZSHousInfoDetailViewController.h"

@interface ZSHousInfoViewController ()
@property (nonatomic,strong)NSMutableArray   *arrayData;
@property (nonatomic,assign)int              currentPage;     //当前页
@end

@implementation ZSHousInfoViewController

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
    [self setLeftBarButtonItem];
    self.imgView_left.image = [UIImage imageNamed:@"tool_guanbi_n"];
    [self configureTable];
    [self configureErrorViewWithStyle:ZSErrorWithoutrecords];//无数据
    //Data
    [self addHeader];
    [self addFooter];
}

- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        weakSelf.arrayData = [[NSMutableArray alloc]init];
        [weakSelf requestNewsData];//列表
    }];
    [weakSelf.tableView.mj_header beginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf requestNewsData];
    }];
    footer.automaticallyHidden = YES;
    weakSelf.tableView.mj_footer = footer;
}

- (void)requestNewsData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                  @"pageSize":[NSNumber numberWithInt:10],
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getNewsDataURL] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            ZSHomeAuditModel *model = [ZSHomeAuditModel yy_modelWithJSON:dict];
            [weakSelf.arrayData addObject:model];
        }
        if (array.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }
        if (weakSelf.arrayData.count > 0) {
            weakSelf.errorView.hidden = YES;
        }else{
            weakSelf.errorView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
        [weakSelf requestFail:weakSelf.tableView array:weakSelf.arrayData];
    }];
}

#pragma mark UITableViewDelegate
- (void)configureTable
{
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-49) withStyle:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:KZSHomeAuditCell bundle:nil] forCellReuseIdentifier:KZSHomeAuditCell];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSHomeAuditCell *cell = [tableView dequeueReusableCellWithIdentifier:KZSHomeAuditCell];
    if (self.arrayData.count > 0) {
        ZSHomeAuditModel *model= self.arrayData[indexPath.row];
        if (model) {
            cell.model = model;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZSHousInfoDetailViewController *auditVC = [[ZSHousInfoDetailViewController alloc]init];
    if (self.arrayData.count > 0) {
        ZSHomeAuditModel *model= self.arrayData[indexPath.row];
        auditVC.model = model;
    }
    [self.navigationController pushViewController:auditVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
