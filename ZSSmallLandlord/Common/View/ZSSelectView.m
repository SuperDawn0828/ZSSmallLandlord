//
//  ZSSelectView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/22.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSelectView.h"

@interface ZSSelectView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView    *backgroundView_black;
@property (nonatomic,strong)UIView    *backgroundView_white;
@property (nonatomic,strong)NSArray   *arrayData;
@property (nonatomic,assign)NSInteger currentIndex;
@end

@implementation ZSSelectView

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)titleArray withCurrentIndex:(NSInteger)currentIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSelectView:titleArray];
        self.arrayData = titleArray;
        self.currentIndex = currentIndex;
        [NOTI_CENTER addObserver:self selector:@selector(cancelBtnAction) name:@"removeSelectView" object:nil];
    }
    return self;
}

- (void)configureSelectView:(NSArray *)titleArray
{
    //黑底
    self.backgroundView_black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    self.backgroundView_black.backgroundColor = ZSColorBlack;
    self.backgroundView_black.alpha = 0;
    [self addSubview:self.backgroundView_black];
  
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnAction)];
    [self.backgroundView_black addGestureRecognizer:tap];
  
    //白底
    self.backgroundView_white = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight*titleArray.count)];
    self.backgroundView_white.backgroundColor = ZSColorWhite;
    self.backgroundView_white.alpha = 0;
    [self addSubview:self.backgroundView_white];
  
    //table
    UITableView *mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, self.backgroundView_white.height) style:UITableViewStylePlain];
    mytable.dataSource = self;
    mytable.delegate = self;
    [self.backgroundView_white addSubview:mytable];
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = ZSColorListLeft;
    }
    
    cell.textLabel.text = self.arrayData[indexPath.row];
    
    if(self.currentIndex == indexPath.row){
        cell.imageView.image = [UIImage imageNamed:@"list_selected_n"];
        cell.textLabel.textColor = ZSColorRed;
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"list_notSelected_n"];
        cell.textLabel.textColor = ZSColorListLeft;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    self.currentIndex = indexPath.row;
   
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    if (_delegate && [_delegate respondsToSelector:@selector(currentSelectIndex:currentSelectTitle:withSecectView:)]){
        [_delegate currentSelectIndex:indexPath.row currentSelectTitle:self.arrayData[indexPath.row] withSecectView:self];
    }
    
    [self cancelBtnAction];
}

#pragma mark 显示自己
- (void)show:(NSInteger)count
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView_black.alpha = 0.5;
        self.backgroundView_white.alpha = 1;
    }];
}

#pragma mark 按钮响应事件
- (void)cancelBtnAction
{
    [self removeFromSuperview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(changeImage)]) {
        [_delegate changeImage];
    }
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

@end
