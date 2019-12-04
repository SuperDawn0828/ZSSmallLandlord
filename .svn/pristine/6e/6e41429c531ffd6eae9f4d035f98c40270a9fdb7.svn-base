//
//  ZSGlobalModel.m
//  ZSMoneytocar
//
//  Created by 武 on 2016/10/13.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSGlobalModel.h"

@implementation ZSGlobalModel

+ (ZSGlobalModel*)shareInfo
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark /*------------------------------产品类型 1001 新房见证 1081星速贷 1080赎楼宝 1084抵押贷 1083车位分期 1085代办业务------------------------------*/
+ (NSArray  *)getProductArray;
{
    return @[@"星速贷",@"赎楼宝",@"抵押贷",@"代办业务",@"融易贷",@"车位分期"];
}

+ (NSString *)getProductStateWithCode:(NSString *)product
{
    if ([product isEqualToString:kProduceTypeWitnessServer]) {
        return @"新房见证";
    }
    else if ([product isEqualToString:kProduceTypeStarLoan]) {
        return @"星速贷";
    }
    else if ([product isEqualToString:kProduceTypeRedeemFloor]) {
        return @"赎楼宝";
    }
    else if ([product isEqualToString:kProduceTypeMortgageLoan]) {
        return @"抵押贷";
    }
    else if ([product isEqualToString:kProduceTypeCarHire]) {
        return @"车位分期";
    }
    else if ([product isEqualToString:kProduceTypeAgencyBusiness]) {
        return @"代办业务";
    }
    else {
        return @"融易贷";
    }
}

+ (NSString *)getProductCodeWithState:(NSString *)product
{
    if ([product isEqualToString:@"新房见证"]) {
        return kProduceTypeWitnessServer;
    }
    else if ([product isEqualToString:@"星速贷"]) {
        return kProduceTypeStarLoan;
    }
    else if ([product isEqualToString:@"赎楼宝"]) {
        return kProduceTypeRedeemFloor;
    }
    else if ([product isEqualToString:@"抵押贷"]) {
        return kProduceTypeMortgageLoan;
    }
    else if ([product isEqualToString:@"车位分期"]) {
        return kProduceTypeCarHire;
    }
    else if ([product isEqualToString:@"代办业务"]) {
        return kProduceTypeAgencyBusiness;
    }
    else {
        return kProduceTypeEasyLoans;
    }
}

#pragma mark /*------------------------------婚姻状况 1未婚 2已婚 3离异 4丧偶------------------------------*/
+ (NSArray *)getMarrayStateArray
{
    return @[@"未婚",@"已婚",@"离异",@"丧偶"];
}

+ (NSString *)getMarrayStateWithCode:(NSString *)beMarrage
{
    if (beMarrage.intValue == 1) {
        return @"未婚";
    }
    else if (beMarrage.intValue == 2) {
        return @"已婚";
    }
    else if (beMarrage.intValue == 3) {
        return @"离异";
    }
    else{
        return @"丧偶";
    }
}

+ (NSString *)getMarrayCodeWithState:(NSString *)beMarrage
{
    if ([beMarrage isEqualToString:@"未婚"]) {
        return @"1";
    }
    else if ([beMarrage isEqualToString:@"已婚"]) {
        return @"2";
    }
    else if ([beMarrage isEqualToString:@"离异"]) {
        return @"3";
    }
    else{
        return @"4";
    }
}

#pragma mark /*------------------------------人员角色 1贷款人 2贷款人配偶 3配偶&共有人 4共有人 5担保人 6担保人配偶 7卖方 8卖方配偶 9买方 10买方配偶------------------------------*/
+ (NSString *)getReleationStateWithCode:(NSString *)releation
{
    if (releation.intValue == 1) {
        return @"贷款人";
    }
    else if (releation.intValue == 2 || releation.intValue == 3) {
        return @"贷款人配偶";
    }
    else if (releation.intValue == 4) {
        return @"共有人";
    }
    else if (releation.intValue == 5) {
        return @"担保人";
    }
    else if (releation.intValue == 6) {
        return @"担保人配偶";
    }
    else if (releation.intValue == 7) {
        return @"卖方";
    }
    else if (releation.intValue == 8) {
        return @"卖方配偶";
    }
    else if (releation.intValue == 9) {
        return @"买方";
    }
    else
    {
        return @"买方配偶";
    }
}

