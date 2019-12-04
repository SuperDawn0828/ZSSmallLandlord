//
//  ZSTotalNumTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/18.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSTotalNumTableViewCell.h"

@interface ZSTotalNumTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *NewLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@end

@implementation ZSTotalNumTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setModelNew:(ZSQuaryNewOrCompleteDataModel *)modelNew
{
    _modelNew = modelNew;
    
    NSString *numString = [NSString stringWithFormat:@"%@",modelNew.totalNum];
    NSString *amountString = [NSString stringWithFormat:@"%@",modelNew.totalAmount];
    amountString = [ZSTool yuanIntoTenThousandYuanWithCount:amountString WithType:YES];
    amountString = [NSString stringWithFormat:@"%.2f",[amountString floatValue]];
    
    if (numString.length && amountString.length)
    {
        self.NewLabel.text = [NSString stringWithFormat:@"%@笔，%@万元",numString,amountString];
    }
    else if (numString.length && !amountString.length)
    {
        self.NewLabel.text = [NSString stringWithFormat:@"%@笔",numString];
    }
    else
    {
        self.NewLabel.text = [NSString stringWithFormat:@"%@万元",amountString];
    }
}

- (void)setModelComplete:(ZSQuaryNewOrCompleteDataModel *)modelComplete
{
    _modelComplete = modelComplete;
    
    NSString *numString = [NSString stringWithFormat:@"%@",modelComplete.totalNum];
    NSString *amountString = [NSString stringWithFormat:@"%@",modelComplete.totalAmount];
    amountString = [ZSTool yuanIntoTenThousandYuanWithCount:amountString WithType:YES];
    amountString = [NSString stringWithFormat:@"%.2f",[amountString floatValue]];
    
    if (numString.length && amountString.length)
    {
        self.completeLabel.text = [NSString stringWithFormat:@"%@笔，%@万元",numString,amountString];
    }
    else if (numString.length && !amountString.length)
    {
        self.completeLabel.text = [NSString stringWithFormat:@"%@笔",numString];
    }
    else
    {
        self.completeLabel.text = [NSString stringWithFormat:@"%@万元",amountString];
    }
}

@end
