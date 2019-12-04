//
//  ZSBanklistModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/8.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  银行名称列表model

#import <Foundation/Foundation.h>

@interface ZSBanklistModel : NSObject
@property(nonatomic,copy  )NSString *bankCode;
@property(nonatomic,copy  )NSString *bankName;       //银行名称
@property(nonatomic,copy  )NSString *bankId;         //银行id(跟着项目走的)
@property(nonatomic,copy  )NSString *tid;            //银行id(预授信银行列表)
@property(nonatomic,copy  )NSString *createBy;
@property(nonatomic,copy  )NSString *createDate;    
@property(nonatomic,copy  )NSString *serviceFee;
@property(nonatomic,copy  )NSString *state;
@property(nonatomic,copy  )NSString *updateBy;
@property(nonatomic,copy  )NSString *updateDate;
@property(nonatomic,copy  )NSString *version;
@end
