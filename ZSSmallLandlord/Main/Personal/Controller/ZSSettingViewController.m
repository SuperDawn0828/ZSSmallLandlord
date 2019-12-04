//
//  ZSSettingViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/31.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSettingViewController.h"
#import "ZSPersonalDetailCell.h"
#import "ZSChangePhoneViewController.h"

static NSString *const messageNoticeOn  = @"关闭后，订单状态发生变动时，将不进行短信提醒。";
static NSString *const messageNoticeOff = @"短信通知开启后，订单状态发生变动时，将及时发送短信提醒。";
static NSString *const systemNoticeOn   = @"关闭后，订单状态发生变动时，将不进行短信提醒，如需关闭，请在系统设置中进行操作。";
static NSString *const systemNoticeOff  = @"开启系统通知，订单状态发生变化时将发送系统消息。";

@interface ZSSettingViewController ()<ZSAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *array_notice;
@end

@implementation ZSSettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.title = @"设置";
    self.tableView.frame = CGRectMake(0, -10, ZSWIDTH, ZSHEIGHT);
    self.tableView.scrollEnabled = NO;
    [self setLeftBarButtonItem];//返回按钮
    //Data
    [NOTI_CENTER addObserver:self selector:@selector(checkIsReceive) name:KSCheckNoitfication object:nil];
    self.array_notice = @[messageNoticeOn,systemNoticeOn].mutableCopy;
    [self getUserInfo];
}

#pragma mark 获取个人信息
- (void)getUserInfo
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getUserInformation] SuccessBlock:^(NSDictionary *dic) {
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSTool saveUserInfoWithDic:newdic];
        //Data
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self resetHeight:self.array_notice[section]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view_footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ZSWIDTH-30, CellHeight)];
    label.textColor = ZSPageItemColor;
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    [view_footer addSubview:label];
    //赋值
    label.text = self.array_notice[section];
    label.height = [self resetHeight:self.array_notice[section]];
    return view_footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ZSPersonalDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    if (cell == nil) {
        cell = [[ZSPersonalDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
        cell.leftImage.hidden = YES;
        cell.leftLabel.left = 15;
        cell.pushImage.hidden = YES;
        cell.rightLabel.right = ZSWIDTH-15;
        cell.rightLabel.textColor = UIColorFromRGB(0x949494);
        [cell.noticeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.noticeSwitch.tag = indexPath.section;
    }
    if (indexPath.section == 0)
    {
        cell.leftLabel.text = @"短信通知";
        cell.noticeSwitch.hidden = NO;
        ZSUidInfo *userInfo = [ZSTool readUserInfo];
        if (userInfo.beNotice) {
            if (userInfo.beNotice.intValue == 1) {
                cell.noticeSwitch.on = YES;
                [self.array_notice replaceObjectAtIndex:0 withObject:messageNoticeOn];
            }else{
                cell.noticeSwitch.on = NO;
                [self.array_notice replaceObjectAtIndex:0 withObject:messageNoticeOff];
            }
        }else{
            cell.noticeSwitch.on = NO;
            [self.array_notice replaceObjectAtIndex:0 withObject:messageNoticeOff];
        }
    }
    else if (indexPath.section == 1)
    {
        cell.leftLabel.text = @"系统通知";
        if ([self checkNotification]) {
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = @"已开启";
            cell.noticeSwitch.hidden = YES;
            [self.array_notice replaceObjectAtIndex:1 withObject:systemNoticeOn];
        }else{
            cell.rightLabel.hidden = YES;
            cell.noticeSwitch.hidden = NO;
            cell.noticeSwitch.on = NO;
            [self.array_notice replaceObjectAtIndex:1 withObject:systemNoticeOff];
        }
    }
    return cell;
}

- (void)switchAction:(UISwitch *)btn
{
    //短信通知
    if (btn.tag == 0) {
        ZSUidInfo *userInfo = [ZSTool readUserInfo];
        //先判断是否接收短信通知
        if (userInfo.telphone.length) {
            if (userInfo.beNotice.intValue == 1) {
                [self changeNoticeState:@"0"];
            }else{
                [self changeNoticeState:@"1"];
            }
        }
        else
        {
            ZSChangePhoneViewController *changeVC = [[ZSChangePhoneViewController alloc]init];
            changeVC.isChange = NO;
            [self.navigationController pushViewController:changeVC animated:YES];
        }
    }
    //系统通知
    if (btn.tag == 1) {
        if (![self checkNotification]) {
            [self goToOpenNotification];
        }
    }
}

#pragma mark 重设高度
- (CGFloat)resetHeight:(NSString *)string
{
    CGFloat height = 0;
    CGSize size = CGSizeMake(ZSWIDTH-30,1000);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    if (labelsize.height+10 <= 30) {
        height = 30;
    }else{
        height = labelsize.height + 10;
    }
    return height;
}

#pragma mark 判断是否允许接收推送
- (void)checkIsReceive
{
    [self.tableView reloadData];
}

- (BOOL)checkNotification
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if(UIUserNotificationTypeNone != setting.types) {
        return YES;
    }else{
        return NO;
    }
}

- (void)goToOpenNotification
{
    //1.跳到APP自身的设置页
    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:appSettings]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:^(BOOL success) {
                //有时候通知不生效,所以在这儿添加一个回调
                [self.tableView reloadData];
            }];
        }else{
            [[UIApplication sharedApplication] openURL:appSettings];
        }
    }
}

#pragma mark 修改个人资料
- (void)changeNoticeState:(NSString *)updateContent;
{
    __weak typeof(self) weakSelf = self;
    [LSProgressHUD showToView:self.view message:@""];
    NSMutableDictionary *parameter = @{@"tid":[ZSTool readUserInfo].tid,
                                       @"beNotice":updateContent}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager updateUserInformation] SuccessBlock:^(NSDictionary *dic){
//        ZSLOG(@"修改资料成功:%@",dic);
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSTool saveUserInfoWithDic:newdic];
        //刷新数据
        [weakSelf.tableView reloadData];
        [LSProgressHUD hideForView:weakSelf.view];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hideForView:weakSelf.view];
        //刷新数据
        [weakSelf.tableView reloadData];
    }];
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
