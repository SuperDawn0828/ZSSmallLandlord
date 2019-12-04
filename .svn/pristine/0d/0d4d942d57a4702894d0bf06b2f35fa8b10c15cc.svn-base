//
//  ZSViewPersonListCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSPersonListViewCell.h"

@implementation ZSWSPersonListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleSpacing;//设置cell上分割线的风格
        self.cellSpace = 0;//设置cell之间的间隔
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //姓名
    self.label_name = [[UILabel alloc]initWithFrame:CGRectMake(15,0,0, 39)];
    self.label_name.font = Font(15);
    self.label_name.numberOfLines = 0;
    self.label_name.textColor = ZSColorListLeft;
    [self addSubview:self.label_name];
    //身份证号
    self.label_idCard = [[UILabel alloc]initWithFrame:CGRectMake(15,self.label_name.bottom+3,250, 20)];
    self.label_idCard.font = Font(13);
    self.label_idCard.textColor = ZSPageItemColor;
    [self addSubview:self.label_idCard];
    //反馈状态
    self.label_feedbackState = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-95,4.5+5,80, 20)];
    self.label_feedbackState.font = Font(12);
    self.label_feedbackState.textColor = ZSColorGreen;
    self.label_feedbackState.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.label_feedbackState];
    //反馈时间
    self.label_time = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-200-15,self.label_name.bottom+3,200, 20)];
    self.label_time.font = Font(12);
    self.label_time.textColor = ZSPageItemColor;
    self.label_time.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.label_time];
    //本人标签
    self.label_self_tag = [[UILabel alloc]initWithFrame:CGRectMake(self.label_name.right+5,4.5+7.5,29,15)];
    self.label_self_tag.font = Font(12);
    self.label_self_tag.textColor = [UIColor whiteColor];
    self.label_self_tag.text = @"本人";
    self.label_self_tag.textAlignment = NSTextAlignmentCenter;
    self.label_self_tag.backgroundColor = ZSColorYellow;
    self.label_self_tag.layer.cornerRadius = 2;
    self.label_self_tag.layer.masksToBounds = YES;
    self.label_self_tag.hidden = YES;
    [self addSubview:self.label_self_tag];
    //配偶标签
    self.label_mate_tag = [[UILabel alloc]initWithFrame:CGRectMake(self.label_self_tag.right+5,4.5+7.5,29,15)];
    self.label_mate_tag.font = Font(12);
    self.label_mate_tag.textColor = [UIColor whiteColor];
    self.label_mate_tag.text = @"配偶";
    self.label_mate_tag.textAlignment = NSTextAlignmentCenter;
    self.label_mate_tag.backgroundColor = ZSColorRed;
    self.label_mate_tag.layer.cornerRadius = 2;
    self.label_mate_tag.layer.masksToBounds = YES;
    self.label_mate_tag.hidden = YES;
    [self addSubview:self.label_mate_tag];
    //共有人标签
    self.label_coowner_tag = [[UILabel alloc]initWithFrame:CGRectMake(self.label_mate_tag.right+5,4.5+7.5,42,15)];
    self.label_coowner_tag.font = Font(12);
    self.label_coowner_tag.textColor = [UIColor whiteColor];
    self.label_coowner_tag.text = @"共有人";
    self.label_coowner_tag.textAlignment = NSTextAlignmentCenter;
    self.label_coowner_tag.backgroundColor = ZSColorGreen;
    self.label_coowner_tag.layer.cornerRadius = 2;
    self.label_coowner_tag.layer.masksToBounds = YES;
    self.label_coowner_tag.hidden = YES;
    [self addSubview:self.label_coowner_tag];
    //担保人标签
    self.label_bondsman_tag = [[UILabel alloc]initWithFrame:CGRectMake(self.label_coowner_tag.right+5,4.5+7.5,42,15)];
    self.label_bondsman_tag.font = Font(12);
    self.label_bondsman_tag.textColor = [UIColor whiteColor];
    self.label_bondsman_tag.text = @"担保人";
    self.label_bondsman_tag.textAlignment = NSTextAlignmentCenter;
    self.label_bondsman_tag.backgroundColor = ZSColorBlue;
    self.label_bondsman_tag.layer.cornerRadius = 2;
    self.label_bondsman_tag.layer.masksToBounds = YES;
    self.label_bondsman_tag.hidden = YES;
    [self addSubview:self.label_bondsman_tag];
    //担保人配偶标签
    self.label_bondsmanMate_tag = [[UILabel alloc]initWithFrame:CGRectMake(self.label_bondsman_tag.right+5,4.5+7.5,68,15)];
    self.label_bondsmanMate_tag.font = Font(12);
    self.label_bondsmanMate_tag.textColor = [UIColor whiteColor];
    self.label_bondsmanMate_tag.text = @"担保人配偶";
    self.label_bondsmanMate_tag.textAlignment = NSTextAlignmentCenter;
    self.label_bondsmanMate_tag.backgroundColor = ZSColorOrange;
    self.label_bondsmanMate_tag.layer.cornerRadius = 2;
    self.label_bondsmanMate_tag.layer.masksToBounds = YES;
    self.label_bondsmanMate_tag.hidden = YES;
    [self addSubview:self.label_bondsmanMate_tag];
    //重设名字的宽度
    self.label_name.width = ZSWIDTH-30-self.label_feedbackState.width-self.label_mate_tag.width-self.label_coowner_tag.width-10;
    if (ZSWIDTH == 320) {
        self.label_name.top = 0;
        self.label_name.height = 40;
    }else{
        self.label_name.top = 4.5;
        self.label_name.height = 30;
    }
}

