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
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //姓名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0,0, 39)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = ZSColorListRight;
    [self addSubview:self.nameLabel];
   
    //身份证号
    self.idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,self.nameLabel.bottom+3,250, 20)];
    self.idCardLabel.font = [UIFont systemFontOfSize:13];
    self.idCardLabel.textColor = ZSColorListLeft;
    [self addSubview:self.idCardLabel];
 
    //反馈状态
    self.label_feedbackState = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-95,4.5+5,80, 20)];
    self.label_feedbackState.font = [UIFont systemFontOfSize:12];
    self.label_feedbackState.textColor = ZSColorGreen;
    self.label_feedbackState.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.label_feedbackState];
   
    //反馈时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-200-15,self.nameLabel.bottom+3,200, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = ZSColorListLeft;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
  
    //人员标签
    self.personnelTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.right+5,4.5+7.5,29,15)];
    self.personnelTagLabel.font = [UIFont systemFontOfSize:12];
    self.personnelTagLabel.textColor = ZSColorWhite;
    self.personnelTagLabel.textAlignment = NSTextAlignmentCenter;
    self.personnelTagLabel.layer.cornerRadius = 2;
    self.personnelTagLabel.layer.masksToBounds = YES;
    [self addSubview:self.personnelTagLabel];
  
    //共有人标签
    self.coownerTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.personnelTagLabel.right+5,4.5+7.5,42,15)];
    self.coownerTagLabel.font = [UIFont systemFontOfSize:12];
    self.coownerTagLabel.textColor = ZSColorWhite;
    self.coownerTagLabel.text = @"共有人";
    self.coownerTagLabel.textAlignment = NSTextAlignmentCenter;
    self.coownerTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_MortgageLoan"] Withview:self.coownerTagLabel]];
    self.coownerTagLabel.layer.cornerRadius = 2;
    self.coownerTagLabel.layer.masksToBounds = YES;
    self.coownerTagLabel.hidden = YES;
    [self addSubview:self.coownerTagLabel];
    
    //重设名字的宽度
    self.nameLabel.width = ZSWIDTH-30-self.label_feedbackState.width-29-42-10;
    if (ZSWIDTH == 320) {
        self.nameLabel.top = 0;
        self.nameLabel.height = 40;
    }else{
        self.nameLabel.top = 4.5;
        self.nameLabel.height = 30;
    }
}

- (void)setDetailModel:(CustInfo *)detailModel
{
    _detailModel = detailModel;
    //姓名
    self.nameLabel.text = SafeStr(detailModel.name);
    //身份证
    self.idCardLabel.text = SafeStr(detailModel.identityNo);
    //银行反馈状态和反馈时间
    if (detailModel.isBankCredit.intValue == 1) {
        if (detailModel.creditResult) {
            if (detailModel.creditResult.intValue == 0) {
                if (global.wsOrderDetail.projectInfo.orderState.intValue == 1) {//订单为待提交征信查询时, 不要显示“未反馈”
                    self.label_feedbackState.hidden = YES;
                    self.timeLabel.hidden = YES;
                }else{
                    self.label_feedbackState.textColor = ZSColorListLeft;
                    self.label_feedbackState.text = @"未反馈";
                    self.timeLabel.hidden = YES;
                }
            }else if (detailModel.creditResult.intValue == 1) {
                self.label_feedbackState.textColor = ZSColorGreen;
                self.label_feedbackState.text = @"已反馈-通过";
                self.timeLabel.hidden = NO;
                self.timeLabel.text = SafeStr(detailModel.creditDate);
            }else if (detailModel.creditResult.intValue == 2){
                self.label_feedbackState.textColor = ZSColorRed;
                self.label_feedbackState.text = @"已反馈-不通过";
                self.timeLabel.hidden = NO;
                self.timeLabel.text = SafeStr(detailModel.creditDate);
            }
        }
        else{
            if (global.wsOrderDetail.projectInfo.orderState.intValue == 1) {//订单为待提交征信查询时, 不要显示“未反馈”
                self.label_feedbackState.hidden = YES;
                self.timeLabel.hidden = YES;
            }else{
                self.label_feedbackState.textColor = ZSColorListLeft;
                self.label_feedbackState.text = @"不查询";
                self.timeLabel.hidden = YES;
            }
        }
    }
    else
    {
        if (global.wsOrderDetail.projectInfo.orderState.intValue == 1) {//订单为待提交征信查询时, 不要显示“未反馈”
            self.label_feedbackState.hidden = YES;
            self.timeLabel.hidden = YES;
        }else{
            self.label_feedbackState.textColor = ZSColorListLeft;
            self.label_feedbackState.text = @"不查询";
            self.timeLabel.hidden = YES;
        }
    }

    //各种标签
    NSString *string_Q = SafeStr(detailModel.name);
    CGSize size = CGSizeMake(ZSWIDTH-30-80-29-42-10,30);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
    CGSize labelsize = [string_Q boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    if (detailModel.releation) {
        self.personnelTagLabel.left = 15 + labelsize.width +5;
        if ([detailModel.releation intValue]==1) {//贷款人
            self.personnelTagLabel.width = 42;
            self.personnelTagLabel.text = @"贷款人";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_witnessServer"] Withview:self.personnelTagLabel]];
            self.coownerTagLabel.hidden = YES;
        }
        else if ([detailModel.releation intValue]==2) {//配偶
            self.personnelTagLabel.width = 68;
            self.personnelTagLabel.text = @"贷款人配偶";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_StarLoan"] Withview:self.personnelTagLabel]];
            self.coownerTagLabel.hidden = YES;
        }
        else if ([detailModel.releation intValue]==3) {//配偶&共有人
            self.personnelTagLabel.width = 68;
            self.personnelTagLabel.text = @"贷款人配偶";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_StarLoan"] Withview:self.personnelTagLabel]];
            self.coownerTagLabel.hidden = NO;
            self.coownerTagLabel.left = self.personnelTagLabel.right+5;
        }
        else if ([detailModel.releation intValue]==4) {//共有人
            self.personnelTagLabel.width = 42;
            self.personnelTagLabel.text = @"共有人";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_MortgageLoan"] Withview:self.personnelTagLabel]];
            self.coownerTagLabel.hidden = YES;
        }
        else if ([detailModel.releation intValue]==5) {//担保人
            self.personnelTagLabel.width = 42;
            self.personnelTagLabel.text = @"担保人";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.personnelTagLabel]];
            self.coownerTagLabel.hidden = YES;
        }
        else if ([detailModel.releation intValue]==6) {//担保人配偶
            self.personnelTagLabel.width = 68;
            self.personnelTagLabel.text = @"担保人配偶";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_ApplyOnline"] Withview:self.personnelTagLabel]];
            self.coownerTagLabel.hidden = YES;
        }
    }
}

@end
