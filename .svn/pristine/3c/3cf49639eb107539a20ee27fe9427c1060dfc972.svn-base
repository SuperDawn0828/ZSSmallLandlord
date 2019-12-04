//
//  ZSWSOrderDetailModel.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/8.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSOrderDetailModel.h"

@implementation ZSWSOrderDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"projectInfo"  : [ProjectInfo class],
             @"scheduleInfo" : [ScheduleInfo class],
             @"custInfo"     : [CustInfo class],
             @"docInfo"      : [DocInfo class]};
}


@end


@implementation ScheduleInfo

@end

@implementation ProjectInfo

@end

@implementation Files

@end

@implementation DocsDataList
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"files" : [Files class]};
}

@end


@implementation CustInfo
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"docsDataList" : [ZSWSFileCollectionModel class],
             @"bizCreditCustomers" : [BizCreditCustomers class]};
}

@end

@implementation DocInfo{
}

@end




