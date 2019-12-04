//
//  ZSGlobalModel.h
//  ZSMoneytocar
//
//  Created by 武 on 2016/10/13.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZSBanklistModel.h"
#import "ZSProductListModel.h"
#import "ZSAllListModel.h"
#import "ZSWSOrderDetailModel.h"
#import "ZSProvinceModel.h"
#import "ZSLoanBankListModel.h"
#import "ZSSLOrderdetailsModel.h"
#import "ZSSLMaterialCollectModel.h"
#import "ZSRFOrderDetailsModel.h"
#import "ZSMLOrderdetailsModel.h"
#import "ZSCHOrderdetailsModel.h"
#import "ZSABOrderdetailsModel.h"
#import "ZSDynamicDataModel.h"
#import "ZSPCOrderDetailModel.h"
#import "ZSELOrderdetailsModel.h"

#pragma mark 服务器地址
//测试服务器
static NSString *const KTestServerUrl             = @"http://test.xiaofangzhu.com/house-api";
static NSString *const KTestServerImgUrl          = @"http://test.xiaofangzhu.com:4869/";
static NSString *const KTestServerImgUploadUrl    = @"http://120.79.255.107:4869/upload";//图片上传地址
//预生产服务器(带端口号)
static NSString *const KPreProductionUrl          = @"http://www.xiaofangzhu.com:8081/house-api";
static NSString *const KPreProductionUrl_port     = @"http://39.108.66.81:8081/house-api";
static NSString *const KPreProductionImgUrl       = @"http://39.108.66.81:4869/";
static NSString *const KPreProductionImgUploadUrl = @"http://39.108.66.81:4869/upload";//图片上传地址(预生产和生产一样)
//正式服务器(不带端口号)
static NSString *const KFormalServerUrl           = @"http://www.xiaofangzhu.com/house-api";
static NSString *const KFormalServerUrl_port      = @"http://39.108.66.81/house-api";
static NSString *const KFormalServerImgUrl        = @"http://39.108.66.81:4869/";

#pragma mark 无数据---枚举
typedef NS_ENUM(NSUInteger, ZSErrorStyle) {
    ZSErrorWithoutOrder = 0,   //订单列表无订单
    ZSErrorCompletedOrder,     //订单列表已完成订单
    ZSErrorClosedOrder,        //订单列表已关闭订单
    ZSErrorSearchNoData,       //搜索无数据
    ZSErrorNotificationNoData, //通知无数据
    ZSErrorWithoutOrderOfBank, //银行后勤首页列表无订单
    ZSErrorWithoutUploadFiles, //上传图片界面没数据
    ZSErrorWithoutrecords    , //新房见证资料收集记录没数据
    ZSErrorWithoutDelete,      //已删除的订单详情
    ZSErrorWithoutCustomReport,//报表列表
};

#pragma mark 订单状态
typedef NS_ENUM(NSUInteger, OrderState) {
    ToSubmitCreditReportingFeedback  = 1,  //待提交征信查询
    CreditReportingResultForFeedback = 2,  //待反馈征信结果
    InTheDataCollection = 3,               //资料收集中
    BankInTheAudit = 4,                    //银行审核中
    HasBeenLending = 5,                    //已放款
    HasBeenCompleted = 6,                  //已完成
    HasBeenClosed = 7,                     //已关闭
};

#pragma mark 照片裁剪枚举
typedef NS_ENUM(NSInteger, TOCropViewControllerAspectRatioPreset)
{
    TOCropViewControllerAspectRatioPresetOriginal,
    TOCropViewControllerAspectRatioPresetSquare,
    TOCropViewControllerAspectRatioPreset3x2,
    TOCropViewControllerAspectRatioPreset5x3,
    TOCropViewControllerAspectRatioPreset4x3,
    TOCropViewControllerAspectRatioPreset5x4,
    TOCropViewControllerAspectRatioPreset7x5,
    TOCropViewControllerAspectRatioPreset16x9,
    TOCropViewControllerAspectRatioPresetCustom
};

#pragma mark 添加资料样式
typedef NS_ENUM(NSUInteger, ZSAddResourceDataStyle) {
    ZSAddResourceDataOne = 0,                //每种细分资料只能添加一张照片
    ZSAddResourceDataTwo,                    //每种细分资料只能添加两张照片
    ZSAddResourceDataCountless,              //每种细分资料能添加无数张照片
};

