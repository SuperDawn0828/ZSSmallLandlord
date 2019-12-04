//
//  ZSBaseSeationView.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSCreditSectionViewDelegate <NSObject>
- (void)tapSection:(NSInteger)sectionIndex;
@optional
- (void)showExplain;
@end

@interface ZSBaseSectionView : UIView
@property (nonatomic,strong)UIImageView *leftImagView;
@property (nonatomic,strong)UIImageView *rightArrowImgV;
@property (nonatomic,strong)UILabel     *leftLab;
@property (nonatomic,strong)UILabel     *rightLab;
@property (nonatomic,strong)UIButton    *showDetailBtn;
@property (nonatomic,strong)UIView      *view_refesh;       //刷新按钮,目前暂时只用于大数据风控
@property (nonatomic,strong)UIView      *bottomLine;
@property (nonatomic,strong)UIView      *verticalLineView;
@property (nonatomic,weak  )id<ZSCreditSectionViewDelegate> delegate;
@end

