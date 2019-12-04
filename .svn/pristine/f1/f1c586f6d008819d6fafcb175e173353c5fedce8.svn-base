//
//  ZSWSOrderListCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSOrderListCell.h"

@interface ZSWSOrderListCell ()
@property (nonatomic,strong) UILabel     *nameLabel;         //姓名
@property (nonatomic,strong) UILabel     *idCardLabel;       //身份证号
@property (nonatomic,strong) UILabel     *orderStateLabel;   //订单状态
@property (nonatomic,strong) UILabel     *timeLabel;         //订单创建时间
@end

@implementation ZSWSOrderListCell

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
    //姓名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0,0, 39)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = ZSColorListRight;
    [self.bgView addSubview:self.nameLabel];
    
    //身份证号
    self.idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,self.nameLabel.bottom+3,250, 20)];
    self.idCardLabel.font = [UIFont systemFontOfSize:13];
    self.idCardLabel.textColor = ZSColorListLeft;
    [self.bgView addSubview:self.idCardLabel];
 
    //订单状态
    self.orderStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellNewWidth-135,0,120, 39)];
    self.orderStateLabel.font = [UIFont systemFontOfSize:12];
    self.orderStateLabel.textColor = ZSColorListRight;
    self.orderStateLabel.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.orderStateLabel];

    //订单创建时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellNewWidth-150-15,self.nameLabel.bottom+3,150, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = ZSColorListLeft;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.timeLabel];
  
    //重设名字的frame
    self.nameLabel.width = cellNewWidth-30-self.orderStateLabel.width;
}

- (void)setModel:(ZSAllListModel *)model
{
    _model = model;
 
    //姓名
    if (model.cust_name) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",model.cust_name];
    }
   
    //身份证
    if (model.identity_no) {
        self.idCardLabel.text = [NSString stringWithFormat:@"%@",model.identity_no];
    }
  
    //订单状态
    if ([[NSString stringWithFormat:@"%@",model.order_state_desc] isEqualToString:@"暂存"]) {
        self.orderStateLabel.text = @"待提交订单";
    }else{
        self.orderStateLabel.text = [NSString stringWithFormat:@"%@",model.order_state_desc];
    }

    //订单创建的时间
    if (model.create_date) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@",model.create_date];
    }
}

@end
