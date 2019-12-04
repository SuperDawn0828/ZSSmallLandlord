//
//  ZSCHOrderdetailsModel.h
//  ZSSmallLandlord
//
//  Created by gengping on 2017/10/12.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SpdOrderStates,BizCustomers,SpdOrder;

@interface ZSCHOrderdetailsModel :NSObject

@property (nonatomic , copy  )  NSArray<SpdOrderStates *>  *cwfqOrderStates;     //订单进度

@property (nonatomic , copy  )  NSArray<BizCustomers *>  *bizCustomers;         //人员信息

@property (nonatomic , strong)  SpdOrder  *cwfqOrder;                            //订单信息

@property (nonatomic , copy  )  NSString   *productCode;                          //产品类型对应的编码

@property (nonatomic , copy  )  NSString   *approvalState;                        //当前节点可操作状态（0:不可操作\2:审批\1:提交资料）

@property (nonatomic , copy  )  NSString   *isOrder;                              //是否是订单创建人 (0:不是 1:是)

@property (nonatomic , copy  )  NSString   *curNodeName;                          //节点名称

@property (nonatomic , copy  )  NSString   *createByTel;                          //创建人电话

@property (nonatomic , copy  )  NSString   *agencyName;                           //中介名称

@property (nonatomic , copy  )  NSString   *isCredit;                             //是否查询大数据风控 1需要查询 2不需要查询 这是针对订单的,后台配置了就差,不配置就不查

@property (nonatomic , copy  )  NSString   *todoUserTel;                          //当前节点处理人电话

@end



