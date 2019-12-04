//
//  ZSShareManager.m
//  ZSYuegeche
//
//  Created by 武 on 2017/7/10.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSShareManager.h"
#import "ZSShareView.h"
#import <UShareUI/UShareUI.h>
@implementation ZSShareManager
+ (ZSShareManager*)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)shareOfcontroller:(UIViewController*)VC WithTitle:(NSString*)title Describe:(NSDictionary*)descri shareUrl:(NSString*)shareUrl thumb:(id)image {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSString *desccriContent;
        if (platformType==UMSocialPlatformType_WechatSession||platformType==UMSocialPlatformType_QQ) {
            desccriContent=descri[@"chat"];
        }else if (platformType==UMSocialPlatformType_WechatTimeLine||platformType==UMSocialPlatformType_Qzone){
            desccriContent=descri[@"timeLine"];
        }else{
            desccriContent=descri[@"sina"];
        }
        [self shareWebPageToPlatformType:platformType WithTitle:title Describe:desccriContent shareUrl:shareUrl thumb:image controller:VC];
    }];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType WithTitle:(NSString*)title Describe:(NSString*)descri shareUrl:(NSString*)shareUrl thumb:(id)image controller:(UIViewController*)controller
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descri thumImage:image];
    //设置网页地址
    shareObject.webpageUrl = shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
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
}
- (void)shareOfcontroller:(UIViewController*)VC {
//- (void)shareOfcontroller:(UIViewController*)VC WithTitle:(NSString*)title Describe:(NSDictionary*)descri shareUrl:(NSString*)shareUrl thumb:(id)image {
    self.viewcontroller = VC;
    NSMutableArray *titlearr = [[NSMutableArray alloc]init];
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];

//    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
//    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
//    if (hadInstalledWeixin){ //安装微信
//        if (hadInstalledQQ){ //安装qq
//        titlearr = @[@"微信好友",@"朋友圈",@"QQ",@"QQ空间"].mutableCopy;
//        imageArr = @[@"home_roommortgage_n",@"home_roommortgage_n",@"home_roommortgage_n",@"home_roommortgage_n"].mutableCopy;
//        }else {//未安装qq
//            titlearr = @[@"微信好友",@"朋友圈"].mutableCopy;
//            imageArr = @[@"home_roommortgage_n",@"home_roommortgage_n"].mutableCopy;
//        }
//    }else {
//        if (hadInstalledQQ){ //安装qq
//            titlearr = @[@"QQ",@"QQ空间"].mutableCopy;
//            imageArr = @[@"home_roommortgage_n",@"home_roommortgage_n"].mutableCopy;
//
//        }else {//未安装qq
//            titlearr = @[@"微信好友"].mutableCopy;
//            imageArr = @[@"home_roommortgage_n"].mutableCopy;
//        }
//    }
    titlearr = @[@"微信好友",@"朋友圈",@"QQ",@"QQ空间"].mutableCopy;
    imageArr = @[@"home_roommortgage_n",@"home_roommortgage_n",@"home_roommortgage_n",@"home_roommortgage_n"].mutableCopy;
   self.shareView = [[ZSShareView alloc]initWithFrame:CGRectMake(0,0, ZSWIDTH, ZSHEIGHT) withArray:titlearr];
    self.shareView.tag = 1002;
    self.shareView.titleArray = titlearr;
    self.shareView.imgViewArray = imageArr;
    self.shareView.delegate = self;
    [self.shareView show];
}

- (void)currentSelectTiemTitle:(NSString *)title {
    [self.shareView dismiss];
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    NSInteger type = -1;

    if ([title isEqualToString:@"微信好友"]) {
        if (hadInstalledWeixin){
            type = UMSocialPlatformType_WechatSession;
        }else {
            [ZSTool showMessage:@"未安装微信" withDuration:DefaultDuration];
            return;
        }
    }
    if ([title isEqualToString:@"朋友圈"]){
        if (hadInstalledWeixin){
            type = UMSocialPlatformType_WechatTimeLine;
        }else {
            [ZSTool showMessage:@"未安装微信" withDuration:DefaultDuration];
            return;
        }
    }
    if ([title isEqualToString:@"QQ"]){
        if (hadInstalledQQ){
            type = UMSocialPlatformType_QQ;
        }else {
            [ZSTool showMessage:@"未安装QQ" withDuration:DefaultDuration];
            return;
        }
    }
    if ([title isEqualToString:@"QQ空间"]){
        if (hadInstalledQQ){
            type = UMSocialPlatformType_Qzone;
        }else {
            [ZSTool showMessage:@"未安装QQ" withDuration:DefaultDuration];
            return;
        }
    }
    [self shareWebPageToPlatformType:type WithTitle:@"小房主金福应用下载" Describe:@"小房主金福APP下载，客户管理、录入资料更方便！" shareUrl:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.zhishi.xdzjinfu" thumb:ImageName(@"share_icon.jpg") controller:self.viewcontroller];
}
//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType WithTitle:(NSString*)title Describe:(NSString*)descri shareUrl:(NSString*)shareUrl thumb:(id)image controller:(UIViewController*)controller
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建网页内容对象
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descri thumImage:image];
//    //设置网页地址
//    shareObject.webpageUrl = shareUrl;
//    
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
//        if (error) {
//            
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//        // [self alertWithError:error];
//    }];
//}

@end
