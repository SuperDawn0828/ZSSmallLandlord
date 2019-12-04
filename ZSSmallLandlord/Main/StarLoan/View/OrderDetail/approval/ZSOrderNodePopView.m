//
//  ZSOrderNodePopView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/8/21.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSOrderNodePopView.h"

@interface ZSOrderNodePopView  ()
@property (nonatomic,strong)NSArray<ZSSLOrderRejectNodeModel *> *rejectArray; //驳回的节点
@end

@implementation ZSOrderNodePopView

- (id)initWithFrame:(CGRect)frame withArray:(NSArray<ZSSLOrderRejectNodeModel *> *)rejectArray;
{
    if (self = [super initWithFrame:frame])
    {
        //UI
        [self configureViews];
        //Data
        self.rejectArray = rejectArray;
        [self.tableView reloadData];
    }
    return self;
}

#pragma mark /*------------------------------------------------黑底白底----------------------------------------------------*/
- (void)creatBaseUI
{
    //驳回至
    self.titleLabel.text = @"驳回至";
    
    //tableView
    [self configureTableView:CGRectMake(0, self.titleLabel.bottom + 10, ZSWIDTH, self.whiteBackgroundView.height-30-CellHeight-SafeAreaBottomHeight) withStyle:UITableViewStylePlain];
}

#pragma mark /*-------------------------------------------------节点tableView-----------------------------------------------------*/
- (void)configureTableView:(CGRect)frame withStyle:(UITableViewStyle)style
{
    self.tableView = [[UITableView alloc]initWithFrame:frame style:style];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ZSColorWhite;
    [self.whiteBackgroundView addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rejectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSOrderNodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZSOrderNodeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //赋值
    if (self.rejectArray.count > 0)
    {
        ZSSLOrderRejectNodeModel *model = self.rejectArray[indexPath.row];
        cell.currentIndex = indexPath.row;
        cell.model = model;
        //虚线和箭头
        if (indexPath.row == 0) {
            cell.lineImage.frame = CGRectMake((50-3)/2+1, 35, 3, 65);
            cell.arrowImage.hidden = YES;
        }
        else if (indexPath.row == self.rejectArray.count - 1) {
            cell.lineImage.frame = CGRectMake((50-3)/2+1, 0, 3, 65);
            cell.arrowImage.hidden = NO;
        }
        else {
            cell.lineImage.frame = CGRectMake((50-3)/2+1, 0, 3, 100);
            cell.arrowImage.hidden = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismiss];
    if (self.rejectArray.count > 0) {
        ZSSLOrderRejectNodeModel *model = self.rejectArray[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(sendData:)]){
            [_delegate sendData:model];
        }
    }
}


@end
