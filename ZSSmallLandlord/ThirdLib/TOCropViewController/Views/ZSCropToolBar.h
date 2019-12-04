//
//  ZSCropToolBar.h
//  ZSYuecheDealer
//
//  Created by 武 on 2017/9/18.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSCropToolBar : UIView
@property (nullable, nonatomic, copy) void (^cancelButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^doneButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^rotateCounterclockwiseButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^rotateClockwiseButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^clampButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^resetButtonTapped)(void);
@end
