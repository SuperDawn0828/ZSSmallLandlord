//
//  ZSDaySignModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/9/30.
//  Copyright © 2018 黄曼文. All rights reserved.
//  日签model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSDaySignModel : NSObject
@property (nonatomic,copy ) NSString *canDo;
@property (nonatomic,copy ) NSString *cannotDo;
@property (nonatomic,copy ) NSString *dayOfWeek;
@property (nonatomic,copy ) NSString *lunarCalendar; //农历
@property (nonatomic,copy ) NSString *maxim;   //鸡汤
@property (nonatomic,copy ) NSString *solarCalendar; //公历
@end

NS_ASSUME_NONNULL_END
