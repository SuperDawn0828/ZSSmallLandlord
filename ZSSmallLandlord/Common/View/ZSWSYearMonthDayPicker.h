//
//  ZSWSYearMonthDayPicker.h
//  ZSMoneytocar
//
//  Created by 黄曼文 on 2017/5/19.
//  Copyright © 2017年 Wu. All rights reserved.
//  年月日picker

#import <UIKit/UIKit.h>


//typedef NS_ENUM(NSUInteger,typeOfDate) {
//    beginDate = 0,//开始时间
//    endDate,      //结束时间
//};
typedef void(^DatePikerBlock)(NSString *selectDate);

@interface ZSWSYearMonthDayPicker : UIView


@property (nonatomic,copy) DatePikerBlock datePickerBlock;

@property (nonatomic,assign) BOOL     hasDateRate;//有日期选择范围

@property (nonatomic,assign) BOOL     timeTypeToMinute;//是否精确到分（一般精确到时）

@end
