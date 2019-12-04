//
//  ZSTool.m
//  ZSMoneytocar
//
//  Created by 武 on 16/7/5.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSTool.h"
#import <CoreText/CoreText.h>
#import "WKProgressHUD.h"
@implementation ZSTool

#pragma mark 初始化
+ (ZSTool*)shareInfo{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark 设置行间距
+(void)setLineSpacingWithView:(UIView*)view Lab:(UILabel *)lab Sting:(NSString*)str Font:(float)font{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:font];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    [lab setAttributedText:attributedString1];
    [lab sizeToFit];
    [view addSubview:lab];
}

#pragma mark 获取本地版本号
+(NSString*)localVersionShort{
    NSDictionary *diction =[[NSBundle mainBundle] infoDictionary] ;
    NSString * localVersionShort=[diction objectForKey:@"CFBundleShortVersionString"];
    return  localVersionShort;
}

#pragma mark 保存用户相关的信息
+(void)saveUserInfoWithDic:(NSDictionary *)Dic
{
    ZSUidInfo *userInfo = [ZSUidInfo shareInfo];
    userInfo.beNotice         = Dic[@"beNotice"];
    userInfo.birthday         = Dic[@"birthday"];
    userInfo.branchCropName   = Dic[@"branchCropName"];
    userInfo.companyId        = Dic[@"companyId"];
    userInfo.createDate       = Dic[@"createDate"];
    userInfo.headPhoto        = Dic[@"headPhoto"];
    userInfo.isNeedBankcredit = Dic[@"isNeedBankcredit"];
    userInfo.lastVisitTime    = Dic[@"lastVisitTime"];
    userInfo.mortgageCropName = Dic[@"mortgageCropName"];
    userInfo.notReadCount     = Dic[@"notReadCount"];
    userInfo.orgnizationId    = Dic[@"orgnizationId"];
    userInfo.orgnizationName  = Dic[@"orgnizationName"];
    userInfo.roleId           = Dic[@"roleId"];
    userInfo.roleName         = Dic[@"roleName"];
    userInfo.sex              = Dic[@"sex"];
    userInfo.telphone         = Dic[@"telphone"];
    userInfo.tid              = Dic[@"tid"];
    userInfo.userid           = Dic[@"userid"];
    userInfo.username         = Dic[@"username"];
    NSData   *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:KCurrentUserInfo];
    [data writeToFile:path atomically:NO];
}

#pragma mark 获取用户信息
+(ZSUidInfo*)readUserInfo{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:KCurrentUserInfo];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //如果文件存在
        NSData *data = [NSData dataWithContentsOfFile:path];
        //NSKeyedUnarchiver解码器，能够把二进制数据解码为对象。
        ZSUidInfo *userInfo = [ZSUidInfo shareInfo];
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return userInfo;
    }else{
        return nil;
    }
}

+(void)removeDicWithSeriesNo:(NSString*)seriesNo{
    NSMutableDictionary *dic = [ZSTool getImagDic];
    [dic removeObjectForKey:seriesNo];
    [ZSTool saveImagDic:dic];
}

+(void)saveImagDic:(NSMutableDictionary*)dic{
    [dic writeToFile:[ZSTool getImagPath] atomically:NO];
}

+(void)saveSeriesDic:(NSMutableDictionary*)dic WithSeriesNo:(NSString*)seriesNo{
    NSMutableDictionary *Dict =[ZSTool getImagDic];
    [Dict setObject:dic forKey:seriesNo];
    [ZSTool saveImagDic:Dict];
}

+(NSString *)getImagPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@OrderImagDic.plist", [ZSTool readUserInfo].tid]];
}

+(NSMutableDictionary*)getImagDic{
    NSMutableDictionary *dic=@{}.mutableCopy;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[ZSTool getImagPath]]) {
        dic=[NSMutableDictionary dictionaryWithContentsOfFile:[ZSTool getImagPath]];
    }else{
        [dic writeToFile:[ZSTool getImagPath] atomically:YES];
    }
    return dic;
}

