//
//  ZSWSPersonListAddViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/7.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSPersonListAddViewCell.h"

@implementation ZSWSPersonListAddViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.cellSpace = 0;//设置cell之间的间隔
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //角色
    self.label_role = [[UILabel alloc]initWithFrame:CGRectMake(15,0,250,70)];
    self.label_role.font = Font(15);
    self.label_role.textColor = ZSColorListLeft;
    self.label_role.text = @"担保人配偶";
    [self addSubview:self.label_role];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-150-30,0,150, 70)];
    label.font = Font(15);
    label.textColor = ZSPageItemColor;
    label.text = @"待添加";
    label.textAlignment = NSTextAlignmentRight;
    [self addSubview:label];
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-30, (70-15)/2, 15, 15)];
    imgview.image = [UIImage imageNamed:@"list_arrow_n"];
    [self addSubview:imgview];
}

@end
