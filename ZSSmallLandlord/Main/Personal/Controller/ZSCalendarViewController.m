//
//  ZSCalendarViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/9/3.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSCalendarViewController.h"
#import "ZSDaySignBigView.h"
#import <UShareUI/UShareUI.h>

@interface ZSCalendarViewController ()
@property (nonatomic,strong)UIButton          *leftButton;
@property (nonatomic,strong)UIScrollView      *bgScrollView;
@property (nonatomic,strong)ZSDaySignBigView  *daySignView;
@property (nonatomic,strong)UIView            *daySignHiddenView;
@property (nonatomic,strong)UIView            *shareBackgroundView;
@property (nonatomic,strong)UIView            *shareHiddenView;
@property (nonatomic,strong)UIImage           *shareImage;
@end

@implementation ZSCalendarViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启返回手势
    [self openInteractivePopGestureRecognizerEnable];
    //导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[ZSTool createImageWithColor:ZSColorWhite] forBarPosition:UIBarPositionAny  barMetrics:UIBarMetricsDefault];
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.view.backgroundColor = ZSColorWhite;
    [self configureNavBar];
    [self configureDaySignView];
    [self configureShareView];
    [self configureShareHiddenView];
    //Data
    [self getDaySignUrl];
}

#pragma mark 获取日签信息
- (void)getDaySignUrl
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getDaySignUrl] SuccessBlock:^(NSDictionary *dic) {
        NSDictionary *dict = dic[@"respData"];
        ZSDaySignModel *model = [ZSDaySignModel yy_modelWithDictionary:dict];
        //赋值
        [weakSelf.daySignView fillinData:model];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark navgationBar
- (void)configureNavBar
{
    //导航栏
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, kNavigationBarHeight)];
    navView.backgroundColor = ZSColorWhite;
    [self.view addSubview:navView];
    
    //返回按钮
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, kStatusBarHeight, 44, 44);
    [self.leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, (44-20)/2, 20, 20)];
    backImg.image = [UIImage imageNamed:@"tool_guanbi_n"];
    [self.leftButton addSubview:backImg];
    [navView addSubview:self.leftButton];
}

- (void)leftAction
{
//    //创建动画
//    CATransition *animation = [CATransition animation];
////    //设置运动轨迹的速度
////    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    //设置动画类型为立方体动画
//    animation.type = @"moveIn";
//    //设置动画时长
//    animation.duration = 0.35f;
//    //设置运动的方向
//    animation.subtype = kCATransitionFromTop;
//    //控制器间跳转动画
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark /*---------------------------------------日签view--------------------------------------------*/
- (void)configureDaySignView
{
    //底部scroll
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, 440)];
    self.bgScrollView.bounces = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.contentSize = CGSizeMake(0, 440);
    [self.view addSubview:self.bgScrollView];
    
    //创建日签view
    self.daySignView = [[ZSDaySignBigView alloc]initWithFrame:CGRectMake(20, 20, ZSWIDTH-40, 400)];
    self.daySignView.backgroundColor = ZSColorWhite;
    self.daySignView.layer.cornerRadius = 10;
    self.daySignView.layer.shadowColor = ZSColorListRight.CGColor;
    self.daySignView.layer.shadowOffset = CGSizeMake(2, 5);
    self.daySignView.layer.shadowOpacity = 0.5;
    self.daySignView.layer.shadowRadius = 5;
    [self.bgScrollView addSubview:self.daySignView];
    
    //分享展示背景View
    self.daySignHiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, 400, ZSWIDTH-40, 60)];
    self.daySignHiddenView.hidden = YES;
    [self.daySignView addSubview:self.daySignHiddenView];
  
    //分享展示背景View-名字
    ZSUidInfo *userInfo = [ZSTool readUserInfo];
    CGFloat width = [ZSTool getStringWidth:userInfo.username withframe:CGSizeMake(ZSWIDTH-40-50, 40) withSizeFont:[UIFont systemFontOfSize:16]];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.daySignHiddenView.width-width-50)/2+50, 0, width, 40)];
    nameLabel.textColor = ZSColorListLeft;
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.text = userInfo.username;
    [self.daySignHiddenView addSubview:nameLabel];
    
    //分享展示背景View-头像
    UIImageView *headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.left-50, 0, 40, 40)];
    headIcon.layer.cornerRadius = 20;
    headIcon.layer.masksToBounds = YES;
    headIcon.userInteractionEnabled = YES;
    headIcon.contentMode = UIViewContentModeScaleAspectFill;
    [headIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,userInfo.headPhoto]] placeholderImage:[UIImage imageNamed:@"my_head_portrait_n"]];
    [self.daySignHiddenView addSubview:headIcon];
}

