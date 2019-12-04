//
//  NSString+add.m
//  ZSMoneytocar
//
//  Created by 武 on 16/7/22.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "NSString+add.h"

@implementation NSString (add)

#pragma mark判断时候全为数字
+(BOOL)isAllNum:(NSString *)string
{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark判断是否为整形
+(BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+(BOOL)validateNumber:(NSString *) textString
{
    NSString* number=@"[\u4e00-\u9fa5]+";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

#pragma mark 数组转Jison
+(NSString *)arrayToJsonString:(NSArray*)arr
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

#pragma mark字典 ----转字符串
+ (NSString*)StingByJson:(id)theData
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:0 error:&parseError];
   // ZSLOG(@"========>>>>>>>%@",jsonData);
    NSString *jsonSting=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonSting;
}

#pragma mark json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        ZSLOG(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark判断是否为浮点形：
+(BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark 判断手机号码格式是否正确
+(BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

+(NSDictionary*)getAttribute
{
    //设置行间距,并且计算行高
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16.0],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return attributes;
}


#pragma mark 自动计算label高度
+ (CGFloat)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
}

#pragma mark 设置placeHolder
+(NSAttributedString*)getPlaceHolderAttributeWithStr:(NSString*)str Color:(UIColor*)color Font:(float)font
{
  return  [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:[UIFont systemFontOfSize:font]}];
}

#pragma mark 获取UUID
+ (NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

#pragma mark 是否是纯汉字
- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

#pragma mark 出去小数点之后多余的零  （如3.14000 变成3.14）
- (NSString *)removeAllZero
{
    NSString * testNumber = self;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    
    return outNumber;
}

#pragma mark 保留几位小数 （如保留两位3.1234 变成3.13  3.0000变成3）
- (NSString *)RetainDecimalOfCount:(NSInteger)count
{
    NSDecimalNumber *selfNumber=[NSDecimalNumber decimalNumberWithString:self];
    
    //保留小数点后两位
    
    NSDecimalNumberHandler*roundUp = [NSDecimalNumberHandler
                                      
                                      decimalNumberHandlerWithRoundingMode:NSRoundUp
                                      
                                      scale:count
                                      
                                      raiseOnExactness:NO
                                      
                                      raiseOnOverflow:NO
                                      
                                      raiseOnUnderflow:NO
                                      
                                      raiseOnDivideByZero:YES];
    
    NSDecimalNumber*newNumber = [selfNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    NSString *str=[NSString stringWithFormat:@"%@",newNumber];
    
    
    return str;
}


#pragma mark 添加小星星(*)
- (NSMutableAttributedString *)addStar
{
    NSString *str = [NSString stringWithFormat:@"%@ *",self];
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutableStr addAttribute:NSForegroundColorAttributeName value:ZSColorRed range:NSMakeRange(str.length - 1, 1) ];
    return   mutableStr;
}

#pragma mark label展示不同的颜色
- (NSMutableAttributedString *)drawLabelTextDiffrentColor:(UIColor *)color beginIndex:(int)beginIndex endIndex:(int)endIndex
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(beginIndex,endIndex)];
    return  str;
}

#pragma mark - 把nsstring转化成jsonStr
- (NSString *)JSONString
{
    NSMutableString *s = [NSMutableString stringWithString:self];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/"  withString:@"\\/"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

#pragma mark 转换时间格式
- (NSString *)changeDateFormat
{
    NSMutableString *s = [NSMutableString stringWithString:self];
    [s replaceOccurrencesOfString:@"-" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

#pragma mark 判断是否输入了emoji 表情
+ (BOOL)isContainsTwoEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         //         NSLog(@"hs++++++++%04x",hs);
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     isEomji = YES;
                 }
                 //                 NSLog(@"uc++++++++%04x",uc);
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3|| ls ==0xfe0f) {
                 isEomji = YES;
             }
             //             NSLog(@"ls++++++++%04x",ls);
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
         
     }];
    return isEomji;
}

#pragma mark 根据角色返回与主贷人关系
+ (NSString *)setRelationByRelation:(CustInfo *)model
{
    NSString *relationString = @"";
    if (model.releation) {
        if ([model.releation intValue] == 1 || [model.releation intValue] == 5) {  //婚姻状况
            if (model.beMarrage) {
                relationString = [ZSGlobalModel getMarrayStateWithCode:model.beMarrage];
            }
        }else if ([model.releation intValue] == 2) {   //是否为共有人2:否
            relationString =  @"否";
        }else if ([model.releation intValue] == 3) {   //是否为共有人3:是
            relationString =  @"是";
        }else if ([model.releation intValue] == 4) {   //与贷款人关系
            if (model.lenderReleation) {
                if (model.lenderReleation.integerValue == 0){
                    relationString = @"直系亲属";
                }else if (model.lenderReleation.integerValue == 1){
                    relationString = @"配偶";
                }else if (model.lenderReleation.integerValue == 2){
                    relationString = @"朋友";
                }
            }
        }
    }
    return relationString;
}

