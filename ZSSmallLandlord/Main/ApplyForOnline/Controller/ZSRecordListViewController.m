//
//  ZSRecordListViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSRecordListViewController.h"
#import "ZSRecordListCell.h"

@interface ZSRecordListViewController ()
@property (nonatomic,strong)NSMutableArray   *arrayData;
@property (nonatomic,assign)int              currentPage;     //当前页
@end

@implementation ZSRecordListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, ZSHEIGHT);//重设tableview的frame
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"跟进记录列表";
    [self setLeftBarButtonItem];//返回按钮
    //Data
    [self addHeader];
    [self addFooter];
}

- (void)reloadCell
{
    self.currentPage = 0;
    self.arrayData  = [[NSMutableArray alloc]init];
    [self getRecordList];//列表
}

- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        weakSelf.arrayData  = [[NSMutableArray alloc]init];
        [weakSelf getRecordList];//列表
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf getRecordList];
    }];
    footer.automaticallyHidden = YES;
    self.tableView.mj_footer = footer;
}

#pragma mark 跟进记录列表
- (void)getRecordList
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                           @"pageSize":[NSNumber numberWithInt:10],
                                           @"applyId":self.onlineOrderIDString}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getRecordListURL] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            ZSAORecordListModel *model = [ZSAORecordListModel yy_modelWithJSON:dict];
            [weakSelf.arrayData addObject:model];
        }
        if (array.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }
        [weakSelf.tableView reloadData];
        //手动改一下tableview的偏移量
        if (weakSelf.currentPage > 0) {
            [weakSelf.tableView setContentOffset:CGPointMake(0, weakSelf.tableView.contentOffset.y+40) animated:YES];
        }
    } ErrorBlock:^(NSError *error) {
        [weakSelf requestFail:weakSelf.tableView array:weakSelf.arrayData];
    }];
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSAORecordListModel *model = self.arrayData[indexPath.row];
    CGFloat height = [ZSTool getStringHeight:model.followContent withframe:CGSizeMake(ZSWIDTH-38.5-15, 100000) withSizeFont:[UIFont systemFontOfSize:14] winthLineSpacing:7] + 43 + 10;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSRecordListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    //赋值
    if (self.arrayData.count > 0)
    {
        ZSAORecordListModel *model = self.arrayData[indexPath.row];
        cell.model = model;
        if (indexPath.row == self.arrayData.count - 1) {
            cell.bottomLine.hidden = YES;
        }
        if (indexPath.row == 0) {
            cell.imgview_left.frame = CGRectMake(15.5, 16.5, 13, 13);
            cell.imgview_left.image = [UIImage imageNamed:@"list_select_s"];
            cell.imgview_left.backgroundColor = [UIColor clearColor];
        }else{
            cell.imgview_left.frame = CGRectMake(18.5, 20, 6.5, 6.5);
            cell.imgview_left.image = nil;
            cell.imgview_left.backgroundColor = UIColorFromRGB(0xCCCCCC);
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
