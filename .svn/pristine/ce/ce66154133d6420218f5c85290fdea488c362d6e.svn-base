//
//  ZSHomeToolButton.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/4/28.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSHomeToolButton.h"

@implementation ZSHomeToolButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgview = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-50)/2,10,50,50)];
        [self addSubview:self.imgview];
        
        self.label_text = [[UILabel alloc] initWithFrame:CGRectMake(0,self.imgview.bottom,self.width,25)];
        self.label_text.textColor = ZSColorListRight;
        self.label_text.font = [UIFont systemFontOfSize:13];
        self.label_text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label_text];
    }
    return self;
}

@end
