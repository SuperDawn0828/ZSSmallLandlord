//
//  ZSToolButton.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/4/28.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSToolButton : UIButton
- (id)initWithFrame:(CGRect)frame;//初始化方法
@property (strong, nonatomic) UIImageView *imgview;
@property (strong, nonatomic) UILabel     *label_text;
@end
