//
//  ZSWSMaterialCollectCell.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSWSMaterialCollectCell.h"

@implementation ZSWSMaterialCollectCell

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame] ;
//    self.selectedBackgroundView.backgroundColor = ZSColorLine;
    // Initialization code
    self.nameLabel.textColor = ZSColorListLeft;
    self.typeLabel.textColor = ZSColorAllNotice;

}

- (void)setModel:(DocInfo *)model
{
    _model = model;
    self.nameLabel.text = SafeStr(model.docName);
    self.typeLabel.text = SafeStr(model.docType);
    self.leftSeclectBtn.selected = model.docFlag == 1?YES:NO;
    self.clickBtn.selected = model.docFlag == 1?YES:NO;
    [self.rightBtn setTitle:model.beCollect == 1?@"已拍照":@"未拍照" forState:UIControlStateNormal];
    [self.leftSeclectBtn setImage:[UIImage imageNamed:@"list_chech_s"] forState:UIControlStateSelected];
    [self.leftSeclectBtn setImage:[UIImage imageNamed:@"list_chech_n"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

     
}

@end
