//
//  ZSAFOOrderDetailViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSAFOOrderDetailViewController.h"
#import "ZSAddRecordViewController.h"
#import "ZSBaseSectionView.h"
#import "ZSRecordListViewController.h"
#import "ZSSLNewLeftRightCell.h"
#import "ZSBaseAddCustomerViewController.h"

#define BOTTOMBTN_HEIGHT 50

@interface ZSAFOOrderDetailViewController ()<ZSCreditSectionViewDelegate,ZSWSRightAlertViewDelegate>
@property(nonatomic,strong)UIWindow       *window;
@property(nonatomic,strong)UIView         *view_bottom;
@property(nonatomic,strong)UIView         *image_bg;
@property(nonatomic,strong)UIImageView    *imgview_header;      //头像
@property(nonatomic,strong)UILabel        *nameLabel;          //姓名
@property(nonatomic,strong)NSMutableArray *array_left_one;
@property(nonatomic,strong)NSMutableArray *array_left_two;
@property(nonatomic,strong)NSMutableArray *array_right_one;
@property(nonatomic,strong)NSMutableArray *array_right_two;
@property(nonatomic,copy  )NSString       *string_record;       //跟进记录
@end

@implementation ZSAFOOrderDetailViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //重设tableview的frame
    if (self.isFromNew){
        self.tableView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-BOTTOMBTN_HEIGHT);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT-BOTTOMBTN_HEIGHT-64);
    }
    //重新创建window上的东西
    [self initHeadImage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.isFromNew = NO;
    [self.imgview_header removeFromSuperview];
    self.imgview_header = nil;
    [self.image_bg removeFromSuperview];
    self.image_bg = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.window = [UIApplication sharedApplication].keyWindow;
    [self setLeftBarButtonItem];//返回按钮
    [self initHearderView];
    [NOTI_CENTER addObserver:self selector:@selector(reloadCell) name:KSUpdateAllOrderDetailNotification object:nil];
    //Data
    [self reloadCell];//用于数据刷新
}

- (void)reloadCell
{
    [self getOrderDetail];
    [self getRecordList];
}

