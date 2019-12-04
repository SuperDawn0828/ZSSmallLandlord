//
//  ZSCustomReportDetailRightCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/11/27.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSCustomReportDetailRightCell.h"
#import "ZSGridView.h"

@interface ZSCustomReportDetailRightCell ()
@property(nonatomic,strong)NSMutableArray <ZSGridView*>*fieldArray;//字段数组
@property(nonatomic,strong)NSArray        *dataArray;
@end

@implementation ZSCustomReportDetailRightCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //创建字段数组(默认)
    self.fieldArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 200; i++) {
        ZSGridView *view = [[ZSGridView alloc]initWithFrame:CGRectMake(gridWidth*i, 0, gridWidth, gridHeight)];
        view.hidden = YES;
        [self addSubview:view];
        [self.fieldArray addObject:view];
    }
}

- (void)setIndxPath:(NSIndexPath *)indxPath
{
    _indxPath = indxPath;
}

- (void)setDataWithArray:(NSArray *)array withDic:(NSDictionary *)dic;
{
    _dataArray = array;
    
    for (int i = 0; i < array.count; i++)
    {
        //赋值
        ZSCustomReportSettingModel *model = array[i];
        if (dic[model.fieldAlias])
        {
            self.fieldArray[i].nameLabel.text = [NSString stringWithFormat:@"%@",dic[model.fieldAlias]];
            self.fieldArray[i].showString = [NSString stringWithFormat:@"%@",dic[model.fieldAlias]];
            self.fieldArray[i].indxPath = self.indxPath;
        }
        else
        {
            self.fieldArray[i].nameLabel.text = @"";
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < _dataArray.count; i++)
    {
        //view
        CGFloat newGridWidth = [self getNewGridWidth:_dataArray];
        self.fieldArray[i].hidden = NO;
        self.fieldArray[i].frame = CGRectMake(newGridWidth*i, 0, newGridWidth, gridHeight);
        self.fieldArray[i].nameLabel.frame = CGRectMake(3, 0, newGridWidth, gridHeight);
    }
}

#pragma mark 单元格宽度适配
- (CGFloat)getNewGridWidth:(NSArray *)array
{
    CGFloat newGridWidth = 0;
    if (gridWidth * array.count < self.contentView.frame.size.width)
    {
        newGridWidth = self.contentView.frame.size.width/array.count;
    }
    else
    {
        newGridWidth = gridWidth;
    }
    return newGridWidth;
}

@end
