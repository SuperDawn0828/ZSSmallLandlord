//
//  ZSBaseSearchViewController.m
//  ZSMoneytocar
//
//  Created by 黄曼文 on 2017/4/17.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSBaseSearchViewController.h"
#import "ZSHomeSeacrResultsViewController.h"
#import "ZSBankHomeOrderListViewController.h"
#import "ZSWitnessServerOrderListViewController.h"
#import "ZSStarLoanOrderListViewController.h"
#import "ZSAFOOrderListViewController.h"
#import "ZSPCOrderListController.h"
#import "ZSSLMaterialCollectViewController.h"
#import "ZSTHOrderListViewController.h"

@interface ZSBaseSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView          *navView;
@property (nonatomic,strong) UIImageView     *searchImage;
@property (nonatomic,strong) UITextField     *inputTxtfeild;
@property (nonatomic,strong) UILabel         *headerLabel;
@property (nonatomic,strong) UIButton        *footerBtn;
@property (nonatomic,strong) NSMutableArray  *historicalDataArray;//历史搜索数组
@property (nonatomic,copy  ) NSString        *keyString;          //文件key,用用户id来代替
@end

@implementation ZSBaseSearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏导航栏
    self.navView.hidden = NO;//显示自定义导航栏
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];//显示导航栏
    self.navView.hidden = YES;//隐藏自定义导航栏
    self.inputTxtfeild.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ZSViewBackgroundColor;
    [self configureSearchBar];
    [self configureTableView];
    self.keyString = [ZSTool readUserInfo].tid;
}

#pragma mark 创建搜索bar
- (void)configureSearchBar
{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, kNavigationBarHeight)];
    self.navView.backgroundColor = ZSColorRed;
    [self.view addSubview:self.navView];
    
    UIButton *button_bg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button_bg.frame = CGRectMake(15, kStatusBarHeight+((kNavigationBarHeight-kStatusBarHeight)-30)/2, ZSWIDTH-62, 30);
    button_bg.backgroundColor = ZSColorWhite;
    button_bg.layer.cornerRadius = 15.0f;
    [self.navView addSubview:button_bg];
 
    self.searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
    self.searchImage.image = [UIImage imageNamed:@"head_search_1_n"];
    [button_bg addSubview:self.searchImage];
 
    NSString *string = [self.filePathString isEqualToString:KOrderDetailDataSearch] ? @"请输入资料名称" : @"请输入客户姓名/身份证号/手机号";
    self.inputTxtfeild = [self FieldWithFrame:CGRectMake(30, 0, ZSWIDTH-62-25, 30) FieldText:string];
    self.inputTxtfeild.delegate = self;
    [self.inputTxtfeild becomeFirstResponder];//默认键盘弹出
    [button_bg addSubview:self.inputTxtfeild];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(ZSWIDTH-60, kStatusBarHeight+((kNavigationBarHeight-kStatusBarHeight)-30)/2, 60, 30);
    [cancelBtn setTitle:@"  取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(btnCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:cancelBtn];
}

- (UITextField *)FieldWithFrame:(CGRect )frame FieldText:(NSString *)TSLable
{
    UITextField *textField       = [[UITextField alloc] init];
    textField.frame              = frame;
    textField.borderStyle        = UITextBorderStyleNone;
    textField.textColor          = ZSColorListRight;;
    textField.textAlignment      = NSTextAlignmentLeft;
    textField.placeholder        = TSLable;
    textField.secureTextEntry    = NO;
    textField.backgroundColor    = [UIColor clearColor];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.returnKeyType      = UIReturnKeySearch;
    textField.font               = [UIFont systemFontOfSize:13];
    [textField setValue:ZSColorAllNotice forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:textField];
    return textField;
}

#pragma mark 创建列表
- (void)configureTableView
{
    [self configureTableView:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight) withStyle:UITableViewStylePlain];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 48)];
    self.headerLabel.layer.borderColor = ZSColorLine.CGColor;  //边框颜色
    self.headerLabel.layer.borderWidth = 0.5;
    self.headerLabel.textAlignment     = NSTextAlignmentLeft;
    self.headerLabel.text              = @"    历史搜索";
    self.headerLabel.textColor         = ZSColor(102, 102, 102);
    self.headerLabel.font              = [UIFont systemFontOfSize:16];
    self.tableView.tableHeaderView   = self.headerLabel;
    
    self.footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.footerBtn.frame              = CGRectMake(0, 0, ZSWIDTH, CellHeight);
    self.footerBtn.backgroundColor    = [UIColor clearColor];
    self.footerBtn.titleLabel.font    = [UIFont systemFontOfSize:16];
    self.tableView.tableFooterView  = self.footerBtn;
    [self.footerBtn setTitle:@"清除搜索记录" forState:UIControlStateNormal];
    [self.footerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.footerBtn addTarget:self action:@selector(btnFooterAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *view_divider = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.5)];
    view_divider.backgroundColor = ZSColorLine;
    [self.footerBtn addSubview:view_divider];
}

- (void)reloadData
{
    NSString *path2 = [NSHomeDirectory() stringByAppendingPathComponent:self.filePathString];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path2]].mutableCopy;
    if (array.count > 0) {
        self.historicalDataArray = [[NSMutableArray alloc]init];
        //文件key用的用户id，不一致可能有空值，空值就不要了
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = array[idx];
            NSString *string = [dic objectForKey:self.keyString];
            if (string.length > 0) {
                [self.historicalDataArray addObject:string];
            }
        }];
        
        //有数据再刷新
        if (self.historicalDataArray.count > 0) {
            self.tableView.hidden     = NO;
            self.headerLabel.hidden  = NO;
            self.footerBtn.hidden    = NO;
            [self.tableView reloadData];
        }
        else
        {
            self.tableView.hidden    = YES;
            self.headerLabel.hidden = YES;
            self.footerBtn.hidden   = YES;
        }
    }
    else
    {
        self.tableView.hidden    = YES;
        self.headerLabel.hidden = YES;
        self.footerBtn.hidden   = YES;
    }
}

