//
//  UITextField+add.h
//  ZSMoneytocar
//
//  Created by 武 on 2016/10/19.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (add)
#pragma mark 检查小数点右边的位数
- (BOOL)checkTextField:(UITextField*)textField WithString:(NSString*)string Range:(NSRange)range numInt:(NSInteger)num;//小数点的个数限制

- (void)changePlaceholderColor;//改变占位符颜色
#pragma mark 检查小数点左边和右边的位数
- (BOOL)checkLeftAndRightTextField:(UITextField*)textField WithString:(NSString*)string Range:(NSRange)range numInt:(NSInteger)num  pointNum:(NSInteger)pointNum;
@end
