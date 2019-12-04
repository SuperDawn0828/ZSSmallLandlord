//
//  CCPTakePicturesController.h
//  CCPCustomCamera
//
//  Created by C CP on 16/9/22.
//  Copyright © 2016年 C CP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CropImgesBlock)(NSArray *images);

@interface CCPTakePicturesController : UIViewController

//是否开启截图,默认开启
@property (nonatomic,assign) BOOL isCanCut;

//最多可拍摄个数
@property (nonatomic,assign)int  maxImgeCount;

//截图后的回调
@property (nonatomic,copy) CropImgesBlock cropImagesBlock;

@property (nonatomic, assign) TOCropViewControllerAspectRatioPreset aspectRatioPreset;

@property (nonatomic,assign)BOOL  showCorver;

@end
