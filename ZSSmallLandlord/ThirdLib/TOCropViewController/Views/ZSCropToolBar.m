//
//  ZSCropToolBar.m
//  ZSYuecheDealer
//
//  Created by 武 on 2017/9/18.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSCropToolBar.h"
#import "Masonry.h"
@interface  ZSCropToolBar ()
@property (nonatomic, strong, readwrite) UIButton *doneTextButton;
@property (nonatomic, strong, readwrite) UIButton *doneIconButton;

@property (nonatomic, strong, readwrite) UIButton *cancelTextButton;
@property (nonatomic, strong, readwrite) UIButton *cancelIconButton;

@property (nonatomic, strong) UIButton *rotateButton;

@end
@implementation ZSCropToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}
- (void)setUpView{
    
    self.doneTextButton=[UIButton new];
    [self addSubview:self.doneTextButton];
    [self.doneTextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.doneTextButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
   [ self.doneIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.equalTo(@42);
       make.height.equalTo(@14);
       make.right.equalTo(self).offset(72.5);
       make.bottom.equalTo(self).offset(62);
   }];
    
}
- (void)buttonTapped:(id)button
{
    if (button == self.cancelTextButton || button == self.cancelIconButton) {
        if (self.cancelButtonTapped)
            self.cancelButtonTapped();
    }
    else if (button == self.doneTextButton || button == self.doneIconButton) {
        if (self.doneButtonTapped)
            self.doneButtonTapped();
    }
    
//    else if (button == self.rotateCounterclockwiseButton && self.rotateCounterclockwiseButtonTapped) {//旋转按钮
//        self.rotateCounterclockwiseButtonTapped();
//    }

    
}
@end
