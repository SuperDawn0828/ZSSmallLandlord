//
//  ZSWSPhotoShowView.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/12.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSPhotoShowView.h"
#import "PYPhotoBrowseView.h"




@implementation ZSWSPhotoShowView

- (NSMutableArray *)imageArray
{
    if (_imageArray == nil){
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)array
{
    if (self = [super initWithFrame:frame]) {
        [self  initWithNum:4 withaArray:array];

        _imageArray = array;
    }
    return self;
}
//初始化
- (void)initWithNum:(NSInteger)lineNum withaArray:(NSMutableArray *)array
{
    CGFloat clearance = 10;//间隙
    CGFloat width = (ZSWIDTH-30- (lineNum-1)*clearance)/lineNum;//图片宽度
    for (int i=0; i<array.count; i++) {
        CGRect frame;
        UIButton *button = [[UIButton alloc]init];
        button.layer.cornerRadius = 8;
        button.clipsToBounds = YES;
        frame.size.width = width;//设置按钮坐标及大小
        frame.size.height = width;
        frame.origin.x = (i%lineNum)*(width+clearance)+ 15;
        frame.origin.y = floor(i/lineNum)*(width+clearance) + 10;
        [button setFrame:frame];
        [self addSubview:button];
        button.userInteractionEnabled = YES;
        button.tag = i;
        [button addTarget:self action:@selector(bigImgShow:) forControlEvents:UIControlEventTouchUpInside];
        //添加一个imgview,防止图片变形
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, button.width, button.height)];
        imgview.layer.cornerRadius = 8;
        imgview.clipsToBounds = YES;
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        [imgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?w=200",array[i]]] placeholderImage:defaultImage_square];
        [button addSubview:imgview];
    }
}

//查看大图
- (void)bigImgShow:(UIButton *)btn
{
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    photoBroseView.imagesURL = self.imageArray;
    photoBroseView.showFromView = btn;
    photoBroseView.hiddenToView = btn;
    photoBroseView.currentIndex = btn.tag;
    // 3.显示(浏览)
    [photoBroseView show];
}

//重设本身的高度 需要每行显示几张图以及图片总数
+ (CGFloat)heightWithPicturesCount:(NSInteger)pictureNum
{
    CGFloat height = 0;
    CGFloat clearance = 10;//间隙
    NSInteger lineNum = 4;
    CGFloat width = (ZSWIDTH-30- (lineNum-1)*clearance)/lineNum;//图片宽度
    int row;
    if (pictureNum/lineNum >=0 && pictureNum%lineNum == 0) {
        row = (int)(pictureNum/lineNum);
    }else
    {
        row = (int)(pictureNum/lineNum) + 1;
    }
    height = row*(width+clearance) + 10;
    return height;
}

@end