- (void)showSelfHeadicon:(BOOL)isShow
{
    if (isShow == YES)
    {
        //分享
        self.leftButton.hidden = YES;
        self.daySignHiddenView.hidden = NO;
        self.daySignView.height = 460;
        self.bgScrollView.height = 500;
        self.bgScrollView.contentSize = CGSizeMake(0, 500);
        self.shareBackgroundView.hidden = YES;
        self.shareHiddenView.hidden = NO;
    }
    else
    {
        //不分享
        self.leftButton.hidden = NO;
        self.daySignHiddenView.hidden = YES;
        self.daySignView.height = 400;
        self.bgScrollView.height = 440;
        self.bgScrollView.contentSize = CGSizeMake(0, 440);
        self.shareBackgroundView.hidden = NO;
        self.shareHiddenView.hidden = YES;
    }
}

#pragma mark /*---------------------------------------分享view--------------------------------------------*/
- (void)configureShareView
{
    self.shareBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT-kNavigationBarHeight-100-SafeAreaBottomHeight, ZSWIDTH, 100)];
    self.shareBackgroundView.hidden = NO;
    [self.view addSubview:self.shareBackgroundView];
    
    //文字
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 40)];
    noticeLabel.font = [UIFont systemFontOfSize:14];
    noticeLabel.textColor = ZSColorListLeft;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.text = @"分享给好友开始一天的好运气";
    [self.shareBackgroundView addSubview:noticeLabel];
    
    //微信好友按钮
    UIButton *WXfriendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    WXfriendsBtn.frame = CGRectMake((ZSWIDTH-88)/3, 40, 44, 44);
    [WXfriendsBtn setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [WXfriendsBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    WXfriendsBtn.tag = 0;
    [self.shareBackgroundView addSubview:WXfriendsBtn];
    
    //微信朋友圈按钮
    UIButton *WXCircleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    WXCircleBtn.frame = CGRectMake(WXfriendsBtn.right+(ZSWIDTH-88)/3, 40, 44, 44);
    [WXCircleBtn setImage:[UIImage imageNamed:@"friends"] forState:UIControlStateNormal];
    [WXCircleBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    WXCircleBtn.tag = 1;
    [self.shareBackgroundView addSubview:WXCircleBtn];
}

- (void)configureShareHiddenView
{
    self.shareHiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT-kNavigationBarHeight-100, ZSWIDTH, 100)];
    self.shareHiddenView.backgroundColor = ZSColorWhite;
    self.shareHiddenView.hidden = YES;
    [self.view addSubview:self.shareHiddenView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ZSWIDTH-80-10)/2, 0, 40, 40)];
    imageView.image = [UIImage imageNamed:@"newAPP_logo"];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    [self.shareHiddenView addSubview:imageView];
    
    UIImageView *imageViewCode = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.right+10, 0, 40, 40)];
    imageViewCode.image = [UIImage imageNamed:@"new_qrcode"];
    [self.shareHiddenView addSubview:imageViewCode];
    
    //文字
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, ZSWIDTH, 40)];
    noticeLabel.font = [UIFont systemFontOfSize:14];
    noticeLabel.textColor = ZSColorListLeft;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.text = @"下载小房主APP 好赚钱";
    [self.shareHiddenView addSubview:noticeLabel];
}

#pragma mark 分享
- (void)shareAction:(UIButton *)sender
{
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    if (!hadInstalledWeixin)
    {
        [ZSTool showMessage:@"请先安装微信" withDuration:DefaultDuration];
    }
    else
    {
        //设置需要分享的图片
        [self showSelfHeadicon:YES];
        self.shareImage = self.shareImage ? self.shareImage : [self nomalSnapshotImage:self.view];
        //分享平台
        UMSocialPlatformType platformType = sender.tag == 0 ? UMSocialPlatformType_WechatSession : UMSocialPlatformType_WechatTimeLine;
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //设置图片
        [shareObject setShareImage:self.shareImage];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
        
        //恢复正常
        [self showSelfHeadicon:NO];
    }
}

#pragma mark 对指定视图进行截图
- (UIImage *)nomalSnapshotImage:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
