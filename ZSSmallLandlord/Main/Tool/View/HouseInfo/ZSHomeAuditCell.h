//
//  ZSHomeAuditCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/6/4.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  工具--房产资讯cell

#import "ZSBaseTableViewCell.h"
#import "ZSHomeAuditModel.h"

static NSString *const  KZSHomeAuditCell = @"ZSHomeAuditCell";

@interface ZSHomeAuditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView      *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel     *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel     *newsFrom;
@property (weak, nonatomic) IBOutlet UILabel *newsTime;

@property (nonatomic,strong)ZSHomeAuditModel     *model;
@end
