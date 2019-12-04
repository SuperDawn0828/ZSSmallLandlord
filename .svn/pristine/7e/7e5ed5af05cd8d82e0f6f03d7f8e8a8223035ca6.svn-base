//
//  ZSMaterialCollectRecordViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/22.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSMaterialCollectRecordViewController.h"
#import "ZSMaterialCollectRecordCell.h"

@interface ZSMaterialCollectRecordViewController ()
@property (nonatomic,strong)NSMutableArray  *arrayData;
@property (nonatomic,assign)int             currentPage;//当前页
@end

@implementation ZSMaterialCollectRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资料收集记录";
    [self setLeftBarButtonItem];//返回按钮
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-64) withStyle:UITableViewStylePlain];
    //Data
    [self addHeader];
    [self addFooter];
    [self configureErrorViewWithStyle:ZSErrorWithoutrecords];
}

#pragma mark 数据请求
- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        weakSelf.arrayData  = [[NSMutableArray alloc]init];
        [weakSelf requestData];
    }];
    [weakSelf.tableView.mj_header beginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf requestData];
    }];
    footer.automaticallyHidden = YES;
    weakSelf.tableView.mj_footer = footer;
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{
                                           @"orderNo":global.wsOrderDetail.projectInfo.tid,
                                           @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                           @"pageSize":[NSNumber numberWithInt:10],
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getUploadCollectRecoredListUrl] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefresh:weakSelf.tableView array:weakSelf.arrayData];
        NSArray *array = dic[@"respData"][@"content"];
        for (NSDictionary *dict in array) {
            ZSMaterialCollectRecordModel *model = [ZSMaterialCollectRecordModel yy_modelWithJSON:dict];
            [weakSelf.arrayData addObject:model];
        }
        if (array.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }
        if (weakSelf.arrayData.count > 0 ) {
            weakSelf.errorView.hidden = YES;
        }else{
            weakSelf.errorView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
        [weakSelf requestFail:weakSelf.tableView array:weakSelf.arrayData];
    }];
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSMaterialCollectRecordModel *model = self.arrayData[indexPath.row];
    NSString *contentSting = [NSString stringWithFormat:@"%@已收集",model.docNames];
    CGFloat height = [ZSTool getStringHeight:contentSting withframe:CGSizeMake(ZSWIDTH-38.5-15, 100000) withSizeFont:[UIFont systemFontOfSize:14] winthLineSpacing:7] + 43 + 10;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSMaterialCollectRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSMaterialCollectRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    //赋值
    if (self.arrayData.count > 0)
    {
        ZSMaterialCollectRecordModel *model = self.arrayData[indexPath.row];
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