#pragma mark 缓存路径
static NSString *KCurrentUserInfo                                      = @"Documents/userInfo.plist";               //当前登录用户的信息
static NSString *KAllListSearch                                        = @"Documents/allListSearch.text";           //主首页订单列表搜索
static NSString *KBankHomeSearch                                       = @"Documents/bankHomeSearch.text";          //副首页订单列表搜索
static NSString *KWitnessServerSearch                                  = @"Documents/witnessServerSearch.text";     //新房见证订单列表搜索
static NSString *KStarLoanSearch                                       = @"Documents/starLoanSearch.text";          //星速贷订单列表搜索
static NSString *KRedeemFloorSearch                                    = @"Documents/redeemFloorSearch.text";       //赎楼宝订单列表搜索
static NSString *KMortgageLoanSearch                                   = @"Documents/mortgageLoanSearch.text";      //抵押贷订单列表搜索
static NSString *KEasyLoanSearch                                       = @"Documents/easyLoanSearch.text";          //融易贷订单列表搜索
static NSString *KCarHireSearch                                        = @"Documents/carHireSearch.text";           //车位分期订单列表搜索
static NSString *KAgencyBusinessSearch                                 = @"Documents/agencyBusiness.text";          //车位分期订单列表搜索
static NSString *KApplyforOnlineSearch                                 = @"Documents/applyforOnlineSeach.text";     //微信申请列表搜索
static NSString *KPreliminaryCreditSearch                              = @"Documents/preliminaryCreditSeach.text";  //预授信列表搜索
static NSString *KTheMediationSearch                                   = @"Documents/theMediationSeach.text";       //中介端跟进搜索
static NSString *KOrderDetailDataSearch                                = @"Documents/orderDetailDataSearch.text";   //订单详情资料列表搜索

#pragma mark 默认提示
static NSString *KPlaceholderChoose                                    = @"请选择";
static NSString *KPlaceholderInput                                     = @"请输入";
static NSString *KMaxAmount                                            = @"100000000.00";

#pragma mark 产品类型
static NSString *const kProduceTypeWitnessServer                       = @"1001";            //新房见证
static NSString *const kProduceTypeRedeemFloor                         = @"1080";            //赎楼宝
static NSString *const kProduceTypeStarLoan                            = @"1081";            //星速贷
static NSString *const kProduceTypeMortgageLoan                        = @"1084";            //抵押贷
static NSString *const kProduceTypeCarHire                             = @"1083";            //车位分期
static NSString *const kProduceTypeAgencyBusiness                      = @"1085";            //代办业务
static NSString *const kProduceTypeEasyLoans                           = @"1086";            //容易贷

#pragma mark 通知名称
//订单列表顶部title
static NSString *const KWitnessServer                                  = @"witnessServer"; //新房见证title
static NSString *const KStarLoan                                       = @"StarLoan";      //星速贷title
static NSString *const KRedeemFloor                                    = @"RedeemFloor";   //赎楼宝title
static NSString *const KMortgageLoan                                   = @"MortgageLoan";  //抵押贷title
static NSString *const KEasyLoan                                       = @"EasyLoan";      //融易贷title
static NSString *const KCarHire                                        = @"CarHire";       //车位分期title
static NSString *const KAgencyBusiness                                 = @"AgencyBusiness";//代办业务title
//订单列表
static NSString *const KSUpdateAllOrderListNotification                = @"KSUpdateAllOrderListNotification";              //所有订单列表
static NSString *const KSUpdateNotificationList                        = @"KSUpdateNotificationList";                      //通知列表
//订单详情
static NSString *const KSUpdateAllOrderDetailNotification              = @"KSUpdateAllOrderDetailNotification";            //订单详情
static NSString *const KSUpdateAllOrderDetailForNoSumbitNotification   = @"KSUpdateAllOrderDetailForNoSumbitNotification"; //订单详情(未提交)
static NSString *const kOrderDetailFreshDataNotification               = @"kOrderDetailFreshDataNotification";             //订单详情子控制器
static NSString *const kOrderDetailFreshMaterialDataNotification       = @"kOrderDetailFreshMaterialDataNotification";     //资料上传状态列表
static NSString *const kOrderDetailFreshPropertyData                   = @"kOrderDetailFreshPropertyData";                 //产权情况表
static NSString *const kOrderDetailDatalistScrollNotification          = @"kOrderDetailDatalistScrollNotification";        //通知资料列表滚动到指定cell
//其他
static NSString *const KuploadPhotoWithTimeout                         = @"uploadPhotoWithTimeout";//图片上传超时
static NSString *const KSCheckNoitfication                             = @"checkNoitfication";//是否开启推送
static NSString *const KSSendUserAliasToJpush                          = @"sendUserAliasToJpush";//登录成功后把用户的tid发送给极光,作为用户的alias
static NSString *const KClearUserAliasToJpush                          = @"clearUserAliasToJpush";
static NSString *const KSCheckVerisonUpdate                            = @"checkVerisonUpdate";//检测版本更新
static NSString *const KSChekTokenState                                = @"chekTokenState";//token失效提醒


