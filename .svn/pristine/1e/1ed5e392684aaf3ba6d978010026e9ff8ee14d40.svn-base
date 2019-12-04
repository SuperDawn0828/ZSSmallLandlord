//
//  ZSGridView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/30.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSGridView.h"

@implementation ZSGridView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, frame.size.width-6, frame.size.height)];
        self.nameLabel.textColor = ZSColorListRight;
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.numberOfLines = 0;
        [self addSubview: self.nameLabel];
        
        //手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction
{
    if (self.showString.length)
    {
        [ZSTool showMessage:self.showString withDuration:2.0f];
    }
    
    //通知啊
    [NOTI_CENTER postNotificationName:@"changeCellBackgroundColor" object:nil userInfo:@{@"index":self.indxPath}];
}

@end
