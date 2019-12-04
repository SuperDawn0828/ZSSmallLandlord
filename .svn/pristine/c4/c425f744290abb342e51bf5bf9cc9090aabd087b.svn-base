//
//  ZSMonthlyPaymentsTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/13.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSMonthlyPaymentsTableViewCell.h"

@interface ZSMonthlyPaymentsTableViewCell  ()
@property (nonatomic,strong)UILabel     *indexLabel;
@property (nonatomic,strong)UILabel     *moneyLabel;
@end

@implementation ZSMonthlyPaymentsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        [self configureViews];
    }
    return self;
}

- (void)configureViews
{
    self.indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth + (60-22)/2, 10, 22, 22)];
    self.indexLabel.font = [UIFont systemFontOfSize:13];
    self.indexLabel.textColor = ZSColorAllNotice;
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
//    self.indexLabel.layer.cornerRadius = 11;
//    self.indexLabel.layer.borderWidth = 0.8;
//    self.indexLabel.layer.borderColor = ZSColorAllNotice.CGColor;
    [self addSubview:self.indexLabel];
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake((ZSWIDTH-200)/2, 0, 200, CellHeight)];
    self.moneyLabel.font = [UIFont systemFontOfSize:14];
    self.moneyLabel.textColor = ZSColorBlack;
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.moneyLabel];
}

- (void)setModel:(repayDetails *)model
{
//    CGFloat width = [ZSTool getStringWidth:model.sequence withframe:CGSizeMake(60, 22) withSizeFont:[UIFont systemFontOfSize:13]];
//    if (width+6 > 22)
//    {
//        self.indexLabel.frame = CGRectMake(GapWidth + (60-width-6)/2, 10, width+6, 22);
//    }
    
    self.indexLabel.frame = CGRectMake(GapWidth + (60-40)/2, 10, 40, 22);
    self.indexLabel.text = [NSString stringWithFormat:@"%@",model.sequence];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",model.repayAmount];
}

@end