+(NSMutableDictionary*)getSeriesNoDic:(NSString*)seriesNo{
    NSMutableDictionary *dic=@{}.mutableCopy;
    NSMutableDictionary *seriesNoDic=@{}.mutableCopy;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[ZSTool getImagPath]]) {
            dic=[NSMutableDictionary dictionaryWithContentsOfFile:[ZSTool getImagPath]];
        if (dic[seriesNo]) {
            seriesNoDic=[dic objectForKey:seriesNo];
        } else {
            [dic setObject:seriesNoDic forKey:seriesNo];
            [dic writeToFile:[ZSTool getImagPath] atomically:YES];
        }
    }else{
        [dic setObject:seriesNoDic forKey:seriesNo];
        [dic writeToFile:[ZSTool getImagPath] atomically:YES];
    }
    return seriesNoDic;
}

+(NSString *)getImageFileName{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    return fileName;
}

+(NSString*)getVideoFileName{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
    return fileName;
}

#pragma mark 改登录
+(NSMutableDictionary*)GetshoopingCartFoodsDic{
    NSMutableDictionary *dic=@{}.mutableCopy;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[ZSTool getFoodPath]]) {
        dic=[NSMutableDictionary dictionaryWithContentsOfFile:[ZSTool getFoodPath]];
    }else{
        [dic setObject:@"0" forKey:@"totlePrice"];
        [dic writeToFile:[ZSTool getFoodPath] atomically:YES];
    }
    return dic;
}

+(NSString*)getFoodPath{
    return [NSHomeDirectory() stringByAppendingString:@"/Documents/shoopcartFood.plist"];
}


+(void)saveToShoppingCartWithDict:(NSMutableDictionary*)dict{
    [dict writeToFile:[ZSTool getFoodPath] atomically:NO];
}

#pragma mark 小数转百分数
+(CFStringRef )getLoanAmountPercentWith:(float)percent{
    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
    CFNumberFormatterRef numberFormatter = CFNumberFormatterCreate(NULL, currentLocale, kCFNumberFormatterPercentStyle);
    CFNumberRef number = CFNumberCreate(NULL, kCFNumberFloatType, &percent);
    CFStringRef numberString = CFNumberFormatterCreateStringWithNumber(NULL, numberFormatter, number);
    return numberString;
}

#pragma mark 是否第一次登陆
+(NSString*)gesturePasswordPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/gesture.plist"];
}

#pragma mark 储存视频
+(void)saveVideoWithVideoData:(NSData*)data UUid:(NSString*)uuid{
    [data writeToFile:[ZSTool getVideoPathWithUUid:uuid] atomically:YES];
}

#pragma mark 储存视频
+(void)saveVideoWithVideoData:(NSData*)data path:(NSString*)path{
    [data writeToFile:path atomically:YES];
}

#pragma mark 删除视频
+(void)deleteVideoByUUid:(NSString*)uuid{
    [[NSFileManager defaultManager] removeItemAtPath:[ZSTool getVideoPathWithUUid:uuid] error:nil];
}

#pragma mark 获取视频路径
+(NSString*)getVideoPathWithUUid:(NSString*)uuid{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@.plist",uuid]];
}

