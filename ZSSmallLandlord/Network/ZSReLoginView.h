//
//  ZSReLoginView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/8/24.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSReLoginViewDelegate <NSObject>
@optional
- (void)gotoRelogin;
@end

@interface ZSReLoginView : UIView
@property (nonatomic,  weak)id<ZSReLoginViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
@end
