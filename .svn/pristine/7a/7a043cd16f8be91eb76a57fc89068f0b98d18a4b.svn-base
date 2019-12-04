//
//  ZSUidInfo.h
//  ZSMoneytocar
//
//  Created by cong on 16/7/26.
//  Copyright © 2016年 Wu. All rights reserved.
//  当前登录用户的信息

#import <Foundation/Foundation.h>

@interface ZSUidInfo : NSObject<NSCoding>//NSCoding编码协议，一个对象实现了NSCoding协议方法，才能被转换成为二进制数据。
@property(nonatomic,copy  )NSString *beNotice;          //是否接收短信通知：1接收0不接收
@property(nonatomic,copy  )NSString *birthday;          //生日
@property(nonatomic,copy  )NSString *branchCropName;
@property(nonatomic,copy  )NSString *companyId;
@property(nonatomic,copy  )NSString *createDate;
@property(nonatomic,copy  )NSString *headPhoto;         //头像url
@property(nonatomic,copy  )NSString *isNeedBankcredit;
@property(nonatomic,copy  )NSString *lastVisitTime;
@property(nonatomic,copy  )NSString *mortgageCropName;
@property(nonatomic,copy  )NSString *notReadCount;
@property(nonatomic,copy  )NSString *orgnizationId;     //部门id
@property(nonatomic,copy  )NSString *orgnizationName;   //部门名称
@property(nonatomic,copy  )NSString *roleId;            //角色id
@property(nonatomic,copy  )NSString *roleName;          //角色名
@property(nonatomic,copy  )NSString *sex;               //性别：1男2女
@property(nonatomic,copy  )NSString *telphone;          //手机号
@property(nonatomic,copy  )NSString *tid;               //userid
@property(nonatomic,copy  )NSString *userid;            //用户名(登录时的账号)
@property(nonatomic,copy  )NSString *username;          //名字
@property(nonatomic,assign)BOOL     isFirstLaunch;      //是否首次启动APP
+ (ZSUidInfo*)shareInfo;
@end