#pragma mark 截取数组
+(NSArray*)getDownPaymentArrayWith:(NSNumber *)downPayment withMaxPayment:(NSNumber*)maxPayment{
    NSArray *array=@[@"10%",@"20%",@"30%",@"40%",@"50%",@"60%",@"70%",@"80%",@"90%",@"100%"].copy;
   __block NSArray *maxArray=@[].copy;
   __block NSArray *downPaymentArray=@[].copy;
    [array enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        int max=[[obj substringToIndex:obj.length-1]intValue];
        if ([maxPayment floatValue]<max) {
            maxArray=[array subarrayWithRange:NSMakeRange(0, idx)];
            *stop=YES;
        }else if([maxPayment floatValue]==max){
            maxArray=[array subarrayWithRange:NSMakeRange(0, idx+1 )];
            *stop=YES;
        }
    }];
    ZSLOG(@"%@,%ld",maxPayment,(long)[maxArray count]);
    [maxArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        int min=[[obj substringToIndex:2] intValue];
        if ([downPayment floatValue]<=min) {
            downPaymentArray=[maxArray subarrayWithRange:NSMakeRange(idx, maxArray.count-idx)];
            *stop=YES;
        }
    }];
    return downPaymentArray;
}

#pragma mark 获取行数
+(int)getNumberOfLines:(NSInteger)Count
{
    int count=(int)Count;
    int numLines=(count-1)/4+1;
    return numLines;

}

#pragma mark 获取首付总额
+(NSString*)getTotleCostWithFeeArray:(NSMutableArray*)feesArray downpayment:(NSString*)downpaymnet
{
    
    NSString* totleCost;
    NSInteger sum = 0;
    
    if (feesArray.count>0) {
        for (NSString *fee in feesArray) {
            sum += fee.integerValue;
        }
    }
    totleCost = [NSString stringWithFormat:@"%ld",sum+downpaymnet.integerValue];
    ZSLOG(@"++++首付总额  %@  ,sum :%ld",totleCost,sum);
    return [NSString stringWithFormat:@"%@",totleCost];
}

#pragma markk 获取各项费用总额(不包括首付)
+(NSString*)getAllFeesWithFeeArray:(NSMutableArray*)feesArray
{
    __block  long totleCost = 0;
    [feesArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totleCost+=obj.intValue;
    }];
    return [NSString stringWithFormat:@"%ld",totleCost];
}

#pragma mark 获取文字图标
+(NSAttributedString*)getAttributestrWithImgeName:(NSString *)imageName imgeBounds:(CGRect)bounds {
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:imageName];
    // 设置图片大小
    attch.bounds = bounds;
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    return string;
}

#pragma mark判断是否输入了emoji 表情
+ (BOOL)stringContainsEmoji:(NSString *)string{
    
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         //         ZSLOG(@"hs++++++++%04x",hs);
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3|| ls ==0xfe0f) {
                 isEomji = YES;
             }
             //             ZSLOG(@"ls++++++++%04x",ls);
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

#pragma mark 空字符串替换
+ (NSString *)beJudgedString:(NSString *)string theReplaceString:(NSString *)newString{
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [string isEqualToString:@"NULL"] ) {
        return newString;
    }else{
        return string;
    }
}

#pragma mark 拨打电话(修复ios10.2反应慢的问题)
+ (void)callPhoneStr:(NSString*)phoneString withVC:(UIViewController *)viewCtrl
{
    if (phoneString.length >= 10) {
        NSString *str_version = [[UIDevice currentDevice] systemVersion];
        if ([str_version compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending ||//判断两对象值的大小(按字母顺序进行比较，str_version小于10.2为真)
            [str_version compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
        {
            NSString *PhoneStr = [NSString stringWithFormat:@"telprompt://%@",phoneString];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr]
                                               options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"phone success");
                                     }];
        }
        else
        {
            NSMutableString *str1 = [[NSMutableString alloc]initWithString:phoneString];//存在堆区，可变字符串
            if (phoneString.length == 10) {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:7];// 把一个字符串插入另一个字符串中的某一个位置
            }else{
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:8];// 把一个字符串插入另一个字符串中的某一个位置
            }
            NSString *str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message: nil preferredStyle:UIAlertControllerStyleAlert];
            alert.popoverPresentationController.barButtonItem = viewCtrl.navigationItem.leftBarButtonItem;// 设置popover指向的item
            [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                NSLog(@"点击了呼叫按钮10.2下");
                NSString *PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneString];
                if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"])
                {
                    UIApplication *app = [UIApplication sharedApplication];
                    if ([app canOpenURL:[NSURL URLWithString:PhoneStr]])
                    {
                        [app openURL:[NSURL URLWithString:PhoneStr]];
                    }
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }]];
            [viewCtrl presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - 时间比较大小
+ (BOOL)compareOneDay:(NSString *)beginTimeStr withAnotherDay:(NSString *)endTimeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-dd-MM"];
    NSDate *dateA = [dateFormatter dateFromString:beginTimeStr];
    NSDate *dateB = [dateFormatter dateFromString:endTimeStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", beginTimeStr, endTimeStr);
    if (result == NSOrderedDescending) {
        //beginTimeStr > endTimeStr
        return YES;
    }
    else if (result == NSOrderedAscending){
        //beginTimeStr < endTimeStr
        return NO;
    }else{
        return NO;
        //beginTimeStr = endTimeStr
    }
}

#pragma mark 判断手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *Regex = @"^[1][3,4,5,6,7,8,9][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@" "withString:@""];//去除手机号里面的空格
    return [phoneTest evaluateWithObject:mobileNum];
}

