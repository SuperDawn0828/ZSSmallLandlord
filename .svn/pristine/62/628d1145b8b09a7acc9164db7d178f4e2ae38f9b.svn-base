//
//  UIImage+add.m
//  ZSMoneytocar
//
//  Created by 武 on 2017/2/10.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "UIImage+add.h"
#import <AssetsLibrary/AssetsLibrary.h>
@implementation UIImage (add)
+ (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark 储存图片到相册
+(void)writeImageToSavedPhotosAlbumWithImage:(UIImage*)image{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            ZSLOG(@"Save image fail：%@",error);
        }else{
            ZSLOG(@"Save image succeed.");
        }
    }];
}


#pragma mark 储存视频到相册
+(void)writeVideoToSavedPhotosAlbumWithURL:(NSString*)url {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:url]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    if (error) {
                                       
                                    } else {
                                        ZSLOG(@"Save video succeed.");
                                        
                                    }
                                }];
}

#pragma mark 修正图片方向
+(UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark 按比例截取图片大小
+(UIImage*)imageByCroppingWithImage:(UIImage*)myImage
{
    CGFloat ratioPic =  0.5f;//宽高比1比1
    CGFloat myWidth = myImage.size.width*myImage.scale;
    //image.size.width乘以缩放比才是真正的尺寸。
    //图像的实际的尺寸(像素)等于image.size乘以image.scale
    CGFloat myHeight = ceil(myWidth*ratioPic);
    CGRect rect = CGRectMake(0,0,myWidth,myHeight);
    CGImageRef imageRef = myImage.CGImage;
    CGImageRef imagePartRef=CGImageCreateWithImageInRect(imageRef,rect);
    UIImage * cropImage=[UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return cropImage;
}


#pragma mark 图片旋转
+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    
    long double rotate = 0.0;
    
    CGRect rect;
    
    float translateX = 0;
    
    float translateY = 0;
    
    float scaleX = 1.0;
    
    float scaleY = 1.0;
    
    
    
    switch (orientation) {
            
        case UIImageOrientationLeft:
            
            rotate =M_PI_2;
            
            rect =CGRectMake(0,0,image.size.height, image.size.width);
            
            translateX=0;
            
            translateY= -rect.size.width;
            
            scaleY =rect.size.width/rect.size.height;
            
            scaleX =rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationRight:
            
            rotate =3 *M_PI_2;
            
            rect =CGRectMake(0,0,image.size.height, image.size.width);
            
            translateX= -rect.size.height;
            
            translateY=0;
            
            scaleY =rect.size.width/rect.size.height;
            
            scaleX =rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationDown:
            
            rotate =M_PI;
            
            rect =CGRectMake(0,0,image.size.width, image.size.height);
            
            translateX= -rect.size.width;
            
            translateY= -rect.size.height;
            
            break;
            
        default:
            
            rotate =0.0;
            
            rect =CGRectMake(0,0,image.size.width, image.size.height);
            
            translateX=0;
            
            translateY=0;
            
            break;
            
    }
    
    
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //做CTM变换
    
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextRotateCTM(context, rotate);
    
    CGContextTranslateCTM(context, translateX,translateY);
    
    
    
    CGContextScaleCTM(context, scaleX,scaleY);
    
    //绘制图片
    
    CGContextDrawImage(context, CGRectMake(0,0,rect.size.width, rect.size.height), image.CGImage);
    
    
    
    UIImage *newPic =UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    return newPic;
    
}

#pragma mark 图片压缩
+(UIImage *)scaleFromImage:(UIImage *)image
{
    if (!image)
    {
        return nil;
    }
    NSData *data =UIImagePNGRepresentation(image);
    CGFloat dataSize = data.length/1024;
    CGFloat width  = image.size.width;
    CGFloat height = image.size.height;
    CGSize size;
    
    if (dataSize<=50)//小于50k
    {
        return image;
    }
    else if (dataSize<=100)//小于100k
    {
        size = CGSizeMake(width/1.f, height/1.f);
    }
    else if (dataSize<=200)//小于200k
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=500)//小于500k
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=1000)//小于1M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=2000)//小于2M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else//大于2M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    NSLog(@"%f,%f",size.width,size.height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (!newImage)
    {
        return image;
    }
    return newImage;
}

#pragma mark 生成视频缩略图
+(UIImage *)getVideoShotWithUrl:(NSURL*)url{
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem   *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:movieAsset];
    CGImageRef thumb = [imageGenerator copyCGImageAtTime:playerItem.currentTime
                                              actualTime:NULL
                                                   error:NULL];
    UIImage *videoImag = [UIImage imageWithCGImage:thumb];
    return videoImag;
}
/**
 * 户口本  bar_household_s_3x
 * 婚姻状况 bar_marital_s_3x
 * 银行流水 bar_bankwater_s_3x
 * 收入证明 bar_income_proof_s_3x
 * 财力证明 bar_finanacial_s_3x
 * 不动产权证 bar_property_rights_s_3x
 * 公证书 bar_notarization_s_3x
 * 审批单 bar_approval_for_s_3x
 * 放款凭证 bar_advances_vouchers_s_3x
 * 他项权证 bar_hexiang_s_3x
 * 产权情况表 bar_property_report_s_3x
 * 预评估报告 bar_appraisal_report_s_3x
 * 收款凭证 bar_first_document_s_3x
 */

#pragma mark 根据订单状态返回image
+ (UIImage *)getImageByOrderState:(NSString*)name
{
    UIImage *image  = nil;
    if ([name isEqualToString:@"已关闭"]) {
        image = ImageName(@"list_closed_n");
    }
    else if ([name isEqualToString:@"完成审批"]) {
        image = ImageName(@"list_completed_n");
    }
    else { //审批中
        image = ImageName(@"list_in approval_n");
    }
    return image;
}

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case GradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case GradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case GradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case GradientTypeUprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
@end
