//
//  ZSMoreActionSheetView.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/7.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSPickerView;
@protocol ZSPickerViewDelegate <NSObject>
@optional
- (void)pickerView:(ZSPickerView *)pickerView didSelectIndex:(NSInteger)index;
@end

@interface ZSPickerView : UIView
@property (nonatomic,weak  )id <ZSPickerViewDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *titleArray;//标题
- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
@end
