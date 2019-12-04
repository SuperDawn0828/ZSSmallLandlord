//
//  BankInfo.m
//  EXOCR
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 z. All rights reserved.
//

#import "BankInfo.h"

static BOOL bSpaceWithBANKCardNum = YES;
static BOOL bNoShowBANKResultView = NO;
static BOOL bNoShowBANKBankName = NO;
static BOOL bNoShowBANKCardName = NO;
static BOOL bNoShowBANKCardType = NO;
static BOOL bNoShowBANKCardNum = NO;
static BOOL bNoShowBANKValidDate = NO;
static BOOL bNoShowBANKCardNumImg = NO;

@implementation BankInfo

//卡号是否需要空格
+(BOOL) getSpaceWithBANKCardNum
{
    return bSpaceWithBANKCardNum;
}
+(void) setSpaceWithBANKCardNum:(BOOL)bSpace
{
    bSpaceWithBANKCardNum = bSpace;
}
//是否显示结果页
+(BOOL) getNoShowBANKResultView
{
    return bNoShowBANKResultView;
}
+(void) setNoShowBANKResultView:(BOOL)bShow
{
    bNoShowBANKResultView = bShow;
}
//是否显示银行名称
+(BOOL) getNoShowBANKBankName
{
    return bNoShowBANKBankName;
}
+(void) setNoShowBANKBankName:(BOOL)bShow
{
    bNoShowBANKBankName = bShow;
}
//是否显示卡名称
+(BOOL) getNoShowBANKCardName
{
    return bNoShowBANKCardName;
}
+(void) setNoShowBANKCardName:(BOOL)bShow
{
    bNoShowBANKCardName = bShow;
}
//是否显示卡类型
+(BOOL) getNoShowBANKCardType
{
    return bNoShowBANKCardType;
}
+(void) setNoShowBANKCardType:(BOOL)bShow
{
    bNoShowBANKCardType = bShow;
}
//是否显示卡号
+(BOOL) getNoShowBANKCardNum
{
    return bNoShowBANKCardNum;
}
+(void) setNoShowBANKCardNum:(BOOL)bShow
{
    bNoShowBANKCardNum = bShow;
}
//是否显示有效期
+(BOOL) getNoShowBANKValidDate
{
    return bNoShowBANKValidDate;
}
+(void) setNoShowBANKValidDate:(BOOL)bShow
{
    bNoShowBANKValidDate = bShow;
}
//是否显示卡号截图
+(BOOL) getNoShowBANKCardNumImg
{
    return bNoShowBANKCardNumImg;
}
+(void) setNoShowBANKCardNumImg:(BOOL)bShow
{
    bNoShowBANKCardNumImg = bShow;
}

- (NSString *)toString
{
    return [NSString stringWithFormat:@"银行名称:%@\n卡名称:%@\n卡类型:%@\n卡号:%@\n有效期:%@",
            _bankName, _cardName, _cardType, _cardNum, _validDate];
}

- (BOOL)isOK
{
    if ( _cardNum!=nil)
    {
        if (_cardNum.length>0)
        {
            return true;
        }
    }
    return false;
}

@end

