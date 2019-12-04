//
//  VeCardInfo.h
//  idcard
//
//  Created by z on 15/6/29.
//  Copyright (c) 2015年 hxg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//是否获取整个行驶证图片
#define GET_FULLIMAGE 1
//是否展示logo
#define DISPLAY_LOGO_VE 1

@interface VeCardInfo : NSObject
{
}
/*
char szPlateNo[64];				//号牌号码
char szVehicleType[64];			//车辆类型
char szOwner[128];				//所有人
char szAddress[256];			//住址
char szModel[64];				//品牌型号
char szUseCharacter[64];		//使用性质
char szEngineNo[64];			//发动机号
char szVIN[64];					//车辆识别代码
char szRegisterData[32];		//注册日期
char szIssueData[32];			//发证日期
//////////////////////////////////////////////////////////////////////////
//以下矩形是相对于整个stdimage的坐标系
TRect rtPlateNo;
TRect rtVehicleType;
TRect rtOwner;
TRect rtAddress;
TRect rtModel;
TRect rtUseCharacter;
TRect rtEngineNo;
TRect rtVIN;
TRect rtRegisterDate;
TRect rtIssueDate;
//////////////////////////////////////////////////////////////////////////
TRect rtTitle; //标题
TRect rtBound; //证在大图中位置
//////////////////////////////////////////////////////////////////////////
int nConfNum;
int nUnConfNum; //整张识别可信度
float fzoom;
float fAngle;	//skew整张图像

int type; //1: 2010年之后的， 2：之前的
int nPosRgt; //顺带求一下PlateNo 右边
*/

@property (copy, nonatomic) NSString *plateNo; //号牌号码
@property (copy, nonatomic) NSString *vehicleType; //车辆类型
@property (copy, nonatomic) NSString *owner; //所有人
@property (copy, nonatomic) NSString *address; //住址
@property (copy, nonatomic) NSString *model; //品牌型号
@property (copy, nonatomic) NSString *useCharacter; //使用性质
@property (copy, nonatomic) NSString *engineNo; //发动机号
@property (copy, nonatomic) NSString *VIN; //车辆识别代码(车架号)
@property (copy, nonatomic) NSString *registerDate; //注册日期
@property (copy, nonatomic) NSString *issueDate; //发证日期

@property UIImage* fullImg;
//是否显示结果页
+(BOOL) getNoShowVEResultView;
+(void) setNoShowVEResultView:(BOOL)bShow;
//是否显示号牌号码
+(BOOL) getNoShowVEplateNo;
+(void) setNoShowVEplateNo:(BOOL)bShow;
//是否显示车辆类型
+(BOOL) getNoShowVEvehicleType;
+(void) setNoShowVEvehicleType:(BOOL)bShow;
//是否显示所有人
+(BOOL) getNoShowVEowner;
+(void) setNoShowVEowner:(BOOL)bShow;
//是否显示住址
+(BOOL) getNoShowVEaddress;
+(void) setNoShowVEaddress:(BOOL)bShow;
//是否显示品牌型号
+(BOOL) getNoShowVEmodel;
+(void) setNoShowVEmodel:(BOOL)bShow;
//是否显示使用性质
+(BOOL) getNoShowVEuseCharacter;
+(void) setNoShowVEuseCharacter:(BOOL)bShow;
//是否显示发动机号
+(BOOL) getNoShowVEengineNo;
+(void) setNoShowVEengineNo:(BOOL)bShow;
//是否显示车辆识别代码
+(BOOL) getNoShowVEvin;
+(void) setNoShowVEvin:(BOOL)bShow;
//是否显示注册日期
+(BOOL) getNoShowVEregisterDate;
+(void) setNoShowVEregisterDate:(BOOL)bShow;
//是否显示发证日期
+(BOOL) getNoShowVEissueDate;
+(void) setNoShowVEissueDate:(BOOL)bShow;

- (NSString *)toString;
- (BOOL)isOK;
@end
