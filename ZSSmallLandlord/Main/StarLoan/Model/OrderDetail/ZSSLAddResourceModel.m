//
//  ZSSLAddResourceModel.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/7/11.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSAddResourceModel.h"

@implementation ZSAddResourceModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"spdDocInfoVos" : [ZSWSFileCollectionModel class]
             };
}

@end


@implementation SpdDocInfoVos
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"spdDocInfoVos" : [SpdDocInfoVos class]
             };
}

@end


@implementation SpdDocdocTextVos
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"orderDocInsurance" : [OrderDocInsurance class]
             };
}

@end

@implementation OrderDocInsurance


@end
