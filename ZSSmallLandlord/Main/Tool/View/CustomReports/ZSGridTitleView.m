//
//  ZSGridTitleView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/30.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSGridTitleView.h"

#define DefaultImg [UIImage imageNamed:@"无序"]
#define UpImg      [UIImage imageNamed:@"从小到大"]
#define DownImg    [UIImage imageNamed:@"从大到小"]

@implementation ZSGridTitleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, frame.size.width-6, frame.size.height)];
        self.nameLabel.textColor = ZSColorListRight;
        self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.numberOfLines = 0;
        [self addSubview: self.nameLabel];
        
        self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.nameLabel.right, (frame.size.height-20)/2, 20, 20)];
        self.rightImage.image = DefaultImg;
        self.rightImage.hidden = YES;
        [self addSubview:self.rightImage];
        
        //手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showRightImage:(BOOL)isShow withModel:(ZSCustomReportSettingModel *)model;
{
    _model = model;
    
    //图片样式
    if (model.orderType == 1) {
        self.rightImage.image = DefaultImg;
    }
    else if (model.orderType == 2) {
        self.rightImage.image = UpImg;
    }
    else{
        self.rightImage.image = DownImg;
    }
    
    //是否显示图片
    if (isShow == YES)
    {
        CGFloat width = [ZSTool getStringWidth:model.columnNameCn withframe:CGSizeMake(self.frame.size.width-26, self.frame.size.height) withSizeFont:[UIFont systemFontOfSize:14]];
        self.rightImage.hidden = NO;
        self.nameLabel.frame = CGRectMake((self.frame.size.width-width-20)/2, 0, width, self.size.height);
        self.rightImage.left = self.nameLabel.right;
    }
    else
    {
        self.rightImage.hidden = YES;
        self.nameLabel.width = self.size.width-6;
        self.rightImage.left = self.nameLabel.right;
    }
}

- (void)tapAction
{
    if (self.rightImage.hidden == NO)
    {
        if ([UIImagePNGRepresentation(self.rightImage.image) isEqual:UIImagePNGRepresentation(DefaultImg)] ||
            [UIImagePNGRepresentation(self.rightImage.image) isEqual:UIImagePNGRepresentation(UpImg)] )
        {
            //从小到大重新排序
            ZSCustomReportSettingModel *model = self.model;
            model.orderType = 3;
            if (_delegate && [_delegate respondsToSelector:@selector(reOrderWithType:withModel:)]) {
                [_delegate reOrderWithType:@"down" withModel:model];
            }
        }
        else if ([UIImagePNGRepresentation(self.rightImage.image) isEqual:UIImagePNGRepresentation(DownImg)])
        {
            //从大到小重新排序
            ZSCustomReportSettingModel *model = self.model;
            model.orderType = 2;
            if (_delegate && [_delegate respondsToSelector:@selector(reOrderWithType:withModel:)]) {
                [_delegate reOrderWithType:@"up" withModel:model];
            }
        }
    }
}

@end
