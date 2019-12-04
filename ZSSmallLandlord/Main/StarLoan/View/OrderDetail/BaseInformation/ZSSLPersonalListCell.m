//
//  ZSSLPersonalListCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLPersonalListCell.h"

@interface ZSSLPersonalListCell ()
@property (nonatomic,strong) UILabel     *nameLabel;         //姓名
@property (nonatomic,strong) UILabel     *idCardLabel;       //身份证号
@property (nonatomic,strong) UILabel     *queryStateLabel;   //查询状态
@property (nonatomic,strong) UIImageView *upImgView;
@property (nonatomic,strong) UIImageView *downImgView;
@property (nonatomic,strong) UIButton    *upChangeBtn;
@property (nonatomic,strong) UIButton    *downChangeBtn;
@property (nonatomic,strong) UIView      *lineView;
@end

@implementation ZSSLPersonalListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
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
 
    //大数据风控状态
    self.queryStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-95,0,80, 70)];
    self.queryStateLabel.font = [UIFont systemFontOfSize:12];
    self.queryStateLabel.textColor = ZSColorGreen;
    self.queryStateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.queryStateLabel];
    
    //人员标签
    self.personnelTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.right+5,4.5+7.5,29,15)];
    self.personnelTagLabel.font = [UIFont systemFontOfSize:12];
    self.personnelTagLabel.textColor = ZSColorWhite;
    self.personnelTagLabel.textAlignment = NSTextAlignmentCenter;
    self.personnelTagLabel.layer.cornerRadius = 2;
    self.personnelTagLabel.layer.masksToBounds = YES;
    [self addSubview:self.personnelTagLabel];
    
    //重设名字的宽度
    self.nameLabel.width = ZSWIDTH-30-self.queryStateLabel.width-10;
    if (ZSWIDTH == 320) {
        self.nameLabel.top = 0;
        self.nameLabel.height = 40;
    }else{
        self.nameLabel.top = 4.5;
        self.nameLabel.height = 30;
    }
    
    //角色互换上面的图片
    self.upImgView = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-45, 0, 30, 15)];
    self.upImgView.image = [UIImage imageNamed:@"下半圆"];
    self.upImgView.hidden = YES;
    [self addSubview:self.upImgView];
    
    //角色互换下面的图片
    self.downImgView = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-45, 70-15, 30, 15)];
    self.downImgView.image = [UIImage imageNamed:@"上半圆"];
    self.downImgView.hidden = YES;
    [self addSubview:self.downImgView];
    
    //角色互换上面按钮
    self.upChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.upChangeBtn.frame = CGRectMake(ZSWIDTH-60, 0, 60, 35);
    [self.upChangeBtn addTarget:self action:@selector(changeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.upChangeBtn.hidden = YES;
    [self addSubview:self.upChangeBtn];
    
    //角色互换下面按钮
    self.downChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downChangeBtn.frame = CGRectMake(ZSWIDTH-60, 35, 60, 35);
    [self.downChangeBtn addTarget:self action:@selector(changeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.downChangeBtn.hidden = YES;
    [self addSubview:self.downChangeBtn];
    
    //分割线
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(GapWidth, 69.5, ZSWIDTH-GapWidth, 0.5)];
    self.lineView.backgroundColor = ZSColorLine;
    [self addSubview:self.lineView];
}

- (void)setDetailModel:(BizCustomers *)detailModel
{
    _detailModel = detailModel;
    
    //是否显示按钮
    if (detailModel.showDown == YES)
    {
        self.downImgView.hidden = NO;
        self.downChangeBtn.hidden = NO;
        self.lineView.frame = CGRectMake(GapWidth, 69.5, ZSWIDTH-GapWidth-60, 0.5);
    }
    else
    {
        self.downImgView.hidden = YES;
        self.downChangeBtn.hidden = YES;
        self.lineView.frame = CGRectMake(GapWidth, 69.5, ZSWIDTH-GapWidth, 0.5);
    }
    
    if (detailModel.showUp  == YES)
    {
        self.upImgView.hidden = NO;
        self.upChangeBtn.hidden = NO;
    }
    else
    {
        self.upImgView.hidden = YES;
        self.upChangeBtn.hidden = YES;
    }
    
    //姓名
    self.nameLabel.text = SafeStr(detailModel.name);
    
    //身份证
    self.idCardLabel.text = SafeStr(detailModel.identityNo);
    
    //标签
    NSString *string_Q = SafeStr(detailModel.name);
    CGSize size = CGSizeMake(ZSWIDTH-30-self.queryStateLabel.width-10,30);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
    CGSize labelsize = [string_Q boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    if (detailModel.releation)
    {
        self.personnelTagLabel.left = 15 + labelsize.width +5;
        if (detailModel.releation.intValue == 1)
        {
            self.personnelTagLabel.width = 42;
            self.personnelTagLabel.text = @"贷款人";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_witnessServer"] Withview:self.personnelTagLabel]];
        }
        else if (detailModel.releation.intValue == 2 || detailModel.releation.intValue == 3)
        {
            self.personnelTagLabel.width = 68;
            self.personnelTagLabel.text = @"贷款人配偶";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_StarLoan"] Withview:self.personnelTagLabel]];
        }
        else if (detailModel.releation.intValue == 4)
        {
            self.personnelTagLabel.width = 42;
            self.personnelTagLabel.text = @"共有人";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_MortgageLoan"] Withview:self.personnelTagLabel]];
        }
        else if (detailModel.releation.intValue == 5)
        {
            self.personnelTagLabel.width = 42;
            self.personnelTagLabel.text = @"担保人";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.personnelTagLabel]];
        }
        else if (detailModel.releation.intValue == 6)
        {
            self.personnelTagLabel.width = 68;
            self.personnelTagLabel.text = @"担保人配偶";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_ApplyOnline"] Withview:self.personnelTagLabel]];
        }
        else if (detailModel.releation.intValue == 7)
        {
            self.personnelTagLabel.width = 29;
            self.personnelTagLabel.text = @"卖方";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.personnelTagLabel]];
        }
        else if (detailModel.releation.intValue == 8)
        {
            self.personnelTagLabel.width = 54;
            self.personnelTagLabel.text = @"卖方配偶";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_ApplyOnline"] Withview:self.personnelTagLabel]];
        }
        else if (detailModel.releation.intValue == 9)
        {
            self.personnelTagLabel.width = 29;
            self.personnelTagLabel.text = @"买方";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.personnelTagLabel]];
        }
        else if (detailModel.releation.intValue == 10)
        {
            self.personnelTagLabel.width = 54;
            self.personnelTagLabel.text = @"买方配偶";
            self.personnelTagLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_ApplyOnline"] Withview:self.personnelTagLabel]];
        }
    }
}

#pragma mark 更换角色
- (void)changeBtnAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(changeRole:)]){
        [self.delegate changeRole:self.detailModel];
    }
}

@end
