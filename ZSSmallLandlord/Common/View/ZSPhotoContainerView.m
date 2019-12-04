//
//  ZSPhotoContainerView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSPhotoContainerView.h"
#import "PYPhotoBrowseView.h"

@interface ZSPhotoContainerView ()
@property (nonatomic,strong)UIImageView *imgview_pos;
@property (nonatomic,strong)UIImageView *imgview_bak;
@property (nonatomic,strong)UIImageView *imgview_auth;
@property (nonatomic,strong)NSArray *array_image;
@end

@implementation ZSPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.imgview_pos = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (ZSWIDTH-30-30)/4, (ZSWIDTH-30-30)/4)];
        self.imgview_pos.backgroundColor = [UIColor clearColor];
        self.imgview_pos.userInteractionEnabled = YES;
        self.imgview_pos.layer.cornerRadius = 4;
        self.imgview_pos.layer.masksToBounds = YES;
        self.imgview_pos.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imgview_pos];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigImgShow:)];
        [self.imgview_pos addGestureRecognizer:tap];
        
        self.imgview_bak = [[UIImageView alloc]initWithFrame:CGRectMake(self.imgview_pos.right+10, 0, (ZSWIDTH-30-30)/4, (ZSWIDTH-30-30)/4)];
        self.imgview_bak.backgroundColor = [UIColor clearColor];
        self.imgview_bak.userInteractionEnabled = YES;
        self.imgview_bak.layer.cornerRadius = 4;
        self.imgview_bak.layer.masksToBounds = YES;
        self.imgview_bak.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imgview_bak];
        UITapGestureRecognizer *tap_bak = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigImgShow:)];
        [self.imgview_bak addGestureRecognizer:tap_bak];
        
        self.imgview_auth = [[UIImageView alloc]initWithFrame:CGRectMake(self.imgview_bak.right+10, 0, (ZSWIDTH-30-30)/4, (ZSWIDTH-30-30)/4)];
        self.imgview_auth.backgroundColor = [UIColor clearColor];
        self.imgview_auth.userInteractionEnabled = YES;
        self.imgview_auth.layer.cornerRadius = 4;
        self.imgview_auth.layer.masksToBounds = YES;
        self.imgview_auth.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imgview_auth];
        UITapGestureRecognizer *tap_auth = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigImgShow:)];
        [self.imgview_auth addGestureRecognizer:tap_auth];
    }
    return self;
}

- (void)LoadImgs:(NSArray *)array
{
    [self.imgview_pos sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,array[0]]] placeholderImage:defaultImage_square];
    [self.imgview_bak sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,array[1]]] placeholderImage:defaultImage_square];
    [self.imgview_auth sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,array[2]]] placeholderImage:defaultImage_square];
    self.array_image = array;
}

- (void)bigImgShow:(UITapGestureRecognizer*)tap
{
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.array_image[0]],[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.array_image[1]],[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.array_image[2]]].mutableCopy;
    photoBroseView.showFromView = tap.view;
    photoBroseView.hiddenToView = tap.view;
    if (tap.view == self.imgview_pos) {
        photoBroseView.currentIndex = 0;
    }else if (tap.view == self.imgview_bak) {
        photoBroseView.currentIndex = 1;
    }else{
        photoBroseView.currentIndex = 2;
    }
    // 3.显示(浏览)
    [photoBroseView show];
}


@end