#pragma mark 根据角色编码返回角色名称
+ (NSString *)setRoleState:(NSInteger)roleType
{
    NSString *string = @"";
    if (roleType == 1) {
        string = @"贷款人信息";
    }
    if (roleType == 2 || roleType == 3) {
        string = @"贷款人配偶信息";
    }
    if (roleType == 4) {
        string = @"共有人信息";
    }
    if (roleType == 5) {
        string = @"担保人信息";
    }
    if (roleType == 6) {
        string = @"担保人配偶";
    }
    if (roleType == 7) {
        string = @"卖方";
    }
    if (roleType == 8) {
        string = @"卖方配偶";
    }
    return string;
}

#pragma makr 获取当前时间
+ (NSString *)getCurrentTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

#pragma mark lable上面添加图片
+ (void)setText:(NSString *)text label:(UILabel *)label imageSpan:(CGFloat)span
{
    if (text.length > 0){
        NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
        UIImage *image = [UIImage imageNamed:@"list_phone_n"];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = image;
        //计算图片大小，与文字同高，按比例设置宽度
        CGFloat imgH = label.font.pointSize;
        CGFloat imgW = (image.size.width / image.size.height) * imgH;
        attach.bounds = CGRectMake(0, -2 , imgW, imgH);
        
        NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
        [textAttrStr appendAttributedString:imgStr];
        //标签后添加空格
        [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        //设置显示文本
        [textAttrStr appendAttributedString:[[NSAttributedString alloc]initWithString:text]];
        //设置间距
//        if (span != 0) {
//            [textAttrStr addAttribute:NSKernAttributeName value:@(span)
//                                range:NSMakeRange(0, 3/*由于图片也会占用一个单位长度,所以带上空格数量，需要 *2 */)];
//        }
        label.attributedText = textAttrStr; 
    }   
}



#pragma mark 判断身份证有效期
+ (NSString *)calcDays:(NSString *)validStr
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //日期格式修正
    validStr = [validStr substringFromIndex:9];
    NSString *year = [validStr substringToIndex:4];
    NSString *mouth = [validStr substringFromIndex:4];
    mouth = [mouth substringToIndex:2];
    NSString *day = [validStr substringFromIndex:6];
    validStr = [NSString stringWithFormat:@"%@-%@-%@",year,mouth,day];
   
    //string转换成日期
    NSDate *validDate = [dateFormatter dateFromString:validStr];
    NSDate *currentDate = [NSDate date];
    
    //取两个日期对象的时间间隔：
    NSTimeInterval time = [validDate timeIntervalSinceDate:currentDate];
    int days = ((int)time)/(3600*24);
    days = days + 1;
    
    //判断身份证有效期
    if (days > 0 && days > 60) {
        return @"有效";
    }
    else if (days > 0 && days <= 60) {
        return [NSString stringWithFormat:@"身份证即将失效，有效期至%@",validStr];
    }
    else{
        return @"身份证已失效";
    }
}

#pragma mark 日期格式转换
+ (NSString *)dateChange:(NSString *)validStr
{
    validStr = [validStr substringFromIndex:9];
    NSString *year = [validStr substringToIndex:4];
    NSString *mouth = [validStr substringFromIndex:4];
    mouth = [mouth substringToIndex:2];
    NSString *day = [validStr substringFromIndex:6];
    validStr = [NSString stringWithFormat:@"%@-%@-%@",year,mouth,day];
    return validStr;
}

#pragma mark 根据订单状态返回详情顶部当前节点名称
+ (NSString *)getStringByOrderState:(NSString *)string
{
    NSString *newString = @"";
    if ([string isEqualToString:@"已关闭"] || [string isEqualToString:@"完成审批"]) {
        newString = string;
    }else {
        newString = [NSString stringWithFormat:@"%@中",string];

    }
    return newString;
}

#pragma mark 根据资料类型是否隐藏errorView  yes 展示
+ (BOOL )getErrorViewIsShowByDocName:(NSString *)string
{
    if (![string isEqualToString:@"DKPZ"] &&
        ![string isEqualToString:@"SKPZ"] &&
        ![string isEqualToString:@"CQQKB"] &&
        ![string isEqualToString:@"HKQR"] &&
        ![string isEqualToString:@"BANK_REPAY"] &&
        ![string isEqualToString:@"BANK_GATHER"])
    {
        return YES;
    }
    return NO;
}

#pragma mark 数据精度问题(默认两位小数)
+ (NSString *)ReviseString:(NSString *)string
{
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 2;//表示最多保留两位小数
        formatter.minimumIntegerDigits = 1;//表示最少保留一位整数,防止像0.01出现.01的情况
    });
    return [formatter stringFromNumber:[formatter numberFromString:string]];
}

#pragma mark 数据精度问题(自定义小数位数)
+ (NSString *)ReviseString:(NSString *)string WithDigits:(NSInteger)count
{
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = count;//表示最多保留几位小数
        formatter.minimumIntegerDigits = 1;//表示最少保留一位整数,防止像0.01出现.01的情况
    });
    return [formatter stringFromNumber:[formatter numberFromString:string]];
}

@end
