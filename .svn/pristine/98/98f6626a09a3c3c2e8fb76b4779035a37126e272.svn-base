//
//  ZSMaterialCollectRecordCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/22.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSMaterialCollectRecordCell.h"

@implementation ZSMaterialCollectRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //禁止cell店家
        self.userInteractionEnabled = NO;
        
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleSpacing;
        self.leftSpace = 38.5;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //线
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(21.5, 0, 0.5, 200)];
    self.lineView.backgroundColor = ZSColorLine;
    [self addSubview:self.lineView];
    //圆
    self.imgview_left = [[UIImageView alloc]initWithFrame:CGRectMake(18.5, 20, 6.5, 6.5)];
    self.imgview_left.backgroundColor = UIColorFromRGB(0xCCCCCC);
    self.imgview_left.layer.cornerRadius = 3.25;
    self.imgview_left.layer.masksToBounds = YES;
    [self addSubview:self.imgview_left];
    //时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(38.5,16,200, 13)];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = ZSPageItemColor;
    [self addSubview:self.timeLabel];
    //提交人
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-100-15,16,100, 13)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:13];
    self.nameLabel.textColor = ZSColorListLeft;
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.nameLabel];
    //内容
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(38.5,43,ZSWIDTH-38.5-15, 200-43-10)];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = ZSColorListLeft;
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
}

- (void)setModel:(ZSMaterialCollectRecordModel *)model
{
    _model = model;
    
    if (model.createDate) {
        self.timeLabel.text = model.createDate;
    }
    
    if (model.userName) {
        self.nameLabel.text = model.userName;
    }
    
    if (model.docNames) {
        NSString *string = [NSString stringWithFormat:@"%@已收集",model.docNames];
        //label行间距
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 7;
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@0.0f};
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:string attributes:dic];
        self.contentLabel.attributedText = attributeStr;
        //设置frame
        self.contentLabel.height = [ZSTool getStringHeight:string withframe:CGSizeMake(ZSWIDTH-38.5-15, 100000) withSizeFont:[UIFont systemFontOfSize:14] winthLineSpacing:7];
    }
    
    self.lineView.height = self.contentLabel.height + 43 +10;
}

@end