- (void)setDetailModel:(CustInfo *)detailModel
{
    _detailModel = detailModel;
    //姓名
    self.label_name.text = SafeStr(detailModel.name);
    //身份证
    self.label_idCard.text = SafeStr(detailModel.identityNo);
    //银行反馈状态和反馈时间
    if (detailModel.creditResult) {
        if (detailModel.creditResult.intValue == 0) {
            if ([global.wsOrderDetail.projectInfo.orderState intValue] == 1) {//订单为待提交征信查询时, 不要显示“未反馈”
                self.label_feedbackState.hidden = YES;
                self.label_time.hidden = YES;
            }else{
                self.label_feedbackState.textColor = ZSPageItemColor;
                self.label_feedbackState.text = @"未反馈";
                self.label_time.hidden = YES;
            }
        }else if (detailModel.creditResult.intValue == 1) {
            self.label_feedbackState.textColor = ZSColorGreen;
            self.label_feedbackState.text = @"已反馈-通过";
            self.label_time.hidden = NO;
            self.label_time.text = SafeStr(detailModel.creditDate);
        }else if (detailModel.creditResult.intValue == 2){
            self.label_feedbackState.textColor = ZSColorRed;
            self.label_feedbackState.text = @"已反馈-不通过";
            self.label_time.hidden = NO;
            self.label_time.text = SafeStr(detailModel.creditDate);
        }
    }else{
        if ([global.wsOrderDetail.projectInfo.orderState intValue] == 1) {//订单为待提交征信查询时, 不要显示“未反馈”
            self.label_feedbackState.hidden = YES;
            self.label_time.hidden = YES;
        }else{
            self.label_feedbackState.textColor = ZSPageItemColor;
            self.label_feedbackState.text = @"不查询";
            self.label_time.hidden = YES;
        }
    }

    //各种标签
    NSString *string_Q = SafeStr(detailModel.name);
    CGSize size = CGSizeMake(ZSWIDTH-30-self.label_feedbackState.width-self.label_mate_tag.width-self.label_coowner_tag.width-10,30);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName, nil];
    CGSize labelsize = [string_Q boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    if ([detailModel.releation intValue]==1) {//本人
        self.label_self_tag.hidden = NO;
        self.label_self_tag.left = 15 + labelsize.width +5;
        self.label_mate_tag.hidden = YES;
        self.label_coowner_tag.hidden = YES;
        self.label_bondsman_tag.hidden = YES;
        self.label_bondsmanMate_tag.hidden = YES;
    }
    else if ([detailModel.releation intValue]==2) {//配偶
        self.label_mate_tag.hidden = NO;
        self.label_mate_tag.left = 15 + labelsize.width +5;
        self.label_self_tag.hidden = YES;
        self.label_coowner_tag.hidden = YES;
        self.label_bondsman_tag.hidden = YES;
        self.label_bondsmanMate_tag.hidden = YES;
    }
    else if ([detailModel.releation intValue]==3) {//配偶&共有人
        self.label_mate_tag.hidden = NO;
        self.label_mate_tag.left = 15 + labelsize.width +5;
        self.label_coowner_tag.hidden = NO;
        self.label_coowner_tag.left = self.label_mate_tag.right + 5;
        self.label_self_tag.hidden = YES;
        self.label_bondsman_tag.hidden = YES;
        self.label_bondsmanMate_tag.hidden = YES;
    }
    else if ([detailModel.releation intValue]==4) {//共有人
        self.label_coowner_tag.hidden = NO;
        self.label_coowner_tag.left = 15 + labelsize.width +5;
        self.label_self_tag.hidden = YES;
        self.label_mate_tag.hidden = YES;
        self.label_bondsman_tag.hidden = YES;
        self.label_bondsmanMate_tag.hidden = YES;
    }
    else if ([detailModel.releation intValue]==5) {//担保人
        self.label_bondsman_tag.hidden = NO;
        self.label_bondsman_tag.left = 15 + labelsize.width +5;
        self.label_self_tag.hidden = YES;
        self.label_mate_tag.hidden = YES;
        self.label_coowner_tag.hidden = YES;
        self.label_bondsmanMate_tag.hidden = YES;
    }
    else if ([detailModel.releation intValue]==6) {//担保人配偶
        self.label_bondsmanMate_tag.hidden = NO;
        self.label_bondsmanMate_tag.left = 15 + labelsize.width +5;
        self.label_self_tag.hidden = YES;
        self.label_mate_tag.hidden = YES;
        self.label_coowner_tag.hidden = YES;
        self.label_bondsman_tag.hidden = YES;
    }
}

@end
