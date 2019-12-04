//
//  SymbolsValueFormatter.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/23.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "SymbolsValueFormatter.h"

@implementation SymbolsValueFormatter

- (id)initWithArray:(NSArray *)array
{
    if (self = [super init])
    {
        _XtitleArray = array;
    }
    return self;
}

#pragma make- IChartAxisValueFormatter
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    return _XtitleArray[(NSInteger)value];
}


@end
