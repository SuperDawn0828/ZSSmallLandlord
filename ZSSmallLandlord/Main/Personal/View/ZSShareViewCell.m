//
//  ZSShareViewCell.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/8/21.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSShareViewCell.h"

@implementation ZSShareViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgview = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-38)/2,45,38,38)];
        [self addSubview:self.imgview];
        
        self.label_text = [[UILabel alloc] initWithFrame:CGRectMake(0,self.imgview.bottom+10,self.width,12)];
        self.label_text.textColor = ZSColorListLeft;
        self.label_text.font = [UIFont systemFontOfSize:12];
        self.label_text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label_text];
    }
    return self;
}

@end
