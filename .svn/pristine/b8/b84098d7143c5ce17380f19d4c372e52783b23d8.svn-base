//
//  ZSMLOrderdetailsModel.h
//  ZSSmallLandlord
//
//  Created by gengping on 2017/7/31.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SpdOrderStates,BizCustomers,SpdOrder,BizCreditCustomers;

@interface ZSMLOrderdetailsModel : NSObject

@property (nonatomic , strong)  NSArray<SpdOrderStates *>   * dydOrderStates;     //订单进度

@property (nonatomic , strong)  NSArray<BizCustomers *>   * bizCustomers;         //人员信息

@property (nonatomic , strong)  SpdOrder   * dydOrder;                            //贷款信息和房产信息

@property (nonatomic , strong)  OrderRelation   *orderRelation;                   //关联订单(不存在的时候可以创建其他订单,存在的时候查看相关订单)

@property (nonatomic , copy  )  NSString   *approvalState;                        //当前节点可操作状态（0:不可操作\2:审批\1:提交资料）

@property (nonatomic , copy  )  NSString   *isOrder;                              //是否是订单创建人 (0:不是 1:是)

@property (nonatomic , copy  )  NSString   *curNodeName;                          //节点名称

@property (nonatomic , copy  )  NSString   *createByTel;                          //创建人电话

@property (nonatomic , copy  )  NSString   *agencyName;                           //中介名称

@property (nonatomic , copy  )  NSString   *isCredit;                             //是否查询大数据风控 1需要查询 2不需要查询 这是针对订单的,后台配置了就差,不配置就不查

@property (nonatomic , copy  )  NSString   *todoUserTel;                          //当前节点处理人电话

@end



