//
//  ZSBaseCardTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/7.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBaseCardTableViewCell.h"

@implementation ZSBaseCardTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        //卡片式背景色
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, cellNewWidth, 70)];
        self.bgView.backgroundColor = ZSColorWhite;
        self.bgView.layer.cornerRadius = 3;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];
    }
    return self;
}

@end
