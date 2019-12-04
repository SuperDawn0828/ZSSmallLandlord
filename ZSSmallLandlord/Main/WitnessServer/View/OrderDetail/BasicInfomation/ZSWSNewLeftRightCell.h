//
//  ZSWSNewLeftRightCell.h
//  ZSMoneytocar
//
//  Created by gengping on 17/4/27.
//  Copyright © 2017年 Wu. All rights reserved.
//  新房见证--订单详情--人员列表--人员详情cell

#import <UIKit/UIKit.h>
#import "ZSOrderModel.h"

static NSString *const  KReuseZSWSNewLeftRightCellIdentifier = @"ZSWSNewLeftRightCell";

@interface ZSWSNewLeftRightCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel     *leftLab;       //左边label

@property (weak, nonatomic) IBOutlet UILabel     *rightLab;      //右边label

@property (weak, nonatomic) IBOutlet UITextField *rightTextField;//右边输入框

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeadingSpacing;//分割线距左边距

@property (strong,nonatomic)ZSOrderModel *model;

@end
