//
//  ZSGetAPIViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/11.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSGetAPIViewController.h"
#import "ZSTabBarViewController.h"
#import "ZSLogInViewController.h"

@interface ZSGetAPIViewController ()
@property (nonatomic,strong)UIImageView *imgView;
@end

@implementation ZSGetAPIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initImgView];
    [self getAPIAddress];
}

- (void)initImgView
{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    self.imgView.image = [UIImage imageNamed:@"apiimage_1242x2208"];
    [self.view addSubview:self.imgView];
}

- (void)getAPIAddress
{
    NSMutableDictionary *parameterDict = @{@"category":[NSString stringWithFormat:@"appServicePath%@",[ZSTool localVersionShort]]}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getAppAccessURL] SuccessBlock:^(NSDictionary *dic) {
        NSString *zsurlHead = [NSString stringWithFormat:@"%@",dic[@"respData"]];
        if (!zsurlHead.length) {
            return;
        }
        //1.服务器地址未更换
        if ([zsurlHead isEqualToString:KPreProductionUrl] || [zsurlHead isEqualToString:[NSString stringWithFormat:@"%@/",KPreProductionUrl]] ||
            [zsurlHead isEqualToString:KPreProductionUrl_port] || [zsurlHead isEqualToString:[NSString stringWithFormat:@"%@/",KPreProductionUrl_port]])
        {
            ZSUidInfo *userInfo = [ZSTool readUserInfo];
            if (userInfo.userid) {
                ZSTabBarViewController *tabbarVC = [[ZSTabBarViewController alloc]init];
                APPDELEGATE.window.rootViewController = tabbarVC;
            }
            else
            {
                //1.2 未登录
                APPDELEGATE.window.rootViewController = [[ZSLogInViewController alloc]init];
            }
        }
        //2.更换接口地址,并保存
        else
        {
            APPDELEGATE.zsurlHead  = zsurlHead;
            APPDELEGATE.zsImageUrl = KFormalServerImgUrl;
            [USER_DEFALT setObject:zsurlHead forKey:APIAddress];
            [USER_DEFALT setObject:KFormalServerImgUrl forKey:APIImgAddress];
            //2.1 更换成功后重新登录
            APPDELEGATE.window.rootViewController = [[ZSLogInViewController alloc]init];
        }
        //3.发送版本更新检查的通知
        [NOTI_CENTER postNotificationName:KSCheckVerisonUpdate object:nil];
    }
    ErrorBlock:^(NSError *error)
    {

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
