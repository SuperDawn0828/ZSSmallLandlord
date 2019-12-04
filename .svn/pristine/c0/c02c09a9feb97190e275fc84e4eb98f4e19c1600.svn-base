//
//  ZCTabbarViewController.m
//  zvframe
//
//  Created by ztsy on 16/1/8.
//  Copyright (c) 2016年 ztsy. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

//获取到当前所在的视图
//获取所在控制器
- (UIViewController *)getCurrentVC{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+ (instancetype)extractFromXib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    for (id item in views) {
        if ([item isKindOfClass:[self class]]) {
            return item;
        }
    }
    return nil;
}

#pragma mark 设置渐变图层
- (CAGradientLayer *)addBackGroundLayerWithLeftColor:(UIColor *)leftColor withRightColor:(UIColor *)rightColor
{
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    //    CGColor 是c的  不是对象  需要强转成对象
    gLayer.colors = @[(id)leftColor.CGColor,(id)rightColor.CGColor];
    gLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    gLayer.startPoint = CGPointMake(0, 0.5);//x表示左右，y表示上下
    gLayer.endPoint = CGPointMake(0.5, 0.5);
    [self.layer addSublayer:gLayer];
    return gLayer;
}

@end
