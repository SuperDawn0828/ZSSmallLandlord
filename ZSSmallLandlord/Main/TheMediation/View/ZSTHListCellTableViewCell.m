//
//  ZSTHListCellTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/9/12.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSTHListCellTableViewCell.h"

@interface ZSTHListCellTableViewCell ()
@property (nonatomic,strong) UILabel     *nameLabel;         //姓名
@property (nonatomic,strong) UILabel     *idCardLabel;       //身份证号
@property (nonatomic,strong) UILabel     *orderStateLabel;   //订单状态
@property (nonatomic,strong) UILabel     *timeLabel;         //订单创建时间
@property (nonatomic,strong) UIImageView *mediationImg;
@property (nonatomic,strong) UILabel     *mediationLabel;
@end

@implementation ZSTHListCellTableViewCell

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
    self.bgView.height = 75 + 45;
    
    //姓名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 4.5, 180, 30)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = ZSColorListRight;
    [self.bgView addSubview:self.nameLabel];
    
    //身份证号
    self.idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, self.nameLabel.bottom, 200, 30)];
    self.idCardLabel.font = [UIFont systemFontOfSize:13];
    self.idCardLabel.textColor = ZSColorListLeft;
    [self.bgView addSubview:self.idCardLabel];
    
    //产品名称
    self.productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellNewWidth-100-GapWidth, 12, 100, 15)];
    self.productNameLabel.font = [UIFont systemFontOfSize:12];
    self.productNameLabel.textColor = ZSColorWhite;
    self.productNameLabel.textAlignment = NSTextAlignmentCenter;
    self.productNameLabel.layer.cornerRadius = 2;
    self.productNameLabel.layer.masksToBounds = YES;
    [self.bgView addSubview:self.productNameLabel];
    
    //订单耗时时间
    self.orderStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.productNameLabel.left-155, 9.5, 150, 20)];
    self.orderStateLabel.font = [UIFont systemFontOfSize:12];
    self.orderStateLabel.textColor = ZSColorListRight;
    self.orderStateLabel.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.orderStateLabel];
    
    //订单创建时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellNewWidth-150-GapWidth, self.nameLabel.bottom, 150, 30)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = ZSColorListLeft;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.timeLabel];
    
    /*------分割------*/
    UIImageView *lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 74.75, self.bgView.width, 0.5)];
    lineImgView.image = [UIImage imageNamed:@"虚线"];
    [self.bgView addSubview:lineImgView];
    
    UIImageView *leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 65, 20, 20)];
    leftImgView.image = [UIImage imageNamed:@"列表圆"];
    [self.bgView addSubview:leftImgView];
    
    UIImageView *rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bgView.width-10, 65, 20, 20)];
    rightImgView.image = [UIImage imageNamed:@"列表圆"];
    [self.bgView addSubview:rightImgView];
    
    //所属中介
    self.mediationImg = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth, 92.5, 15, 15)];
    self.mediationImg.image = [UIImage imageNamed:@"中介"];
    [self.bgView addSubview:self.mediationImg];
    
    self.mediationLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.mediationImg.right+10, 85, self.bgView.width-60, 30)];
    self.mediationLabel.font = [UIFont systemFontOfSize:14];
    self.mediationLabel.textColor = ZSColorListLeft;
    [self.bgView addSubview:self.mediationLabel];
}

- (void)setModel:(ZSAllListModel *)model
{
    _model = model;
    
    //姓名
    if (model.cust_name) {
        self.nameLabel.text = SafeStr(model.cust_name);
    }
    
    //身份证
    if (model.identity_no) {
        self.idCardLabel.text = SafeStr(model.identity_no);
    }
    
    //首页显示产品名称
    if (model.prd_type)
    {
        [self layoutproductNameLabel:model.prd_type];
        self.productNameLabel.text = [ZSGlobalModel getProductStateWithCode:model.prd_type];
        self.orderStateLabel.left = self.productNameLabel.left-155;
    }
    
    //订单状态
    if (model.order_state)
    {
        self.orderStateLabel.text = [model.order_state isEqualToString:@"暂存"] ? @"待提交订单" : model.order_state;
    }
    
    //订单时间
    self.timeLabel.text = [NSString stringWithFormat:@"%@",SafeStr(model.create_date)];
    
    //所属中介
    if (model.agent_user_name && model.agent_user_company)
    {
        self.mediationLabel.text = [NSString stringWithFormat:@"%@（%@）",model.agent_user_name,model.agent_user_company];
    }
    else if (model.agent_user_name && !model.agent_user_company)
    {
        self.mediationLabel.text = [NSString stringWithFormat:@"%@",model.agent_user_name];
    }
    else if (!model.agent_user_name && model.agent_user_company)
    {
        self.mediationLabel.text = [NSString stringWithFormat:@"%@",model.agent_user_company];
    }
    else
    {
        self.mediationLabel.text = @"";
    }
}

@end
