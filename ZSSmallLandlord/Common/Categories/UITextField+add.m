//
//  UITextField+add.m
//  ZSMoneytocar
//
//  Created by 武 on 2016/10/19.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "UITextField+add.h"

@implementation UITextField (add)
- (BOOL)checkTextField:(UITextField*)textField WithString:(NSString*)string Range:(NSRange)range numInt:(NSInteger)num{
    BOOL  isHaveDian = false;
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian = NO;
    }else{
         isHaveDian = YES;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    //     [self alertView:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }

            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                    
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    
                    NSInteger tt = range.location-ran.location;
                    
                    if (tt <= num){
                        return YES;
                    }else{
                        //[self alertView:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
//改变占位符颜色
- (void)changePlaceholderColor
{
    [self setValue:ZSColorAllNotice forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark 检查小数点左边和右边的位数
- (BOOL)checkLeftAndRightTextField:(UITextField*)textField WithString:(NSString*)string Range:(NSRange)range numInt:(NSInteger)num  pointNum:(NSInteger)pointNum {
//    
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    //     [self alertView:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
            // 判断是否输入内容，或者用户点击的是键盘的删除按钮
            if (![string isEqualToString:@""]) {
                // 小数点在字符串中的位置 第一个数字从0位置开始
                NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
                if (dotLocation == NSNotFound && range.location != 0) {
                    //没有小数点,最大数值
                    if (range.location >= num){
                        if ([string isEqualToString:@"."] && range.location == num) {
                            return YES;
                        }
                        return NO;
                    }
                }
                //判断输入多个小数点,禁止输入多个小数点
                if (dotLocation != NSNotFound){
                    if ([string isEqualToString:@"."])return NO;
                }
                //判断小数点后最多两位
                if (dotLocation != NSNotFound && range.location > dotLocation + pointNum) { return NO; }
                //判断总长度
                if (textField.text.length > num + pointNum) {
                    return NO;
                }
                
            }
            return YES;
        }
        return NO;

    }else{
        return YES;

    }

}


@end
