//
//  ZSCHOrderdetailsModel.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/10/12.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSCHOrderdetailsModel.h"

@implementation ZSCHOrderdetailsModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"cwfqOrder"       : [SpdOrder class],
             @"bizCustomers"    : [BizCustomers class],
             @"cwfqOrderStates" : [SpdOrderStates class]
             };
}
@end
