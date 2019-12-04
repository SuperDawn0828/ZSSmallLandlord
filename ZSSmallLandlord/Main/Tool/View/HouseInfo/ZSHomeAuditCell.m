//
//  ZSHomeAuditCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/6/4.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSHomeAuditCell.h"

@implementation ZSHomeAuditCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = ZSViewBackgroundColor;
    
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.masksToBounds = YES;
    
    self.newsImage.layer.masksToBounds = YES;
}

- (void)setModel:(ZSHomeAuditModel *)model
{
    _model = model;
    
    //图片
    [self.newsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.listPic]] placeholderImage:defaultImage_rectangle];
    
    //标题
    self.newsTitle.attributedText = [ZSTool setTextString:[NSString stringWithFormat:@"%@",model.title] withSizeFont:[UIFont systemFontOfSize:15]];
    
    //来源
    self.newsFrom.text = [NSString stringWithFormat:@"%@",model.source];
    
    //时间
    self.newsTime.text = [NSString stringWithFormat:@"%@",model.pubTime];
}

@end
