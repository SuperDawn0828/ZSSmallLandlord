//
//  ZSOrderDetailModel.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/10.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSPCOrderDetailModel.h"

@implementation ZSPCOrderDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"agentPrecredit" : [AgentPrecredit class],
             @"customers"      : [CustomersModel class],
             @"order"          : [OrderModel class],
             @"warrantImg"     : [WarrantImg class]
             };
}
@end



@implementation AgentPrecredit

@end



@implementation CustomersModel

@end



@implementation OrderModel

@end



@implementation WarrantImg

@end
