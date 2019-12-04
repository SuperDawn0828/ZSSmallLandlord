//
//  ZSOrderNodeTableViewCell.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/8/21.
//  Copyright © 2018年 黄曼文. All rights reserved.
//  审批驳回至某个节点弹窗--cell

#import "ZSBaseCardTableViewCell.h"
#import "ZSSLOrderRejectNodeModel.h"

static NSString *CellIdentifier = @"ZSOrderNodeTableViewCell";

@interface ZSOrderNodeTableViewCell : ZSBaseCardTableViewCell

@property(nonatomic,strong)UIImageView              *lineImage;
@property(nonatomic,strong)UIImageView              *arrowImage;
@property(nonatomic,strong)ZSSLOrderRejectNodeModel *model;
@property(nonatomic,assign)NSInteger                currentIndex;

@end
