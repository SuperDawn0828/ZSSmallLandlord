//
//  ZSSLNewLeftRightCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLNewLeftRightCell.h"

@implementation ZSSLNewLeftRightCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        [self initViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initViews
{
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0,100,self.height)];
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    self.leftLabel.textColor = ZSColorListLeft;
    self.leftLabel.numberOfLines = 0;
    [self addSubview:self.leftLabel];
   
    self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.leftLabel.right+5,0,ZSWIDTH-100-30,self.height)];
    self.rightLabel.font = [UIFont systemFontOfSize:15];
    self.rightLabel.textColor = ZSColorListRight;
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.numberOfLines = 0;
    [self addSubview:self.rightLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    float height = [NSString sizeWithText:self.rightLabel.text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(self.rightLabel.width, MAXFLOAT)] + 20;
    if (height > CellHeight){
        self.rightLabel.textAlignment = NSTextAlignmentLeft;
        self.rightLabel.frame = CGRectMake(self.leftLabel.right+5, 0, ZSWIDTH-100-30, height);
    }else{
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.frame = CGRectMake(self.leftLabel.right+5, 0, ZSWIDTH-100-30, CellHeight);
    }
}

+ (CGFloat)resetHeight:(NSString *)string
{
    CGFloat height = 0;
    CGSize size = CGSizeMake(ZSWIDTH-100-30,1000);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
    CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    if (labelsize.height+20 <= CellHeight) {
        height = CellHeight;
    }else{
        height = labelsize.height + 20;
    }
    return height;
}

@end
