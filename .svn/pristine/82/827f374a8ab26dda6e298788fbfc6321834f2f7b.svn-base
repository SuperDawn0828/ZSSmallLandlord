//
//  ZSSLAddResourceModel.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/7/11.
//  Copyright © 2017年 黄曼文. All rights reserved.
//星速贷资料详情model -- 文本model  -- 图片model

#import <Foundation/Foundation.h>
#import "ZSWSFileCollectionModel.h"

@class SpdDocInfoVos;
@class ZSWSFileCollectionModel;
@class Propitems;

@interface ZSSLAddResourceModel : NSObject
@property (nonatomic , copy  )  NSString   *serialNo;

@property (nonatomic , strong)  NSArray    <ZSWSFileCollectionModel *>   * spdDocInfoVos;

@property (nonatomic , copy  )  NSString   *category;

@property (nonatomic , copy  )  NSString   *docId;

@property (nonatomic , copy  )  NSString   *custNo;

@property (nonatomic , copy  )  NSString   *subCategory;

@property (nonatomic , copy  )  NSString   *custName;

@property (nonatomic , copy  )  NSString   *dataUrl;

@property (nonatomic , strong)  NSArray<ZSWSFileCollectionModel *>   * _Nullable propitems;



@end

@interface SpdDocInfoVos :NSObject

@property (nonatomic , copy  )  NSString   *custNo;

@property (nonatomic , copy  )  NSString   *custName;

@property (nonatomic , copy  )  NSString   *subCategory;

@property (nonatomic , copy  )  NSString   *dataUrl;



@end

@interface OrderDocInsurance :NSObject

@property (nonatomic , assign)  NSInteger  version;

@property (nonatomic , assign)  NSInteger  updateDate;

@property (nonatomic , copy  )  NSString   *createBy;

@property (nonatomic , assign)  NSInteger  state;

@property (nonatomic , copy  )  NSString  *insuranceAmount;

@property (nonatomic , copy  )  NSString   *updateBy;

@property (nonatomic , copy  )  NSString   *insuranceTime;

@property (nonatomic , assign)  NSInteger  createDate;

@property (nonatomic , copy  )  NSString   *orderno;

@property (nonatomic , copy  )  NSString   *tid;

@property (nonatomic , copy  )  NSString   *insuranceAccount;



@end


//资料详情文本model
@interface SpdDocdocTextVos :NSObject

@property (nonatomic , copy  )  NSString   *text;      //文本值

@property (nonatomic , copy  )  NSString   *textType;  //文本类型

@property (nonatomic , copy  )  NSString   *textId;    //文本Id

@property (nonatomic , copy  )  NSString   *id;        //文本Id

@property (nonatomic , copy  )  NSString   *value;     //文本值

@property (nonatomic , copy  )  NSString   *textUnit;  //后缀名字 1是% 2是元

@property (nonatomic , strong)  OrderDocInsurance   * orderDocInsurance;
@end





