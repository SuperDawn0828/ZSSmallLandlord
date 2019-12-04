//
//  NSString+ReviseString.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/25.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "NSString+ReviseString.h"

@implementation NSString (ReviseString)


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
