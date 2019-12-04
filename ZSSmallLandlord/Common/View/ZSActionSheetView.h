//
//  ZSActionSheetView.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSActionSheetView;
@protocol ZSActionSheetViewDelegate <NSObject>
@optional
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag;//选中某个按钮响应方法
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag sheetStyle:(ZSAddResourceDataStyle)sheetStyle;//选照片代理响应方法
@end

@interface ZSActionSheetView : UIView
@property (nonatomic,weak  )id<ZSActionSheetViewDelegate> delegate;
@property (nonatomic,assign)ZSAddResourceDataStyle        sheetStyle;
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)titleArray;
- (void)show:(NSInteger)count;
@end