#pragma mark textField---Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.inputTxtfeild.text.length == 0)
    {
        [ZSTool showMessage:@"请输入需要搜索的内容" withDuration:DefaultDuration];
        return NO;
    }
    else
    {
        //根据关键字搜索需要搜索的内容
        [self requestTheSearchContent:self.inputTxtfeild.text];
        //存值
        NSString *string_search = [NSString stringWithFormat:@"%@",self.inputTxtfeild.text];
        NSString *path2 = [NSHomeDirectory() stringByAppendingPathComponent:self.filePathString];
        NSMutableArray *array2 = [NSMutableArray arrayWithContentsOfFile:path2];
        NSMutableArray  *MuArray = [array2 mutableCopy];
        for (int i = 0; i<MuArray.count; i++) {
            if ([[[MuArray objectAtIndex:i] objectForKey:self.keyString ]isEqualToString:string_search]) {
                [MuArray removeObjectAtIndex:i];
            }
        }
        
        NSDictionary *dic = @{self.keyString:string_search};
        NSArray *array = @[dic];
        NSMutableArray *mutArrary1 = [[NSMutableArray alloc] initWithCapacity:2225];
        [mutArrary1 addObjectsFromArray:MuArray];
        [mutArrary1 addObjectsFromArray:array];
        //数组写文件
        [mutArrary1 writeToFile:path2 atomically:YES];
        [USER_DEFALT setObject:string_search forKey:self.keyString];
        [textField resignFirstResponder];//键盘回收代码

        return YES;
    }

    return NO;
}

- (void)textFieldDone
{
    [self.view endEditing:YES];
}

#pragma mark tableView---Delaget
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.historicalDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifyCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, ZSWIDTH-15, 0.5)];
        lineView.backgroundColor = ZSColorLine;
        [cell addSubview:lineView];
    }
    if (self.historicalDataArray.count > 0) {
        cell.textLabel.text = self.historicalDataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.historicalDataArray.count > 0) {
         NSString *string = self.historicalDataArray[indexPath.row];
         [self requestTheSearchContent:string];//根据关键字搜索需要搜索的内容
    }
}

#pragma mark 事件
//返回上级
- (void)btnCancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//清除搜索历史
- (void)btnFooterAction
{
    NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent:self.filePathString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager removeItemAtPath:filePath1 error:nil];
    self.historicalDataArray = 0;
    self.headerLabel.hidden  = YES;
    self.footerBtn.hidden    = YES;
    
    [self.tableView reloadData];
    if (success) {
        [self.tableView reloadData];
    }
}

#pragma mark 根据关键字搜索需要搜索的内容
- (void)requestTheSearchContent:(NSString *)searchSting
{
    //首页列表搜索
    if ([self.filePathString isEqualToString:KAllListSearch])
    {
        ZSHomeSeacrResultsViewController *searchVC = [[ZSHomeSeacrResultsViewController alloc]init];
        searchVC.searchKeyWord = searchSting;
        searchVC.title = searchSting;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    //审批列表搜索
    else if ([self.filePathString isEqualToString:KBankHomeSearch])
    {
        ZSBankHomeOrderListViewController *homeVC = [[ZSBankHomeOrderListViewController alloc]init];
        homeVC.searchKeyWord  = searchSting;
        homeVC.title = searchSting;
        [self.navigationController pushViewController:homeVC animated:YES];
    }
    //新房见证搜索
    else if ([self.filePathString isEqualToString:KWitnessServerSearch])
    {
        ZSWitnessServerOrderListViewController *searchVC = [[ZSWitnessServerOrderListViewController alloc]init];
        searchVC.searchKeyWord = searchSting;
        searchVC.title = searchSting;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    //微信申请搜索
    else if ([self.filePathString isEqualToString:KApplyforOnlineSearch])
    {
        ZSAFOOrderListViewController *searchVC = [[ZSAFOOrderListViewController alloc]init];
        searchVC.searchKeyWord  = searchSting;
        searchVC.title = searchSting;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    //预授信搜索
    else if ([self.filePathString isEqualToString:KPreliminaryCreditSearch])
    {
        ZSPCOrderListController *searchVC = [[ZSPCOrderListController alloc]init];
        searchVC.searchKeyWord  = searchSting;
        searchVC.title = searchSting;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    //中介端跟进搜索
    else if ([self.filePathString isEqualToString:KTheMediationSearch])
    {
        ZSTHOrderListViewController *searchVC = [[ZSTHOrderListViewController alloc]init];
        searchVC.searchKeyWord  = searchSting;
        searchVC.title = searchSting;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    //订单详情资料搜索
    else if ([self.filePathString isEqualToString:KOrderDetailDataSearch])
    {
        ZSSLMaterialCollectViewController *searchVC = [[ZSSLMaterialCollectViewController alloc]init];
        searchVC.searchKeyWord  = searchSting;
        searchVC.title = searchSting;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    //金融产品
    else
    {
        ZSStarLoanOrderListViewController *searchVC = [[ZSStarLoanOrderListViewController alloc]init];
        searchVC.searchKeyWord = searchSting;
        searchVC.title = searchSting;
        searchVC.prdType = self.prdType;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
