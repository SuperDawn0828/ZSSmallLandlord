//
//  HYCalendarCollectionReusableView.m
//  HYCalendar
//
//  Created by 王厚一 on 16/11/14.
//  Copyright © 2016年 why. All rights reserved.
//

#import "HYCalendarCollectionReusableView.h"

@implementation HYCalendarCollectionReusableView

- (void)showTimeLabelWithArray:(NSArray *)array
{
    self.timeLabel.text = [NSString stringWithFormat:@"%@年 %@月", array[0], array[1]];
}

@end
