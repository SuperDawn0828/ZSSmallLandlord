//
//  ZSYearMonthDayPicker.h
//  ZSCreditApp
//
//  Created by gengping on 2017/12/29.
//  Copyright © 2017年 gengping. All rights reserved.
//年月选择
typedef void(^DatePikerBlock)(NSString *selectDate);

#import <UIKit/UIKit.h>

@interface ZSYearMonthDayPicker : UIView
@property (nonatomic,copy) DatePikerBlock datePickerBlock;
@property (nonatomic,assign) NSInteger minYear;
//初始化最小年份
- (instancetype)initWithFrame:(CGRect)frame withMInYear:(NSInteger )minyear;
@end
