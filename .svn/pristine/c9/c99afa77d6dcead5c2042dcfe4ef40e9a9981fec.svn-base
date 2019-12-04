//
//  ZSSLCustomerSourceViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLCustomerSourceViewController.h"
#import "ZSSLMediumMessageViewController.h"
#import "ZSBaseAddCustomerViewController.h"
#import "ZSBaseTableViewCell.h"

@interface ZSSLCustomerSourceViewController ()

@end

@implementation ZSSLCustomerSourceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势(自定义返回按钮会导致手势失效)
    [self openInteractivePopGestureRecognizerEnable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"客户来源";
    [self setLeftBarButtonItem];//返回按钮
    self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, self.view.height+10);
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        cell.bottomLineStyle = CellLineStyleSpacing;//设置cell上分割线的风格
        //left img
        UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
        leftImage.tag = 0;
        [cell addSubview:leftImage];
        //title
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(70,0,250,70)];
        label.tag = 1;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = ZSColorListLeft;
        [cell addSubview:label];
        //push img
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-30, (70-15)/2, 15, 15)];
        imgview.image = [UIImage imageNamed:@"list_arrow_n"];
        [cell addSubview:imgview];
        
    }
    NSArray *array_img = @[@"bar_mediation_s",@"bar_offline_customer_s"];
    NSArray *array_str = @[@"中介推荐",@"线下客户"];
    UIImageView *leftImage = (UIImageView *)[cell viewWithTag:0];
    leftImage.image = [UIImage imageNamed:array_img[indexPath.row]];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = array_str[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0)
    {
        ZSSLMediumMessageViewController *mediumVC = [[ZSSLMediumMessageViewController alloc]init];
        mediumVC.prdType = self.prdType;
        [self.navigationController pushViewController:mediumVC animated:YES];
    }
    else
    {
        //清空人员信息
        global.bizCustomers = nil;
        ZSBaseAddCustomerViewController *addVC = [[ZSBaseAddCustomerViewController alloc]init];
        addVC.isFromAdd = YES;
        addVC.title = @"贷款人信息";
        addVC.prdType = self.prdType;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
