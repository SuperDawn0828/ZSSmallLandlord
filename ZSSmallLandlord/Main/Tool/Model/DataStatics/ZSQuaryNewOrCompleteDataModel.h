//
//  ZSQuaryNewOrCompleteDataModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/23.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具--数据统计--数据总览--新增订单/完成订单总数

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSQuaryNewOrCompleteDataModel : NSObject

@property(nonatomic,copy  )NSString *totalAmount; //金额
@property(nonatomic,copy  )NSString *totalNum;    //笔数

@end

NS_ASSUME_NONNULL_END
