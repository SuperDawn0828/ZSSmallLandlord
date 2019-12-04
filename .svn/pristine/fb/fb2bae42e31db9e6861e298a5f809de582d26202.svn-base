//
//  ZSUidInfo.m
//  ZSMoneytocar
//
//  Created by cong on 16/7/26.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSUidInfo.h"
#import "ZSTool.h"
@implementation ZSUidInfo
+ (ZSUidInfo*)shareInfo{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//编码方法，当对象被编码成二进制数据时调用。
- (void)encodeWithCoder:(NSCoder *)aCoder{
    //在编码方法中，需要对对象的每一个属性进行编码。
    [aCoder encodeObject:_beNotice                    forKey:@"beNotice"];
    [aCoder encodeObject:_birthday                    forKey:@"birthday"];
    [aCoder encodeObject:_branchCropName              forKey:@"branchCropName"];
    [aCoder encodeObject:_companyId                   forKey:@"companyId"];
    [aCoder encodeObject:_createDate                  forKey:@"createDate"];
    [aCoder encodeObject:_headPhoto                   forKey:@"headPhoto"];
    [aCoder encodeObject:_isNeedBankcredit            forKey:@"isNeedBankcredit"];
    [aCoder encodeObject:_lastVisitTime               forKey:@"lastVisitTime"];
    [aCoder encodeObject:_mortgageCropName            forKey:@"mortgageCropName"];
    [aCoder encodeObject:_notReadCount                forKey:@"notReadCount"];
    [aCoder encodeObject:_orgnizationId               forKey:@"orgnizationId"];
    [aCoder encodeObject:_orgnizationName             forKey:@"orgnizationName"];
    [aCoder encodeObject:_roleId                      forKey:@"roleId"];
    [aCoder encodeObject:_roleName                    forKey:@"roleName"];
    [aCoder encodeObject:_sex                         forKey:@"sex"];
    [aCoder encodeObject:_telphone                    forKey:@"telphone"];
    [aCoder encodeObject:_tid                         forKey:@"tid"];
    [aCoder encodeObject:_userid                      forKey:@"userid"];
    [aCoder encodeObject:_username                    forKey:@"username"];
}

//解码方法，当把二进制数据转成对象时调用。
- (id)initWithCoder:(NSCoder *)aDecoder{
    //如果父类也遵守NSCoding协议，那么需要写self = [super initWithCoder]
    self = [super init];
    if (self) {
        _beNotice             = [aDecoder decodeObjectForKey:@"beNotice"];
        _birthday             = [aDecoder decodeObjectForKey:@"birthday"];
        _branchCropName       = [aDecoder decodeObjectForKey:@"branchCropName"];
        _companyId            = [aDecoder decodeObjectForKey:@"companyId"];
        _createDate           = [aDecoder decodeObjectForKey:@"createDate"];
        _headPhoto            = [aDecoder decodeObjectForKey:@"headPhoto"];
        _isNeedBankcredit     = [aDecoder decodeObjectForKey:@"isNeedBankcredit"];
        _lastVisitTime        = [aDecoder decodeObjectForKey:@"lastVisitTime"];
        _mortgageCropName     = [aDecoder decodeObjectForKey:@"mortgageCropName"];
        _notReadCount         = [aDecoder decodeObjectForKey:@"notReadCount"];
        _orgnizationId        = [aDecoder decodeObjectForKey:@"orgnizationId"];
        _orgnizationName      = [aDecoder decodeObjectForKey:@"orgnizationName"];
        _roleId               = [aDecoder decodeObjectForKey:@"roleId"];
        _roleName             = [aDecoder decodeObjectForKey:@"roleName"];
        _sex                  = [aDecoder decodeObjectForKey:@"sex"];
        _telphone             = [aDecoder decodeObjectForKey:@"telphone"];
        _tid                  = [aDecoder decodeObjectForKey:@"tid"];
        _userid               = [aDecoder decodeObjectForKey:@"userid"];
        _username             = [aDecoder decodeObjectForKey:@"username"];
    }
    return self;
}

- (BOOL)isFirstLaunch
{
    return  ![USER_DEFALT boolForKey:[ZSTool localVersionShort]];
}

- (void)setIsFirstLaunch:(BOOL)isFirstLaunch
{
    [USER_DEFALT setBool:YES forKey:[ZSTool localVersionShort]];
    [USER_DEFALT synchronize];
}


@end
