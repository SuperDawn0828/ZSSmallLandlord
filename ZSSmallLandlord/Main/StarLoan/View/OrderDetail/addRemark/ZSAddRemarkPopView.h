//
//  ZSAddRemarkPopView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/8/24.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  添加备注弹窗

#import "ZSBasePopView.h"

@class ZSAddRemarkPopView;
@protocol ZSAddRemarkPopViewDelegate <NSObject>
@optional
- (void)sendData:(NSString *)remarkString;
@end

@interface ZSAddRemarkPopView : ZSBasePopView
@property (weak, nonatomic)id<ZSAddRemarkPopViewDelegate> delegate;
@end
