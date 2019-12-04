//
//  ZSSLMaterialCollectCell.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  首页--订单列表--星速贷订单详情--资料收集单元格

static NSString *const KReuseZSSLMaterialCollectCellIdentifier=@"ZSSLMaterialCollectCell";

#import <UIKit/UIKit.h>

@interface ZSSLMaterialCollectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView        *headImgView;    //资料logo
@property (weak, nonatomic) IBOutlet UILabel            *nameLabel;      //资料名称
@property (weak, nonatomic) IBOutlet UILabel            *remarkLabel;    //备注
@property (weak, nonatomic) IBOutlet UIButton           *rightBtn;       //选择按钮
@property (weak, nonatomic) IBOutlet UIImageView        *checkImgView;   //是否完成上传图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceIng;   //剧左间距
@property(nonatomic,strong) Handles                     *model;          //星速贷model
@end
