//
//  ZSToolTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/23.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSToolTableViewCell.h"

@implementation ZSToolTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
    }
    return self;
}

- (void)setModel:(ZSToolModel *)model
{
    //移除所有子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    //数据填充
    _model = model;
    CGFloat Button_Width = ZSWIDTH/3;//按钮宽度
    CGFloat Button_height = KZZSToolTableViewCellHeight;//按钮高度
    
    [model.data enumerateObjectsUsingBlock:^(ToolDatamodel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
        NSInteger index = idx % 3;
        NSInteger page = idx / 3;
        ZSToolButton *toolBtn = [[ZSToolButton alloc]initWithFrame:CGRectMake(index * Button_Width, page * Button_height, Button_Width, Button_height)];
        [toolBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        toolBtn.tag = idx;
        [self addSubview:toolBtn];
        //数据填充
        ToolDatamodel *dataModel = model.data[idx];
        [toolBtn.imgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",APPDELEGATE.zsImageUrl,dataModel.toolUrl,@"?p=0"]] placeholderImage:defaultImage_square];
        toolBtn.label_text.text = dataModel.toolName;
    }];
}

//#pragma mark 点击
- (void)toolBtnClick:(UIButton *)sender
{
    ToolDatamodel *dataModel = _model.data[sender.tag];
    if (_delegate && [_delegate respondsToSelector:@selector(selectCurrentTool:)]){
        [self.delegate selectCurrentTool:dataModel];
    }
}

@end
