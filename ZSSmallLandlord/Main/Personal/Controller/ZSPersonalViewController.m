//
//  ZSPersonalViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSPersonalViewController.h"
#import "ZSAboutViewController.h"
#import "ZSChangePasswordViewController.h"
#import "PYPhotoBrowseView.h"
#import "ZSLogInViewController.h"
#import "ZSPersonalDetailViewController.h"
#import "ZSPersonalDetailCell.h"
#import "ZSSettingViewController.h"
#import "ZSCalendarViewController.h"
#import "ZSToolWebViewController.h"
#import "ZSDaySignSmallView.h"
#import <UShareUI/UShareUI.h>

@interface ZSPersonalViewController ()<ZSAlertViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)ZSDaySignSmallView   *daySignView;
@property(nonatomic,strong)UIImageView          *HeadPortraitImage;
@property(nonatomic,strong)UILabel              *Namelabel;
@property(nonatomic,strong)UILabel              *label_role_tag;
@end

@implementation ZSPersonalViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏导航栏
    self.tableView.frame = CGRectMake(0, -20, ZSWIDTH, ZSHEIGHT);
    [self getUserInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHearderView];
    [self initFooterView];
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
        [weakSelf fillInData];
    } ErrorBlock:^(NSError *error) {
    }];
}

- (void)fillInData
{
    //赋值
    ZSUidInfo *userInfo = [ZSTool readUserInfo];
    if (userInfo.headPhoto)
    {
        [self.HeadPortraitImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,userInfo.headPhoto]] placeholderImage:[UIImage imageNamed:@"my_head_portrait_n"]];
    }
    if (userInfo.username)
    {
        self.Namelabel.text = userInfo.username;
    }
    
    //如果是中介的角色则不显示
    if (userInfo.roleName)
    {
        if (![userInfo.roleName containsString:@"中介"]) {
            self.label_role_tag.text = [NSString stringWithFormat:@"%@ | %@",SafeStr(userInfo.roleName),SafeStr(userInfo.orgnizationName)];
        }
    }
}

- (void)initHearderView
{
    UIImageView *imgview_header = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 178)];
    imgview_header.userInteractionEnabled = YES;
    imgview_header.image = [UIImage imageNamed:@"my_picture_n"];
    self.tableView.tableHeaderView = imgview_header;
    
    //日签
    self.daySignView = [[ZSDaySignSmallView alloc]initWithFrame:CGRectMake(0, -140, ZSWIDTH, 140)];
    [imgview_header addSubview:self.daySignView];
    
    //头像
    UIView *backgroundView_head = [[UIView alloc]init];
    if (IS_iPhoneX) {
        backgroundView_head.frame = CGRectMake(30, 82, 60, 60);
    }else{
        backgroundView_head.frame = CGRectMake(30, 62, 60, 60);
    }
    backgroundView_head.backgroundColor = ZSColorWhite;
    backgroundView_head.layer.cornerRadius = 30;
    backgroundView_head.layer.masksToBounds = YES;
    [imgview_header addSubview:backgroundView_head];
    self.HeadPortraitImage = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 56, 56)];
    self.HeadPortraitImage.layer.cornerRadius = 28;
    self.HeadPortraitImage.layer.masksToBounds = YES;
    self.HeadPortraitImage.userInteractionEnabled = YES;
    self.HeadPortraitImage.contentMode = UIViewContentModeScaleAspectFill;
    self.HeadPortraitImage.image = [UIImage imageNamed:@"my_head_portrait_n"];
    [backgroundView_head addSubview:self.HeadPortraitImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigImgShow:)];
    [self.HeadPortraitImage addGestureRecognizer:tap];
    
    //姓名
    self.Namelabel = [[UILabel alloc]init];
    if (IS_iPhoneX) {
        self.Namelabel.frame = CGRectMake(110,94, ZSWIDTH-110-15, 16);
    }else{
        self.Namelabel.frame = CGRectMake(110,74, ZSWIDTH-110-15, 16);
    }
    self.Namelabel.textColor = ZSColorWhite;
    self.Namelabel.font = [UIFont systemFontOfSize:16];
    self.Namelabel.textAlignment = NSTextAlignmentLeft;
    [imgview_header addSubview:self.Namelabel];
    
    //角色部门标签
    self.label_role_tag = [[UILabel alloc]initWithFrame:CGRectMake(110, self.Namelabel.bottom+15, ZSWIDTH-110-15, 10)];
    self.label_role_tag.font = [UIFont systemFontOfSize:12];
    self.label_role_tag.textColor = ZSColorWhite;
    self.label_role_tag.textAlignment = NSTextAlignmentLeft;
    [imgview_header addSubview:self.label_role_tag];
}

#pragma mark 退出按钮
- (void)initFooterView
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = backgroundView;
    
    //退出按钮
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0,10, ZSWIDTH, CellHeight);
    logoutBtn.backgroundColor = ZSColorWhite;
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [logoutBtn setTitleColor:ZSColorRed forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(loginOutClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:logoutBtn];
}

