//
//  ZSNotificationModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/4.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  通知model

#import <Foundation/Foundation.h>

@interface ZSNotificationModel : NSObject
@property(nonatomic,copy  )NSString *content;     //通知内容
@property(nonatomic,copy  )NSString *createDate;
@property(nonatomic,copy  )NSString *fedbackState;//银行后勤用的(0待处理 1已处理)
@property(nonatomic,copy  )NSString *msgStatus;
@property(nonatomic,copy  )NSString *orderState;  //订单状态
@property(nonatomic,copy  )NSString *prdType;     //产品类型
@property(nonatomic,copy  )NSString *serialNo;    //订单id
@property(nonatomic,copy  )NSString *state;
@property(nonatomic,copy  )NSString *tid;
@property(nonatomic,copy  )NSString *title;       //通知标题
@property(nonatomic,copy  )NSString *type;
@property(nonatomic,copy  )NSString *updateDate;
@property(nonatomic,copy  )NSString *userId;
@property(nonatomic,copy  )NSString *version;
@end
