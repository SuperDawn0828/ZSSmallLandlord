//
//  JWCollectionViewCell.h
//  ZSMoneytocar
//
//  Created by 武 on 2017/2/10.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSWSFileCollectionModel.h"
static NSString *const KReuseJWCollectionViewCell=@"JWCollectionViewCell";

@class JWCollectionViewCell;
@protocol JWCollectionViewCellDelegate <NSObject>
- (void)deleteDataByIndexPath:(NSIndexPath *)indexPath;
@end

@interface JWCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainImageViewBottomContraint;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *videoCoverView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名称
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHightContraint;
@property (nonatomic,strong)   ZSWSFileCollectionModel *fileModel;
@property (nonatomic,strong)   NSIndexPath *indexPath;
@property (nonatomic,weak)   id<JWCollectionViewCellDelegate> delegate;
@property (nonatomic,copy)     NSString *uuid;
@property (nonatomic,copy)     NSString *biztemplateItemName;//资料分类名称

@property (nonatomic,assign)BOOL     isShowAdd;//是否展示加号，完成和关闭订单不显示加号

@end
