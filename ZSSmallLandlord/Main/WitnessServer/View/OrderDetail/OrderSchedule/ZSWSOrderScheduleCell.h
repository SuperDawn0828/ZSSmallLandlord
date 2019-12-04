//
//  ZSWSProjectScheduleCell.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  首页--订单列表--订单详情--资料收集单元格

static NSString *const KReuseZSWSOrderScheduleCellIdentifier=@"ZSWSOrderScheduleCell";

#import <UIKit/UIKit.h>
#import "ZSWSOrderScheduleCell.h"
@interface ZSWSOrderScheduleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pointImgView;
@property (weak, nonatomic) IBOutlet UIView *topView;
//上半部分的线条
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//下半部分的线条
//节点时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//备注
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
//节点

@property (nonatomic,strong)ScheduleInfo *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointImgViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointImgViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointImgViewLeftConstraint;
@end