#pragma mark 数据模型
@interface ZSGlobalModel : NSObject
//全局的
@property (nonatomic,strong)ZSBanklistModel          *banklistModel;                //银行名称
@property (nonatomic,strong)ZSProductListModel       *productlistModel;             //项目名称
@property (nonatomic,strong)ZSAllListModel           *allListModel;                 //列表信息
@property (nonatomic,strong)BizCustomers             *bizCustomers;                 //金融产品人员信息详情数据
//新房见证
@property (nonatomic,strong)ZSWSOrderDetailModel     *wsOrderDetail;                //新房见证订单详情
@property (nonatomic,strong)CustInfo                 *wsCustInfo;                   //新房见证人员信息详情数据
@property (nonatomic,strong)ZSProvinceModel          *provinceModel;                //省市区model
//星速贷
@property (nonatomic,strong)ZSSLOrderdetailsModel    *slOrderDetails;               //星速贷订单详情
@property (nonatomic,strong)ZSSLMaterialCollectModel *slMaterialCollectModel;       //金融产品资料收集列表数据
//赎楼宝
@property (nonatomic,strong)ZSRFOrderDetailsModel    *rfOrderDetails;               //赎楼宝订单详情
@property (nonatomic,strong)ZSSLMaterialCollectModel *rfMaterialCollectModel;       //赎楼宝资料收集列表数据
//抵押贷
@property (nonatomic,strong)ZSMLOrderdetailsModel    *mlOrderDetails;               //抵押贷订单详情
//车位分期
@property (nonatomic,strong)ZSCHOrderdetailsModel    *chOrderDetails;               //车位分期订单详情
//代办业务
@property (nonatomic,strong)ZSABOrderdetailsModel    *abOrderDetails;               //代办业务订单详情
//融易贷
@property (nonatomic,strong)ZSELOrderdetailsModel    *elOrderDetails;               //融易贷订单详情
//预授信报告
@property (nonatomic,strong)ZSPCOrderDetailModel     *pcOrderDetailModel;           //预授信报告订单详情
@property (nonatomic,strong)CustomersModel           *currentCustomer;              //预授信报告人员信息model
//网络状态
@property (nonatomic,assign)long                     netStatus;

+ (ZSGlobalModel*)shareInfo;

#pragma mark /*------------------------------产品类型 1081星速贷 1080赎楼宝 1084抵押贷 1083车位分期------------------------------*/
+ (NSArray  *)getProductArray;
+ (NSString *)getProductStateWithCode:(NSString *)product;
+ (NSString *)getProductCodeWithState:(NSString *)product;

#pragma mark /*------------------------------婚姻状况 1未婚 2已婚 3离异 4丧偶------------------------------*/
+ (NSArray  *)getMarrayStateArray;
+ (NSString *)getMarrayStateWithCode:(NSString *)beMarrage;
+ (NSString *)getMarrayCodeWithState:(NSString *)beMarrage;

#pragma mark /*------------------------------人员角色 1贷款人 2贷款人配偶 3配偶&共有人 4共有人 5担保人 6担保人配偶 7卖方 8卖方配偶------------------------------*/
+ (NSString *)getReleationStateWithCode:(NSString *)releation;
+ (NSString *)getReleationCodeWithState:(NSString *)releation;

#pragma mark /*------------------------------与贷款人关系 1朋友 2直系亲属 ------------------------------*/
+ (NSArray  *)getRelationshipStateArray;
+ (NSString *)getRelationshipStateWithCode:(NSString *)relationship;
+ (NSString *)getRelationshipCodeWithState:(NSString *)relationship;

#pragma mark /*------------------------------大数据风控/央行征信查询状态 1查询 其他不查询------------------------------*/
+ (NSString *)getBigDataStateWithCode:(NSString *)bigData;
+ (NSString *)getBigDataCodeWithState:(NSString *)bigData;

#pragma mark /*------------------------------是否可贷 1可贷 2不可贷------------------------------*/
+ (NSString *)getCanLoanStateWithCode:(NSString *)canLoan;
+ (NSString *)getCanLoanCodeWithState:(NSString *)canLoan;

#pragma mark /*------------------------------用户资质 1A类 2B类 3C类------------------------------*/
+ (NSString *)getCustomerQualificationStateWithCode:(NSString *)custQualification;
+ (NSString *)getCustomerQualificationCodeWithState:(NSString *)custQualification;

#pragma mark /*------------------------------报表查询时间 1当前月份 2最近30天 3最近100天 4最近一年 5全部订单------------------------------*/
+ (NSArray  *)getCustomReportTimeHorizonArray;
+ (NSString *)getCustomReportTimeHorizonStateWithCode:(NSString *)timeHorizon;
+ (NSString *)getCustomReportTimeHorizonCodeWithState:(NSString *)timeHorizon;

#pragma mark /*------------------------------------------根据产品类型获取订单ID 订单状态------------------------------------------*/
+ (NSString *)getOrderID:(NSString *)prdType;
+ (NSString *)getOrderState:(NSString *)prdType;

@end
