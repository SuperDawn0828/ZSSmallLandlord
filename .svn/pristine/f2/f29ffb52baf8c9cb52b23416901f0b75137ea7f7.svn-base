//
//  ZSBaseTableViewCell.h
//  ZSMoneytocar
//
//  Created by 黄曼文 on 2017/4/25.
//  Copyright © 2017年 Wu. All rights reserved.
//  tableviewCell base

#import <UIKit/UIKit.h>

#define cellNewWidth ZSWIDTH-20

typedef NS_ENUM(NSInteger, ZSCellLineStyle)
{
    CellLineStyleSpacing,   //分割线左侧有距离(LeftFreeSpace)
    CellLineStyleFill,      //分割线充满cell
    CellLineStyleNone,      //没有分割线
};

@interface ZSBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView          *topLine;               //上分割线
@property (nonatomic, strong) UIView          *bottomLine;            //下分割线
@property (nonatomic, assign) float           leftSpace;              //分割线与左侧的间隔(默认15,可自定义)
@property (nonatomic, assign) ZSCellLineStyle topLineStyle;           //上分割线的风格(默认不显示,可自定义)
@property (nonatomic, assign) ZSCellLineStyle bottomLineStyle;        //下分割线的风格(默认填满,可自定义)

@property (nonatomic, strong) UILabel         *productNameLabel;      //产品名称
@property (nonatomic, strong) UILabel         *personnelTagLabel;     //人员标签
@property (nonatomic, strong) UILabel         *coownerTagLabel;       //共有人标签(既是配偶又是共有人的时候会用到)

#pragma mark 产品名称
- (void)layoutproductNameLabel:(NSString *)prdTypeString;

@end
