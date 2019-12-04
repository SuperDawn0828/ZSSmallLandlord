//
//  ZSNotificationCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSNotificationCell.h"

@implementation ZSNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleSpacing;//设置cell下分割线的风格
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //logo
    self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 38, 38)];
    [self addSubview:self.logoImage];
  
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.logoImage.right+15,15,ZSWIDTH-110-85,15)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = ZSColorListRight;
    [self addSubview:self.titleLabel];
 
    //时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-110-15,15,110,12)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = ZSColorAllNotice;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
   
    //内容
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.logoImage.right+15,41,ZSWIDTH-45-38, 35)];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = UIColorFromRGB(0x737373);
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
}

- (void)setModel:(ZSNotificationModel *)model
{
    _model = model;
  
    if (model.title)
    {
        NSString *titleString = [NSString stringWithFormat:@"%@",model.title];
        //logo
        self.logoImage.image = [UIImage imageNamed:[self setImageWithNotiType:titleString]];
        //标题
        self.titleLabel.text = titleString;
    }
 
    //时间
    if (model.createDate) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@",model.createDate];
    }
   
    //内容
    if (model.content)
    {
        NSString *string_Q = [NSString stringWithFormat:@"%@",model.content];
        CGSize size;
        if ([model.title isEqualToString:@"系统通知"] || [model.title isEqualToString:@"升级通知"] ) {
            size = CGSizeMake(ZSWIDTH-45-38,45);//最多显示两行,这个行高是根据数据打印出来获取的
        }
        else
        {
            size = CGSizeMake(ZSWIDTH-45-38,10000);
        }
        
        //设置label的frame
        self.contentLabel.frame = CGRectMake(self.logoImage.right+15, 41, ZSWIDTH-45-38, [ZSTool getStringHeight:string_Q withframe:size withSizeFont:[UIFont systemFontOfSize:14] winthLineSpacing:7]);
        
        //设置行间距
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 7;
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@0.0f};
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:string_Q attributes:dic];
        self.contentLabel.attributedText = attributeStr;
    }
}

- (NSString *)setImageWithNotiType:(NSString *)titleString
{
    if ([titleString isEqualToString:@"已审批通知"])
    {
        return @"notice_approved_n";
    }
    else if ([titleString isEqualToString:@"待审批通知"])
    {
        return @"notice_pending approval_n";
    }
    else if ([titleString isEqualToString:@"待提交资料通知"])
    {
        return @"notice_pending_n";
    }
    else if ([titleString isEqualToString:@"待征信反馈通知"])
    {
       return @"notice_pending credit feedback_n";
    }
    else if ([titleString isEqualToString:@"征信反馈通知"])
    {
        return @"notice_credit feedback_n";
    }
    else if ([titleString isEqualToString:@"微信申请派发通知"] || [titleString isEqualToString:@"微信申请通知"])
    {
        return @"notice_shenqing_n";
    }
    else if ([titleString isEqualToString:@"系统通知"])
    {
        return @"notice_news_n";
    }
    else if ([titleString isEqualToString:@"升级通知"])
    {
        return @"notice_upgrade_n";
    }
    else if ([titleString isEqualToString:@"待预授信评估通知"] || [titleString isEqualToString:@"待派单通知"] || [titleString isEqualToString:@"派单通知"])
    {
        return @"notice_pending credit feedback_n";
    }
    else
    {
        return @"notice_pending_n";
    }
}

@end