#pragma mark 订单详情
- (void)getOrderDetail
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@""];
    NSMutableDictionary *parameterDict = @{
                                           @"applyId":self.onlineOrderIDString}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getApplyOnlineOrderDetailURL] SuccessBlock:^(NSDictionary *dic) {
//        ZSLOG(@"订单详情请求成功:%@",dic);
        ZSAOListModel *model = [ZSAOListModel yy_modelWithJSON:dic[@"respData"]];
        weakSelf.model = model;
        if (model.applyState.intValue == 1) {
            [weakSelf setRightBarButtom];//只有待处理订单显示关闭按钮
        }
        [weakSelf initBottomBtns];//创建底部按钮
        [weakSelf fillinData:model];//数据填充
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 数据填充
- (void)fillinData:(ZSAOListModel *)model
{
    self.array_left_one  = [[NSMutableArray alloc]init];
    self.array_left_two  = [[NSMutableArray alloc]init];
    self.array_right_one = [[NSMutableArray alloc]init];
    self.array_right_two = [[NSMutableArray alloc]init];
    
    //header
    if (model.headUrl) {
        [self.imgview_header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",SafeStr(model.headUrl)]] placeholderImage:[UIImage imageNamed:@"list_weixin_n"]];
    }
    if (model.realName) {
        self.nameLabel.text = SafeStr(model.realName);
    }
    
    //第一个section
    if (model.phone) {
        if (model.phone.length) {
            [self.array_left_one addObject:@"联系电话"];
            [self.array_right_one addObject:SafeStr(model.phone)];
        }
    }
    if (model.prdType) {
        if (model.prdType.length) {
            [self.array_left_one addObject:@"业务类型"];
            if (model.prdType.intValue == 1) {
                [self.array_right_one addObject:@"新房见证"];
            }
            if (model.prdType.intValue == 2) {
                [self.array_right_one addObject:@"赎楼宝"];
            }
            if (model.prdType.intValue == 3) {
                [self.array_right_one addObject:@"抵押贷"];
            }
            if (model.prdType.intValue == 4) {
                [self.array_right_one addObject:@"星速贷"];
            }
            if (model.prdType.intValue == 5) {
                [self.array_right_one addObject:@"车位分期"];
            }
        }
    }
    if (model.createDate) {
        if (model.createDate.length) {
            [self.array_left_one addObject:@"申请时间"];
            [self.array_right_one addObject:SafeStr(model.createDate)];
        }
    }
    if (model.source) {
        if (model.source.length) {
            [self.array_left_one addObject:@"申请渠道"];
            if ([model.source isEqualToString:@"wechat"]) {
                [self.array_right_one addObject:@"微信"];
            }
            if ([model.source isEqualToString:@"website"]) {
                [self.array_right_one addObject:@"官网"];
            }
        }
    }
    
    //第二个section
    if (model.idCardNo) {
        if (model.idCardNo.length) {
            [self.array_left_two addObject:@"身份证号"];
            [self.array_right_two addObject:SafeStr(model.idCardNo)];
        }
    }
    if (model.loanLimit) {
        if (model.loanLimit.length) {
            [self.array_left_two addObject:@"申请额度"];
            [self.array_right_two addObject:[NSString stringWithFormat:@"%@ 元",SafeStr(model.loanLimit)]];
        }
    }
    if (model.monthlyIncome) {
        if (model.monthlyIncome.length) {
            [self.array_left_two addObject:@"月收入"];
            [self.array_right_two addObject:SafeStr(model.monthlyIncome)];
        }
    }
    if (model.proCity) {
        if (model.proCity.length) {
            [self.array_left_two addObject:@"所在城市"];
            [self.array_right_two addObject:SafeStr(model.proCity)];
        }
    }
    if (model.localHouseProperty) {
        if (model.localHouseProperty.length) {
            [self.array_left_two addObject:@"本市房产"];
            if (model.localHouseProperty.intValue == 1) {
                [self.array_right_two addObject:@"有"];
            }else{
                [self.array_right_two addObject:@"无"];
            }
        }
    }
    if (model.acceptMortgage) {
        if (model.acceptMortgage.length) {
            [self.array_left_two addObject:@"是否接受抵押"];
            if (model.acceptMortgage.intValue == 1) {
                [self.array_right_two addObject:@"是"];
            }else{
                [self.array_right_two addObject:@"否"];
            }
        }
    }
    
    //刷新
    [self.tableView reloadData];
}

#pragma mark 跟进记录列表
- (void)getRecordList
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@""];
    NSMutableDictionary *parameterDict = @{
                                           @"nextPage":[NSNumber numberWithInt:0],
                                           @"pageSize":[NSNumber numberWithInt:10],
                                           @"applyId":self.onlineOrderIDString}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getRecordListURL] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"][@"content"];
        if (array.count > 0) {
            NSDictionary *dic_content = array.firstObject;
            weakSelf.string_record = dic_content[@"followContent"];
        }
        [weakSelf.tableView reloadData];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 关闭订单
- (void)didSelectBtnClick:(NSInteger)tag
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@""];
    NSMutableDictionary *parameterDict = @{
                                           @"applyId":self.onlineOrderIDString}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getCloseApplyOnlineOrderURL] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //通知微信申请列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
    }];
}

#pragma mark 右侧按钮
- (void)setRightBarButtom
{
    UIButton *rightAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightAction setFrame:CGRectMake(0, 0, 80, 40)];
    UIView *backBtnView = [[UIView alloc] initWithFrame:rightAction.bounds];
    backBtnView.bounds = CGRectOffset(backBtnView.bounds, -6, 0);
    [backBtnView addSubview:rightAction];
    [rightAction setImage:ImageName(@"head_more_n") forState:UIControlStateNormal];
    rightAction.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightAction.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightAction addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backBtnView];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