#pragma mark 判断身份证号码
+ (BOOL)checkUserIDCard:(NSString *)userID
{
    //判断是否为空
    if (userID==nil||userID.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:userID]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [userID substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(userID.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[userID substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[userID substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

#pragma mark 判断是否是数字字母下划线
+ (BOOL)isLettersAndNumbersAndUnderScore:(NSString *)string
{
    NSInteger len = string.length;
    for(int i=0;i<len;i++)
    {
        unichar a = [string characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_'))
             ))
            return NO;
    }
    return YES;
}

#pragma mark 密码输入规则
+ (BOOL)isPassword:(NSString *)password
{
    NSString *Regex = @"^[0-9a-zA-Z_!@#$%^&*()+-:;',.?]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:password];
}

#pragma mark 获取label中最后一行字
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}


#pragma mark 检查是否有需要上传的图片(必填)
+(BOOL)chekIsNeedUploadFilesWithArray:(NSMutableArray *)fileArray
{
    NSMutableArray *array = @[].mutableCopy;
    if ([fileArray count]) {
        for (Handles *model in fileArray) {
            if (model.need == 1 && model.finish == 0) {
                [array addObject:model.docname];//beNeed=1是必填
            }
        }
    }

    if (array.count > 0) {
        NSString *uploadStr = [array componentsJoinedByString:@","];
        UIView *view = [UIApplication sharedApplication].keyWindow;
        [WKProgressHUD popMessage:[NSString stringWithFormat:@"%@未上传！  ",uploadStr] inView:view duration:1.5 animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark 检查是否有需要上传的图片（非必填）
+(NSString *)checkingIsNotNeedUploadFilesWithArray:(NSArray *)fileArray
{
    NSMutableArray *array = @[].mutableCopy;
    NSString *uploadStr = @"";
    if ([fileArray count]) {
        for (Handles *model in fileArray) {
            if (model.need == 0 && model.finish == 0) {
                [array addObject:model.docname];//beNeed=1是必填
            }
        }
    }
    if (array.count>0) {
       uploadStr = [array componentsJoinedByString:@","];
       uploadStr = [NSString stringWithFormat:@"%@未上传,是否确认提交?",uploadStr];
    }
    return uploadStr;
}

#pragma mark 检查是否有需要上传的图片（必填和非必填）
+ (NSString *)isCheckingNeedingUploadFilesWithArray:(NSArray *)fileArray
{
    NSMutableArray *array=@[].mutableCopy;
    NSString *uploadStr = @"";
    if ([fileArray count]) {
        for (Handles* model in fileArray) {
            if (model.finish == 0) {
                [array addObject:model.docname];//beNeed=1是必填
            }
        }
    }
    if (array.count>0) {
        uploadStr = [array componentsJoinedByString:@","];
        uploadStr = [NSString stringWithFormat:@"%@未上传,是否确认提交?",uploadStr];
    }
    return uploadStr;
}

#pragma mark 新房见证判断订单是否可编辑
+(BOOL)checkWitnessServerOrderIsCanEditing
{
    if (![global.wsOrderDetail.projectInfo.orderState isEqualToString:@"6"] && ![global.wsOrderDetail.projectInfo.orderState isEqualToString:@"7"]){
        return YES;
    }
    return NO;
}

#pragma mark 判断金融产品订单是否可编辑
+ (BOOL)checkStarLoanOrderIsCanEditingWithType:(NSString *)prdType
{
    //星速贷
    if ([prdType isEqualToString:kProduceTypeStarLoan])
    {
        if (![SafeStr(global.slOrderDetails.spdOrder.orderState) isEqualToString:@"已关闭"]){
            return YES;
        }
        return NO;
    }
    //赎楼宝
    else if ([prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if (![SafeStr(global.rfOrderDetails.redeemOrder.orderState) isEqualToString:@"已关闭"]){
            return YES;
        }
        return NO;
    }
    //抵押贷
    else if ([prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        if (![SafeStr(global.mlOrderDetails.dydOrder.orderState) isEqualToString:@"已关闭"]){
            return YES;
        }
        return NO;
    }
    //车位分期
    else if ([prdType isEqualToString:kProduceTypeCarHire])
    {
        if (![SafeStr(global.chOrderDetails.cwfqOrder.orderState) isEqualToString:@"已关闭"]){
            return YES;
        }
        return NO;
    }
    //代办业务
    else
    {
        if (![SafeStr(global.abOrderDetails.insteadOrder.orderState) isEqualToString:@"已关闭"]){
            return YES;
        }
        return NO;
    }
}

#pragma mark 判断是否是订单创建人
+ (BOOL)checkFinancialOrderMasterWithType:(NSString *)prdType
{
    //星速贷
    if ([prdType isEqualToString:kProduceTypeStarLoan])
    {
        if ([global.slOrderDetails.isOrder isEqualToString:@"1"]){
            return YES;
        }
        return NO;
    }
    //赎楼宝
    else if ([prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if ([global.rfOrderDetails.isOrder isEqualToString:@"1"]){
            return YES;
        }
        return NO;
    }
    //抵押贷
    else if ([prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        if ([global.mlOrderDetails.isOrder isEqualToString:@"1"]){
            return YES;
        }
        return NO;
    }
    //车位分期
    else if ([prdType isEqualToString:kProduceTypeCarHire])
    {
        if ([global.chOrderDetails.isOrder isEqualToString:@"1"]){
            return YES;
        }
        return NO;
    }
    //代办业务
    else
    {
        if ([global.abOrderDetails.isOrder isEqualToString:@"1"]){
            return YES;
        }
        return NO;
    }
}

#pragma mark 判断数值大小
+ (BOOL)checkMaxNumWithInputNum:(NSString *)inputNum MaxNum:(NSString *)maxNum alert:(BOOL)isAlert
{
    if (inputNum.length > 0 && maxNum.length > 0){
        NSDecimalNumber *numberBaseRate = [NSDecimalNumber decimalNumberWithString:inputNum];
        NSDecimalNumber *numberRateEnd = [NSDecimalNumber decimalNumberWithString:maxNum];
        /// 这里不仅包含Multiply还有加 减 除。
        NSComparisonResult numResult = [numberBaseRate compare:numberRateEnd];
        if (numResult == NSOrderedDescending){
            if (isAlert){
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }
    return NO;
}

#pragma mark 计算数值差
+ (NSString *)calculateNumWithTheNum:(NSString *)theNum ortherNum:(NSString *)ortherNum
{
    NSString *endStr = @"";
    if (theNum.length  > 0 && ortherNum.length > 0 ){
        NSDecimalNumber *numberBaseRate = [NSDecimalNumber decimalNumberWithString:theNum];
        NSDecimalNumber *numberRateEnd = [NSDecimalNumber decimalNumberWithString :ortherNum];
        /// 这里不仅包含Multiply还有加 减 除。
        NSDecimalNumber *numResult = [numberBaseRate decimalNumberBySubtracting:numberRateEnd];
        endStr = [numResult stringValue];
    }
    return endStr;
}

#pragma mark 颜色转图片
+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark 点击cell的动画
//CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
//CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
//[ZSTool showCellAnimation:rect];
+(void)showCellAnimation:(CGRect)oldFrame
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *view_new = [[UIView alloc]initWithFrame:oldFrame];
    view_new.backgroundColor = ZSColorWhite;
    [window addSubview:view_new];
    
    [UIView animateWithDuration:0.3 animations:^
    {
        view_new.frame = CGRectMake(0,0, ZSWIDTH, ZSHEIGHT);
    }
    completion:^(BOOL finished)
    {
        [view_new removeFromSuperview];
    }];
}

#pragma mark iOS限制输入表情(emoji)，出现九宫格不能输入的解决方法
+ (BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

#pragma mark 判断是否全是空格
+ (BOOL)isEmpty:(NSString *)string
{
    if (!string) {
        return true;
    }
    else
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

#pragma mark 删除手机号里面的空格
+ (NSString *)filteringTheBlankSpace:(NSString *)string
{
    if (string.length >= 13) {
        string = [string stringByReplacingOccurrencesOfString:@" "withString:@""];//去除手机号里面的空格
        return string;
    }
    else {
        return string;
    }
}

#pragma mark 往手机号里塞空格
+ (NSString *)addTheBlankSpace:(NSString *)string
{
    //先把里面的空格去掉,然后再拆
    string = [string stringByReplacingOccurrencesOfString:@" "withString:@""];
    
    if (string.length >= 11)
    {
        NSString *first = [string substringToIndex:3];
        NSString *second = [string substringFromIndex:3];
        second = [second substringToIndex:4];
        NSString *third = [string substringFromIndex:7];
        
        NSString *newString = [NSString stringWithFormat:@"%@ %@ %@",first,second,third];
        return newString;
    }
    else {
        return string;
    }
}


#pragma mark 模型转化为字典
+ (NSMutableDictionary *)returnToDictionaryWithModel:(SpdDocdocTextVos *)model
{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([SpdDocdocTextVos class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [userDic setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return userDic;
}

#pragma mark 把之前大数组套小数组的对象整合成一个新的数组,里面全部是对象,用于传给服务器和下一个页面
+ (NSMutableArray *)getModelArrayWithArray:(NSMutableArray *)array
{
    NSMutableArray *new_customerArray = [[NSMutableArray alloc]init];
    for (SpdDocdocTextVos *lender in array) {
        [new_customerArray addObject:[ZSTool returnToDictionaryWithModel:lender]];//model转字典
    }
    return new_customerArray;
}

#pragma mark 获取普通label的高度
+ (CGFloat)getStringHeight:(NSString *)string
                 withframe:(CGSize)size
              withSizeFont:(UIFont*)font
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return labelsize.height;
}

#pragma mark 获取普通label的宽度
+ (CGFloat)getStringWidth:(NSString *)string
                withframe:(CGSize)size
             withSizeFont:(UIFont*)font
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return labelsize.width;
}

#pragma mark 获取带行间距label的高度
+ (CGFloat)getStringHeight:(NSString *)string
                 withframe:(CGSize)size
              withSizeFont:(UIFont*)font
          winthLineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.firstLineHeadIndent = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    NSDictionary *dict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@0.0f};
    CGSize labelsize = [string boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:dict
                                              context:nil].size;
    return labelsize.height;
}

#pragma mark label内容左右对齐
+ (NSAttributedString *)setTextString:(NSString *)text
                         withSizeFont:(UIFont *)font
{
    NSMutableAttributedString *mAbStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *npgStyle = [[NSMutableParagraphStyle alloc] init];
    npgStyle.alignment = NSTextAlignmentJustified;
    npgStyle.paragraphSpacing = 11.0;
    npgStyle.paragraphSpacingBefore = 10.0;
    npgStyle.firstLineHeadIndent = 0.0;
    npgStyle.headIndent = 0.0;
    NSDictionary *dic = @{
                          NSForegroundColorAttributeName:[UIColor blackColor],
                          NSFontAttributeName           :font,
                          NSParagraphStyleAttributeName :npgStyle,
                          NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleNone]
                          };
    [mAbStr setAttributes:dic range:NSMakeRange(0, mAbStr.length)];
    NSAttributedString *attrString = [mAbStr copy];
    return attrString;
}

#pragma mark 拉伸图片
+ (UIImage *)changeImage:(UIImage *)image Withview:(UIView *)view;
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.f);
    [image drawInRect:view.bounds];
    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return lastImage;
}

#pragma mark 获取当前年限
+ (NSInteger )getCurrentYear {
    //获取当前年限
    NSDate * mydate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM";
    NSString *str_year = [dateFormatter stringFromDate:mydate];
    NSRange rang_year = NSMakeRange(0, 4);
    NSString *substring = [str_year substringWithRange:rang_year];
    NSInteger maxYear  = [substring integerValue];
    //最大年限
    return maxYear;
}

#pragma mark 生成随机数, 用于图片上传的压缩系数
+ (double)configureRandomNumber
{
    //获取一个随机数范围在：[600000,700000]
    srand((unsigned)time(0));
    int value = (arc4random() % 100000) + 600000;
    NSString *string = [NSString stringWithFormat:@"0.%i",value];
    double newValue = [string floatValue];
    return newValue;
}

#pragma mark 重新定义提示语的位置,ost
+ (void)showMessage:(NSString *)message withDuration:(NSTimeInterval)duration
{
    //文字的宽高
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGSize labelsize = [message boundingRectWithSize:CGSizeMake(ZSWIDTH-50, ZSHEIGHT) options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    //label
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake((ZSWIDTH-labelsize.width-20)/2, (ZSHEIGHT-labelsize.height-20)/2, labelsize.width+20, labelsize.height+20)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.layer.cornerRadius = 5;
    [window addSubview:blackView];
    
    UILabel *whiteLabel =  [[UILabel alloc]initWithFrame:CGRectMake((ZSWIDTH-labelsize.width)/2, (ZSHEIGHT-labelsize.height)/2, labelsize.width, labelsize.height)];
    whiteLabel.backgroundColor = [UIColor clearColor];
    whiteLabel.text = message;
    whiteLabel.textColor = ZSColorWhite;
    whiteLabel.numberOfLines = 0;
    whiteLabel.textAlignment = NSTextAlignmentCenter;
    whiteLabel.font = [UIFont systemFontOfSize:14];
    [window addSubview:whiteLabel];
    
    [UIView animateWithDuration:duration animations:^{
        blackView.alpha = 0.8;
        whiteLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
        [whiteLabel removeFromSuperview];
    }];
}

#pragma mark 万元和元之间的转化
+ (NSString *)yuanIntoTenThousandYuanWithCount:(NSString *)count WithType:(BOOL)isYuan;//isYuan为yes表示元转化成万元,反之万元转成元
{
    NSString *result;
    if (isYuan)
    {
        //除以
        NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:count];
        NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:@"10000"];
        result = [NSString stringWithFormat:@"%@", [a decimalNumberByDividingBy:b]];
    }
    else
    {
        //乘
        NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:count];
        NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:@"10000"];
        result = [NSString stringWithFormat:@"%@", [a decimalNumberByMultiplyingBy:b]];
    }
    return result;
}

@end
