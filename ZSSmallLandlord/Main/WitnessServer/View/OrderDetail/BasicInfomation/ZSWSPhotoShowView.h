//
//  ZSWSPhotoShowView.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/12.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSWSPhotoShowView : UIView
@property (nonatomic,strong)NSMutableArray *imageArray;

//初始化
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)array;

//重设本身的高度
+ (CGFloat)heightWithPicturesCount:(NSInteger)pictureNum;



@end