- (void)rightAction
{
    ZSWSRightAlertView *alertView = [[ZSWSRightAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow) withArray:@[KCloseBtnTitle]];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark table--header
- (void)initHearderView
{
    UIView *view_header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 64)];
    view_header.backgroundColor = ZSColorWhite;
    self.tableView.tableHeaderView = view_header;
    
    //姓名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,35,ZSWIDTH,20)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = ZSColorListLeft;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [view_header addSubview:self.nameLabel];
}

- (void)initHeadImage
{
    //头像
    self.image_bg = [[UIView alloc]initWithFrame:CGRectMake((ZSWIDTH-60)/2, 34, 60, 60)];
    self.image_bg.backgroundColor = ZSColorWhite;
    self.image_bg.layer.cornerRadius = 3;
    self.image_bg.layer.masksToBounds = YES;
    [self.window addSubview:self.image_bg];
    self.imgview_header = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 56, 56)];
    self.imgview_header.layer.cornerRadius = 3;
    self.imgview_header.layer.masksToBounds = YES;
    self.imgview_header.image = [UIImage imageNamed:@"list_weixin_n"];
    self.imgview_header.userInteractionEnabled = YES;
    [self.image_bg addSubview:self.imgview_header];
   
    //header
    if (_model.headUrl) {
        [self.imgview_header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",SafeStr(_model.headUrl)]] placeholderImage:[UIImage imageNamed:@"list_weixin_n"]];
    }
   
    //点击头像放大
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigImgShow:)];
    [self.imgview_header addGestureRecognizer:tap];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0)
    {
        self.imgview_header.hidden = NO;
        self.image_bg.hidden = NO;
    }
    else
    {
        self.imgview_header.hidden = YES;
        self.image_bg.hidden = YES;
    }
}

#pragma mark 点击头像
- (void)bigImgShow:(UITapGestureRecognizer*)tap
{
    UIImageView *imageView = (UIImageView*)tap.view;
    if (imageView.image) {
        // 1. 创建photoBroseView对象
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        photoBroseView.images = @[imageView.image];
        photoBroseView.showFromView = tap.view;
        photoBroseView.hiddenToView = tap.view;
        photoBroseView.currentIndex = 0;
        // 3.显示(浏览)
        [photoBroseView show];
    }
}

