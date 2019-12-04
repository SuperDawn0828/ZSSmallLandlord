//
//  ZSBankHomeTableCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/8.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBankHomeTableCell.h"

@interface ZSBankHomeTableCell ()
@property (nonatomic,strong) UILabel     *nameLabel;         //姓名
@property (nonatomic,strong) UILabel     *idCardLabel;       //身份证号
@property (nonatomic,strong) UILabel     *orderStateLabel;   //订单状态
@property (nonatomic,strong) UILabel     *timeLabel;         //订单创建时间
@property (nonatomic,strong) UILabel     *addressLabel;      //所在地区
@property (nonatomic,strong) UILabel     *bankLabel;         //所属银行
@property (nonatomic,strong) UILabel     *createMsgLabel;    //创建信息
@property (nonatomic,strong) UIImageView *addressImgView;
@property (nonatomic,strong) UIImageView *bankImgView;
@property (nonatomic,strong) UIImageView *createImgView;
@end

@implementation ZSBankHomeTableCell

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
    self.bgView.height = 75 + 110;
    
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
    
    
    //所属城市
    self.addressImgView = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth, 92.5, 15, 15)];
    self.addressImgView.image = [UIImage imageNamed:@"地址"];
    [self.bgView addSubview:self.addressImgView];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.addressImgView.right+10, 85, self.bgView.width-60, 30)];
    self.addressLabel.font = [UIFont systemFontOfSize:14];
    self.addressLabel.textColor = ZSColorListLeft;
    self.addressLabel.numberOfLines = 0;
    [self.bgView addSubview:self.addressLabel];
    
    
    //所属银行
    self.bankImgView = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth, self.addressLabel.bottom+7.5, 15, 15)];
    self.bankImgView.image = [UIImage imageNamed:@"银行"];
    [self.bgView addSubview:self.bankImgView];
    
    self.bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bankImgView.right+10, self.addressLabel.bottom, self.bgView.width-60, 30)];
    self.bankLabel.font = [UIFont systemFontOfSize:14];
    self.bankLabel.textColor = ZSColorListLeft;
    self.bankLabel.numberOfLines = 0;
    [self.bgView addSubview:self.bankLabel];
    
    
    //创建信息
    self.createImgView = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth, self.bankLabel.bottom+7.5, 15, 15)];
    self.createImgView.image = [UIImage imageNamed:@"创建人"];
    [self.bgView addSubview:self.createImgView];
    
    self.createMsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.createImgView.right+10, self.bankLabel.bottom, self.bgView.width-60, 30)];
    self.createMsgLabel.font = [UIFont systemFontOfSize:14];
    self.createMsgLabel.textColor = ZSColorListLeft;
    self.createMsgLabel.numberOfLines = 0;
    [self.bgView addSubview:self.createMsgLabel];
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

    //订单列表 未完成列表显示订单创建时间,已完成列表显示订单完成时间,已关闭订单显示订单关闭时间
    //订单列表 暂存订单状态显示待提交订单,其他按正常显示
    if (model.listType == 3)
    {
        //未完成列表
        if (model.state_result.intValue == 1) {
            self.timeLabel.text = model.submit_loan_date ? model.submit_loan_date : model.create_date;
        }
        //已完成列表
        else if (model.state_result.intValue == 2) {
            self.timeLabel.text = model.complete_date ? model.complete_date : model.create_date;
        }
        //已关闭列表
        else
        {
            self.timeLabel.text = model.close_date ? model.close_date : model.create_date;
        }
        
        //订单状态
        self.orderStateLabel.left = cellNewWidth-150-GapWidth;
        if ([[NSString stringWithFormat:@"%@",model.order_state_desc] isEqualToString:@"暂存"]) {
            self.orderStateLabel.text = @"待提交订单";
        }else{
            self.orderStateLabel.text = [NSString stringWithFormat:@"%@",model.order_state_desc];
        }
    }
    //审批列表 待处理列表显示流转到当前节点的时间,显示审批时间
    //审批列表 订单状态不显示,显示耗时时间
    //审批列表 显示产品名称
    else if (model.listType == 4)
    {
        //待处理列表:
        if (model.state_result.intValue == 0)
        {
            self.timeLabel.text = model.process_date ? SafeStr(model.process_date) : model.create_date;//显示流转到当前节点的时间
            self.orderStateLabel.text = [NSString stringWithFormat:@"已耗时%@",SafeStr(model.remain_time)];//订单耗时时间
        }
        //已处理列表:
        else if (model.state_result.intValue == 1)
        {
            self.timeLabel.text = model.sign_date ? SafeStr(model.sign_date) : model.create_date;//显示审批时间
            self.orderStateLabel.text = [NSString stringWithFormat:@"共耗时%@",SafeStr(model.remain_time)];//订单耗时时间
        }
        
        //显示产品名称
        if (model.prd_type)
        {
            [self layoutproductNameLabel:model.prd_type];
            self.productNameLabel.text = [ZSGlobalModel getProductStateWithCode:model.prd_type];
            self.orderStateLabel.left = self.productNameLabel.left-155;
        }
    }
    
    //地址
    if (model.city && model.area)
    {
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@",SafeStr(model.city), SafeStr(model.area)];
    }
    else{
        self.addressLabel.text = @"";
    }
    
    //银行
    if (model.loan_bank)
    {
        self.bankLabel.text = SafeStr(model.loan_bank);
    }
    else{
        self.bankLabel.text = @"";
    }
    
    //创建人
    if (model.create_by && model.create_date)
    {
        NSString *dateString = SafeStr(model.create_date);
        NSString *year = [dateString substringToIndex:4];
        NSString *month = [dateString substringFromIndex:5];
        month = [month substringToIndex:2];
        NSString *day = [dateString substringFromIndex:9];
        day = [month substringToIndex:2];
        self.createMsgLabel.text = [NSString stringWithFormat:@"%@创建于%@年%@月%@日",model.create_by, year, month, day];
    }
    else{
        self.createMsgLabel.text = @"";
    }
}

@end
