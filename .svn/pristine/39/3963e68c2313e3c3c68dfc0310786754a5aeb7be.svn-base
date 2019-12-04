
//
//  ZSMonthlyPaymentsPopView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/13.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSMonthlyPaymentsPopView.h"

@interface ZSMonthlyPaymentsPopView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy  )NSString     *totalMoney;
@property (nonatomic,strong)NSArray<repayDetails *> *moneyArray;
@end

@implementation ZSMonthlyPaymentsPopView

- (id)initWithFrame:(CGRect)frame withModel:(ZSMonthlyPaymentsModel *)model;
{
    if (self = [super initWithFrame:frame])
    {
        //UI
        [self configureViews];
        [self creatBaseUI];
        //Data
        self.totalMoney = model.totalRepay;
        self.moneyArray = model.repayDetails;
        [self.tableView reloadData];
    }
    return self;
}

#pragma mark /*------------------------------------------------黑底白底----------------------------------------------------*/
- (void)creatBaseUI
{
    //月供计算
    self.titleLabel.text = @"月供计算";
    
    //table
    [self configureTableView:CGRectMake(0, self.titleLabel.bottom, ZSWIDTH, self.whiteBackgroundView.height-54) withStyle:UITableViewStylePlain];
}

#pragma mark /*------------------------------------------tableview------------------------------------------*/
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight)];
    view.backgroundColor = ZSColorWhite;
   
    UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 0, 60, CellHeight)];
    chooseLabel.font = [UIFont systemFontOfSize:14];
    chooseLabel.textColor = ZSColorBlack;
    chooseLabel.text = @"本息合计";
    [view addSubview:chooseLabel];
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake((ZSWIDTH-200)/2, 0, 200, CellHeight)];
    totalLabel.font = [UIFont systemFontOfSize:14];
    totalLabel.textColor = ZSColorRed;
    totalLabel.textAlignment = NSTextAlignmentCenter;
    if (self.totalMoney) {
        totalLabel.text = [NSString stringWithFormat:@"%@元",self.totalMoney];
    }
    [view addSubview:totalLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return CellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moneyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSMonthlyPaymentsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"area_cell"];
    if (!cell) {
        cell = [[ZSMonthlyPaymentsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"area_cell"];
    }
    if (self.moneyArray.count > 0)
    {
        cell.model = self.moneyArray[indexPath.row];
    }
    return cell;
}

@end
