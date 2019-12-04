//
//  ZSWSNewLeftRightCell.m
//  ZSMoneytocar
//
//  Created by gengping on 17/4/27.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSWSNewLeftRightCell.h"

@implementation ZSWSNewLeftRightCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.leftLab.textColor  = ZSColorListLeft;
    self.rightLab.textColor = ZSColorListRight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    ZSLOG(@"-------%f",self.rightLab.height);
    //换行的时候靠左显示
   float height = [NSString sizeWithText:self.rightLab.text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(self.rightLab.width, MAXFLOAT)] + 20;
    if (height > 44){
        self.rightLab.textAlignment = NSTextAlignmentLeft;
    }else{
        self.rightLab.textAlignment = NSTextAlignmentRight;
    }
}

- (void)setModel:(ZSOrderModel *)model
{
    if (model)
    {
        _model = model;
        
        self.leftLab.text = model.leftName;
        
        if ([model.leftName isEqualToString:@"订单编号"]) {
            if (model.rightData.length)
            {
                NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc]initWithString:model.rightData];
                [mutableString addAttribute:NSForegroundColorAttributeName value:ZSColorRed range:NSMakeRange(model.rightData.length - 2, 2)];
                self.rightLab.attributedText = mutableString;
            }
        }
        else
        {
            self.rightLab.text = model.rightData;
        }
    }
}

@end
