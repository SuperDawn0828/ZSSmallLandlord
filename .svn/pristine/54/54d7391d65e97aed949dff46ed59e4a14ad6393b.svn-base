//
//  UIScrollView+backGesture.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/6/12.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "UIScrollView+backGesture.h"

#define IPHONE_H [UIScreen mainScreen].bounds.size.height //屏幕的高度
#define IPHONE_W [UIScreen mainScreen].bounds.size.width // 屏幕的宽度

@implementation UIScrollView (backGesture)

//一句话总结就是此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
}

//location_X可自己定义,其代表的是滑动返回距左边的有效长度
- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer
{
    //是滑动返回距左边的有效长度
    int location_X = 30;
    if (gestureRecognizer ==self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state ||UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            //这是允许每张图片都可实现滑动返回
            int temp1 = location.x;
            int temp2 =IPHONE_W;
            NSInteger XX = temp1 % temp2;
            if (point.x >0 && XX < location_X) {
                return YES;
            }
            //下面的是只允许在第一张时滑动返回生效
            //            if (point.x > 0 && location.x < location_X && self.contentOffset.x <= 0) {
            //                return YES;
            //            }
        }
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
}

@end
