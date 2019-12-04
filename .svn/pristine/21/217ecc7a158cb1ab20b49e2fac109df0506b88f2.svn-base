//
//  Header.h
//  zuan
//
//  Created by zhouzhanpeng on 14-5-28.
//  Copyright (c) 2014年 Thousand Earn. All rights reserved.
//



#define ZS_Header_h
#ifdef DEBUG
#define ZSLOG(xx, ...)     NSLog(@"ZS<INFO>: " xx, ##__VA_ARGS__)
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define LSLog(...) printf("%s: %s 第%d行: %s\n\n",[[NSString lr_stringDate] UTF8String], [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#define ZSWarning(xx, ...) NSLog(@"ZS<Warning>:" xx, ##__VA_ARGS__)
#define ZSLOGData(data) ZSLOG(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding])
#else
#define ZSLOG(xx, ...) ((void)0)
#define ZSWarning(xx, ...) ((void)0)
#define ZSLOGData(data) ((void)0)
#endif

#define ZSAssignSafely(value) (((value) == nil) ? @"" : value)

#define SYSTEM_IOS7 [[UIDevice currentDevice].systemVersion floatValue]>= 7.0&[[UIDevice currentDevice].systemVersion floatValue]< 8.0
#define SYSTEM_IOS8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0
#define NOT_SYSTEM_IOS7 (!(SYSTEM_IOS7))

#define ZSTimeIntervalPerMin    60.0f
#define ZSTimeIntervalPerHour   (60 * ZSTimeIntervalPerMin)
#define ZSTimeIntervalPerDay    (24 * ZSTimeIntervalPerHour)

#define QiYe        //修改发布方式

#ifdef QiYe
#define QiYeOrAppStore(qiye, appstore) qiye
#endif

#ifdef AppStore
#define QiYeOrAppStore(qiye, appstore) appstore
#endif


/*
 *  System Versioning Preprocessor Macros
 */
#define  system_version  [[[UIDevice currentDevice] systemVersion] floatValue]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
/*
 * screen
 */

//相关提示
#define identifyImage                @"正在连接服务器"
#define SuccessSttring               @"连接成功"
#define FailureSttring               @"连接失败"
#define IdIsNotTheSame               @"身份不能相同"
#define SUPPORT_INFO                 @"小房主金福"
#define Camera_permissions           @"请在Iphone的“设置－隐私－相机”选项中，允许小房主金福访问你的相机"
#define IsIdCard                     @"身份证号码不正确"
#define IsIdCardS                    @"请输入正确的身份证号码"
#define IdSaveFailed                 @"身份证保存失败，请重新扫描"
#define PowerOfAttorneySaveFailed    @"授权书保存失败，请重新扫描"

//需要的类
#import "ZSBaseViewController.h"
#import "AFNetworking.h"
#import "AFSecurityPolicy.h"
#import "ZSUidInfo.h"
#import "ALView+PureLayout.h"
#import "ZSTool.h"
#import "ZSUIViewExt.h"
#import "MJRefresh.h"
#import "ZSGlobalModel.h"
#import "AppDelegate.h"
#import "ZSAlertView.h"
#import "ZSActionSheetView.h"
#import "ZSPickerView.h"
#import "ZSSelectView.h"
#import "FSTextView.h"
#import "ZSURLManager.h"
#import "LSProgressHUD.h"
#import "UIImage+add.h"
#import "objc/runtime.h"
#import "YYModel.h"
#import "NSString+add.h"
#import "UITextField+add.h"
#import "ZSRequestManager.h"
#import "ZSUIViewExt.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIButton+WebCache.h"
#import "ZSWSRightAlertView.h"
#import "ZSAlertView.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "AFSecurityPolicy.h"
#import "WKProgressHUD.h"
#import "ZSsmallControl.h"
#import "NSString+ReviseString.h"

//程序总委托
#define APPDELEGATE               ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define USER_DEFALT               [NSUserDefaults standardUserDefaults]
#define FILE_MANAGER              [NSFileManager defaultManager]
#define NOTI_CENTER               [NSNotificationCenter defaultCenter]
#define editionStr                @"zs-financial-1.1-normal"


//key名
#define APIAddress                @"API"           //API地址
#define APIImgAddress             @"APIImage"      //API图片地址
#define APIH5Address              @"APIH5"         //h5地址
#define tokenForApp               @"tokenForApp"   //用户token


//全局模型
#define global                    [ZSGlobalModel shareInfo]
#define defaultImage_square       [UIImage imageNamed:@"defaultImage_square"]
#define defaultImage_rectangle    [UIImage imageNamed:@"defaultImage_rectangle"]


//UI布局
#define IS_iPhoneX                            ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define UIScreenBounds                        [UIScreen mainScreen].bounds
#define ZSWIDTH                               [UIScreen  mainScreen].bounds.size.width
#define IS_IPHONE                             ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define SystemVersion                         [[UIDevice currentDevice].systemVersion floatValue]
#define kStatusBarHeight                      (IS_iPhoneX ? 44.f : 20.f)//状态栏高度
#define kNavigationBarHeight                  (IS_iPhoneX ? 88.f : 64.f)//导航栏高度
#define kTabbarHeight                         (IS_iPhoneX ? 83.f : 49.f)//tabbar的高度
#define SafeAreaBottomHeight                  (IS_iPhoneX ? 34 : 0)//iphoneX设置底部的按钮底部距离屏幕底部34即可
#define ZSHEIGHT                              [UIScreen mainScreen].bounds.size.height - SafeAreaBottomHeight //屏幕高度
#define ZSHEIGHT_PopupWindow                  [UIScreen mainScreen].bounds.size.height //屏幕高度

#define GapWidth                              10
#define CellHeight                            44 //cell的高度默认44
#define ImageRate                             0.5//照片压缩系数
#define viewTopHeight                         70 //创建订单顶部视图高度默认60


//RGB颜色
#define ZSColor(r, g, b)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ZSColorAlpha(r, g, b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ZSColorRed                UIColorFromRGB(0xFD7272)//主色调-红色
#define ZSColorRedHighlighted     UIColorFromRGB(0xE95046)//主色调-红色高亮
#define ZSColorListLeft           UIColorFromRGB(0x736B6B)//列表正文文字颜色(左边)
#define ZSColorListRight          UIColorFromRGB(0x262424)//列表输入完后的文字颜色(右边)
#define ZSColorAllNotice          UIColorFromRGB(0xB0B0B0)//提示文字颜色,例如-请输入姓名
#define ZSColorSecondTitle        UIColorFromRGB(0x8C8C8C)//二级标题颜色
#define ZSColorCanNotClick        UIColorFromRGB(0xC8C8C8)//按钮不可点击的颜色,此时文字为白色
#define ZSColorCutCell            UIColorFromRGB(0xF8F8F8)//分割cell的颜色
#define ZSColorLine               (IS_iPhoneX ? ZSColorAlpha(238,238,238,0.5) : ZSColorAlpha(238,238,238,1))//分割线
#define ZSViewBackgroundColor     UIColorFromRGB(0xF2F2F2)//背景色
#define ZSPageItemColor           UIColorFromRGB(0xA8A8A8)//page颜色
#define ZSColorOrange             UIColorFromRGB(0xFC8965)//橘色
#define ZSColorYellow             UIColorFromRGB(0xF8B763)//黄色
#define ZSColorGreen              UIColorFromRGB(0x2aca79)//绿色
#define ZSColorCyan               UIColorFromRGB(0x48D1CC)//青色
#define ZSColorBlue               UIColorFromRGB(0x38BDEF)//蓝色
#define ZSColorPurple             UIColorFromRGB(0x9370DB)//紫色
#define ZSColorPink               UIColorFromRGB(0xFFB6C1)//粉色
#define ZSColorDarkGray           UIColorFromRGB(0x1A1A1A)//深灰色
#define ZSColorGolden             UIColorFromRGB(0xBE9E5F)//金色
#define ZSColorWhite              [UIColor whiteColor]    //白色
#define ZSColorBlack              [UIColor blackColor]    //黑色


//字体
#define FontBtn                   [UIFont systemFontOfSize:15]//按钮文字大小
#define FontSecondTitle           [UIFont systemFontOfSize:14]//二级标题文字大小
#define FontNotice                [UIFont systemFontOfSize:13]//提示性文字
#define ImageName(a)              [UIImage imageNamed:a]


//数据验证
#define ValidStr(f)               StrValid(f)
#define StrValid(f)               (f!=nil &&[f isKindOfClass:[NSString class]]&& ![f isEqualToString:@""] && ![f isEqualToString:@"0"])
#define SafeStr(f)                (StrValid(f)?f:@"")
#define HasString(str,eky)        ([str rangeOfString:key].location!=NSNotFound)
#define ValidDict(f)              (f!=nil &&[f isKindOfClass:[NSDictionary class]])
#define ValidArray(f)             (f!=nil &&[f isKindOfClass:[NSArray class]]&&[f count]>0)
#define ValidNum(f)               (f!=nil &&[f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls)         (f!=nil &&[f isKindOfClass:[cls class]])
#define ValidData(f)              (f!=nil &&[f isKindOfClass:[NSData class]])


// View圆角
#define ViewRadius(View,Radius)\[View.layer setCornerRadius:(Radius)];\[View.layer setMasksToBounds:YES]


//拼接字符串
#define NSStringFormat(format,...)[NSString stringWithFormat:format,##__VA_ARGS__]


//property属性快速声明
#define PropertyString(s)         @property(nonatomic,copy)NSString * s
#define PropertyNSInteger(s)      @property(nonatomic,assign)NSIntegers
#define PropertyFloat(s)          @property(nonatomic,assign)floats
#define PropertyLongLong(s)       @property(nonatomic,assign)long long s
#define PropertyNSDictionary(s)   @property(nonatomic,strong)NSDictionary * s
#define PropertyNSArray(s)        @property(nonatomic,strong)NSArray * s
#define PropertyNSMutableArray(s) @property(nonatomic,strong)NSMutableArray * s


//强弱引用
#define kWeakSelf(type)__weak typeof(type)weak##type = type;

#define kStrongSelf(type)__strong typeof(type)type = weak##type;

