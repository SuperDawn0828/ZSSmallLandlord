//
//  VeCardInfo.m
//  idcard
//
//  Created by z on 15/6/29.
//  Copyright (c) 2015年 hxg. All rights reserved.
//

#import "VeCardInfo.h"

static BOOL bNoShowVEResultView = NO;
static BOOL bNoShowVEplateNo = NO;
static BOOL bNoShowVEvehicleType = NO;
static BOOL bNoShowVEowner = NO;
static BOOL bNoShowVEaddress = NO;
static BOOL bNoShowVEmodel = NO;
static BOOL bNoShowVEuseCharacter = NO;
static BOOL bNoShowVEengineNo = NO;
static BOOL bNoShowVEvin = NO;
static BOOL bNoShowVEregisterDate = NO;
static BOOL bNoShowVEissueDate = NO;
//static BOOL bNoShowVEFullImg = NO;

@implementation VeCardInfo
//是否显示结果页
+(BOOL) getNoShowVEResultView
{
    return bNoShowVEResultView;
}
+(void) setNoShowVEResultView:(BOOL)bShow
{
    bNoShowVEResultView = bShow;
}
//是否显示号牌号码
+(BOOL) getNoShowVEplateNo
{
    return bNoShowVEplateNo;
}
+(void) setNoShowVEplateNo:(BOOL)bShow
{
    bNoShowVEplateNo = bShow;
}
//是否显示车辆类型
+(BOOL) getNoShowVEvehicleType
{
    return bNoShowVEvehicleType;
}
+(void) setNoShowVEvehicleType:(BOOL)bShow
{
    bNoShowVEvehicleType = bShow;
}
//是否显示所有人
+(BOOL) getNoShowVEowner
{
    return bNoShowVEowner;
}
+(void) setNoShowVEowner:(BOOL)bShow
{
    bNoShowVEowner = bShow;
}
//是否显示住址
+(BOOL) getNoShowVEaddress
{
    return bNoShowVEaddress;
}
+(void) setNoShowVEaddress:(BOOL)bShow
{
    bNoShowVEaddress = bShow;
}
//是否显示品牌型号
+(BOOL) getNoShowVEmodel
{
    return bNoShowVEmodel;
}
+(void) setNoShowVEmodel:(BOOL)bShow
{
    bNoShowVEmodel = bShow;
}
//是否显示使用性质
+(BOOL) getNoShowVEuseCharacter
{
    return bNoShowVEuseCharacter;
}
+(void) setNoShowVEuseCharacter:(BOOL)bShow
{
    bNoShowVEuseCharacter = bShow;
}
//是否显示发动机号
+(BOOL) getNoShowVEengineNo
{
    return bNoShowVEengineNo;
}
+(void) setNoShowVEengineNo:(BOOL)bShow
{
    bNoShowVEengineNo = bShow;
}
//是否显示车辆识别代码
+(BOOL) getNoShowVEvin
{
    return bNoShowVEvin;
}
+(void) setNoShowVEvin:(BOOL)bShow
{
    bNoShowVEvin = bShow;
}
//是否显示注册日期
+(BOOL) getNoShowVEregisterDate
{
    return bNoShowVEregisterDate;
}
+(void) setNoShowVEregisterDate:(BOOL)bShow
{
    bNoShowVEregisterDate = bShow;
}
//是否显示发证日期
+(BOOL) getNoShowVEissueDate
{
    return bNoShowVEissueDate;
}
+(void) setNoShowVEissueDate:(BOOL)bShow
{
    bNoShowVEissueDate = bShow;
}

- (NSString *)toString
{
    /*
    @property (copy, nonatomic) NSString *plateNo; //号牌号码
    @property (copy, nonatomic) NSString *vehicleType; //车辆类型
    @property (copy, nonatomic) NSString *owner; //所有人
    @property (copy, nonatomic) NSString *address; //住址
    @property (copy, nonatomic) NSString *model; //品牌型号
    @property (copy, nonatomic) NSString *useCharacter; //使用性质
    @property (copy, nonatomic) NSString *engineNo; //发动机号
    @property (copy, nonatomic) NSString *VIN; //车辆识别代码
    @property (copy, nonatomic) NSString *registerDate; //注册日期
    @property (copy, nonatomic) NSString *issueDate; //发证日期
    */
    
    return [NSString stringWithFormat:@"号牌号码:%@\n车辆型号:%@\n所有人:%@\n住址:%@\n品牌型号:%@\n使用性质:%@\n发动机号:%@\n车辆识别代码:%@\n注册日期:%@\n发证日期:%@",
            _plateNo, _vehicleType, _owner, _address, _model, _useCharacter, _engineNo, _VIN, _registerDate,_issueDate];
}
- (BOOL)isOK
{
    if (_plateNo !=nil && _vehicleType!=nil && _owner!=nil && _address!=nil && _model!=nil && _useCharacter!=nil && _engineNo!=nil && _VIN!=nil && _registerDate!=nil && _issueDate!=nil)
    {
        if (_plateNo.length>0 && _vehicleType.length >0 && _owner.length>0 && _address.length>0 && _model.length>0 && _useCharacter.length>0 && _engineNo.length>0 && _VIN.length>0 && _registerDate.length>0 && _issueDate.length>0)
        {
            return true;
        }
    }
    return false;
}
@end
