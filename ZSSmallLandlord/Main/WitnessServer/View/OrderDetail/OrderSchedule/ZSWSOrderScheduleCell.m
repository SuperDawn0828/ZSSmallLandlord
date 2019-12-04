//
//  ZSWSProjectScheduleCell.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSOrderScheduleCell.h"

@implementation ZSWSOrderScheduleCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.orderStateLabel.textColor = ZSColorGreen;
    self.contentLabel.textColor    = ZSColorListRight;
}

- (void)setModel:(ScheduleInfo *)model
{
    _model = model;
    NSString *dateStr = SafeStr(model.itemDate);
    if (dateStr.length > 10){
        self.timeLabel.text = [dateStr substringToIndex:10];//截取掉下标10之后的字符串
    }
    self.orderStateLabel.text = SafeStr(model.item);
    self.contentLabel.text    = SafeStr(model.remark);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
