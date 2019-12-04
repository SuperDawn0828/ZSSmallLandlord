//
//  ZSOrderNodeTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/8/21.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSOrderNodeTableViewCell.h"

@interface ZSOrderNodeTableViewCell  ()
@property (nonatomic,strong)UILabel     *indexLabel;
@property (nonatomic,strong)UILabel     *nodeNameLabel;          //节点名称
@property (nonatomic,strong)UILabel     *operationManLabel;      //节点操作人
@end

@implementation ZSOrderNodeTableViewCell

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
    //虚线图片
    self.lineImage = [[UIImageView alloc]initWithFrame:CGRectMake((50-3)/2+1, 0, 3, 100)];
    self.lineImage.image = [UIImage imageNamed:@"list_orderNode_line"];
    [self addSubview:self.lineImage];
    
    //箭头图片
    self.arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake((50-20)/2, 22, 20, 20)];
    self.arrowImage.image = [UIImage imageNamed:@"list_orderNode_arrow"];
    [self addSubview:self.arrowImage];
    
    //index
    self.indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 30, 30)];
    self.indexLabel.backgroundColor = ZSColorWhite;
    self.indexLabel.font = [UIFont systemFontOfSize:14];
    self.indexLabel.textColor = ZSColorBlack;
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.layer.borderWidth = 1;
    self.indexLabel.layer.borderColor = ZSColorLine.CGColor;
    self.indexLabel.layer.cornerRadius = 15;
    [self addSubview:self.indexLabel];
    
    //右侧
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(50, 10, ZSWIDTH-50-15, 80)];
    rightView.layer.borderWidth = 1;
    rightView.layer.borderColor = ZSColorLine.CGColor;
    rightView.layer.cornerRadius = 5;
    [self addSubview:rightView];

    //节点名称
    self.nodeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, rightView.width-20, 30)];
    self.nodeNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nodeNameLabel.textColor = ZSColorBlack;
    [rightView addSubview:self.nodeNameLabel];
    
    //节点操作人
    self.operationManLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.nodeNameLabel.bottom, rightView.width-20, 30)];
    self.operationManLabel.font = [UIFont systemFontOfSize:14];
    self.operationManLabel.textColor = ZSColorBlack;
    [rightView addSubview:self.operationManLabel];
}

- (void)setModel:(ZSSLOrderRejectNodeModel *)model
{
    _model = model;
    
    //下标
    self.indexLabel.text = [NSString stringWithFormat:@"%ld",self.currentIndex + 1];
    
    //节点名称
    if (model.nodeName) {
        self.nodeNameLabel.text = [NSString stringWithFormat:@"%@",model.nodeName];
    }
    
    //节点操作人
    if (model.Operator && model.operatorRole) {
        self.operationManLabel.text = [NSString stringWithFormat:@"%@ (%@)",model.Operator,model.operatorRole];
    }
}

@end
