//
//  ZSSLOrderdetailsModel.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/30.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLOrderdetailsModel.h"

@implementation ZSSLOrderdetailsModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"bizCustomers"   : [BizCustomers class],
             @"spdOrderStates" : [SpdOrderStates class],
             @"spdOrder"       : [SpdOrder class],
             @"orderRelation"  : [OrderRelation class]
             };
}
@end


@implementation OrderRelation

@end


@implementation BizCustomers
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"bizCreditCustomers" : [BizCreditCustomers class]
             };
}
@end


@implementation SpdOrderStates

@end


@implementation SpdOrder

@end


@implementation BizCreditCustomers

@end