#pragma mark UITableView-delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZSUidInfo *userInfo = [ZSTool readUserInfo];
    if ([userInfo.userid isEqualToString:@"13875877865"]) {
        return 5;//如果是审核账号,直接屏蔽分享入口
    }
    else{
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    ZSPersonalDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZSPersonalDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.leftLabel.textColor = ZSColorListRight;
    }
    //赋值
    NSArray *array_img   = @[@"my_personal information_n",@"my_modify password_n",@"my_setting_n",@"my_about_n",@"my_clean_n",@"my_share_n"];
    NSArray *array_title = @[@"个人信息",@"修改密码",@"设置",@"关于",@"清除缓存",@"分享应用"];
    cell.leftImage.image = [UIImage imageNamed:array_img[indexPath.row]];
    cell.leftLabel.text = array_title[indexPath.row];
    if (indexPath.row == 4) {
        //获取图片缓存大小
        CGFloat size = [[SDImageCache sharedImageCache] getSize];
        CGFloat totalSize = size/1000.0/1000.0;
        cell.rightLabel.text = [NSString stringWithFormat:@"%.2f MB",totalSize];
        cell.rightLabel.textColor = ZSColorAllNotice;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //个人信息
    if (indexPath.row == 0)
    {
        ZSPersonalDetailViewController *personalDetailVC = [[ZSPersonalDetailViewController alloc]init];
        [self.navigationController pushViewController:personalDetailVC animated:YES];
    }
    //修改密码
    else if (indexPath.row == 1)
    {
        ZSChangePasswordViewController *ChangePasswordVC = [[ZSChangePasswordViewController alloc]init];
        [self.navigationController pushViewController:ChangePasswordVC animated:YES];
    }
    //设置
    else if (indexPath.row == 2)
    {
        ZSSettingViewController *settingVC = [[ZSSettingViewController alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    //关于
    else if (indexPath.row == 3)
    {
        ZSAboutViewController *aboutVC = [[ZSAboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    //清除缓存
    else if (indexPath.row == 4)
    {
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"确定要清除缓存吗?" sureTitle:@"确定" cancelTitle:@"取消"];
        alert.delegate = self;
        alert.tag = 100;
        [alert show];
    }
    //分享
    else if (indexPath.row == 5)
    {
        BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
        BOOL hadInstalledQQ     = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
        if (!hadInstalledWeixin && !hadInstalledQQ){
            [ZSTool showMessage:@"请先安装微信或QQ" withDuration:DefaultDuration];
        }else{
            [self shareAPP];
        }
    }
}

#pragma mark 点击头像
- (void)bigImgShow:(UITapGestureRecognizer*)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    if (imageView.image) {
        // 1. 创建photoBroseView对象
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        //2.赋值
        ZSUidInfo *userInfo = [ZSTool readUserInfo];
        if (userInfo.headPhoto) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,userInfo.headPhoto]];
        }else{
            photoBroseView.images = @[[UIImage imageNamed:@"my_head_portrait_n"]];
        }
        photoBroseView.showFromView = tap.view;
        photoBroseView.hiddenToView = tap.view;
        photoBroseView.currentIndex = 0;
        // 3.显示(浏览)
        [photoBroseView show];
    }
}

#pragma mark 分享
- (void)shareAPP
{
    NSString *title = @"小房主金福应用下载";
    NSString *describe = @"小房主金福APP下载，客户管理、录入资料更方便！";
    //    NSString *webpageUrl = @"https://itunes.apple.com/app/id1246638083";
    NSString *webpageUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zhishi.xdzjinfu";
    UIImage  *image = ImageName(@"about_logo_n");
    
    //设置平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),]];
    
    //创建分享
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:describe thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = webpageUrl;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            // [self alertWithError:error];
        }];
    }];
}

#pragma mark 退出
- (void)loginOutClick
{
    ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"确定要退出吗?" sureTitle:@"确定" cancelTitle:@"取消"];
    alert.delegate = self;
    alert.tag = 110;
    [alert show];
}

- (void)AlertView:(ZSAlertView *)alert
{
    if (alert.tag == 100)
    {
        __weak typeof(self) weakSelf = self;
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [ZSTool showMessage:@"清除成功" withDuration:DefaultDuration];
            [weakSelf.tableView reloadData];
        }];
    }
    else if (alert.tag == 110)
    {
        //退出登录,清空用户信息
        NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent:KCurrentUserInfo];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath1 error:nil];
        //清除token
        [USER_DEFALT setObject:@"" forKey:tokenForApp];
        //清除推送注册别名
        [NOTI_CENTER postNotificationName:KClearUserAliasToJpush object:nil];
        //跳转至登录页
        ZSLogInViewController *logInVC = [[ZSLogInViewController alloc]init];
        [self presentViewController:logInVC animated:YES completion:nil];
    }
}

#pragma mark tableView滑动,修改日签View的提示
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -120)
    {
        self.daySignView.noticeLabel.text = hilightString;
    }
    else
    {
        self.daySignView.noticeLabel.text = normalString;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);
{
    if (scrollView.contentOffset.y <= -120)
    {
        ZSCalendarViewController *calendarVC = [[ZSCalendarViewController alloc]init];
        //创建动画
        CATransition *animation = [CATransition animation];
        //设置运动轨迹的速度
        //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
        //设置动画类型为立方体动画
        animation.type = @"moveIn";
        //设置动画时长
        animation.duration = 0.5f;
        //设置运动的方向
        animation.subtype = kCATransitionFromBottom;
        //控制器间跳转动画
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
        [self.navigationController pushViewController:calendarVC animated:NO];
    }
}

@end