+ (NSString *)getReleationCodeWithState:(NSString *)releation
{
    if ([releation isEqualToString:@"贷款人"] || [releation isEqualToString:@"贷款人信息"]) {
        return @"1";
    }
    else if ([releation isEqualToString:@"贷款人配偶"] || [releation isEqualToString:@"贷款人配偶信息"]) {
        return @"2";
    }
    else if ([releation isEqualToString:@"共有人"] || [releation isEqualToString:@"共有人信息"]) {
        return @"4";
    }
    else if ([releation isEqualToString:@"担保人"] || [releation isEqualToString:@"担保人信息"]) {
        return @"5";
    }
    else if ([releation isEqualToString:@"担保人配偶"] || [releation isEqualToString:@"担保人配偶信息"]) {
        return @"6";
    }
    else if ([releation isEqualToString:@"卖方"] || [releation isEqualToString:@"卖方信息"]) {
        return @"7";
    }
    else if ([releation isEqualToString:@"卖方配偶"] || [releation isEqualToString:@"卖方配偶信息"]) {
        return @"8";
    }
    else if ([releation isEqualToString:@"买方"] || [releation isEqualToString:@"买方信息"]) {
        return @"9";
    }
    else {
        return @"10";
    }
}

#pragma mark /*------------------------------与贷款人关系 1朋友 2直系亲属 ------------------------------*/
+ (NSArray *)getRelationshipStateArray
{
    return @[@"直系亲属",@"朋友"];
}

+ (NSString *)getRelationshipStateWithCode:(NSString *)relationship
{
    if (relationship.intValue == 1) {
        return @"朋友";
    }else {
        return @"直系亲属";
    }
}

+ (NSString *)getRelationshipCodeWithState:(NSString *)relationship
{
    if ([relationship isEqualToString:@"朋友"]) {
        return @"1";
    }else {
        return @"2";
    }
}

#pragma mark /*------------------------------大数据风控/央行征信查询状态 1查询 其他不查询------------------------------*/
+ (NSString *)getBigDataStateWithCode:(NSString *)bigData
{
    if (bigData.intValue == 1) {
        return @"查询";
    }else {
        return @"不查询";
    }
}

+ (NSString *)getBigDataCodeWithState:(NSString *)bigData
{
    if ([bigData isEqualToString:@"查询"]) {
        return @"1";
    }else {
        return @"0";
    }
}

#pragma mark /*------------------------------是否可贷 1可贷 2不可贷------------------------------*/
+ (NSString *)getCanLoanStateWithCode:(NSString *)canLoan
{
    if (canLoan.intValue == 1) {
        return @"可贷";
    }
    else{
        return @"不可贷";
    }
}

+ (NSString *)getCanLoanCodeWithState:(NSString *)canLoan
{
    if ([canLoan isEqualToString:@"可贷"]) {
        return @"1";
    }
    else{
        return @"2";
    }
}

#pragma mark /*------------------------------用户资质 1A类 2B类 3C类------------------------------*/
+ (NSString *)getCustomerQualificationStateWithCode:(NSString *)custQualification
{
    if (custQualification.intValue == 1) {
        return @"A类";
    }
    else if (custQualification.intValue == 2) {
        return @"B类";
    }
    else if (custQualification.intValue == 3) {
        return @"C类";
    }
    else {
        return @"D类";
    }
}

