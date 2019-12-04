//
//  ZSCustomReportListCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/27.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSCustomReportListCell.h"

@interface ZSCustomReportListCell ()
@property (nonatomic,strong) UILabel         *reportNameLabel;  //报表名称
@property (nonatomic,strong) UILabel         *checkTimeLabel;   //查询时间
@end

@implementation ZSCustomReportListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleFill;//设置cell上分割线的风格
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //报表名称
    self.reportNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    self.reportNameLabel.textColor = ZSColorBlack;
    self.reportNameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:self.reportNameLabel];
    
    //产品类型
    self.productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.reportNameLabel.right, 12, 100, 15)];
    self.productNameLabel.font = [UIFont systemFontOfSize:12];
    self.productNameLabel.textColor = ZSColorWhite;
    self.productNameLabel.textAlignment = NSTextAlignmentCenter;
    self.productNameLabel.layer.cornerRadius = 2;
    self.productNameLabel.layer.masksToBounds = YES;
    [self addSubview:self.productNameLabel];
    
    //查询时间
    self.checkTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.reportNameLabel.bottom, ZSWIDTH-20*2, 30)];
    self.checkTimeLabel.textColor = ZSColorRed;
    self.checkTimeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.checkTimeLabel];
    
    //报表说明
    self.explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.checkTimeLabel.bottom, ZSWIDTH-20*2, 0)];
    self.explainLabel.textColor = ZSColorListLeft;
    self.explainLabel.font = [UIFont systemFontOfSize:14];
    self.explainLabel.numberOfLines = 0;
    [self addSubview:self.explainLabel];
}

#pragma mark 赋值
- (void)setModel:(ZSCustomReportListModel *)model
{
    _model = model;
    
    //报表名称
    CGFloat reportNameLabelWidth = model.editingType == 1 ? ZSWIDTH-55-20*2 : ZSWIDTH-55-20*2-60-44;
    self.reportNameLabel.text = SafeStr(model.name);
    self.reportNameLabel.width = [ZSTool getStringWidth:SafeStr(model.name) withframe:CGSizeMake(reportNameLabelWidth, 30) withSizeFont:[UIFont boldSystemFontOfSize:16]];
    
    //产品类型
    self.productNameLabel.text = [ZSGlobalModel getProductStateWithCode:SafeStr(model.prdType)];
    [self layoutproductNameLabel:SafeStr(model.prdType)];
    
    //查询时间
    NSString *string = [ZSGlobalModel getCustomReportTimeHorizonStateWithCode:SafeStr(model.timeFrame)];
    string = [string stringByReplacingOccurrencesOfString:@"订单" withString:@""];
    string = [NSString stringWithFormat:@"查询%@订单",string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:ZSColorListLeft range:NSMakeRange(0,2)];
    [str addAttribute:NSForegroundColorAttributeName value:ZSColorListLeft range:NSMakeRange(string.length-2,2)];
    self.checkTimeLabel.attributedText = str;

    //报表说明
    if (model.remark && model.remark.length)
    {
        self.explainLabel.text = SafeStr(model.remark);
        self.explainLabel.height = 30;
    }
    else
    {
        self.explainLabel.text = @"";
        self.explainLabel.height = 0;
    }
    
    //是否是编辑模式
    if (model.editingType == 1)
    {
        self.reportNameLabel.left = 20;
        self.productNameLabel.left = self.reportNameLabel.right+3;
        self.checkTimeLabel.left = 20;
        self.explainLabel.left = 20;
        self.explainLabel.width = ZSWIDTH-20*2;
    }
    else
    {
        self.reportNameLabel.left = 55;
        self.productNameLabel.left = self.reportNameLabel.right+3;
        self.checkTimeLabel.left = 55;
        self.explainLabel.left = 55;
        self.explainLabel.width = ZSWIDTH-20*2-60-44;
    }
}

#pragma mark 设置产品类型
- (void)layoutproductNameLabel:(NSString *)prdTypeString
{
    //新房见证
    if ([prdTypeString isEqualToString:kProduceTypeWitnessServer])
    {
        self.productNameLabel.frame = CGRectMake(self.reportNameLabel.right+3, 17, 55, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_witnessServer"] Withview:self.productNameLabel]];
    }
    //星速贷
    else if ([prdTypeString isEqualToString:kProduceTypeStarLoan])
    {
        self.productNameLabel.frame = CGRectMake(self.reportNameLabel.right+3, 17, 42, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_StarLoan"] Withview:self.productNameLabel]];
    }
    //赎楼宝
    else if ([prdTypeString isEqualToString:kProduceTypeRedeemFloor])
    {
        self.productNameLabel.frame = CGRectMake(self.reportNameLabel.right+3, 17, 42, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_RedeemFloor"] Withview:self.productNameLabel]];
    }
    //抵押贷
    else if ([prdTypeString isEqualToString:kProduceTypeMortgageLoan])
    {
        self.productNameLabel.frame = CGRectMake(self.reportNameLabel.right+3, 17, 42, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_MortgageLoan"] Withview:self.productNameLabel]];
    }
    //融易贷
    else if ([prdTypeString isEqualToString:kProduceTypeEasyLoans])
    {
        self.productNameLabel.frame = CGRectMake(self.reportNameLabel.right+3, 17, 42, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_witnessServer"] Withview:self.productNameLabel]];
    }
    //车位分期
    else if ([prdTypeString isEqualToString:kProduceTypeCarHire])
    {
        self.productNameLabel.frame = CGRectMake(self.reportNameLabel.right+3, 17, 55, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.productNameLabel]];
    }
    //代办业务
    else if ([prdTypeString isEqualToString:kProduceTypeAgencyBusiness])
    {
        self.productNameLabel.frame = CGRectMake(self.reportNameLabel.right+3, 17, 55, 15);
        self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.productNameLabel]];
    }
}

#pragma mark 修改排序按钮图片
- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];
    if (editing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = [UIImage imageNamed:@"move_icon"];
                    }
                }
            }
        }
    }
}

@end
