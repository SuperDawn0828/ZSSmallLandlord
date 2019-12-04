//
//  ZSSLPersonDetailBigDataCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLPersonDetailBigDataCell.h"

@implementation ZSSLPersonDetailBigDataCell

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
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0,150,CellHeight)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = ZSColorListLeft;
    [self addSubview:self.titleLabel];

    self.img_result = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-35, (CellHeight-20)/2, 20, 20)];
    [self addSubview:self.img_result];
    
    self.label_result = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-35-160,0,150,CellHeight)];
    self.label_result.font = [UIFont systemFontOfSize:15];
    self.label_result.textColor = ZSColorListRight;
    self.label_result.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.label_result];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, ZSWIDTH-30, CellHeight)];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel.textColor = ZSPageItemColor;
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
}

- (void)setDetailModel:(BizCreditCustomers *)detailModel
{
    _detailModel = detailModel;
   
    //查询内容
    self.titleLabel.text = SafeStr(detailModel.interactName);
  
    //概要
    NSString *frontCreditSummary = SafeStr(detailModel.frontCreditSummary);
    if([frontCreditSummary rangeOfString:@"</"].location !=NSNotFound){
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[frontCreditSummary dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.label_result.attributedText = attrStr;
        self.label_result.font = [UIFont systemFontOfSize:15];
        self.label_result.textAlignment = NSTextAlignmentRight;
    }
    else{
        self.label_result.text = SafeStr(detailModel.frontCreditSummary);
    }
  
    //概要图片
    if (detailModel.showType) {
        if (detailModel.showType.intValue == 0)
        {
            self.img_result.image = [UIImage imageNamed:@"bar_warning_s"];
            self.label_result.textColor = UIColorFromRGB(0xFF6B61);
        }
        else if (detailModel.showType.intValue == 1)
        {
            self.img_result.image = [UIImage imageNamed:@"bar_warning_s"];
            self.label_result.textColor = UIColorFromRGB(0xFF6B61);
        }
        else if (detailModel.showType.intValue ==  2)
        {
            self.img_result.image = [UIImage imageNamed:@"list_chech_s"];
            self.label_result.textColor = UIColorFromRGB(0x515151);
        }
    }
  
    //详细内容
    NSString *htmlString = SafeStr(detailModel.frontCreditInfo);
    if([htmlString containsString:@"</"] || [htmlString containsString:@"/>"])
    {
        NSAttributedString *attrStr = [[NSAttributedString alloc]
                                       initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                       documentAttributes:nil
                                       error:nil];
        self.contentLabel.attributedText = attrStr;
        self.contentLabel.font = [UIFont systemFontOfSize:13];
    }
    else
    {
        self.contentLabel.text = SafeStr(detailModel.frontCreditInfo);
    }
    self.contentLabel.height = [ZSSLPersonDetailBigDataCell resetCellHeight:detailModel]-CellHeight;
}

+ (CGFloat)resetCellHeight:(BizCreditCustomers *)detailModel
{
    if (detailModel.frontCreditInfo.length) {
        
        NSString *htmlString = detailModel.frontCreditInfo;
        if([htmlString rangeOfString:@"</"].location !=NSNotFound)
        {
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

            return CellHeight + [ZSSLPersonDetailBigDataCell getStringHeight:[attrStr string]] + 10;
        }
        else
        {
            return CellHeight + [ZSSLPersonDetailBigDataCell getStringHeight:htmlString] + 10;
        }
    }
    else
    {
        return CellHeight;
    }
}

+ (CGFloat)getStringHeight:(NSString *)string
{
    CGSize size = CGSizeMake(ZSWIDTH-30,100000);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
    CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return labelsize.height;
}

@end
