//
//  ZSBaseTableViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBaseTableViewController.h"

@interface ZSBaseTableViewController ()

@end

@implementation ZSBaseTableViewController

@synthesize tableView = _tableView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _style = UITableViewStylePlain;
    }
    return (self);
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [self init]) {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (UITableView *)tableView
{
    if(_tableView == nil) {
        UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:self.style];
        [self addChildViewController:tableViewController];
        _tableView = tableViewController.tableView;
        _tableView.frame = self.view.frame;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ZSViewBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentSize = CGSizeMake(ZSWIDTH, ZSHEIGHT);
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
        if (@available(iOS 11.0, *)) {
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

#pragma mark - datasource
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

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

@end
