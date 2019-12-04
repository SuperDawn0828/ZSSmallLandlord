//
//  ZSSharView.h
//  ZSSmallLandlord
//
//  Created by gengping on 2017/8/18.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSShareViewDelegate <NSObject>
@optional
- (void)currentSelectTiemTitle:(NSString *)title;//选择的item

@end

@interface ZSShareView : UIView
@property (nonatomic,strong)UIView               *view_title;
@property (strong, nonatomic) NSMutableArray     *titleArray;
@property (strong, nonatomic) NSMutableArray     *imgViewArray;

@property (weak, nonatomic)id<ZSShareViewDelegate> delegate;


#pragma mark show
- (void)show;
#pragma mark dismiss
- (void)dismiss;
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)titleArray;

//重设本身的高度 需要每行显示几张图以及图片总数
- (CGFloat)heightWithPicturesCount:(NSInteger)pictureNum;
@end
