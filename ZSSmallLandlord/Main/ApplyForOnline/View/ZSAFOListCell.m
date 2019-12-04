//
//  ZSAFOListCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSAFOListCell.h"

@implementation ZSAFOListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleSpacing;//设置cell上分割线的风格
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //头像
    self.imgview_header = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    self.imgview_header.layer.cornerRadius = 3;
    self.imgview_header.layer.masksToBounds = YES;
    self.imgview_header.image = [UIImage imageNamed:@"list_weixin_n"];
    [self addSubview:self.imgview_header];
  
    //姓名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imgview_header.right+15,15,100, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = ZSColorListRight;
    [self addSubview:self.nameLabel];
   
    //地区
    self.label_area = [[UILabel alloc]initWithFrame:CGRectMake(self.imgview_header.right+15,40,0, 15)];
    self.label_area.font = [UIFont systemFontOfSize:12];
    self.label_area.textColor = ZSPageItemColor;
    self.label_area.layer.cornerRadius = 3;
    self.label_area.layer.masksToBounds = YES;
    self.label_area.layer.borderWidth = 0.5;
    self.label_area.layer.borderColor = ZSPageItemColor.CGColor;
    self.label_area.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label_area];
   
    //有无房产
    self.label_house = [[UILabel alloc]initWithFrame:CGRectMake(self.label_area.right+5,40,0, 15)];
    self.label_house.font = [UIFont systemFontOfSize:12];
    self.label_house.textColor = ZSPageItemColor;
    self.label_house.layer.cornerRadius = 3;
    self.label_house.layer.masksToBounds = YES;
    self.label_house.layer.borderWidth = 0.5;
    self.label_house.layer.borderColor = ZSPageItemColor.CGColor;
    self.label_house.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label_house];
   
    //产品名称
    self.productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-15-55,15,55,15)];
    self.productNameLabel.font = [UIFont systemFontOfSize:12];
    self.productNameLabel.textColor = ZSColorWhite;
    self.productNameLabel.textAlignment = NSTextAlignmentCenter;
    self.productNameLabel.layer.cornerRadius = 2;
    self.productNameLabel.layer.masksToBounds = YES;
    [self addSubview:self.productNameLabel];
   
    //订单状态
    self.orderStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.productNameLabel.left-10-65,15,65, 15)];
    self.orderStateLabel.font = [UIFont systemFontOfSize:12];
    self.orderStateLabel.textColor = ZSColorListLeft;
    self.orderStateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.orderStateLabel];
}

- (void)setModel:(ZSAOListModel *)model
{
    _model = model;
   
    //头像
    if (model.headUrl) {
        [self.imgview_header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",SafeStr(model.headUrl)]] placeholderImage:[UIImage imageNamed:@"list_weixin_n"]];
    }
  
    //姓名
    if (model.realName) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",model.realName];
    }
   
    //地区
    if (model.proCity) {
        self.label_area.text = model.proCity;
        self.label_area.frame = CGRectMake(70, 40, [ZSTool getStringWidth:model.proCity withframe:CGSizeMake(ZSWIDTH-135, 15) withSizeFont:[UIFont systemFontOfSize:12]]+10, 15);
    }
    else
    {
        self.label_area.frame = CGRectMake(70, 40, 0, 15);
    }
   
    //有无房产
    if (model.localHouseProperty) {
        if (model.localHouseProperty.intValue == 1) {
            self.label_house.text = @"有房";
        }else{
            self.label_house.text = @"无房";
        }
        //根据有无地区修改房产的位置
        if (model.proCity) {
            self.label_house.frame = CGRectMake(70+[ZSTool getStringWidth:model.proCity withframe:CGSizeMake(ZSWIDTH-135, 15) withSizeFont:[UIFont systemFontOfSize:12]]+20, 40, 33, 15);
        }else{
            self.label_house.frame = CGRectMake(70, 40, 33, 15);
        }
    }
    else
    {
        self.label_house.frame = CGRectMake(70, 40, 0, 15);
    }

    //产品名称
    if (model.prdType)
    {
        if (model.prdType.intValue == 1) {
            self.productNameLabel.text = @"新房见证";
            self.productNameLabel.frame = CGRectMake(ZSWIDTH-55-10, 15, 55, 15);
            self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_witnessServer"] Withview:self.productNameLabel]];
        }
        if (model.prdType.intValue == 2) {
            self.productNameLabel.text = @"赎楼宝";
            self.productNameLabel.frame = CGRectMake(ZSWIDTH-42-10, 15, 42, 15);
            self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_RedeemFloor"] Withview:self.productNameLabel]];
        }
        if (model.prdType.intValue == 3) {
            self.productNameLabel.text = @"抵押贷";
            self.productNameLabel.frame = CGRectMake(ZSWIDTH-42-10, 15, 42, 15);
            self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_MortgageLoan"] Withview:self.productNameLabel]];
        }
        if (model.prdType.intValue == 4) {
            self.productNameLabel.text = @"星速贷";
            self.productNameLabel.frame = CGRectMake(ZSWIDTH-42-10, 15, 42, 15);
            self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_StarLoan"] Withview:self.productNameLabel]];
        }
        if (model.prdType.intValue == 5) {
            self.productNameLabel.text = @"车位分期";
            self.productNameLabel.frame = CGRectMake(ZSWIDTH-55-10, 15, 55, 15);
            self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.productNameLabel]];
        }
    }
    
    //订单状态
    self.orderStateLabel.frame = CGRectMake(self.productNameLabel.left-10-65,15,65, 15);
    if (model.applyState)
    {
        if (model.applyState.intValue == 2)
        {
            self.orderStateLabel.text = @"已创建订单";
            self.orderStateLabel.textColor = ZSColorListLeft;
        }
        else if (model.applyState.intValue == 3)
        {
            self.orderStateLabel.text = @"已关闭";
            self.orderStateLabel.textColor = ZSColorRed;
        }
        else
        {
            self.orderStateLabel.text = @"";
        }
    }
}

@end