#pragma mark tableview--delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.string_record)
    {
        if (self.array_right_one.count > 0 && self.array_right_two.count > 0) {
            return 3;
        }else{
            return 2;
        }
    }
    else
    {
        if (self.array_right_one.count > 0 && self.array_right_two.count > 0) {
            return 2;
        }else{
            return 1;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.string_record)
    {
        if (self.array_right_one.count > 0 && self.array_right_two.count > 0) {
            if (section == 0) {
                return self.array_right_one.count;
            }
            else if (section == 1) {
                return self.array_right_two.count;
            }
            else {
                return 1;
            }
        }
        else if (self.array_right_one.count){
            if (section == 0) {
                return self.array_right_one.count;
            }
            else {
                return 1;
            }
        }
        else {
            if (section == 0) {
                return self.array_right_two.count;
            }
            else {
                return 1;
            }
        }
    }
    else
    {
        if (self.array_right_one.count > 0 && self.array_right_two.count > 0) {
            if (section == 0) {
                return self.array_right_one.count;
            }
            else{
                return self.array_right_two.count;
            }
        }
        else if (self.array_right_one.count){
            return self.array_right_one.count;
        }
        else {
            return self.array_right_two.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.string_record)
    {
        if (self.array_right_one.count > 0 && self.array_right_two.count > 0) {
            if (section == 0 || section == 1)
            {
                return 10;
            }else {
                return 54;
            }
        }else{
            if (section == 0)
            {
                return 10;
            }else {
                return 54;
            }
        }
    }
    else
    {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.string_record)
    {
        if (self.array_right_one.count > 0 && self.array_right_two.count > 0) {
            if (indexPath.section == 0 || indexPath.section == 1) {
                return CellHeight;
            }
            else {
                if ([ZSTool getStringHeight:self.string_record withframe:CGSizeMake(ZSWIDTH-30, 1000000) withSizeFont:[UIFont systemFontOfSize:15] winthLineSpacing:7] + 15 < CellHeight) {
                    return CellHeight;
                }
                return [ZSTool getStringHeight:self.string_record withframe:CGSizeMake(ZSWIDTH-30, 1000000) withSizeFont:[UIFont systemFontOfSize:15] winthLineSpacing:7] + 15;
            }
        }
        else {
            if (indexPath.section == 0) {
                return CellHeight;
            }
            else {
                if ([ZSTool getStringHeight:self.string_record withframe:CGSizeMake(ZSWIDTH-30, 1000000) withSizeFont:[UIFont systemFontOfSize:15] winthLineSpacing:7] + 15 < CellHeight) {
                    return CellHeight;
                }
                return [ZSTool getStringHeight:self.string_record withframe:CGSizeMake(ZSWIDTH-30, 1000000) withSizeFont:[UIFont systemFontOfSize:15] winthLineSpacing:7] + 15;
            }
        }
    }
    else
    {
        return CellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ZSSLNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    if (cell == nil) {
        cell = [[ZSSLNewLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
        cell.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        cell.bottomLineStyle = CellLineStyleSpacing;
    }
    
    //赋值
    if (self.string_record)
    {
        if (self.array_right_one.count > 0 && self.array_right_two.count > 0) {
            if (indexPath.section == 0) {
                [self fillCellSectionOne:cell AtIndexPath:indexPath];
            }
            if (indexPath.section == 1) {
                [self fillCellSectionTwo:cell AtIndexPath:indexPath];
            }
            if (indexPath.section == 2) {
                [self fillCellSectionThree:cell AtIndexPath:indexPath];
            }
        }
        else if (self.array_right_one.count)
        {
            if (indexPath.section == 0) {
                [self fillCellSectionOne:cell AtIndexPath:indexPath];
            }
            if (indexPath.section == 1) {
                [self fillCellSectionThree:cell AtIndexPath:indexPath];
            }
        }
        else {
            if (indexPath.section == 0) {
                [self fillCellSectionTwo:cell AtIndexPath:indexPath];
            }
            if (indexPath.section == 1) {
                [self fillCellSectionThree:cell AtIndexPath:indexPath];
            }
        }
    }
    else
    {
        if (self.array_right_one.count > 0 && self.array_right_two.count > 0) {
            if (indexPath.section == 0) {
                [self fillCellSectionOne:cell AtIndexPath:indexPath];
            }
            if (indexPath.section == 1) {
                [self fillCellSectionTwo:cell AtIndexPath:indexPath];
            }
        }
        else if (self.array_right_one.count) {
            [self fillCellSectionOne:cell AtIndexPath:indexPath];
        }
        else {
            [self fillCellSectionTwo:cell AtIndexPath:indexPath];
        }
    }
    
    return cell;
}

- (void)fillCellSectionOne:(ZSSLNewLeftRightCell *)cell AtIndexPath:(NSIndexPath *)indexPath;
{
    cell.leftLabel.width = 100;
    cell.leftLabel.height = CellHeight;
    cell.leftLabel.text = self.array_left_one[indexPath.row];
    cell.rightLabel.text = self.array_right_one[indexPath.row];
}

- (void)fillCellSectionTwo:(ZSSLNewLeftRightCell *)cell AtIndexPath:(NSIndexPath *)indexPath;
{
    cell.leftLabel.width = 100;
    cell.leftLabel.height = CellHeight;
    cell.leftLabel.text = self.array_left_two[indexPath.row];
    cell.rightLabel.text = self.array_right_two[indexPath.row];
}

- (void)fillCellSectionThree:(ZSSLNewLeftRightCell *)cell AtIndexPath:(NSIndexPath *)indexPath;
{
    cell.leftLabel.width = ZSWIDTH-30;
    if ([ZSTool getStringHeight:self.string_record withframe:CGSizeMake(ZSWIDTH-30, 1000000) withSizeFont:[UIFont systemFontOfSize:15]] + 15 < CellHeight) {
        cell.leftLabel.height = CellHeight;
    }else{
        cell.leftLabel.height = [ZSTool getStringHeight:self.string_record withframe:CGSizeMake(ZSWIDTH-30, 1000000) withSizeFont:[UIFont systemFontOfSize:15] winthLineSpacing:7] + 15;
    }
    //label行间距
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 7;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@0.0f};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.string_record attributes:dic];
    cell.leftLabel.attributedText = attributeStr;
}

#pragma mark 区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (self.string_record)
    {
        if (self.array_right_one.count > 0 && self.array_right_two.count > 0) {
            if (section == 2) {
                return [self createSectionView];
            }else{
                return nil;
            }
        }else {
            if (section == 1) {
                return [self createSectionView];
            }else{
                return nil;
            }
        }
    }
    else
    {
        return nil;
    }
}

- (UIView *)createSectionView
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    view.backgroundColor = [UIColor clearColor];
    ZSBaseSectionView *sectionView = [[ZSBaseSectionView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    sectionView.backgroundColor = ZSColorWhite;
    sectionView.delegate = self;
    sectionView.bottomLine.hidden = NO;
    sectionView.rightLab.hidden = NO;
    sectionView.leftLab.text = @"跟进记录";
    sectionView.rightLab.text = @"全部记录";
    [view addSubview:sectionView];
    return view;
}

#pragma mark 区头代理
- (void)tapSection:(NSInteger)sectionIndex
{
    ZSRecordListViewController *addVC = [[ZSRecordListViewController alloc]init];
    addVC.onlineOrderIDString = self.onlineOrderIDString;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark 底部按钮
- (void)initBottomBtns
{
    if (!self.view_bottom)
    {
        self.view_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT-BOTTOMBTN_HEIGHT-64, ZSWIDTH, BOTTOMBTN_HEIGHT)];
        self.view_bottom.backgroundColor = ZSColorWhite;
        [self.view addSubview:self.view_bottom];
        if (self.model.applyState.intValue == 1)//只有未处理的订单可以创建订单
        {
            if (self.model.prdType.intValue == 1 ) {//新房见证不可以创建订单
                [self initBtns:2];
            }else{
                [self initBtns:3];
            }
        }
        else{
            [self initBtns:2];
        }
    }
}

- (void)initBtns:(int)count
{
    //创建底部按钮
    for (int i = 0; i < count; i++){
        [self createBtns:i superView:self.view_bottom btnAmount:count];
    }
}

- (void)createBtns:(int)i superView:(UIView *)view_bottom btnAmount:(int)mount
{
    NSMutableArray *array_img  = [NSMutableArray arrayWithObjects:@"list_number_n",@"list_record_n",@"list_addOrder_n",nil];
    NSMutableArray *array_name = [NSMutableArray arrayWithObjects:@"联系客户",@"新增记录",@"创建订单",nil];
    
    //按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((ZSWIDTH/mount)*i, 0, ZSWIDTH/mount, BOTTOMBTN_HEIGHT);
    btn.tag = i;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn];
    
    //按钮之间的竖线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [btn addSubview:lineView];
    
    //图片
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((btn.width-15-65-5)/2, (btn.height-15)/2, 15, 15)];
    imgview.image = [UIImage imageNamed:array_img[i]];
    [btn addSubview:imgview];
    
    //label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imgview.right+5, 0, 65, btn.height)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = ZSColorListLeft;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@", array_name[i]];
    [btn addSubview:label];
    
    //竖线
    UIView *lineView_vertical = [[UIView alloc]initWithFrame:CGRectMake(btn.width, 7.5, 0.5, btn.height-15)];
    lineView_vertical.backgroundColor = ZSColorLine;
    [btn addSubview:lineView_vertical];
}

