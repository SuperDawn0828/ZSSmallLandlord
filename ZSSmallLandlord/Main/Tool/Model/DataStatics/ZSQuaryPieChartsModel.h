//
//  ZSQuaryPieChartsModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/23.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具--数据统计--饼状图

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSQuaryPieChartsModel : NSObject

@property(nonatomic,copy  )NSString *name; //名称
@property(nonatomic,copy  )NSString *value;//数据
@property(nonatomic,copy  )NSString *rate; //占比

@end

NS_ASSUME_NONNULL_END
