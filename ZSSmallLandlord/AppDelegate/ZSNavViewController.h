//
//  NavViewController.h
//  
//
//  Created by 黄曼文 on 14-11-5.
//  Copyright (c) 2014年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSNavViewController : UINavigationController<UIGestureRecognizerDelegate>
@property (assign, nonatomic) BOOL                   leftPanUse;            //是否为滑动状态
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer; //滑动手势
@property (strong, nonatomic) UIImageView            *backView;             //图片
@property (strong, nonatomic) NSMutableArray         *backImgs;             //缓存图片数组
@property (assign, nonatomic) CGPoint                panBeginPoint;         //滑动起始位置
@property (assign, nonatomic) CGPoint                panEndPoint;           //滑动结束为止
@property (assign, nonatomic) NSInteger              toIndex;               //目标ViewControlelr的index
@end