- (void)btnAction:(UIButton*)btn//0:联系客户 1:新增记录 2:创建订单
{
    if (btn.tag == 0)
    {
        if (self.model.phone) {
            [ZSTool callPhoneStr:self.model.phone withVC:self];
        }else{
            [ZSTool showMessage:@"暂无客户电话" withDuration:DefaultDuration];
        }
    }
    else if (btn.tag == 1)
    {
        ZSAddRecordViewController *addVC = [[ZSAddRecordViewController alloc]init];
        addVC.onlineOrderIDString = self.onlineOrderIDString;
        [self.navigationController pushViewController:addVC animated:YES];
    }
    else
    {
        //创建订单之前检查该产品是否被禁用
        NSMutableDictionary *parameterDict = @{}.mutableCopy;
        if (self.model.prdType.intValue == 2) {
            [parameterDict setObject:kProduceTypeRedeemFloor forKey:@"prdType"];//赎楼宝
        }
        if (self.model.prdType.intValue == 3) {
            [parameterDict setObject:kProduceTypeMortgageLoan forKey:@"prdType"];//抵押贷
        }
        if (self.model.prdType.intValue == 4) {
            [parameterDict setObject:kProduceTypeStarLoan forKey:@"prdType"];//星速贷
        }
        if (self.model.prdType.intValue == 5) {
            [parameterDict setObject:kProduceTypeCarHire forKey:@"prdType"];//车位分期
        }
        __weak typeof(self) weakSelf = self;
        [LSProgressHUD showToView:self.view message:@""];
        [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getCheckProductState] SuccessBlock:^(NSDictionary *dic) {
            if ([dic[@"respData"] intValue] == 1) {
                if (weakSelf.model.prdType.intValue == 2) {
                    [weakSelf creatOrderWithProductType:kProduceTypeRedeemFloor];
                }
                if (weakSelf.model.prdType.intValue == 3) {
                    [weakSelf creatOrderWithProductType:kProduceTypeMortgageLoan];
                }
                if (weakSelf.model.prdType.intValue == 4) {
                    [weakSelf creatOrderWithProductType:kProduceTypeStarLoan];
                }
                if (weakSelf.model.prdType.intValue == 5) {
                    [weakSelf creatOrderWithProductType:kProduceTypeCarHire];
                }
            }else{
                [ZSTool showMessage:@"暂不支持新增订单，请稍后!" withDuration:DefaultDuration];
            }
            [LSProgressHUD hideForView:weakSelf.view];
        } ErrorBlock:^(NSError *error) {
            [LSProgressHUD hideForView:weakSelf.view];
        }];
    }
}

#pragma mark 创建订单
- (void)creatOrderWithProductType:(NSString *)prdType
{
    ZSBaseAddCustomerViewController *addVC = [[ZSBaseAddCustomerViewController alloc]init];
    addVC.isFromAdd = YES;
    addVC.onlineOrderIDString = self.onlineOrderIDString;
    if ([self.model.source isEqualToString:@"wechat"]) {
        addVC.isFromWeiXin = YES;
    }
    if ([self.model.source isEqualToString:@"website"]) {
        addVC.isFromOfficial = YES;
    }
    //人员信息
    global.bizCustomers = [BizCustomers yy_modelWithDictionary:[self getUserMessage]];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (NSMutableDictionary *)getUserMessage
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (self.model.realName) {
        [dic setObject:self.model.realName forKey:@"name"];
    }
    if (self.model.idCardNo) {
        [dic setObject:self.model.idCardNo forKey:@"identityNo"];
    }
    if (self.model.phone) {
        [dic setObject:self.model.phone forKey:@"cellphone"];
    }
    return dic;
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
    self.isFromNew = NO;
    [self.imgview_header removeFromSuperview];
    self.imgview_header = nil;
    [self.image_bg removeFromSuperview];
    self.image_bg = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
