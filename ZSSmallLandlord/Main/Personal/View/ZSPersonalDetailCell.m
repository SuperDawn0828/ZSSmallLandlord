//
//  ZSPersonalDetailCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/31.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSPersonalDetailCell.h"

@implementation ZSPersonalDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleSpacing;//设置cell下分割线的风格
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //左侧图标
    self.leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, (self.height-21)/2, 21, 21)];
    [self addSubview:self.leftImage];
    //左侧title
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImage.right+10,0,100, self.height)];
    self.leftLabel.textColor = ZSColorListLeft;
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.leftLabel];
    //右侧label
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftLabel.right+5,0,ZSWIDTH-self.leftLabel.right-35, self.height)];
    self.rightLabel.textColor = ZSColorListRight;
    self.rightLabel.font = [UIFont systemFontOfSize:15];
    self.rightLabel.numberOfLines = 0;
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.rightLabel];
    //push-img
    self.pushImage = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-30, (self.height-15)/2, 15, 15)];
    self.pushImage.image = [UIImage imageNamed:@"list_arrow_n"];
    [self addSubview:self.pushImage];
    //switch
    self.noticeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ZSWIDTH-65, (self.height-30)/2, 50, 30)];
    self.noticeSwitch.hidden = YES;
    self.noticeSwitch.onTintColor = UIColorFromRGB(0xFF5E53);
    [self addSubview: self.noticeSwitch];
}

@end
