//
//  ZSStarLoanPageController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/27.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSStarLoanPageController.h"
#import "ZSStarLoanOrderListViewController.h"
#import "ZSBaseSearchViewController.h"
#import "ZSSLCustomerSourceViewController.h"

@interface ZSStarLoanPageController ()

@end

@implementation ZSStarLoanPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = [ZSGlobalModel getProductStateWithCode:self.prdType];
    [self configureRightNavItemWithTitleArray:nil withNormalImgArray:@[@"head_search_n",@"head_add_n"] withHilightedImg:nil];//右侧按钮
    //Data
    [self loadData];
}

#pragma mark 初始化title(子类需要重写)
- (NSArray *)setupViewTitle
{
    return @[@"未完成订单",@"已完成订单",@"已关闭订单"].copy;
}

#pragma mark 初始化的控制器(子类需要重写)
- (NSArray *)setupViewControllers
{
    NSMutableArray *testVCS = [NSMutableArray arrayWithCapacity:0];
    
    ZSStarLoanOrderListViewController *listVC1 = [[ZSStarLoanOrderListViewController alloc] init];
    listVC1.Orderstate = @"1";
    listVC1.prdType = self.prdType;
    [testVCS addObject:listVC1];
    
    ZSStarLoanOrderListViewController *listVC2 = [[ZSStarLoanOrderListViewController alloc] init];
    listVC2.Orderstate = @"2";
    listVC2.prdType = self.prdType;
    [testVCS addObject:listVC2];
    
    ZSStarLoanOrderListViewController *listVC3 = [[ZSStarLoanOrderListViewController alloc] init];
    listVC3.Orderstate = @"3";
    listVC3.prdType = self.prdType;
    [testVCS addObject:listVC3];
    
    return testVCS.copy;
}

#pragma mark 右侧按钮--搜索--添加
- (void)RightBtnAction:(UIButton *)sender
{
    //移除弹窗
    [NOTI_CENTER postNotificationName:@"removeSelectView" object:nil];
    
    if (sender.tag == 0) {
        ZSBaseSearchViewController *searchVC = [[ZSBaseSearchViewController alloc]init];
        searchVC.prdType = self.prdType;
        //星速贷
        if ([self.prdType isEqualToString:kProduceTypeStarLoan])
        {
            searchVC.filePathString = KStarLoanSearch;
        }
        //赎楼宝
        else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
        {
            searchVC.filePathString = KRedeemFloorSearch;
        }
        //抵押贷
        else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
        {
            searchVC.filePathString = KMortgageLoanSearch;
        }
        //融易贷
        else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
        {
            searchVC.filePathString = KEasyLoanSearch;
        }
        //车位分期
        else if ([self.prdType isEqualToString:kProduceTypeCarHire])
        {
            searchVC.filePathString = KCarHireSearch;
        }
        //代办业务
        else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
        {
            searchVC.filePathString = KAgencyBusinessSearch;
        }
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    else
    {
        //创建订单之前检查该产品是否被禁用
        __weak typeof(self) weakSelf  = self;
        NSMutableDictionary *parameterDict = @{
                                               @"prdType":self.prdType}.mutableCopy;
        [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getCheckProductState] SuccessBlock:^(NSDictionary *dic) {
            if ([dic[@"respData"] intValue] == 1) {
                //清空人员信息model
                global.bizCustomers = nil;
                //跳到客户来源页面
                ZSSLCustomerSourceViewController *addVC = [[ZSSLCustomerSourceViewController alloc]init];
                addVC.prdType = weakSelf.prdType;
                [weakSelf.navigationController pushViewController:addVC animated:YES];
            }else{
                [ZSTool showMessage:@"暂不支持新增订单，请稍后!" withDuration:DefaultDuration];
            }
        } ErrorBlock:^(NSError *error) {
        }];
    }
}

#pragma mark 获取列表数据权限
//1贷款人订单 2所在部门 3所在层级 4所有订单
- (void)loadData
{
    __weak typeof(self) weakSelf  = self;
    NSMutableDictionary *parameterDict = @{
                                           @"prdType":self.prdType
                                           }.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getAllOrderListDataPermission] SuccessBlock:^(NSDictionary *dic) {
        NSString *string = dic[@"respData"];
        //产品名
        NSString *productName = [ZSGlobalModel getProductStateWithCode:self.prdType];
      
        //数据权限
        if (string.intValue == 1)
        {
            weakSelf.titleLabel.text = productName;
        }
        else
        {
            //创建view
            if ([productName isEqualToString:@"星速贷"] ||
                [productName isEqualToString:@"赎楼宝"] ||
                [productName isEqualToString:@"抵押贷"] ||
                [productName isEqualToString:@"融易贷"])
            {
                [weakSelf initTitleView:90];
            }else{
                [weakSelf initTitleView:110];
            }
            
            //部门权限
            if (string.intValue == 2)
            {
                weakSelf.titleArray = @[@"我创建的订单",@"所在部门订单"];
                weakSelf.titleLabel.text = [NSString stringWithFormat:@"%@-我的",productName];
                weakSelf.titleArrayShow = @[[NSString stringWithFormat:@"%@-我的",productName],[NSString stringWithFormat:@"%@-部门",productName]];
            }
            //层级权限
            else if (string.intValue == 3)
            {
                weakSelf.titleArray = @[@"我创建的订单",@"所在层级订单"];
                weakSelf.titleLabel.text = [NSString stringWithFormat:@"%@-我的",productName];
                weakSelf.titleArrayShow = @[[NSString stringWithFormat:@"%@-我的",productName],[NSString stringWithFormat:@"%@-层级",productName]];
            }
            //全部权限
            else if (string.intValue == 4)
            {
                weakSelf.titleArray = @[@"我创建的订单",@"平台所有订单"];
                weakSelf.titleLabel.text = [NSString stringWithFormat:@"%@-我的",productName];
                weakSelf.titleArrayShow = @[[NSString stringWithFormat:@"%@-我的",productName],[NSString stringWithFormat:@"%@-公司",productName]];
            }
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark ZSSelectViewDelegate
- (void)currentSelectIndex:(NSInteger)index currentSelectTitle:(NSString*)string withSecectView:(ZSSelectView *)alert;
{
    //存值
    //星速贷
    if ([self.prdType isEqualToString:kProduceTypeStarLoan])
    {
        [USER_DEFALT setObject:string forKey:KStarLoan];
    }
    //赎楼宝
    else if ([self.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        [USER_DEFALT setObject:string forKey:KRedeemFloor];
    }
    //抵押贷
    else if ([self.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        [USER_DEFALT setObject:string forKey:KMortgageLoan];
    }
    //融易贷
    else if ([self.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        [USER_DEFALT setObject:string forKey:KEasyLoan];
    }
    //车位分期
    else if ([self.prdType isEqualToString:kProduceTypeCarHire])
    {
        [USER_DEFALT setObject:string forKey:KCarHire];
    }
    //代办业务
    else if ([self.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        [USER_DEFALT setObject:string forKey:KAgencyBusiness];
    }

    //改标题
    self.titleLabel.text = self.titleArrayShow[index];
    
    //发通知,掉接口
    [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
}

- (void)changeImage
{
    self.titleImg.image = [UIImage imageNamed:@"home_dropdown_n"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
