//
//  HYCalendarCollectionReusableView.h
//  HYCalendar
//
//  Created by 王厚一 on 16/11/14.
//  Copyright © 2016年 why. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCalendarCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)showTimeLabelWithArray:(NSArray *)array;

@end
