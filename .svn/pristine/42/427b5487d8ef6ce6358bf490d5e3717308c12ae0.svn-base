//
//  ZSCustomReportDetailLeftCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/28.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSCustomReportDetailLeftCell.h"

@implementation ZSCustomReportDetailLeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //排序
    self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, gridHeight)];
    self.indexLabel.textColor = ZSColorListRight;
    self.indexLabel.font = [UIFont systemFontOfSize:13];
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.indexLabel];
    
    //名字
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 70, gridHeight)];
    self.nameLabel.textColor = ZSColorListRight;
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.numberOfLines = 0;
    [self addSubview:self.nameLabel];
}

@end
