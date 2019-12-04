//
//  ZSWSLeftRightCell.m
//  ZSMoneytocar
//
//  Created by 武 on 16/7/15.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSWSLeftRightCell.h"

@implementation ZSWSLeftRightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self  setUpView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor=ZSColorWhite;
    }
    return self;
}


- (void)setUpView
{
    self.bottomLab = [[UILabel alloc]initWithFrame:CGRectMake(10,0, ZSWIDTH-15, self.frame.size.height)];
    self.bottomLab.textColor = ZSColorListLeft;
    self.bottomLab.font=[UIFont systemFontOfSize:15.0f];
    self.bottomLab.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:self.bottomLab];
    
    self.leftLab=[UILabel new];
    self.leftLab.textColor=ZSColorListLeft;
    self.leftLab.font=[UIFont systemFontOfSize:15.0f];
    self.leftLab.textAlignment=NSTextAlignmentLeft;
    self.leftLab.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(ZSWIDTH/2+30, self.frame.size.height);//labelsize的最大值
    //关键语句
    CGSize expectSize = [self.leftLab sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    self.leftLab.frame = CGRectMake(15, 0, expectSize.width, self.frame.size.height);
    [self.leftLab addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.contentView addSubview:self.leftLab];
    
    self.rightTextField=[UITextField new];
    self.rightTextField.textAlignment=NSTextAlignmentRight;
    self.rightTextField.textColor = ZSColorListRight;
    self.rightTextField.font=[UIFont systemFontOfSize:15.0f];
    self.rightTextField.returnKeyType=UIReturnKeyDone;
    [self.contentView addSubview:self.rightTextField];
    [self.rightTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.leftLab withOffset:10];
    [self.rightTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [self.rightTextField autoSetDimension:ALDimensionHeight toSize:self.frame.size.height];
    [self.rightTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom ];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        UILabel *lab=(UILabel*)object;
        CGSize maximumLabelSize = CGSizeMake(ZSWIDTH/2, self.frame.size.height);//labelsize的最大值
        //关键语句
        CGSize expectSize = [lab sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        lab.frame = CGRectMake(15, 0, expectSize.width, self.frame.size.height);
    }
}

- (void)dealloc
{
    [self.leftLab removeObserver:self forKeyPath:@"text"];
}

@end
