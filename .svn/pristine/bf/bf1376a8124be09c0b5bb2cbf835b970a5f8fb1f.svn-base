//
//  ZSBaseTableViewCell.m
//  ZSMoneytocar
//
//  Created by 黄曼文 on 2017/4/25.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSBaseTableViewCell.h"

@implementation ZSBaseTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.leftSpace) {
            self.leftSpace = 15;//左侧间隔,默认15,可自定义
        }
        if (!self.topLineStyle) {
            self.topLineStyle = CellLineStyleNone;//上分割线的风格,默认没有,可自定义
        }
        if (!self.bottomLineStyle) {
            self.bottomLineStyle = CellLineStyleFill;//下分割线的风格,默认填满,可自定义
        }
        
        self.topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.5)];
        self.topLine.backgroundColor = ZSColorLine;
        [self addSubview:self.topLine];
        
        self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-0.5, ZSWIDTH, 0.5)];
        self.bottomLine.backgroundColor = ZSColorLine;
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setBottomLineStyle:_bottomLineStyle];
    [self setTopLineStyle:_topLineStyle];
}

#pragma mark 设置分割线
- (void) setTopLineStyle:(ZSCellLineStyle)style
{
    _topLineStyle = style;
    if (style == CellLineStyleSpacing)
    {
        self.topLine.frame = CGRectMake(_leftSpace, 0, ZSWIDTH-_leftSpace, 0.5);
        [self.topLine setHidden:NO];
    }
    else if (style == CellLineStyleFill)
    {
        self.topLine.frame = CGRectMake(0, 0, ZSWIDTH, 0.5);
        [self.topLine setHidden:NO];
    }
    else if (style == CellLineStyleNone)
    {
        [self.topLine setHidden:YES];
    }
}

- (void) setBottomLineStyle:(ZSCellLineStyle)style
{
    _bottomLineStyle = style;
    if (style == CellLineStyleSpacing)
    {
        self.bottomLine.frame = CGRectMake(_leftSpace, self.height-0.5, ZSWIDTH-_leftSpace, 0.5);
        [self.bottomLine setHidden:NO];
    }
    else if (style == CellLineStyleFill)
    {
        self.bottomLine.frame = CGRectMake(0, self.height-0.5, ZSWIDTH, 0.5);
        [self.bottomLine setHidden:NO];
    }
    else if (style == CellLineStyleNone)
    {
        [self.bottomLine setHidden:YES];
    }
}

#pragma mark 产品名称
- (void)layoutproductNameLabel:(NSString *)prdTypeString
{
    //新房见证
    if ([prdTypeString isEqualToString:kProduceTypeWitnessServer])
    {
        self.productNameLabel.frame = CGRectMake(cellNewWidth-55-10, 4.5+7.5, 55, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_witnessServer"] Withview:self.productNameLabel]];
    }
    //星速贷
    else if ([prdTypeString isEqualToString:kProduceTypeStarLoan])
    {
        self.productNameLabel.frame = CGRectMake(cellNewWidth-42-10, 4.5+7.5, 42, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_StarLoan"] Withview:self.productNameLabel]];
    }
    //赎楼宝
    else if ([prdTypeString isEqualToString:kProduceTypeRedeemFloor])
    {
        self.productNameLabel.frame = CGRectMake(cellNewWidth-42-10, 4.5+7.5, 42, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_RedeemFloor"] Withview:self.productNameLabel]];
    }
    //抵押贷
    else if ([prdTypeString isEqualToString:kProduceTypeMortgageLoan])
    {
        self.productNameLabel.frame = CGRectMake(cellNewWidth-42-10, 4.5+7.5, 42, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_MortgageLoan"] Withview:self.productNameLabel]];
    }
    //融易贷
    else if ([prdTypeString isEqualToString:kProduceTypeEasyLoans])
    {
        self.productNameLabel.frame = CGRectMake(cellNewWidth-42-10, 4.5+7.5, 42, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_witnessServer"] Withview:self.productNameLabel]];
    }
    //车位分期
    else if ([prdTypeString isEqualToString:kProduceTypeCarHire])
    {
        self.productNameLabel.frame = CGRectMake(cellNewWidth-55-10, 4.5+7.5, 55, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.productNameLabel]];
    }
    //代办业务
    else if ([prdTypeString isEqualToString:kProduceTypeAgencyBusiness])
    {
        self.productNameLabel.frame = CGRectMake(cellNewWidth-55-10, 4.5+7.5, 55, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.productNameLabel]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end

