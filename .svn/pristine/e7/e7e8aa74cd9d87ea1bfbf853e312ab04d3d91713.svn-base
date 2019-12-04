//
//  NSString+add.h
//  ZSMoneytocar
//
//  Created by 武 on 16/7/22.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZSGlobalModel.h"

typedef void (^BackMonthAndSumBlock)(NSString *str1,NSString*str2);
typedef void (^BackStrBlock)(NSString *str);
@interface NSString (add)

+(BOOL)isAllNum:(NSString *)string;

+(BOOL)isPureInt:(NSString*)string;

+(BOOL)isPureFloat:(NSString*)string;

+(BOOL)valiMobile:(NSString *)mobile;

#pragma mark 数组转Jison
+ (NSString *)arrayToJsonString:(NSArray*)arr;

#pragma mark 字典转字符串
+ (NSString*)StingByJson:(id)theData;

#pragma markjson字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+(BOOL)validateNumber:(NSString *) textString;

+(NSDictionary*)getAttribute;

#pragma mark 自动计算label高度
+ (CGFloat)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

#pragma mark 设置placeHolder
+(NSAttributedString*)getPlaceHolderAttributeWithStr:(NSString*)str Color:(UIColor*)color Font:(float)font;

#pragma mark 获取UUID
+ (NSString *)uuidString;

#pragma mark 是否是纯汉字
- (BOOL)isChinese;

#pragma mark 出去小数点之后多余的零  （如3.14000 变成3.14）
- (NSString *)removeAllZero;

#pragma mark 保留几位小数 （如保留两位3.1234 变成3.13  3.0000变成3）
- (NSString *)RetainDecimalOfCount:(NSInteger)count;

#pragma mark 添加小星星(*)
- (NSMutableAttributedString *)addStar;

#pragma mark label展示不同的颜色
- (NSMutableAttributedString *)drawLabelTextDiffrentColor:(UIColor *)color beginIndex:(int)beginIndex endIndex:(int)endIndex;

#pragma mark 把nsstring转化成jsonStr
- (NSString *)JSONString;

#pragma mark 转换时间格式
- (NSString *)changeDateFormat;

#pragma mark 判断是否输入了emoji 表情
+ (BOOL)isContainsTwoEmoji:(NSString *)string;

#pragma mark 根据角色返回与主贷人关系
+ (NSString *)setRelationByRelation:(CustInfo *)model;

#pragma mark 根据角色编码返回角色名称
+ (NSString *)setRoleState:(NSInteger)roleType;

#pragma makr 获取当前时间
+ (NSString *)getCurrentTimes;

#pragma mark判断身份证有效期
+ (NSString *)calcDays:(NSString *)validStr;

#pragma mark 日期格式转换
+ (NSString *)dateChange:(NSString *)validStr;

#pragma mark lable上面添加图片
+(void)setText:(NSString *)text label:(UILabel *)label imageSpan:(CGFloat)span;

#pragma mark 根据订单状态返回详情顶部当前节点名称
+(NSString *)getStringByOrderState:(NSString *)string;

#pragma mark 根据资料类型是否隐藏errorView yes 展示
+(BOOL )getErrorViewIsShowByDocName:(NSString *)string;

#pragma mark 数据精度问题(默认两位小数)
+ (NSString *)ReviseString:(NSString *)string;

#pragma mark 数据精度问题(自定义小数位数)
+ (NSString *)ReviseString:(NSString *)string WithDigits:(NSInteger)count;
@end
