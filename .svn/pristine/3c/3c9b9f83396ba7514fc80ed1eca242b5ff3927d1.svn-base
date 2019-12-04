//
//  ZSSLPersonListFooterView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/8/7.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLPersonListFooterView.h"

#define cellNewWidth ZSWIDTH-20

@interface ZSSLPersonListFooterView ()
@property (nonatomic,strong) UILabel     *label_sourceLeft;
@property (nonatomic,strong) UILabel     *label_sourceRight;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *label_phone;
@end

@implementation ZSSLPersonListFooterView

- (instancetype)initWithFrame:(CGRect)frame
             withMOrderSource:(NSString *)source        //客户来源 1中介 2线下 3微信 4官网 5中介APP
            withAgencyContact:(NSString *)contactName
       withAgencyContactPhone:(NSString *)contactPhone
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (source.intValue == 1 || source.intValue == 5) {
            [self initMediationwithMOrderSource:(NSString *)source WithAgencyContact:contactName withAgencyContactPhone:contactPhone withSource:source];
        }
        else
        {
            [self initOfflinewithSource:source];
        }
    }
    return self;
}

#pragma mark 中介
- (void)initMediationwithMOrderSource:(NSString *)source
                    WithAgencyContact:(NSString *)contactName
               withAgencyContactPhone:(NSString *)contactPhone
                           withSource:(NSString *)source
{
    UIView *view_cut = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    view_cut.backgroundColor = ZSViewBackgroundColor;
    [self addSubview:view_cut];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, self.height-10)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self addSubview:backgroundView];
    
    self.label_sourceLeft = [[UILabel alloc]init];
    self.label_sourceLeft.font = [UIFont systemFontOfSize:15];
    self.label_sourceLeft.textColor = ZSColorListRight;
    self.label_sourceLeft.text = @"客户来源";
    [backgroundView addSubview:self.label_sourceLeft];
    
    self.label_sourceRight = [[UILabel alloc]init];
    self.label_sourceRight.font = [UIFont systemFontOfSize:15];
    self.label_sourceRight.textColor = UIColorFromRGB(0xFF9D2D);
    self.label_sourceRight.textAlignment = NSTextAlignmentRight;
    self.label_sourceRight.text = source.intValue == 1 ? @"中介推荐" : @"中介APP";
    [backgroundView addSubview:self.label_sourceRight];
    
    if (contactName.length == 0 && contactPhone.length == 0)
    {
        self.label_sourceLeft.frame = CGRectMake(15, 0, 100, backgroundView.height);
        self.label_sourceRight.frame = CGRectMake(ZSWIDTH-150-15, 0, 150, backgroundView.height);
    }
    else
    {
        self.label_sourceLeft.frame = CGRectMake(15, 0, 100, 39);
        self.label_sourceRight.frame = CGRectMake(ZSWIDTH-150-15, 0, 150, 39);
        //中介人名字
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,self.label_sourceLeft.bottom+3,250, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textColor = ZSColorListLeft;
        self.nameLabel.text = contactName.length ? contactName : @"";
        [backgroundView addSubview:self.nameLabel];
        //中介人电话
        self.label_phone = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-150-15,self.label_sourceRight.bottom+3,150, 20)];
        self.label_phone.font = [UIFont systemFontOfSize:12];
        self.label_phone.textColor = ZSColorListLeft;
        self.label_phone.textAlignment = NSTextAlignmentRight;
        self.label_phone.text = contactPhone.length ? contactPhone : @"";
        [backgroundView addSubview:self.label_phone];
    }
    
    if (source.intValue == 1) {
        //如果是中介信息可以进行修改
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:tap];
    }
}

#pragma mark 线下/微信/官网/中介APP
- (void)initOfflinewithSource:(NSString *)source
{
    UIView *view_cut = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    view_cut.backgroundColor = ZSViewBackgroundColor;
    [self addSubview:view_cut];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, self.height-10)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self addSubview:backgroundView];
    
    self.label_sourceLeft = [[UILabel alloc]init];
    self.label_sourceLeft.frame = CGRectMake(15, 0, 100, self.height-10);
    self.label_sourceLeft.font = [UIFont systemFontOfSize:15];
    self.label_sourceLeft.textColor = ZSColorListRight;
    self.label_sourceLeft.text = @"客户来源";
    [backgroundView addSubview:self.label_sourceLeft];
    
    self.label_sourceRight = [[UILabel alloc]init];
    self.label_sourceRight.frame = CGRectMake(ZSWIDTH-150-15, 0, 150, self.height-10);
    self.label_sourceRight.font = [UIFont systemFontOfSize:15];
    self.label_sourceRight.textColor = UIColorFromRGB(0xFF9D2D);
    self.label_sourceRight.textAlignment = NSTextAlignmentRight;
    [backgroundView addSubview:self.label_sourceRight];
  
    if (source.intValue == 2) {
        self.label_sourceRight.text = @"线下客户";
        //如果是线下客户可以进行修改
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:tap];
    }
    else if (source.intValue == 3) {
        self.label_sourceRight.text = @"微信申请";
    }
    else if (source.intValue == 4) {
        self.label_sourceRight.text = @"官网申请";
    }
}

- (void)tapGesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(goToChangeAgency)]){
        [self.delegate goToChangeAgency];
    }
}

@end
