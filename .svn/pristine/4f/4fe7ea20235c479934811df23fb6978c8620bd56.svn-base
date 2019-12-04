
//
//  ZSHomeTableCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSHomeTableCell.h"
#import "ZSHomeViewController.h"
#import "ZSBankHomeViewController.h"

@interface ZSHomeTableCell ()
@property (nonatomic,strong) UILabel     *nameLabel;         //姓名
@property (nonatomic,strong) UILabel     *idCardLabel;       //身份证号
@property (nonatomic,strong) UILabel     *orderStateLabel;   //订单状态
@property (nonatomic,strong) UILabel     *timeLabel;         //订单创建时间
@property (nonatomic,strong) UIButton    *selectBtn;         //选择按钮
@end

@implementation ZSHomeTableCell

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
    //选择按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(-CellHeight, 0, CellHeight, 75);
    [self.selectBtn setImage:[UIImage imageNamed:@"派单-未选中"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"派单-选中"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.selectBtn];
    
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
 
    //订单状态
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
    if (model.order_state_desc)
    {
        self.orderStateLabel.text = [model.order_state_desc isEqualToString:@"暂存"] ? @"待提交订单" : model.order_state_desc;
    }
    else if (model.order_state)
    {
        self.orderStateLabel.text = [model.order_state isEqualToString:@"暂存"] ? @"待提交订单" : model.order_state;
    }
  
    //不同列表分开处理
    //预授信评估列表 待处理显示提交预授信申请时间,已处理显示生成预授信报告时间
    if (model.listType == 1)
    {
        if (model.state_result.intValue == 1) {
            self.timeLabel.text = model.apply_precredit_date ? model.apply_precredit_date : model.create_date;
        }
        else{
            self.timeLabel.text = model.submit_precredit_date ? model.submit_precredit_date : model.create_date;
        }
    }
    //派单列表列表 待处理显示提交贷款时间,已处理显示派单时间
    else if (model.listType == 2)
    {
        if (model.state_result.intValue == 1) {
            self.timeLabel.text = model.submit_loan_date ? model.submit_loan_date : model.create_date;
        }
        else{
            self.timeLabel.text = model.submit_distribute_date ? model.submit_distribute_date : model.create_date;
        }
        
        #pragma mark 派单列表用的
        self.selectBtn.selected = model.isSelect == YES ? YES : NO;
    }
    //订单列表 未完成列表显示订单创建时间,已完成列表显示订单完成时间,已关闭订单显示订单关闭时间
    else if (model.listType == 3)
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
    }
    //首页列表
    else if (model.listType == 5)
    {
        if (model.create_date) {
            self.timeLabel.text = [NSString stringWithFormat:@"%@",model.create_date];
        }
    }
    
    //只有订单列表不显示
    if (model.listType != 3)
    {
        //产品名称
        if (model.prd_type)
        {
            [self layoutproductNameLabel:model.prd_type];
            self.productNameLabel.text = [ZSGlobalModel getProductStateWithCode:model.prd_type];
            self.orderStateLabel.left = self.productNameLabel.left-155;
        }
    }
    else
    {
        self.orderStateLabel.left = cellNewWidth-150-GapWidth;
    }
}

#pragma mark 派单列表用的
- (void)selectBtnAction:(UIButton *)sender
{
    if (sender.selected == YES)
    {
        sender.selected = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(sendData:withIndex:withType:)]) {
            [_delegate sendData:_model withIndex:_currentIndex withType:NO];
        }
    }
    else
    {
        sender.selected = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(sendData:withIndex:withType:)]) {
            [_delegate sendData:_model withIndex:_currentIndex withType:YES];
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (self.editing == editing)
    {
        return;
    }
    
    [super setEditing:editing animated:animated];

    if (self.editing)
    {
        [UIView animateWithDuration:0.35 animations:^{
            self.selectBtn.left = -CellHeight + CellHeight;
            self.nameLabel.left = 10 + CellHeight;
            self.idCardLabel.left = 10 + CellHeight;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.35 animations:^{
             self.selectBtn.left = -CellHeight;
             self.nameLabel.left = 10;
             self.idCardLabel.left = 10;
         }];
    }
}

@end
