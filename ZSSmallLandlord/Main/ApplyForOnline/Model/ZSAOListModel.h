//
//  ZSAOListModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/11.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSAOListModel : NSObject
@property (nonatomic,copy  )NSString *tid;                   //订单id
@property (nonatomic,copy  )NSString *userId;
@property (nonatomic,copy  )NSString *nickName;              //微信昵称
@property (nonatomic,copy  )NSString *realName;              //真实姓名
@property (nonatomic,copy  )NSString *phone;                 //手机号
@property (nonatomic,copy  )NSString *prdType;               //产品类型 新房见证1 | 赎楼宝2 | 抵押贷3 | 星速贷4 |车位分期5
@property (nonatomic,copy  )NSString *source;                //申请渠道 微信wechat 官网website
@property (nonatomic,copy  )NSString *createDate;            //申请时间
@property (nonatomic,copy  )NSString *updateDate;
@property (nonatomic,copy  )NSString *version;
@property (nonatomic,copy  )NSString *state;
@property (nonatomic,copy  )NSString *acceptMortgage;        //是否接收抵押 1是 2否
@property (nonatomic,copy  )NSString *localHouseProperty;    //是否有房产   1有 2无
@property (nonatomic,copy  )NSString *monthlyIncome;         //月收入
@property (nonatomic,copy  )NSString *proCity;               //所在地区
@property (nonatomic,copy  )NSString *applyState;            //订单状态 0未派发 1未处理 2已创建订单 3已关闭
@property (nonatomic,copy  )NSString *handler;               //当前登录的用户id
@property (nonatomic,copy  )NSString *distributeDate;
@property (nonatomic,copy  )NSString *headUrl;               //头像url
@property (nonatomic,copy  )NSString *loanLimit;             //贷款额度
@property (nonatomic,copy  )NSString *idCardNo;              //身份证号
@end
