//
//  SymbolsValueFormatter.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/23.
//  Copyright © 2018 黄曼文. All rights reserved.
//  工具--数据统计--折线图cell--X轴坐标显示的数据

#import <Foundation/Foundation.h>
#import "ZSSmallLandlord-Bridging-Header.h"
#import "ZSSmallLandlord-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface SymbolsValueFormatter : NSObject<IChartAxisValueFormatter>

@property (nonatomic,strong) NSArray *XtitleArray;//横坐标标签

- (id)initWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