+ (NSString *)getCustomerQualificationCodeWithState:(NSString *)custQualification
{
    if ([custQualification isEqualToString:@"A"] || [custQualification isEqualToString:@"A类"]) {
        return @"1";
    }
    else if ([custQualification isEqualToString:@"B"] || [custQualification isEqualToString:@"B类"]) {
        return @"2";
    }
    else if ([custQualification isEqualToString:@"C"] || [custQualification isEqualToString:@"C类"]) {
        return @"3";
    }
    else {
        return @"4";
    }
}

#pragma mark /*------------------------------报表查询时间 1当前月份 2最近30天 3最近100天 4最近一年 5全部订单------------------------------*/
+ (NSArray  *)getCustomReportTimeHorizonArray;
{
    return @[@"当前月份",@"最近30天",@"最近100天",@"最近一年",@"全部订单"];
}

+ (NSString *)getCustomReportTimeHorizonStateWithCode:(NSString *)timeHorizon
{
    if (timeHorizon.intValue == 1) {
        return @"当前月份";
    }
    else if (timeHorizon.intValue == 2) {
        return @"最近30天";
    }
    else if (timeHorizon.intValue == 3) {
        return @"最近100天";
    }
    else if (timeHorizon.intValue == 3) {
        return @"最近一年";
    }
    else {
        return @"全部订单";
    }
}

+ (NSString *)getCustomReportTimeHorizonCodeWithState:(NSString *)timeHorizon
{
    if ([timeHorizon isEqualToString:@"当前月份"]) {
        return @"1";
    }
    else if ([timeHorizon isEqualToString:@"最近30天"]) {
        return @"2";
    }
    else if ([timeHorizon isEqualToString:@"最近100天"]) {
        return @"3";
    }
    else if ([timeHorizon isEqualToString:@"最近一年"]) {
        return @"4";
    }
    else {
        return @"5";
    }
}

#pragma mark /*------------------------------------------根据产品类型获取订单ID 订单状态------------------------------------------*/
+ (NSString *)getOrderID:(NSString *)prdType;
{
    NSString *orderIDString;
    
    //星速贷
    if ([prdType isEqualToString:kProduceTypeStarLoan])
    {
        orderIDString = global.slOrderDetails.spdOrder.tid;
    }
    //赎楼宝
    else if ([prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        orderIDString = global.rfOrderDetails.redeemOrder.tid;
    }
    //抵押贷
    else if ([prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        orderIDString = global.mlOrderDetails.dydOrder.tid;
    }
    //车位分期
    else if ([prdType isEqualToString:kProduceTypeCarHire])
    {
        orderIDString = global.chOrderDetails.cwfqOrder.tid;
    }
    //代办业务
    else if ([prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        orderIDString = global.abOrderDetails.insteadOrder.tid;
    }
    //融易贷
    else if ([prdType isEqualToString:kProduceTypeEasyLoans])
    {
        orderIDString = global.elOrderDetails.easyOrder.tid;
    }
    
    return orderIDString;
}

+ (NSString *)getOrderState:(NSString *)prdType;
{
    NSString *orderStateString;
    
    //星速贷
    if ([prdType isEqualToString:kProduceTypeStarLoan])
    {
        orderStateString = global.slOrderDetails.spdOrder.orderState;
    }
    //赎楼宝
    else if ([prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        orderStateString = global.rfOrderDetails.redeemOrder.orderState;
    }
    //抵押贷
    else if ([prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        orderStateString = global.mlOrderDetails.dydOrder.orderState;
    }
    //车位分期
    else if ([prdType isEqualToString:kProduceTypeCarHire])
    {
        orderStateString = global.chOrderDetails.cwfqOrder.orderState;
    }
    //代办业务
    else if ([prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        orderStateString = global.abOrderDetails.insteadOrder.orderState;
    }
    //融易贷
    else if ([prdType isEqualToString:kProduceTypeEasyLoans])
    {
        orderStateString = global.elOrderDetails.easyOrder.orderState;
    }
    
    return orderStateString;
}

@end
