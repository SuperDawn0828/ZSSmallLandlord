//
//  ZSToolButton.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/4/28.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSToolButton.h"

@implementation ZSToolButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgview = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-40)/2,22,40,40)];
        [self addSubview:self.imgview];
        
        self.label_text = [[UILabel alloc] initWithFrame:CGRectMake(0,self.imgview.bottom+16,self.width,12)];
        self.label_text.textColor = ZSColorListRight;
        self.label_text.font = [UIFont systemFontOfSize:13];
        self.label_text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label_text];
    }
    return self;
}

@end
