//
//  UIImage+add.h
//  ZSMoneytocar
//
//  Created by 武 on 2017/2/10.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface UIImage (add)

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

#pragma mark 纯色图片
+ (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)rect;

#pragma mark 储存图片到相册
+(void)writeImageToSavedPhotosAlbumWithImage:(UIImage*)image;

#pragma mark 按比例截取图片大小
+(UIImage*)imageByCroppingWithImage:(UIImage*)myImage;

#pragma mark 储存视频到相册
+(void)writeVideoToSavedPhotosAlbumWithURL:(NSString*)url;

#pragma mark 图片旋转
+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

#pragma mark 修正图片方向
+(UIImage *)fixOrientation:(UIImage *)aImag;

#pragma mark 图片压缩
+(UIImage *)scaleFromImage:(UIImage *)image;

#pragma mark 生成视频缩略图
+(UIImage *)getVideoShotWithUrl:(NSURL*)url;

#pragma mark 根据订单状态返回image
+(UIImage *)getImageByOrderState:(NSString*)name;

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

@end
