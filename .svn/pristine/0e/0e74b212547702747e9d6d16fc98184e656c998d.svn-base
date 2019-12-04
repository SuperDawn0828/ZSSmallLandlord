//
//  ZSCustomReportSettingCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/28.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSCustomReportSettingCell.h"

@interface ZSCustomReportSettingCell ()
@property(nonatomic,strong)UIImageView *leftImage;
@property(nonatomic,strong)UIButton    *addOrDeleteBtn;
@property(nonatomic,strong)UILabel     *nameLabel;
@end

@implementation ZSCustomReportSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleFill;//设置cell上分割线的风格
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //左侧按钮
    self.leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    [self addSubview:self.leftImage];

    //可操作区域放大点
    self.addOrDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addOrDeleteBtn.frame = CGRectMake(0, 0, ZSWIDTH-60, CellHeight);
    [self.addOrDeleteBtn addTarget:self action:@selector(addOrDeleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addOrDeleteBtn];
    
    //字段名称
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CellHeight, 0, ZSWIDTH-CellHeight*2, CellHeight)];
    self.nameLabel.textColor = ZSColorBlack;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.nameLabel];
}

- (void)setModel:(ZSCustomReportSettingModel *)model
{
    _model = model;
    
    //左侧按钮
    if (model.selectedType == 1)
    {
        if ([model.columnNameCn isEqualToString:@"客户姓名"]) {
            self.leftImage.image = nil;
            self.addOrDeleteBtn.userInteractionEnabled = NO;
        }
        else
        {
            self.leftImage.image = [UIImage imageNamed:@"delete_icon"];
            self.addOrDeleteBtn.userInteractionEnabled = YES;
        }
    }
    else
    {
        self.leftImage.image = [UIImage imageNamed:@"add_icon"];
        self.addOrDeleteBtn.userInteractionEnabled = YES;
    }
    
    //字段名称
    if (model.columnNameCn) {
        self.nameLabel.text = SafeStr(model.columnNameCn);
    }
}

#pragma mark 添加/删除
- (void)addOrDeleteBtnAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectCell:)]) {
        [_delegate selectCell:_model];
    }
}

#pragma mark 修改排序按钮图片
- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];
    if (editing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = [UIImage imageNamed:@"move_icon"];
                    }
                }
            }
        }
    }
}

@end
