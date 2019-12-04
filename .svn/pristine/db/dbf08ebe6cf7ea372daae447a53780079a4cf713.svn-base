//
//  ZSCreateOrderPopupView.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/27.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSSendOrderPopView.h"

#define SORT_ARRAY [[_dataDic allKeys]sortedArrayUsingSelector:@selector(compare:)]

@interface ZSSendOrderPopView  ()
@property (nonatomic,strong)NSArray<ZSSendOrderPersonModel*>  *dataArray;
@property (nonatomic,strong)NSMutableDictionary               *dataDic;  //城市根据首字母分区字典
@end

@implementation ZSSendOrderPopView

- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)array
{
    if (self = [super initWithFrame:frame])
    {
        //UI
        [self configureViews];
        [self creatBaseUI];
        //Data
        [self initData:array];
    }
    return self;
}

#pragma mark /*------------------------------------------tableview------------------------------------------*/
- (void)creatBaseUI
{
    //派单
    self.titleLabel.text = @"派单";
    
    //table
    [self configureTableView:CGRectMake(0, 10+CellHeight, ZSWIDTH, self.whiteBackgroundView.height-CellHeight) withStyle:UITableViewStylePlain];
}

- (void)initData:(NSArray *)array
{
    self.dataArray = array;
    [self pinyinFromChiniseString];
}

#pragma mark 根据首字母排序
- (void)pinyinFromChiniseString
{
    self.dataDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < self.dataArray.count; i++) {
        ZSSendOrderPersonModel *model = self.dataArray[i];
        NSString *cityPinYin = [model.userid uppercaseString]; //转大写
        NSString *firstLetter = [cityPinYin substringWithRange:NSMakeRange(0, 1)];//截取城市拼音的第一个字母
        if (![self.dataDic objectForKey:firstLetter])
        {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [self.dataDic setObject:array forKey:firstLetter];
        }
        [[self.dataDic objectForKey:firstLetter] addObject:model];
    }
}

#pragma mark /*------------------------------------------tableview------------------------------------------*/
- (void)configureTableView:(CGRect)frame withStyle:(UITableViewStyle)style
{
    self.tableView = [[UITableView alloc]initWithFrame:frame style:style];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ZSColorWhite;
    self.tableView.sectionIndexColor = ZSColorAllNotice;
    [self.whiteBackgroundView addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *cityArrays = [self.dataDic objectForKey:SORT_ARRAY[section]];
    return cityArrays.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataDic.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 30)];
    sectionHeaderView.backgroundColor = ZSViewBackgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 0, ZSWIDTH-GapWidth*2, 30)];
    label.font = FontSecondTitle;
    label.textColor = ZSColorAllNotice;
    if (self.dataArray.count > 0) {
        label.text = [NSString stringWithFormat:@"%@",SORT_ARRAY[section]];
    }
    [sectionHeaderView addSubview:label];
    return sectionHeaderView;
}

// 右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return SORT_ARRAY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    if (self.dataArray.count) {
        NSMutableArray *cityArrays = [self.dataDic objectForKey:SORT_ARRAY[indexPath.section]];
        ZSSendOrderPersonModel *model = cityArrays[indexPath.row];
        cell.textLabel.text = model.username;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismiss];
    if (self.dataArray.count > 0) {
        NSMutableArray *cityArrays = [self.dataDic objectForKey:SORT_ARRAY[indexPath.section]];
        ZSSendOrderPersonModel *model = cityArrays[indexPath.row];
        //代理传值
        if (_delegate && [_delegate respondsToSelector:@selector(selectWithData:)]){
            [_delegate selectWithData:model];
        }
    }
}

@end
